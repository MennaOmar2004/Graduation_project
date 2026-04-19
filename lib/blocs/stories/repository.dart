import 'package:wanisi_app/blocs/stories/data_provider.dart';
import 'package:wanisi_app/models/story.dart';

class StoriesRepository {
  final StoriesDataProvider _dataProvider;

  StoriesRepository({StoriesDataProvider? dataProvider})
      : _dataProvider = dataProvider ?? StoriesDataProvider();

  Future<List<Story>> getStories() async {
    try {
      final response = await _dataProvider.getAllStories();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Story.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load stories');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Story>> getStoriesByCategory(String category) async {
    try {
      final response = await _dataProvider.getStoriesByCategory(category);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Story.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load stories');
      }
    } catch (e) {
      rethrow;
    }
  }
}
