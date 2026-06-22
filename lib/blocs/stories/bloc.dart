import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/stories/repository.dart';
import 'package:wanisi_app/blocs/stories/state.dart';

class StoriesCubit extends Cubit<StoriesState> {
  final StoriesRepository _repository;

  StoriesCubit(this._repository) : super(StoriesInitial());

  Future<void> fetchStories() async {
    emit(StoriesLoading());
    try {
      final stories = await _repository.getStories();
      emit(StoriesLoaded(stories));
    } catch (e) {
      emit(StoriesError(e.toString()));
    }
  }

  Future<void> fetchStoriesByCategory(String category) async {
    emit(StoriesLoading());
    try {
      final stories = await _repository.getStoriesByCategory(category);
      emit(StoriesLoaded(stories, selectedCategory: category));
      debugPrint("Loaded stories: ${stories.length}");
    } catch (e) {
      emit(StoriesError(e.toString()));
    }
  }

  Future<void> fetchVideos() async {
    emit(StoriesLoading());
    try {
      final videos = await _repository.getVideos();
      emit(StoriesLoaded(videos));
    } catch (e) {
      emit(StoriesError(e.toString()));
    }
  }

  Future<void> fetchVideosByCategory(String category) async {
    emit(StoriesLoading());
    try {
      final videos = await _repository.getVideosByCategory(category);
      emit(StoriesLoaded(videos, selectedCategory: category));
      debugPrint("Loaded videos: ${videos.length}");
    } catch (e) {
      emit(StoriesError(e.toString()));
    }
  }

  Future<void> completeStory(
    int childId,
    int storyId, {
    double progressPercent = 100,
  }) async {
    try {
      await _repository.completeStory(
        childId,
        storyId,
        progressPercent: progressPercent,
      );
    } catch (e) {
      debugPrint("Failed to complete story: $e");
    }
  }

  Future<void> completeVideo(
    int childId,
    int videoId, {
    double watchPercent = 100,
  }) async {
    try {
      await _repository.completeVideo(
        childId,
        videoId,
        watchPercent: watchPercent,
      );
    } catch (e) {
      debugPrint("Failed to complete video: $e");
    }
  }
}
