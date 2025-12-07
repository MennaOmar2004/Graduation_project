import 'package:flutter/material.dart';

/// Prayer time data for educational game
class PrayerTime {
  final String nameArabic;
  final String nameEnglish;
  final int hour; // 24-hour format
  final Color color;
  final String emoji;
  final String description;
  final String skyGradientStart;
  final String skyGradientEnd;

  const PrayerTime({
    required this.nameArabic,
    required this.nameEnglish,
    required this.hour,
    required this.color,
    required this.emoji,
    required this.description,
    required this.skyGradientStart,
    required this.skyGradientEnd,
  });
}

class PrayerTimesData {
  static const List<PrayerTime> prayers = [
    PrayerTime(
      nameArabic: 'الفجر',
      nameEnglish: 'Fajr',
      hour: 5,
      color: Color(0xFF9C27B0),
      emoji: '🌅',
      description: 'صلاة الفجر - قبل شروق الشمس',
      skyGradientStart: '#1A237E',
      skyGradientEnd: '#FF6F00',
    ),
    PrayerTime(
      nameArabic: 'الظهر',
      nameEnglish: 'Dhuhr',
      hour: 12,
      color: Color(0xFFFFB300),
      emoji: '☀️',
      description: 'صلاة الظهر - منتصف النهار',
      skyGradientStart: '#01579B',
      skyGradientEnd: '#4FC3F7',
    ),
    PrayerTime(
      nameArabic: 'العصر',
      nameEnglish: 'Asr',
      hour: 15,
      color: Color(0xFFFF6F00),
      emoji: '🌤️',
      description: 'صلاة العصر - بعد الظهر',
      skyGradientStart: '#F57C00',
      skyGradientEnd: '#FFE082',
    ),
    PrayerTime(
      nameArabic: 'المغرب',
      nameEnglish: 'Maghrib',
      hour: 18,
      color: Color(0xFFE91E63),
      emoji: '🌆',
      description: 'صلاة المغرب - عند الغروب',
      skyGradientStart: '#880E4F',
      skyGradientEnd: '#FF6F00',
    ),
    PrayerTime(
      nameArabic: 'العشاء',
      nameEnglish: 'Isha',
      hour: 20,
      color: Color(0xFF311B92),
      emoji: '🌙',
      description: 'صلاة العشاء - بعد الغروب',
      skyGradientStart: '#0D47A1',
      skyGradientEnd: '#1A237E',
    ),
  ];

  static PrayerTime getPrayerByHour(int hour) {
    return prayers.reduce(
      (a, b) => (a.hour - hour).abs() < (b.hour - hour).abs() ? a : b,
    );
  }
}
