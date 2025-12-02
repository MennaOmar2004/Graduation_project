import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../alphabet_learning_game.dart';

class AlphabetBackground extends Component
    with HasGameReference<AlphabetLearningGame> {
  late List<FloatingLetter> floatingLetters;

  @override
  Future<void> onLoad() async {
    // Create floating decorative letters in the background
    floatingLetters = [];
    final random = Random();
    final letters = [
      'أ',
      'ب',
      'ت',
      'ج',
      'ح',
      'د',
      'ر',
      'س',
      'ش',
      'ع',
      'ف',
      'ق',
      'ل',
      'م',
      'ن',
      'ه',
      'و',
      'ي',
    ];

    for (int i = 0; i < 15; i++) {
      final letter = FloatingLetter(
        letter: letters[random.nextInt(letters.length)],
        position: Vector2(
          random.nextDouble() * game.size.x,
          random.nextDouble() * game.size.y,
        ),
        speed: random.nextDouble() * 20 + 10,
        opacity: random.nextDouble() * 0.15 + 0.05,
      );
      floatingLetters.add(letter);
      add(letter);
    }
  }

  @override
  void render(Canvas canvas) {
    // Draw vibrant gradient background
    final rect = Rect.fromLTWH(0, 0, game.size.x, game.size.y);
    final paint =
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFE5B4), // Peach
              Color(0xFFFFD4E5), // Light pink
              Color(0xFFE5D4FF), // Light purple
              Color(0xFFD4F1FF), // Light blue
            ],
          ).createShader(rect);
    canvas.drawRect(rect, paint);

    super.render(canvas);
  }
}

class FloatingLetter extends PositionComponent
    with HasGameReference<AlphabetLearningGame> {
  final String letter;
  final double speed;
  final double opacity;

  FloatingLetter({
    required this.letter,
    required Vector2 position,
    required this.speed,
    required this.opacity,
  }) : super(position: position, size: Vector2(80, 80), anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);

    // Slowly float upward
    position.y -= speed * dt;

    // Wrap around when off screen
    if (position.y < -size.y) {
      position.y = game.size.y + size.y;
    }
  }

  @override
  void render(Canvas canvas) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(
          fontSize: 60,
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(opacity),
          fontFamily: 'Cairo',
        ),
      ),
      textDirection: TextDirection.rtl,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        (size.y - textPainter.height) / 2,
      ),
    );
  }
}
