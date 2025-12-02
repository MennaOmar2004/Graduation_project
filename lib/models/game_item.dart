import 'package:flutter/material.dart';

class GameItem {
  final String id;
  final String title;
  final String description;
  final String icon;
  final Color color;
  final String? illustration;

  GameItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.illustration,
  });
}
