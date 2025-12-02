import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../alphabet_learning_game.dart';
import '../data/arabic_words.dart';

class TargetWordComponent extends PositionComponent
    with HasGameReference<AlphabetLearningGame> {
  ArabicWord? currentWord;

  TargetWordComponent()
    : super(
        size: Vector2(380, 180), // Larger size
        anchor: Anchor.center,
      );

  @override
  Future<void> onLoad() async {
    // Position higher from bottom for better visibility
    position = Vector2(game.size.x / 2, game.size.y - 120);
  }

  void setWord(ArabicWord word) {
    currentWord = word;
  }

  @override
  void render(Canvas canvas) {
    if (currentWord == null) return;

    // Draw container background with shadow
    final shadowRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(5, 5, size.x, size.y),
      const Radius.circular(35),
    );
    final shadowPaint =
        Paint()
          ..color = Colors.black.withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawRRect(shadowRect, shadowPaint);

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(35),
    );

    final paint =
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFFFF6B9D), Color(0xFFFF8E53)],
          ).createShader(Rect.fromLTWH(0, 0, size.x, size.y));

    canvas.drawRRect(rect, paint);

    // Draw white border
    final borderPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5;
    canvas.drawRRect(rect, borderPaint);

    // Draw instruction text at top
    final instructionPainter = TextPainter(
      text: const TextSpan(
        text: 'اضغط على الحرف الأول',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Cairo',
        ),
      ),
      textDirection: TextDirection.rtl,
    );
    instructionPainter.layout();
    instructionPainter.paint(
      canvas,
      Offset((size.x - instructionPainter.width) / 2, 15),
    );

    // Draw emoji (larger)
    final emojiPainter = TextPainter(
      text: TextSpan(
        text: currentWord!.emoji,
        style: const TextStyle(fontSize: 70),
      ),
      textDirection: TextDirection.ltr,
    );
    emojiPainter.layout();
    emojiPainter.paint(canvas, Offset(25, size.y - emojiPainter.height - 15));

    // Draw word (larger)
    final wordPainter = TextPainter(
      text: TextSpan(
        text: currentWord!.word,
        style: const TextStyle(
          fontSize: 60,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Cairo',
          shadows: [
            Shadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 4),
          ],
        ),
      ),
      textDirection: TextDirection.rtl,
    );
    wordPainter.layout();
    wordPainter.paint(
      canvas,
      Offset(size.x - wordPainter.width - 25, size.y - wordPainter.height - 15),
    );
  }
}
