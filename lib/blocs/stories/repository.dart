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

  Future<List<Story>> getVideos() async {
    try {
      final response = await _dataProvider.getAllVideos();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Story.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load videos');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Story>> getVideosByCategory(String category) async {
    try {
      final response = await _dataProvider.getVideosByCategory(category);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Story.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load videos');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeStory(int childId, int storyId, {double progressPercent = 100}) async {
    try {
      final response = await _dataProvider.completeStory(childId, storyId, progressPercent);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['message'] ?? 'Failed to complete story');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeVideo(int childId, int videoId, {double watchPercent = 100}) async {
    try {
      final response = await _dataProvider.completeVideo(childId, videoId, watchPercent);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['message'] ?? 'Failed to complete video');
      }
    } catch (e) {
      rethrow;
    }
  }
}
