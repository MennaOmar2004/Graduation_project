import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Result of a Tajweed analysis call.
sealed class TajweedResult {}

class TajweedSuccess extends TajweedResult {
  /// Raw HTML returned by the Gradio space (colored span tags).
  final String html;
  TajweedSuccess(this.html);
}

class TajweedFailure extends TajweedResult {
  final String message;
  TajweedFailure(this.message);
}

/// Calls the HuggingFace Gradio Space for Quran Tajweed analysis.
///
/// API (from /gradio_api/info):
///   POST /gradio_api/call/process_ayah → {"event_id": "..."}
///   GET  /gradio_api/call/process_ayah/{event_id} → SSE → HTML string
class TajweedService {
  static const String _baseUrl =
      'https://nermeen28-quran-tajweed-analyzer.hf.space';
  static const String _apiName = 'process_ayah';
  static const Duration _enqueueTimeout = Duration(seconds: 30);
  static const Duration _streamTimeout = Duration(seconds: 120);

  Future<TajweedResult> analyzeAyah(String text) async {
    try {
      final eventId = await _enqueue(text);
      if (eventId == null) {
        return TajweedFailure('فشل إرسال الطلب. جربي تاني.');
      }

      final html = await _streamResult(eventId);
      if (html == null || html.isEmpty) {
        return TajweedFailure('ما جاش رد من السيرفر. السيرفر ممكن يكون مشغول.');
      }

      return TajweedSuccess(html);
    } on TimeoutException {
      return TajweedFailure('انتهى وقت الانتظار. السيرفر بطيء، جربي تاني.');
    } catch (e) {
      return TajweedFailure('حدث خطأ: $e');
    }
  }

  // ─── Enqueue ─────────────────────────────────────────────────────────────

  Future<String?> _enqueue(String text) async {
    final uri = Uri.parse('$_baseUrl/gradio_api/call/$_apiName');
    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'data': [text]}),
          )
          .timeout(_enqueueTimeout);

      if (response.statusCode != 200) return null;
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return decoded['event_id']?.toString();
    } catch (_) {
      return null;
    }
  }

  // ─── SSE Stream ──────────────────────────────────────────────────────────

  Future<String?> _streamResult(String eventId) async {
    final uri =
        Uri.parse('$_baseUrl/gradio_api/call/$_apiName/$eventId');
    final client = http.Client();
    try {
      final request = http.Request('GET', uri)
        ..headers['Accept'] = 'text/event-stream'
        ..headers['Cache-Control'] = 'no-cache';

      final response =
          await client.send(request).timeout(_streamTimeout);
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
        // process_completed: {"msg":"process_completed","output":{"data":["<html>..."]}}
        if (data['msg'] == 'process_completed') {
          final outputData = data['output']?['data'];
          if (outputData is List && outputData.isNotEmpty) {
            return outputData.first?.toString();
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
