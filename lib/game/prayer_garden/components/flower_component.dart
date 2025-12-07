import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../data/prayer_times_data.dart';

/// Beautiful blooming flower component
class FlowerComponent extends PositionComponent {
  final PrayerTime prayer;
  final bool isPlanted;
  double bloomProgress = 0.0;

  FlowerComponent({
    required this.prayer,
    required Vector2 position,
    required Vector2 size,
    this.isPlanted = false,
  }) : super(position: position, size: size, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    if (isPlanted) {
      // Bloom animation
      // Fade in handled by scale effect

      // Grow animation
      add(
        ScaleEffect.to(
          Vector2.all(1.0),
          EffectController(duration: 1.0, curve: Curves.elasticOut),
        ),
      );

      // Gentle sway
      add(
        MoveEffect.by(
          Vector2(0, -5),
          EffectController(
            duration: 2.0,
            infinite: true,
            reverseDuration: 2.0,
            curve: Curves.easeInOut,
          ),
        ),
      );
    }
  }

  @override
  void render(Canvas canvas) {
    if (!isPlanted) return;

    final center = Offset(size.x / 2, size.y / 2);

    // Draw stem
    final stemPaint =
        Paint()
          ..color = const Color(0xFF4CAF50)
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(center.dx, size.y), center, stemPaint);

    // Draw leaves
    final leafPaint = Paint()..color = const Color(0xFF66BB6A);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - 10, center.dy + 10),
        width: 15,
        height: 8,
      ),
      leafPaint,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + 10, center.dy + 10),
        width: 15,
        height: 8,
      ),
      leafPaint,
    );

    // Draw flower petals
    final petalPaint = Paint()..color = prayer.color;
    final petalCount = 6;
    final petalRadius = size.x * 0.15;

    for (int i = 0; i < petalCount; i++) {
      final angle = (i * 2 * math.pi / petalCount);
      final petalCenter = Offset(
        center.dx + math.cos(angle) * petalRadius,
        center.dy + math.sin(angle) * petalRadius,
      );

      canvas.drawCircle(petalCenter, petalRadius * 0.8, petalPaint);
    }

    // Draw flower center
    final centerPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [const Color(0xFFFFD700), const Color(0xFFFFA500)],
          ).createShader(
            Rect.fromCircle(center: center, radius: petalRadius * 0.5),
          );

    canvas.drawCircle(center, petalRadius * 0.5, centerPaint);

    // Draw glow
    final glowPaint =
        Paint()
          ..color = prayer.color.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawCircle(center, size.x * 0.4, glowPaint);
  }
}

/// Butterfly particle effect
class ButterflyComponent extends PositionComponent {
  final math.Random _random = math.Random();
  Vector2 velocity = Vector2.zero();
  double flutterTime = 0.0;

  ButterflyComponent({required Vector2 position})
    : super(position: position, size: Vector2.all(20), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    velocity = Vector2(
      _random.nextDouble() * 100 - 50,
      _random.nextDouble() * 100 - 50,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    flutterTime += dt * 5;
    position += velocity * dt;

    // Flutter effect
    velocity.x += math.sin(flutterTime) * 10 * dt;
    velocity.y += math.cos(flutterTime) * 10 * dt;

    // Wrap around screen - use game reference
    final gameSize = findGame()?.size ?? Vector2.zero();
    if (position.x < 0) position.x = gameSize.x;
    if (position.x > gameSize.x) position.x = 0;
    if (position.y < 0) position.y = gameSize.y;
    if (position.y > gameSize.y) position.y = 0;
  }

  @override
  void render(Canvas canvas) {
    final paint =
        Paint()
          ..color = const Color(0xFFFF6B9D)
          ..style = PaintingStyle.fill;

    // Draw butterfly wings
    final wingPath = Path();

    // Left wing
    wingPath.addOval(
      Rect.fromCenter(center: const Offset(-5, 0), width: 12, height: 8),
    );

    // Right wing
    wingPath.addOval(
      Rect.fromCenter(center: const Offset(5, 0), width: 12, height: 8),
    );

    canvas.drawPath(wingPath, paint);

    // Draw body
    final bodyPaint = Paint()..color = const Color(0xFF6B4CE6);
    canvas.drawCircle(Offset.zero, 3, bodyPaint);
  }
}
