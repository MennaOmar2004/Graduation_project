import 'package:dio/dio.dart';
import 'package:wanisi_app/configs/api_endpoints.dart';
import 'package:wanisi_app/dio/dio.dart';

class StoriesDataProvider {
  /// Fetches all stories from the API
  Future<Response> getAllStories() async {
    return await ApiConsumer.get(ApiEndpoints.stories);
  }

  /// Fetches stories by category
  Future<Response> getStoriesByCategory(String category) async {
    return await ApiConsumer.get(ApiEndpoints.storiesByCategory(category));
  }

  /// Fetches a specific story by ID
  Future<Response> getStoryById(int id) async {
    return await ApiConsumer.get(ApiEndpoints.storyById(id));
  }

  /// Fetches all videos from the API
  Future<Response> getAllVideos() async {
    return await ApiConsumer.get(ApiEndpoints.videos);
  }

  /// Fetches videos by category
  Future<Response> getVideosByCategory(String category) async {
    return await ApiConsumer.get(ApiEndpoints.videosByCategory(category));
  }

  /// Sends progress for a story to earn points
  Future<Response> completeStory(int childId, int storyId, double progressPercent) async {
    return await ApiConsumer.post(
      ApiEndpoints.storyProgress,
      data: {
        "childId": childId,
        "storyId": storyId,
        "progressPercent": progressPercent,
      },
    );
  }

  /// Sends progress for a video to earn points
  Future<Response> completeVideo(int childId, int videoId, double watchPercent) async {
    return await ApiConsumer.post(
      ApiEndpoints.videoActivitiesProgress,
      data: {
        "childId": childId,
        "videoId": videoId,
        "watchPercent": watchPercent,
      },
    );
  }
}
