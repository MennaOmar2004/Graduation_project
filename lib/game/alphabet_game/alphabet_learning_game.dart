import 'dart:math';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'components/alphabet_background.dart';
import 'components/letter_component.dart';
import 'components/target_word_component.dart';
import 'data/arabic_words.dart';

class AlphabetLearningGame extends FlameGame {
  late AlphabetBackground background;
  late LetterSpawner letterSpawner;
  late TargetWordComponent targetWordDisplay;

  // Game state
  int score = 0;
  int level = 1;
  int correctAnswers = 0;
  int lives = 3;
  bool isGameActive = true;
  bool showEncouragement = false;
  String encouragementMessage = '';

  // Current word and wrong letters
  ArabicWord? currentWord;
  List<String> wrongLetters = [];
  List<ArabicWord> availableWords = [];
  final Random _random = Random();

  @override
  Future<void> onLoad() async {
    // Add background
    background = AlphabetBackground();
    add(background);

    // Add target word display
    targetWordDisplay = TargetWordComponent();
    add(targetWordDisplay);

    // Add letter spawner
    letterSpawner = LetterSpawner();
    add(letterSpawner);

    // Start first word
    _loadNextWord();
  }

  void _loadNextWord() {
    // Get words for current level
    availableWords = ArabicAlphabetData.getWordsForLevel(level);

    // Pick random word
    currentWord = availableWords[_random.nextInt(availableWords.length)];
    targetWordDisplay.setWord(currentWord!);

    // Get 3-4 wrong letters
    wrongLetters = ArabicAlphabetData.getRandomLetters(
      currentWord!.letter,
      _random.nextInt(2) + 3, // 3 or 4 wrong letters
    );

    // Remove all existing letters
    children.whereType<LetterComponent>().forEach(
      (letter) => letter.removeFromParent(),
    );
  }

  void onLetterTapped(String letter) {
    if (!isGameActive || currentWord == null) return;

    // Normalize strings by trimming whitespace
    final tappedLetter = letter.trim();
    final correctLetter = currentWord!.letter.trim();

    // Debug output
    print('Tapped: "$tappedLetter" (${tappedLetter.codeUnits})');
    print('Correct: "$correctLetter" (${correctLetter.codeUnits})');
    print('Match: ${tappedLetter == correctLetter}');

    if (tappedLetter == correctLetter) {
      // Correct answer!
      print('✅ CORRECT!');
      _onCorrectAnswer();
    } else {
      // Wrong answer
      print('❌ WRONG!');
      _onWrongAnswer();
    }
  }

  void _onCorrectAnswer() {
    score += 10;
    correctAnswers++;

    // Show encouragement
    final messages = [
      'أحسنت! 👏',
      'ممتاز! ⭐',
      'رائع! 🎉',
      'عظيم! 💫',
      'برافو! 🌟',
    ];
    encouragementMessage = messages[_random.nextInt(messages.length)];
    showEncouragement = true;

    // Hide encouragement after 1 second
    Future.delayed(const Duration(milliseconds: 1000), () {
      showEncouragement = false;
    });

    // Check level progression (10 correct answers = next level)
    if (correctAnswers >= 10) {
      correctAnswers = 0;
      level++;
      encouragementMessage = 'مستوى جديد! 🎊';
      showEncouragement = true;
    }

    // Load next word
    Future.delayed(const Duration(milliseconds: 500), () {
      _loadNextWord();
    });

    // TODO: Play success sound
  }

  void Function(int score)? onGameFinished;

  void _onWrongAnswer() {
    lives--;

    if (lives <= 0) {
      // Game over - but gentle for kids
      encouragementMessage = 'حاول مرة أخرى! 💪';
      showEncouragement = true;
      onGameFinished?.call(score);
      lives = 3; // Reset lives
    } else {
      encouragementMessage = 'حاول مرة أخرى 😊';
      showEncouragement = true;

      Future.delayed(const Duration(milliseconds: 1000), () {
        showEncouragement = false;
      });
    }

    // TODO: Play gentle error sound
  }

  void onLetterMissed() {
    // Don't penalize for missing letters - just keep playing
  }

  void restartGame() {
    score = 0;
    level = 1;
    correctAnswers = 0;
    lives = 3;
    isGameActive = true;
    showEncouragement = false;

    // Remove all letters
    children.whereType<LetterComponent>().forEach(
      (letter) => letter.removeFromParent(),
    );

    // Reset spawner
    letterSpawner.reset();

    // Load first word
    _loadNextWord();
  }
}
