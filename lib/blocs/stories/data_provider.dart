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
}
