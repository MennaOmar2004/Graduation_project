import 'package:flutter/material.dart';

enum ElementType { dome, minaret, wall, door, window, decoration }

class BuildingElement {
  final String id;
  final String nameArabic;
  final String nameEnglish;
  final ElementType type;
  final String emoji;
  final Color color;
  final Size size; // Grid units (width, height)
  final String? description;

  const BuildingElement({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.type,
    required this.emoji,
    required this.color,
    required this.size,
    this.description,
  });
}

class PlacedElement {
  final String id;
  final BuildingElement element;
  final Offset position; // Grid position
  final int rotation; // 0, 90, 180, 270 degrees
  final Color? customColor;

  const PlacedElement({
    required this.id,
    required this.element,
    required this.position,
    this.rotation = 0,
    this.customColor,
  });

  PlacedElement copyWith({
    Offset? position,
    int? rotation,
    Color? customColor,
  }) {
    return PlacedElement(
      id: id,
      element: element,
      position: position ?? this.position,
      rotation: rotation ?? this.rotation,
      customColor: customColor ?? this.customColor,
    );
  }
}
