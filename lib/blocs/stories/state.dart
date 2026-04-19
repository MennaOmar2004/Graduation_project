import 'package:equatable/equatable.dart';
import 'package:wanisi_app/models/story.dart';

sealed class StoriesState extends Equatable {
  const StoriesState();

  @override
  List<Object?> get props => [];
}

class StoriesInitial extends StoriesState {}

class StoriesLoading extends StoriesState {}

class StoriesLoaded extends StoriesState {
  final List<Story> stories;
  final String? selectedCategory;

  const StoriesLoaded(this.stories, {this.selectedCategory});

  @override
  List<Object?> get props => [stories, selectedCategory];
}

class StoriesError extends StoriesState {
  final String message;

  const StoriesError(this.message);

  @override
  List<Object?> get props => [message];
}
