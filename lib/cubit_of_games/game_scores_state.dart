import 'package:equatable/equatable.dart';

abstract class GameScoresState extends Equatable {
  const GameScoresState();

  @override
  List<Object?> get props => [];
}

class GameScoresInitial extends GameScoresState {}

class GameScoresLoading extends GameScoresState {}

class GameScoresLoaded extends GameScoresState {
  final List<dynamic> scores;
  final int totalGameScore;

  const GameScoresLoaded({required this.scores, required this.totalGameScore});

  @override
  List<Object?> get props => [scores, totalGameScore];
}

class GameScoresError extends GameScoresState {
  final String message;

  const GameScoresError(this.message);

  @override
  List<Object?> get props => [message];
}

class GameScoreSubmitSuccess extends GameScoresState {
  final int submittedScore;

  const GameScoreSubmitSuccess(this.submittedScore);

  @override
  List<Object?> get props => [submittedScore];
}
