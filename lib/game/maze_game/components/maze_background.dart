import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../maze_game.dart';

class MazeBackground extends Component with HasGameReference<MazeGame> {
  @override
  void render(Canvas canvas) {
    // Beautiful gradient background
    final rect = Rect.fromLTWH(0, 0, game.size.x, game.size.y);
    final paint =
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF3E0), // Light peach
              Color(0xFFFFE0F0), // Light pink
              Color(0xFFE8F5E9), // Light green
              Color(0xFFE3F2FD), // Light blue
            ],
          ).createShader(rect);
    canvas.drawRect(rect, paint);

    super.render(canvas);
  }
}

class FloatingParticle extends PositionComponent
    with HasGameReference<MazeGame> {
  final Color color;
  final double speed;
  double elapsed = 0;

  FloatingParticle({
    required Vector2 position,
    required this.color,
    required this.speed,
  }) : super(position: position, size: Vector2(20, 20), anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    elapsed += dt;

    // Float upward in a sine wave
    position.y -= speed * dt;
    position.x += sin(elapsed * 3) * 30 * dt;

    // Wrap around
    if (position.y < -size.y) {
      position.y = game.size.y + size.y;
      position.x = Random().nextDouble() * game.size.x;
    }
  }

  @override
  void render(Canvas canvas) {
    final opacity = (sin(elapsed * 2) * 0.3 + 0.5).clamp(0.0, 1.0);
    final paint =
        Paint()
          ..color = color.withOpacity(opacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 8, paint);
  }
}
