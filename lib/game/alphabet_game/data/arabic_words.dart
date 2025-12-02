/// Arabic words data for the alphabet learning game
class ArabicWord {
  final String letter;
  final String word;
  final String emoji;

  const ArabicWord({
    required this.letter,
    required this.word,
    required this.emoji,
  });
}

/// Complete list of Arabic alphabet with simple words
class ArabicAlphabetData {
  static const List<ArabicWord> words = [
    ArabicWord(letter: 'أ', word: 'أسد', emoji: '🦁'),
    ArabicWord(letter: 'ب', word: 'بطة', emoji: '🦆'),
    ArabicWord(letter: 'ت', word: 'تفاحة', emoji: '🍎'),
    ArabicWord(letter: 'ث', word: 'ثعلب', emoji: '🦊'),
    ArabicWord(letter: 'ج', word: 'جمل', emoji: '🐫'),
    ArabicWord(letter: 'ح', word: 'حصان', emoji: '🐴'),
    ArabicWord(letter: 'خ', word: 'خروف', emoji: '🐑'),
    ArabicWord(letter: 'د', word: 'دب', emoji: '🐻'),
    ArabicWord(letter: 'ذ', word: 'ذئب', emoji: '🐺'),
    ArabicWord(letter: 'ر', word: 'رمان', emoji: '🍎'),
    ArabicWord(letter: 'ز', word: 'زرافة', emoji: '🦒'),
    ArabicWord(letter: 'س', word: 'سمكة', emoji: '🐟'),
    ArabicWord(letter: 'ش', word: 'شمس', emoji: '☀️'),
    ArabicWord(letter: 'ص', word: 'صقر', emoji: '🦅'),
    ArabicWord(letter: 'ض', word: 'ضفدع', emoji: '🐸'),
    ArabicWord(letter: 'ط', word: 'طائر', emoji: '🐦'),
    ArabicWord(letter: 'ظ', word: 'ظبي', emoji: '🦌'),
    ArabicWord(letter: 'ع', word: 'عصفور', emoji: '🐦'),
    ArabicWord(letter: 'غ', word: 'غراب', emoji: '🦅'),
    ArabicWord(letter: 'ف', word: 'فيل', emoji: '🐘'),
    ArabicWord(letter: 'ق', word: 'قطة', emoji: '🐱'),
    ArabicWord(letter: 'ك', word: 'كلب', emoji: '🐕'),
    ArabicWord(letter: 'ل', word: 'ليمون', emoji: '🍋'),
    ArabicWord(letter: 'م', word: 'موز', emoji: '🍌'),
    ArabicWord(letter: 'ن', word: 'نحلة', emoji: '🐝'),
    ArabicWord(letter: 'ه', word: 'هدهد', emoji: '🦜'),
    ArabicWord(letter: 'و', word: 'وردة', emoji: '🌹'),
    ArabicWord(letter: 'ي', word: 'يد', emoji: '✋'),
  ];

  /// Get a subset of letters for a specific level
  static List<ArabicWord> getWordsForLevel(int level) {
    // Start with 5 letters, add 3 more each level
    final count = (5 + (level - 1) * 3).clamp(5, words.length);
    return words.sublist(0, count);
  }

  /// Get random words excluding the target
  static List<String> getRandomLetters(String targetLetter, int count) {
    final available =
        words
            .where((w) => w.letter != targetLetter)
            .map((w) => w.letter)
            .toList()
          ..shuffle();
    return available.take(count).toList();
  }
}
