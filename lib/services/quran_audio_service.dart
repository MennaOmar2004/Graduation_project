import 'dart:convert';
import 'package:http/http.dart' as http;

class QuranAudioService {
  /// Searches for the given ayah text using a spelling-tolerant Quran.com search API,
  /// then fetches Mishary Rashid Alafasy's audio recitation for the matched Ayah.
  Future<String?> getAudioUrl(String ayahText) async {
    try {
      final query = Uri.encodeComponent(ayahText.trim());

      // 1. Query Quran.com API which has advanced fuzzy/spelling matching (tolerant of hamza & tashkeel omissions)
      final quranComUrl = Uri.parse(
        'https://api.quran.com/api/v4/search?q=$query&size=1',
      );
      final response = await http.get(quranComUrl);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final results = decoded['search']?['results'];

        if (results is List && results.isNotEmpty) {
          final verseKey = results.first['verse_key']; // e.g. "112:1"

          if (verseKey != null && verseKey.toString().contains(':')) {
            // 2. Fetch the global ayah number from Alquran.cloud using the surah:ayah key
            final metadataUrl = Uri.parse(
              'https://api.alquran.cloud/v1/ayah/$verseKey',
            );
            final metadataRes = await http.get(metadataUrl);

            if (metadataRes.statusCode == 200) {
              final metadataDecoded = jsonDecode(metadataRes.body);
              final globalAyahNumber = metadataDecoded['data']?['number'];
              if (globalAyahNumber != null) {
                // Return Mishary Rashid Alafasy audio URL
                return 'https://cdn.alquran.cloud/media/audio/ayah/ar.alafasy/$globalAyahNumber';
              }
            }
          }
        }
      }
    } catch (_) {
      // Fallback on search/parsing errors
    }

    // 3. Fallback: Search directly on Alquran.cloud
    try {
      final query = Uri.encodeComponent(ayahText.trim());
      final url = Uri.parse(
        'https://api.alquran.cloud/v1/search/$query/all/ar',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['code'] == 200 && decoded['data'] != null) {
          final matches = decoded['data']['matches'];
          if (matches is List && matches.isNotEmpty) {
            final int globalAyahNumber = matches.first['number'];
            return 'https://cdn.alquran.cloud/media/audio/ayah/ar.alafasy/$globalAyahNumber';
          }
        }
      }
    } catch (_) {}

    return null;
  }
}
