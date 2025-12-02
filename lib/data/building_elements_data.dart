import 'package:flutter/material.dart';
import '../models/building_element.dart';

class BuildingElementsData {
  static List<BuildingElement> getAllElements() {
    return [
      ...getDomes(),
      ...getMinarets(),
      ...getWalls(),
      ...getDoors(),
      ...getWindows(),
      ...getDecorations(),
    ];
  }

  static List<BuildingElement> getDomes() {
    return [
      BuildingElement(
        id: 'dome_large',
        nameArabic: 'قبة كبيرة',
        nameEnglish: 'Large Dome',
        type: ElementType.dome,
        emoji: '🕌',
        color: const Color(0xFF00BCD4),
        size: const Size(3, 2),
        description: 'القبة الرئيسية للمسجد',
      ),
      BuildingElement(
        id: 'dome_small',
        nameArabic: 'قبة صغيرة',
        nameEnglish: 'Small Dome',
        type: ElementType.dome,
        emoji: '⛪',
        color: const Color(0xFF4DD0E1),
        size: const Size(2, 1.5),
        description: 'قبة جانبية',
      ),
      BuildingElement(
        id: 'dome_onion',
        nameArabic: 'قبة بصلية',
        nameEnglish: 'Onion Dome',
        type: ElementType.dome,
        emoji: '🧅',
        color: const Color(0xFF26C6DA),
        size: const Size(2, 2),
        description: 'قبة على الطراز العثماني',
      ),
    ];
  }

  static List<BuildingElement> getMinarets() {
    return [
      BuildingElement(
        id: 'minaret_tall',
        nameArabic: 'مئذنة طويلة',
        nameEnglish: 'Tall Minaret',
        type: ElementType.minaret,
        emoji: '🗼',
        color: const Color(0xFFFFB74D),
        size: const Size(1, 4),
        description: 'مئذنة عالية للأذان',
      ),
      BuildingElement(
        id: 'minaret_short',
        nameArabic: 'مئذنة قصيرة',
        nameEnglish: 'Short Minaret',
        type: ElementType.minaret,
        emoji: '🏛️',
        color: const Color(0xFFFFA726),
        size: const Size(1, 3),
        description: 'مئذنة متوسطة الارتفاع',
      ),
      BuildingElement(
        id: 'minaret_decorative',
        nameArabic: 'مئذنة مزخرفة',
        nameEnglish: 'Decorative Minaret',
        type: ElementType.minaret,
        emoji: '🕋',
        color: const Color(0xFFFF9800),
        size: const Size(1.5, 3.5),
        description: 'مئذنة بزخارف إسلامية',
      ),
    ];
  }

  static List<BuildingElement> getWalls() {
    return [
      BuildingElement(
        id: 'wall_straight',
        nameArabic: 'جدار مستقيم',
        nameEnglish: 'Straight Wall',
        type: ElementType.wall,
        emoji: '🧱',
        color: const Color(0xFFBCAAA4),
        size: const Size(2, 2),
        description: 'جدار أساسي للمسجد',
      ),
      BuildingElement(
        id: 'wall_corner',
        nameArabic: 'جدار زاوية',
        nameEnglish: 'Corner Wall',
        type: ElementType.wall,
        emoji: '📐',
        color: const Color(0xFFA1887F),
        size: const Size(2, 2),
        description: 'جدار للزوايا',
      ),
      BuildingElement(
        id: 'wall_arched',
        nameArabic: 'جدار مقوس',
        nameEnglish: 'Arched Wall',
        type: ElementType.wall,
        emoji: '🌉',
        color: const Color(0xFF8D6E63),
        size: const Size(3, 2),
        description: 'جدار بقوس إسلامي',
      ),
    ];
  }

  static List<BuildingElement> getDoors() {
    return [
      BuildingElement(
        id: 'door_main',
        nameArabic: 'باب رئيسي',
        nameEnglish: 'Main Door',
        type: ElementType.door,
        emoji: '🚪',
        color: const Color(0xFF6D4C41),
        size: const Size(1.5, 2),
        description: 'الباب الرئيسي للمسجد',
      ),
      BuildingElement(
        id: 'door_side',
        nameArabic: 'باب جانبي',
        nameEnglish: 'Side Door',
        type: ElementType.door,
        emoji: '🚧',
        color: const Color(0xFF5D4037),
        size: const Size(1, 1.5),
        description: 'باب جانبي',
      ),
      BuildingElement(
        id: 'door_arched',
        nameArabic: 'باب مقوس',
        nameEnglish: 'Arched Entrance',
        type: ElementType.door,
        emoji: '⛩️',
        color: const Color(0xFF4E342E),
        size: const Size(2, 2.5),
        description: 'مدخل بقوس كبير',
      ),
    ];
  }

  static List<BuildingElement> getWindows() {
    return [
      BuildingElement(
        id: 'window_arched',
        nameArabic: 'نافذة مقوسة',
        nameEnglish: 'Arched Window',
        type: ElementType.window,
        emoji: '🪟',
        color: const Color(0xFF42A5F5),
        size: const Size(1, 1.5),
        description: 'نافذة بقوس إسلامي',
      ),
      BuildingElement(
        id: 'window_round',
        nameArabic: 'نافذة دائرية',
        nameEnglish: 'Round Window',
        type: ElementType.window,
        emoji: '⭕',
        color: const Color(0xFF1E88E5),
        size: const Size(1, 1),
        description: 'نافذة دائرية',
      ),
      BuildingElement(
        id: 'window_decorative',
        nameArabic: 'نافذة مزخرفة',
        nameEnglish: 'Decorative Window',
        type: ElementType.window,
        emoji: '🔷',
        color: const Color(0xFF1976D2),
        size: const Size(1.5, 1.5),
        description: 'نافذة بزخارف هندسية',
      ),
    ];
  }

  static List<BuildingElement> getDecorations() {
    return [
      BuildingElement(
        id: 'crescent',
        nameArabic: 'هلال',
        nameEnglish: 'Crescent Moon',
        type: ElementType.decoration,
        emoji: '☪️',
        color: const Color(0xFFFFD700),
        size: const Size(1, 1),
        description: 'هلال إسلامي',
      ),
      BuildingElement(
        id: 'star',
        nameArabic: 'نجمة',
        nameEnglish: 'Star',
        type: ElementType.decoration,
        emoji: '⭐',
        color: const Color(0xFFFFC107),
        size: const Size(1, 1),
        description: 'نجمة إسلامية',
      ),
      BuildingElement(
        id: 'pattern',
        nameArabic: 'زخرفة',
        nameEnglish: 'Pattern',
        type: ElementType.decoration,
        emoji: '✨',
        color: const Color(0xFFFF9800),
        size: const Size(1, 1),
        description: 'زخرفة هندسية',
      ),
      BuildingElement(
        id: 'calligraphy',
        nameArabic: 'خط عربي',
        nameEnglish: 'Calligraphy',
        type: ElementType.decoration,
        emoji: '📜',
        color: const Color(0xFF795548),
        size: const Size(2, 1),
        description: 'خط عربي جميل',
      ),
    ];
  }

  static List<BuildingElement> getElementsByType(ElementType type) {
    return getAllElements().where((e) => e.type == type).toList();
  }
}
