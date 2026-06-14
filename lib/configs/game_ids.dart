/// Static game IDs as registered in the backend (GET /api/v1/games).
/// Update these if the backend re-seeds the games table.
abstract final class GameIds {
  GameIds._();

  static const int alphabet    = 3;   // تعلم الحروف
  static const int numberCircus = 4;  // سيرك الأرقام
  static const int moonPhases  = 5;   // مراحل القمر
  static const int prayerGarden = 6;  // حديقة الصلاة
  static const int coloring    = 7;   // لعبة التلوين
  static const int mosqueBuilder = 11;  // باني المسجد — add via POST /api/v1/games when ready
  static const int starCatcher = 9;   // صائد النجوم
  static const int maze        = 10;  // لعبة المتاهة
}
