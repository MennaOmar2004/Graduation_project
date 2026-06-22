import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Result of a Qalqlah detection call.
sealed class QalqlahServiceResult {}

class QalqlahServiceSuccess extends QalqlahServiceResult {
  /// Decoded result text returned by the Gradio space.
  final String resultText;
  QalqlahServiceSuccess(this.resultText);
}

class QalqlahServiceFailure extends QalqlahServiceResult {
  final String message;
  QalqlahServiceFailure(this.message);
}

/// Calls the HuggingFace Gradio Space for Qalqlah Detection.
///
/// Flow (Gradio 5 named-endpoint):
///   POST /gradio_api/upload              → uploaded temp path
///   POST /gradio_api/call/analyze_audio  → {\"event_id\": \"...\"}
///   GET  /gradio_api/call/analyze_audio/{event_id} → SSE → result text
class QalqlahService {
  static const String _baseUrl =
      'https://nermeen28-final-qalqlah-detection.hf.space';
  static const String _apiName = 'analyze_audio';

  static const Duration _uploadTimeout = Duration(seconds: 60);
  static const Duration _enqueueTimeout = Duration(seconds: 30);
  static const Duration _streamTimeout = Duration(seconds: 180);

  // ─── Public API ──────────────────────────────────────────────────────────

  Future<QalqlahServiceResult> analyzeAudio(File audioFile) async {
    try {
      // Step 1: Upload audio → get server-side temp path
      final uploadedPath = await _uploadAudio(audioFile);
      if (uploadedPath == null) {
        return QalqlahServiceFailure('فشل رفع التسجيل للسيرفر. حاولي تاني.');
      }

      // Step 2: Enqueue → get event_id
      final eventId = await _enqueue(uploadedPath);
      if (eventId == null) {
        return QalqlahServiceFailure('فشل إرسال الطلب للـ AI. حاولي تاني.');
      }

      // Step 3: Stream SSE → extract result text
      final result = await _streamResult(eventId);
      if (result == null || result.isEmpty) {
        return QalqlahServiceFailure('الـ AI لم يرجع نتيجة. السيرفر قد يكون مشغولاً.');
      }

      return QalqlahServiceSuccess(result);
    } on SocketException {
      return QalqlahServiceFailure('مفيش اتصال بالنت. تحقق من الشبكة.');
    } on TimeoutException {
      return QalqlahServiceFailure('انتهت مدة الانتظار. السيرفر بطيء، حاولي تاني.');
    } catch (e) {
      return QalqlahServiceFailure('خطأ غير متوقع: $e');
    }
  }

  // ─── Step 1 – Upload ─────────────────────────────────────────────────────

  Future<String?> _uploadAudio(File audioFile) async {
    final uri = Uri.parse('$_baseUrl/gradio_api/upload');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Accept'] = 'application/json'
      ..files.add(
        await http.MultipartFile.fromPath(
          'files',
          audioFile.path,
          filename: 'audio.m4a',
        ),
      );

    try {
      final streamed = await request.send().timeout(_uploadTimeout);
      final body = await streamed.stream.bytesToString();
      if (streamed.statusCode != 200) return null;

      final decoded = jsonDecode(body);
      if (decoded is List && decoded.isNotEmpty) {
        return decoded.first as String?;
      }
    } catch (_) {
      // fall through
    }
    return null;
  }

  // ─── Step 2 – Enqueue ────────────────────────────────────────────────────

  Future<String?> _enqueue(String uploadedPath) async {
    final uri = Uri.parse('$_baseUrl/gradio_api/call/$_apiName');

    // The Gradio space `analyze_audio` expects:
    //   {"data": [{"path": "...", "meta": {"_type": "gradio.FileData"}}]}
    final payload = jsonEncode({
      'data': [
        {
          'path': uploadedPath,
          'meta': {'_type': 'gradio.FileData'},
        },
      ],
    });

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: payload,
          )
          .timeout(_enqueueTimeout);

      if (response.statusCode != 200) return null;

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return decoded['event_id']?.toString();
    } catch (_) {
      return null;
    }
  }

  // ─── Step 3 – SSE Stream ─────────────────────────────────────────────────

  Future<String?> _streamResult(String eventId) async {
    final uri = Uri.parse('$_baseUrl/gradio_api/call/$_apiName/$eventId');
    final client = http.Client();
    try {
      final request = http.Request('GET', uri)
        ..headers['Accept'] = 'text/event-stream'
        ..headers['Cache-Control'] = 'no-cache';

      final response = await client.send(request).timeout(_streamTimeout);
      if (response.statusCode != 200) return null;

      final buffer = StringBuffer();
      await for (final chunk
          in response.stream.timeout(_streamTimeout).transform(utf8.decoder)) {
        buffer.write(chunk);
        final content = buffer.toString();
        final events = content.split('\n\n');
        buffer.clear();
        buffer.write(events.last);

        for (var i = 0; i < events.length - 1; i++) {
          final result = _parseEvent(events[i]);
          if (result != null) return result;
        }
      }

      if (buffer.isNotEmpty) {
        return _parseEvent(buffer.toString());
      }
      return null;
    } finally {
      client.close();
    }
  }

  String? _parseEvent(String eventBlock) {
    String? jsonStr;
    for (final line in eventBlock.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.startsWith('data:')) {
        jsonStr = trimmed.substring(5).trim();
      }
    }
    if (jsonStr == null || jsonStr.isEmpty) return null;

    try {
      final data = jsonDecode(jsonStr);

      if (data is Map<String, dynamic>) {
        if (data['msg'] == 'process_completed') {
          final outputData = data['output']?['data'];
          if (outputData is List && outputData.isNotEmpty) {
            return outputData.first?.toString();
          }
        }
        // Some Gradio versions send raw data
        if (data.containsKey('data')) {
          final inner = data['data'];
          if (inner is List && inner.isNotEmpty) {
            return inner.first?.toString();
          }
        }
      } else if (data is List && data.isNotEmpty) {
        return data.first?.toString();
      }
    } catch (_) {
      // Malformed JSON — skip
    }
    return null;
  }
}
