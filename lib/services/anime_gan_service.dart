import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

/// Result of an AnimeGAN conversion.
sealed class AnimeGanResult {}

class AnimeGanSuccess extends AnimeGanResult {
  final Uint8List imageBytes;
  AnimeGanSuccess(this.imageBytes);
}

class AnimeGanFailure extends AnimeGanResult {
  final String message;
  AnimeGanFailure(this.message);
}

/// Service that calls the Gradio-powered HuggingFace Space for AnimeGANv2.
///
/// Uses the Gradio 5 named-endpoint API (discovered via /gradio_api/info):
///   POST /gradio_api/upload            → get uploaded file path
///   POST /gradio_api/call/face2paint   → enqueue, returns {"event_id": "..."}
///   GET  /gradio_api/call/face2paint/{event_id} → SSE stream for this event
class AnimeGanService {
  static const String _baseUrl =
      'https://nermeen28-second-anime-gan.hf.space';

  static const String _apiName = 'face2paint';

  static const Duration _uploadTimeout = Duration(seconds: 60);
  static const Duration _enqueueTimeout = Duration(seconds: 30);
  static const Duration _streamTimeout = Duration(seconds: 180);

  // ───────────────────────────────────────────────────────────────
  // Public API
  // ───────────────────────────────────────────────────────────────

  Future<AnimeGanResult> convertToAnime(File imageFile) async {
    try {
      // Step 1: Upload image → get server-side temp path
      final uploadedPath = await _uploadImage(imageFile);
      if (uploadedPath == null) {
        return AnimeGanFailure('فشل رفع الصورة للسيرفر. حاولي تاني.');
      }

      // Step 2: Enqueue the prediction → get event_id
      final eventId = await _enqueue(uploadedPath);
      if (eventId == null) {
        return AnimeGanFailure('فشل إرسال الطلب للـ AI. حاولي تاني.');
      }

      // Step 3: Stream SSE for this specific event → extract output URL
      final outputUrl = await _streamResult(eventId);
      if (outputUrl == null) {
        return AnimeGanFailure(
            'الـ AI لم يرجع نتيجة. ممكن السيرفر مشغول، حاولي تاني بعد شوية.');
      }

      // Step 4: Download the output image bytes
      final bytes = await _downloadImage(outputUrl);
      if (bytes == null) {
        return AnimeGanFailure('فشل تحميل صورة الأنمي. حاولي تاني.');
      }

      return AnimeGanSuccess(bytes);
    } on SocketException {
      return AnimeGanFailure('مفيش اتصال بالنت. تحققي من الشبكة.');
    } on TimeoutException {
      return AnimeGanFailure('انتهت مدة الانتظار. السيرفر بطيء، حاولي تاني.');
    } catch (e) {
      return AnimeGanFailure('خطأ غير متوقع: $e');
    }
  }

  // ───────────────────────────────────────────────────────────────
  // Step 1 – Upload
  // ───────────────────────────────────────────────────────────────

  Future<String?> _uploadImage(File imageFile) async {
    final uri = Uri.parse('$_baseUrl/gradio_api/upload');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Accept'] = 'application/json'
      ..files.add(
        await http.MultipartFile.fromPath(
          'files',
          imageFile.path,
          filename: 'image.jpg',
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
      // fall through → return null
    }
    return null;
  }

  // ───────────────────────────────────────────────────────────────
  // Step 2 – Enqueue via named endpoint
  // ───────────────────────────────────────────────────────────────

  Future<String?> _enqueue(String uploadedPath) async {
    final uri =
        Uri.parse('$_baseUrl/gradio_api/call/$_apiName');

    // The Gradio 5 API accepts the input as a named-field JSON object.
    // The API info confirms the parameter is called "img".
    final payload = jsonEncode({
      'data': [
        {
          'path': uploadedPath,
          'orig_name': 'image.jpg',
          'mime_type': 'image/jpeg',
          'meta': {'_type': 'gradio.FileData'},
        }
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

  // ───────────────────────────────────────────────────────────────
  // Step 3 – Stream SSE for the specific event_id
  // ───────────────────────────────────────────────────────────────

  Future<String?> _streamResult(String eventId) async {
    // Gradio 5 named-endpoint SSE: GET /gradio_api/call/{name}/{event_id}
    final uri = Uri.parse(
      '$_baseUrl/gradio_api/call/$_apiName/$eventId',
    );

    final client = http.Client();
    try {
      final request = http.Request('GET', uri)
        ..headers['Accept'] = 'text/event-stream'
        ..headers['Cache-Control'] = 'no-cache';

      final response =
          await client.send(request).timeout(_streamTimeout);

      if (response.statusCode != 200) return null;

      // Accumulate chunked bytes to handle partial SSE lines
      final buffer = StringBuffer();

      await for (final chunk in response.stream
          .timeout(_streamTimeout)
          .transform(utf8.decoder)) {
        buffer.write(chunk);
        final content = buffer.toString();

        // Process all complete SSE events (separated by double newline)
        final events = content.split('\n\n');

        // Keep the last incomplete event in the buffer
        buffer.clear();
        buffer.write(events.last);

        for (var i = 0; i < events.length - 1; i++) {
          final result = _parseEvent(events[i]);
          if (result != null) return result;
        }
      }

      // Check if anything remains in the buffer
      if (buffer.isNotEmpty) {
        final result = _parseEvent(buffer.toString());
        if (result != null) return result;
      }

      return null;
    } finally {
      client.close();
    }
  }

  /// Parses a single SSE event block; returns image URL if process_completed.
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

      // Gradio 5 SSE events can be:
      //   {"msg": "process_completed", "output": {"data": [...]}}
      // OR for the named-endpoint stream, the raw data array:
      //   [{"path": "...", "url": "...", ...}]

      if (data is Map<String, dynamic>) {
        final msg = data['msg'] as String?;
        if (msg == 'process_completed') {
          return _extractUrl(data['output']?['data']);
        }
        // Some Gradio 5 versions send the output directly without "msg"
        if (data.containsKey('data')) {
          final url = _extractUrl(data['data']);
          if (url != null) return url;
        }
      } else if (data is List && data.isNotEmpty) {
        // Named-endpoint direct data array
        return _extractUrl(data);
      }
    } catch (_) {
      // Malformed JSON — skip
    }
    return null;
  }

  /// Extracts the image URL from a Gradio output data list.
  String? _extractUrl(dynamic dataList) {
    if (dataList is! List || dataList.isEmpty) return null;
    final item = dataList.first;
    if (item is! Map) return null;

    // Prefer the direct URL field (already publicly accessible)
    final url = item['url']?.toString();
    if (url != null && url.isNotEmpty && url.startsWith('http')) {
      return url;
    }

    // Fall back to constructing from path
    final path = item['path']?.toString();
    if (path != null && path.isNotEmpty) {
      return '$_baseUrl/gradio_api/file=$path';
    }

    return null;
  }

  // ───────────────────────────────────────────────────────────────
  // Step 4 – Download result
  // ───────────────────────────────────────────────────────────────

  Future<Uint8List?> _downloadImage(String url) async {
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(_streamTimeout);
      if (response.statusCode == 200) return response.bodyBytes;
    } catch (_) {
      // fall through
    }
    return null;
  }

  // ───────────────────────────────────────────────────────────────
  // Utilities
  // ───────────────────────────────────────────────────────────────

  // ignore: unused_element
  String _randomSessionHash() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rng = Random();
    return List.generate(11, (_) => chars[rng.nextInt(chars.length)]).join();
  }
}
