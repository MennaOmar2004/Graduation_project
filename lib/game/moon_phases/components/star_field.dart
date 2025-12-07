import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Beautiful starry background for moon phases game
class StarField extends PositionComponent {
  final List<Star> stars = [];
  final math.Random _random = math.Random();

  @override
  Future<void> onLoad() async {
    // Create 150 twinkling stars
    for (int i = 0; i < 150; i++) {
      final star = Star(
        position: Vector2(
          _random.nextDouble() * size.x,
          _random.nextDouble() * size.y,
        ),
        size: _random.nextDouble() * 2 + 1,
        twinkleSpeed: _random.nextDouble() * 2 + 1,
      );
      stars.add(star);
      add(star);
    }

    // Add shooting stars occasionally
    add(TimerComponent(period: 5.0, repeat: true, onTick: _addShootingStar));
  }

  void _addShootingStar() {
    final shootingStar = ShootingStar(
      start: Vector2(_random.nextDouble() * size.x, 0),
      end: Vector2(
        _random.nextDouble() * size.x,
        _random.nextDouble() * size.y * 0.5,
      ),
    );
    add(shootingStar);
  }

  @override
  void render(Canvas canvas) {
    // Gradient background
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF0A0E27),
        const Color(0xFF1A1F3A),
        const Color(0xFF2D1B4E),
      ],
    );

    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    super.render(canvas);
  }
}

/// Individual twinkling star
class Star extends PositionComponent {
  final double twinkleSpeed;
  double opacity = 1.0;
  bool increasing = false;

  Star({
    required Vector2 position,
    required double size,
    required this.twinkleSpeed,
  }) : super(position: position, size: Vector2.all(size));

  @override
  void update(double dt) {
    super.update(dt);

    // Twinkle effect
    if (increasing) {
      opacity += dt * twinkleSpeed;
      if (opacity >= 1.0) {
        opacity = 1.0;
        increasing = false;
      }
    } else {
      opacity -= dt * twinkleSpeed;
      if (opacity <= 0.3) {
        opacity = 0.3;
        increasing = true;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final paint =
        Paint()
          ..color = Colors.white.withValues(alpha: opacity)
          ..style = PaintingStyle.fill;

    // Draw star with glow
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);

    // Glow effect
    final glowPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: opacity * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x, glowPaint);
  }
}

/// Shooting star effect
class ShootingStar extends PositionComponent {
  final Vector2 start;
  final Vector2 end;
  double progress = 0.0;

  ShootingStar({required this.start, required this.end})
    : super(position: start);

  @override
  Future<void> onLoad() async {
    // Fade handled manually in render method
  }

  @override
  void update(double dt) {
    super.update(dt);
    progress += dt * 0.8;
    if (progress >= 1.0) {
      removeFromParent();
      return;
    }

    position = start + (end - start) * progress;
  }

  @override
  void render(Canvas canvas) {
    final paint =
        Paint()
          ..color = Colors.white.withValues(alpha: 1.0 - progress)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    // Draw trail
    final trail = start + (end - start) * (progress - 0.1).clamp(0.0, 1.0);
    canvas.drawLine(trail.toOffset(), position.toOffset(), paint);

    // Draw head
    final headPaint =
        Paint()..color = Colors.white.withValues(alpha: 1.0 - progress);
    canvas.drawCircle(position.toOffset(), 3, headPaint);
  }
}
