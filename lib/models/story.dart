import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:wanisi_app/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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

extension StoryUIExtensions on Story {
  Color get uiColor {
    final List<Color> palette = [
      AppColors.blue,
      AppColors.purple,
      AppColors.green,
      const Color(0xFFFF8C67), // Coral
      const Color(0xFF67BCFF), // Sky
      const Color(0xFFB167FF), // Lavender
      const Color(0xFFFFB567), // Sunflower
      const Color(0xFF67FFD1), // Mint
    ];
    return palette[id % palette.length];
  }

  IconData get uiIcon {
    final List<IconData> icons = [
      Icons.auto_stories,
      Icons.import_contacts_rounded,
      Icons.local_library_rounded,
      Icons.menu_book_rounded,
      Icons.auto_awesome_rounded,
      Icons.palette_rounded,
      Icons.explore_rounded,
      Icons.history_edu_rounded,
    ];
    return icons[id % icons.length];
  }

  String? get youtubeId => videoUrl != null ? YoutubePlayer.convertUrlToId(videoUrl!) : null;

  String get thumbnailUrl =>
      youtubeId != null ? 'https://img.youtube.com/vi/$youtubeId/maxresdefault.jpg' : 'assets/images/stories.png';
}
