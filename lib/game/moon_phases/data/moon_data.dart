/// Moon phase data for educational game
class MoonPhase {
  final String nameArabic;
  final String nameEnglish;
  final double illumination; // 0.0 to 1.0
  final int dayOfMonth; // Hijri day
  final String emoji;
  final String fact;

  const MoonPhase({
    required this.nameArabic,
    required this.nameEnglish,
    required this.illumination,
    required this.dayOfMonth,
    required this.emoji,
    required this.fact,
  });
}

class MoonPhasesData {
  static const List<MoonPhase> phases = [
    MoonPhase(
      nameArabic: 'محاق',
      nameEnglish: 'New Moon',
      illumination: 0.0,
      dayOfMonth: 1,
      emoji: '🌑',
      fact: 'بداية الشهر القمري الجديد',
    ),
    MoonPhase(
      nameArabic: 'هلال',
      nameEnglish: 'Waxing Crescent',
      illumination: 0.25,
      dayOfMonth: 3,
      emoji: '🌒',
      fact: 'الهلال الذي نراه في بداية رمضان',
    ),
    MoonPhase(
      nameArabic: 'تربيع أول',
      nameEnglish: 'First Quarter',
      illumination: 0.5,
      dayOfMonth: 7,
      emoji: '🌓',
      fact: 'نصف القمر مضيء',
    ),
    MoonPhase(
      nameArabic: 'أحدب متزايد',
      nameEnglish: 'Waxing Gibbous',
      illumination: 0.75,
      dayOfMonth: 10,
      emoji: '🌔',
      fact: 'القمر يقترب من البدر',
    ),
    MoonPhase(
      nameArabic: 'بدر',
      nameEnglish: 'Full Moon',
      illumination: 1.0,
      dayOfMonth: 14,
      emoji: '🌕',
      fact: 'ليلة البدر - منتصف الشهر القمري',
    ),
    MoonPhase(
      nameArabic: 'أحدب متناقص',
      nameEnglish: 'Waning Gibbous',
      illumination: 0.75,
      dayOfMonth: 18,
      emoji: '🌖',
      fact: 'القمر يبدأ بالتناقص',
    ),
    MoonPhase(
      nameArabic: 'تربيع ثاني',
      nameEnglish: 'Last Quarter',
      illumination: 0.5,
      dayOfMonth: 22,
      emoji: '🌗',
      fact: 'النصف الآخر من القمر مضيء',
    ),
    MoonPhase(
      nameArabic: 'هلال متناقص',
      nameEnglish: 'Waning Crescent',
      illumination: 0.25,
      dayOfMonth: 26,
      emoji: '🌘',
      fact: 'نهاية الشهر القمري',
    ),
  ];

  static const List<String> hijriMonths = [
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الثاني',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ];

  static MoonPhase getPhaseForDay(int day) {
    // Find closest phase
    return phases.reduce(
      (a, b) => (a.dayOfMonth - day).abs() < (b.dayOfMonth - day).abs() ? a : b,
    );
  }
}
