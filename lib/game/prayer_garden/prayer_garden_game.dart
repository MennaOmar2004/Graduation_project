import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'components/flower_component.dart';
import 'data/prayer_times_data.dart';

/// Beautiful prayer garden educational game
class PrayerGardenGame extends FlameGame with TapDetector {
  final List<FlowerComponent> flowers = [];
  final List<ButterflyComponent> butterflies = [];

  int currentPrayerIndex = 0;
  int score = 0;
  bool isGameActive = true;

  Function(int)? onScoreChanged;
  Function(PrayerTime)? onPrayerChanged;
  Function(bool)? onAnswerSubmitted;

  @override
  Future<void> onLoad() async {
    // Add butterflies
    for (int i = 0; i < 5; i++) {
      final butterfly = ButterflyComponent(
        position: Vector2(
          math.Random().nextDouble() * size.x,
          math.Random().nextDouble() * size.y,
        ),
      );
      butterflies.add(butterfly);
      add(butterfly);
    }

    // Start first prayer
    _loadNextPrayer();
  }

  void _loadNextPrayer() {
    if (currentPrayerIndex >= PrayerTimesData.prayers.length) {
      // Game complete!
      isGameActive = false;
      return;
    }

    final prayer = PrayerTimesData.prayers[currentPrayerIndex];
    onPrayerChanged?.call(prayer);
  }

  void checkAnswer(int selectedHour) {
    if (!isGameActive) return;

    final correctHour = PrayerTimesData.prayers[currentPrayerIndex].hour;
    final isCorrect = (selectedHour - correctHour).abs() <= 1; // Allow ±1 hour

    if (isCorrect) {
      score += 10;
      onScoreChanged?.call(score);
      onAnswerSubmitted?.call(true);

      // Plant flower
      _plantFlower();

      // Move to next prayer
      currentPrayerIndex++;

      Future.delayed(const Duration(milliseconds: 1000), () {
        if (isGameActive) {
          _loadNextPrayer();
        }
      });
    } else {
      onAnswerSubmitted?.call(false);
    }
  }

  void _plantFlower() {
    final prayer = PrayerTimesData.prayers[currentPrayerIndex];
    final x = (currentPrayerIndex + 1) * (size.x / 6);
    final y = size.y * 0.7;

    final flower = FlowerComponent(
      prayer: prayer,
      position: Vector2(x, y),
      size: Vector2.all(size.x * 0.15),
      isPlanted: true,
    );

    flowers.add(flower);
    add(flower);
  }

  void restartGame() {
    currentPrayerIndex = 0;
    score = 0;
    isGameActive = true;

    for (final flower in flowers) {
      flower.removeFromParent();
    }
    flowers.clear();

    _loadNextPrayer();
    onScoreChanged?.call(score);
  }

  @override
  void render(Canvas canvas) {
    // Dynamic sky gradient based on current prayer
    final prayer =
        currentPrayerIndex < PrayerTimesData.prayers.length
            ? PrayerTimesData.prayers[currentPrayerIndex]
            : PrayerTimesData.prayers.last;

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        _parseColor(prayer.skyGradientStart),
        _parseColor(prayer.skyGradientEnd),
        const Color(0xFF4CAF50), // Grass
      ],
      stops: const [0.0, 0.6, 1.0],
    );

    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    super.render(canvas);
  }

  Color _parseColor(String hex) {
    return Color(int.parse(hex.substring(1), radix: 16) + 0xFF000000);
  }
}
