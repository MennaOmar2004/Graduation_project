import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../star_catcher_game.dart';

class BackgroundComponent extends Component
    with HasGameReference<StarCatcherGame> {
  late List<TwinklingStarBackground> backgroundStars;
  late List<CloudComponent> clouds;

  @override
  Future<void> onLoad() async {
    // Create twinkling background stars
    backgroundStars = [];
    final random = Random();
    for (int i = 0; i < 50; i++) {
      final star = TwinklingStarBackground(
        position: Vector2(
          random.nextDouble() * game.size.x,
          random.nextDouble() * game.size.y,
        ),
        size: random.nextDouble() * 3 + 1,
        twinkleSpeed: random.nextDouble() * 2 + 1,
      );
      backgroundStars.add(star);
      add(star);
    }

    // Create clouds for parallax effect
    clouds = [];
    for (int i = 0; i < 5; i++) {
      final cloud = CloudComponent(
        position: Vector2(
          random.nextDouble() * game.size.x,
          random.nextDouble() * game.size.y * 0.6,
        ),
        speed: random.nextDouble() * 20 + 10,
        opacity: random.nextDouble() * 0.2 + 0.1,
      );
      clouds.add(cloud);
      add(cloud);
    }
  }

  @override
  void render(Canvas canvas) {
    // Draw gradient background
    final rect = Rect.fromLTWH(0, 0, game.size.x, game.size.y);
    final paint =
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A0033), // Deep purple (night sky)
              Color(0xFF2D1B4E), // Purple
              Color(0xFF4A2C6B), // Lighter purple
              Color(0xFF6B4C8A), // Even lighter
            ],
          ).createShader(rect);
    canvas.drawRect(rect, paint);

    super.render(canvas);
  }
}

/// Twinkling star in the background
class TwinklingStarBackground extends PositionComponent {
  final double starSize;
  final double twinkleSpeed;
  double elapsed = 0;

  TwinklingStarBackground({
    required Vector2 position,
    required double size,
    required this.twinkleSpeed,
  }) : starSize = size,
       super(
         position: position,
         size: Vector2.all(size),
         anchor: Anchor.center,
       );

  @override
  void update(double dt) {
    super.update(dt);
    elapsed += dt * twinkleSpeed;
  }

  @override
  void render(Canvas canvas) {
    final opacity = (sin(elapsed) * 0.5 + 0.5).clamp(0.2, 1.0);

    final paint =
        Paint()
          ..color = Colors.white.withOpacity(opacity)
          ..style = PaintingStyle.fill;

    // Draw a small star shape
    canvas.drawCircle(Offset(starSize / 2, starSize / 2), starSize / 2, paint);

    // Add a subtle glow
    final glowPaint =
        Paint()
          ..color = Colors.white.withOpacity(opacity * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawCircle(Offset(starSize / 2, starSize / 2), starSize, glowPaint);
  }
}

/// Cloud component for parallax effect
class CloudComponent extends PositionComponent
    with HasGameReference<StarCatcherGame> {
  final double speed;
  final double opacity;

  CloudComponent({
    required Vector2 position,
    required this.speed,
    required this.opacity,
  }) : super(position: position, size: Vector2(120, 60), anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);

    // Move cloud to the right
    position.x += speed * dt;

    // Wrap around when off screen
    if (position.x > game.size.x + width) {
      position.x = -width;
    }
  }

  @override
  void render(Canvas canvas) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(opacity)
          ..style = PaintingStyle.fill;

    // Draw a simple cloud shape (three overlapping circles)
    final radius1 = size.x * 0.25;
    final radius2 = size.x * 0.3;
    final radius3 = size.x * 0.25;

    canvas.drawCircle(Offset(size.x * 0.25, size.y * 0.6), radius1, paint);
    canvas.drawCircle(Offset(size.x * 0.5, size.y * 0.5), radius2, paint);
    canvas.drawCircle(Offset(size.x * 0.75, size.y * 0.6), radius3, paint);
  }
}
