import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/particles.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../components/balloon_component.dart';
import '../components/circus_background.dart';
import '../components/circus_particle_effects.dart';

/// Stunning balloon popping mini-game
class BalloonPopGame extends FlameGame with TapDetector {
  int targetNumber = 1;
  int score = 0;
  int level = 1;
  bool isGameActive = false;

  late TextComponent instructionText;
  late TextComponent scoreText;
  final List<BalloonComponent> activeBalloons = [];
  final math.Random _random = math.Random();

  double spawnTimer = 0;
  final double spawnInterval = 2.0;

  Function(int)? onScoreChanged;
  Function()? onLevelComplete;

  @override
  Color backgroundColor() => const Color(0xFF87CEEB);

  @override
  Future<void> onLoad() async {
    // Add beautiful circus background
    add(CircusBackground());

    // Add instruction text with beautiful styling
    instructionText = TextComponent(
      text: 'اضغط على البالون رقم ١',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(color: Colors.black54, offset: Offset(3, 3), blurRadius: 6),
            Shadow(
              color: Color(0xFF6B4CE6),
              offset: Offset(0, 0),
              blurRadius: 20,
            ),
          ],
        ),
      ),
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, 50),
    );
    add(instructionText);

    // Add score display
    scoreText = TextComponent(
      text: 'النقاط: ٠',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFD700),
          shadows: [
            Shadow(color: Colors.black45, offset: Offset(2, 2), blurRadius: 4),
          ],
        ),
      ),
      anchor: Anchor.topLeft,
      position: Vector2(20, 20),
    );
    add(scoreText);

    // Add decorative confetti rain
    add(CircusParticleEffects.confettiRain(Vector2(0, 0), size.x));

    startGame();
  }

  void startGame() {
    isGameActive = true;
    targetNumber = 1;
    score = 0;
    level = 1;
    updateInstructionText();
  }

  void updateInstructionText() {
    final arabicNumber = _getArabicNumber(targetNumber);
    instructionText.text = 'اضغط على البالون رقم $arabicNumber';
  }

  void spawnBalloon() {
    if (!isGameActive) return;

    // Spawn balloon with random number (including target)
    final isTarget = _random.nextBool();
    final number = isTarget ? targetNumber : _random.nextInt(10) + 1;

    final balloon = BalloonComponent(
      number: number,
      balloonColor: _getBalloonColor(number),
      position: Vector2(
        50 + _random.nextDouble() * (size.x - 100),
        size.y + 50,
      ),
      onPopped: () => _onBalloonPopped(number),
    );

    activeBalloons.add(balloon);
    add(balloon);
  }

  void _onBalloonPopped(int number) {
    if (number == targetNumber) {
      // Correct balloon!
      score += 10 * level;
      scoreText.text = 'النقاط: ${_getArabicNumber(score)}';

      // Move to next number
      targetNumber++;

      if (targetNumber > 10) {
        // Level complete!
        _levelComplete();
      } else {
        updateInstructionText();
      }

      onScoreChanged?.call(score);
    } else {
      // Wrong balloon - small penalty
      score = math.max(0, score - 5);
      scoreText.text = 'النقاط: ${_getArabicNumber(score)}';
    }
  }

  void _levelComplete() {
    isGameActive = false;
    level++;

    // Celebration!
    add(
      CircusParticleEffects.celebrationFireworks(
        Vector2(size.x / 2, size.y / 2),
      ),
    );
    add(CircusParticleEffects.starBurst(Vector2(size.x / 2, size.y / 2)));

    // Show completion message
    final completionText = TextComponent(
      text: '🎉 أحسنت! 🎉',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFD700),
          shadows: [
            Shadow(color: Colors.black54, offset: Offset(4, 4), blurRadius: 8),
          ],
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
    );
    add(completionText);

    Future.delayed(const Duration(seconds: 2), () {
      completionText.removeFromParent();
      targetNumber = 1;
      startGame();
      onLevelComplete?.call();
    });
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isGameActive) {
      spawnTimer += dt;
      if (spawnTimer >= spawnInterval) {
        spawnTimer = 0;
        spawnBalloon();
      }
    }

    // Remove balloons that are off-screen
    activeBalloons.removeWhere((balloon) => balloon.isRemoved);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (!isGameActive) return;

    final tapPosition = info.eventPosition.widget;

    // Check balloons in reverse order (top-most first)
    for (final balloon in activeBalloons.reversed) {
      if (balloon.containsPoint(tapPosition)) {
        if (balloon.number == targetNumber) {
          // CORRECT balloon! 🎉
          add(
            CircusParticleEffects.balloonPopExplosion(
              balloon.position,
              balloon.balloonColor,
            ),
          );
          add(CircusParticleEffects.glitterTrail(balloon.position));
          add(CircusParticleEffects.starBurst(balloon.position));
          add(
            CircusParticleEffects.numberPopEffect(
              balloon.position,
              _getArabicNumber(balloon.number),
            ),
          );

          balloon.pop();
        } else {
          // WRONG balloon! ❌ Show error feedback
          _showWrongBalloonFeedback(balloon);
        }

        break; // Only interact with one balloon per tap
      }
    }
  }

  void _showWrongBalloonFeedback(BalloonComponent balloon) {
    // Shake animation
    balloon.add(
      SequenceEffect([
        MoveEffect.by(Vector2(-10, 0), EffectController(duration: 0.05)),
        MoveEffect.by(Vector2(20, 0), EffectController(duration: 0.05)),
        MoveEffect.by(Vector2(-20, 0), EffectController(duration: 0.05)),
        MoveEffect.by(Vector2(10, 0), EffectController(duration: 0.05)),
      ]),
    );

    // Show red X mark
    final xMark = TextComponent(
      text: '❌',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 48,
          shadows: [
            Shadow(color: Colors.black54, offset: Offset(2, 2), blurRadius: 4),
          ],
        ),
      ),
      anchor: Anchor.center,
      position: balloon.position,
    );
    add(xMark);

    // Fade out and remove X mark
    xMark.add(
      SequenceEffect([
        ScaleEffect.by(
          Vector2.all(1.5),
          EffectController(duration: 0.3, curve: Curves.easeOut),
        ),
        RemoveEffect(delay: 0.5),
      ]),
    );

    // Red flash particle effect
    add(
      ParticleSystemComponent(
        particle: Particle.generate(
          count: 8,
          lifespan: 0.5,
          generator: (i) {
            final angle = (i / 8) * 3.14159 * 2;
            return AcceleratedParticle(
              acceleration: Vector2(0, 100),
              speed: Vector2(math.cos(angle) * 80, math.sin(angle) * 80),
              child: CircleParticle(
                radius: 4,
                paint: Paint()..color = Colors.red,
              ),
            );
          },
        ),
        position: balloon.position,
      ),
    );
  }

  Color _getBalloonColor(int number) {
    final colors = [
      const Color(0xFFFF6B9D), // Pink
      const Color(0xFF6BCB77), // Green
      const Color(0xFF4D96FF), // Blue
      const Color(0xFFFFC93C), // Yellow
      const Color(0xFFB983FF), // Purple
      const Color(0xFFFF6B6B), // Red
      const Color(0xFF4ECDC4), // Turquoise
      const Color(0xFFFFBE0B), // Orange
      const Color(0xFFFF006E), // Magenta
      const Color(0xFF8338EC), // Violet
    ];
    return colors[number % colors.length];
  }

  String _getArabicNumber(int num) {
    if (num == 0) return '٠';

    String result = '';
    String numStr = num.toString();

    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < numStr.length; i++) {
      int digit = int.parse(numStr[i]);
      result += arabicDigits[digit];
    }

    return result;
  }
}
