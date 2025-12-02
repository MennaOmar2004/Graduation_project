import 'package:flutter/material.dart';

class ColoringPage {
  final String id;
  final String title;
  final String titleArabic;
  final String category;
  final int difficulty; // 1-3
  final List<ColorRegion> regions;
  final String thumbnailPath;

  const ColoringPage({
    required this.id,
    required this.title,
    required this.titleArabic,
    required this.category,
    required this.difficulty,
    required this.regions,
    required this.thumbnailPath,
  });
}

class ColorRegion {
  final String id;
  final List<Offset> path;
  final Color? fillColor;

  const ColorRegion({required this.id, required this.path, this.fillColor});

  ColorRegion copyWith({Color? fillColor}) {
    return ColorRegion(
      id: id,
      path: path,
      fillColor: fillColor ?? this.fillColor,
    );
  }
}

class ColorInfo {
  final Color color;
  final String nameArabic;
  final String nameEnglish;

  const ColorInfo({
    required this.color,
    required this.nameArabic,
    required this.nameEnglish,
  });
}
