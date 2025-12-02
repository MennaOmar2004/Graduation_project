/// Arabic values and ethics data for the maze game
class ValueData {
  final String arabicName;
  final String emoji;
  final String description;

  const ValueData({
    required this.arabicName,
    required this.emoji,
    required this.description,
  });
}

class ValuesDatabase {
  // Good values to collect
  static const List<ValueData> goodValues = [
    ValueData(
      arabicName: 'الصدق',
      emoji: '🤝',
      description: 'قول الحقيقة دائماً',
    ),
    ValueData(arabicName: 'الأمانة', emoji: '🔒', description: 'حفظ الأمانات'),
    ValueData(
      arabicName: 'الاحترام',
      emoji: '🙏',
      description: 'احترام الآخرين',
    ),
    ValueData(
      arabicName: 'اللطف',
      emoji: '💝',
      description: 'كن لطيفاً مع الجميع',
    ),
    ValueData(
      arabicName: 'النظافة',
      emoji: '🧼',
      description: 'النظافة من الإيمان',
    ),
    ValueData(
      arabicName: 'الصبر',
      emoji: '⏳',
      description: 'الصبر مفتاح الفرج',
    ),
    ValueData(arabicName: 'المساعدة', emoji: '🤲', description: 'ساعد الآخرين'),
    ValueData(
      arabicName: 'الشكر',
      emoji: '🌟',
      description: 'اشكر الله دائماً',
    ),
  ];

  // Bad behaviors to avoid
  static const List<ValueData> badBehaviors = [
    ValueData(arabicName: 'الكذب', emoji: '❌', description: 'لا تكذب أبداً'),
    ValueData(arabicName: 'الغش', emoji: '🚫', description: 'الغش حرام'),
    ValueData(arabicName: 'الغضب', emoji: '😠', description: 'تحكم في غضبك'),
    ValueData(arabicName: 'الكسل', emoji: '😴', description: 'كن نشيطاً'),
  ];

  static ValueData getRandomGoodValue() {
    return goodValues[(DateTime.now().millisecondsSinceEpoch %
        goodValues.length)];
  }

  static ValueData getRandomBadBehavior() {
    return badBehaviors[(DateTime.now().millisecondsSinceEpoch %
        badBehaviors.length)];
  }
}
