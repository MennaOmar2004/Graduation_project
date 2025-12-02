import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../alphabet_learning_game.dart';

class LetterComponent extends PositionComponent
    with HasGameReference<AlphabetLearningGame>, TapCallbacks {
  final String letter;
  final double speed;
  final Color color;

  LetterComponent({
    required this.letter,
    required Vector2 position,
    required this.speed,
    required this.color,
  }) : super(
         position: position,
         size: Vector2(110, 110),
         anchor: Anchor.center,
       );

  @override
  Future<void> onLoad() async {
    // Add tap hitbox - larger for easier tapping
    add(CircleHitbox(radius: 55)..position = Vector2(55, 55));

    // Add floating animation
    add(
      MoveEffect.by(
        Vector2(0, -8),
        EffectController(
          duration: 1.2,
          infinite: true,
          reverseDuration: 1.2,
          curve: Curves.easeInOut,
        ),
      ),
    );

    // Add gentle rotation
    add(
      RotateEffect.by(
        0.1,
        EffectController(duration: 2.0, infinite: true, reverseDuration: 2.0),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Fall down
    position.y += speed * dt;

    // Remove if off screen
    if (position.y > game.size.y + height) {
      game.onLetterMissed();
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final center = Offset(size.x / 2, size.y / 2);
    final radius = 50.0;

    // Draw outer glow
    final glowPaint =
        Paint()
          ..color = color.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center, radius + 8, glowPaint);

    // Draw main circle with gradient
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradientPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [color, Color.lerp(color, Colors.white, 0.3)!],
          ).createShader(rect);
    canvas.drawCircle(center, radius, gradientPaint);

    // Draw white inner circle
    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius - 8, innerPaint);

    // Draw decorative ring
    final ringPaint =
        Paint()
          ..color = color.withOpacity(0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
    canvas.drawCircle(center, radius - 4, ringPaint);

    // Draw the letter - PROPERLY CENTERED
    final textSpan = TextSpan(
      text: letter,
      style: TextStyle(
        fontSize: 55,
        fontWeight: FontWeight.bold,
        color: color,
        fontFamily: 'Cairo',
        height: 1.0,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
    );

    textPainter.layout();

    // Calculate proper center position accounting for text metrics
    final textOffset = Offset(
      center.dx - (textPainter.width / 2),
      center.dy - (textPainter.height / 2),
    );

    textPainter.paint(canvas, textOffset);

    // Draw subtle sparkle effect
    final sparklePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.6)
          ..style = PaintingStyle.fill;

    // Top-right sparkle
    canvas.drawCircle(Offset(center.dx + 25, center.dy - 25), 3, sparklePaint);
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.onLetterTapped(letter);

    // Burst animation
    add(ScaleEffect.to(Vector2.all(1.8), EffectController(duration: 0.12)));

    // Fade and remove
    Future.delayed(const Duration(milliseconds: 120), () {
      if (isMounted) removeFromParent();
    });
  }
}

/// Spawns letters at random intervals
class LetterSpawner extends Component
    with HasGameReference<AlphabetLearningGame> {
  late Timer _timer;
  final Random _rng = Random();
  double _currentInterval = 2.0;

  LetterSpawner() {
    _timer = Timer(_currentInterval, repeat: true, onTick: _spawnLetter);
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void update(double dt) {
    _timer.update(dt);
  }

  void _spawnLetter() {
    if (!game.isGameActive || game.currentWord == null) return;

    // Spawn either the target letter or a random wrong letter
    final isTarget = _rng.nextDouble() < 0.4; // 40% chance of target letter
    final letter =
        isTarget
            ? game.currentWord!.letter
            : game.wrongLetters[_rng.nextInt(game.wrongLetters.length)];

    final x = _rng.nextDouble() * (game.size.x - 140) + 70;
    final speed = _rng.nextDouble() * 50 + 120;

    // More vibrant, carefully chosen colors
    final colors = [
      const Color(0xFFFF6B9D), // Pink
      const Color(0xFF4ECDC4), // Turquoise
      const Color(0xFFFFBE0B), // Yellow
      const Color(0xFFFF006E), // Magenta
      const Color(0xFF8338EC), // Purple
      const Color(0xFF3A86FF), // Blue
      const Color(0xFFFB5607), // Orange
      const Color(0xFF06FFA5), // Mint
    ];

    game.add(
      LetterComponent(
        letter: letter,
        position: Vector2(x, -60),
        speed: speed,
        color: colors[_rng.nextInt(colors.length)],
      ),
    );
  }

  void reset() {
    _currentInterval = 2.0;
    _timer.stop();
    _timer = Timer(_currentInterval, repeat: true, onTick: _spawnLetter);
    _timer.start();
  }
}
