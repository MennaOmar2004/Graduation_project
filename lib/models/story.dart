import 'package:equatable/equatable.dart';

class Story extends Equatable {
  final int id;
  final String title;
  final String text;
  final String category;
  final String? audioUrl;
  final String? videoUrl;
  final int points;

  const Story({
    required this.id,
    required this.title,
    required this.text,
    required this.category,
    this.audioUrl,
    this.videoUrl,
    required this.points,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['storyId'] ?? 0,
      title: json['title'] ?? '',
      text: json['storyText'] ?? '',
      category: json['category'] ?? '',
      audioUrl: json['audioUrl'],
      videoUrl: json['url'],
      points: json['pointsRewarded'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, title, text, category, audioUrl, videoUrl, points];
}
