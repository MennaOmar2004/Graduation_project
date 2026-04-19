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
    } catch (e) {
      emit(StoriesError(e.toString()));
    }
  }
}
