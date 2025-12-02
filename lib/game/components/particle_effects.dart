import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Particle effect for star collection
class StarCollectionEffect extends Component {
  final Vector2 position;

  StarCollectionEffect({required this.position});

  @override
  Future<void> onLoad() async {
    final random = Random();

    // Create sparkle particles
    for (int i = 0; i < 20; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final speed = random.nextDouble() * 200 + 100;
      final velocity = Vector2(cos(angle), sin(angle)) * speed;

      final particle = SparkleParticle(
        position: position.clone(),
        velocity: velocity,
        color: _getRandomSparkleColor(random),
        size: random.nextDouble() * 8 + 4,
        lifetime: random.nextDouble() * 0.5 + 0.5,
      );

      parent?.add(particle);
    }

    // Auto-remove after all particles are done
    Future.delayed(const Duration(milliseconds: 1500), () {
      removeFromParent();
    });
  }

  Color _getRandomSparkleColor(Random random) {
    final colors = [
      const Color(0xFFFFD700), // Gold
      const Color(0xFFFFFF00), // Yellow
      const Color(0xFFFFA500), // Orange
      const Color(0xFFFFFFFF), // White
      const Color(0xFFFF69B4), // Pink
    ];
    return colors[random.nextInt(colors.length)];
  }
}

/// Individual sparkle particle
class SparkleParticle extends PositionComponent {
  Vector2 velocity;
  final Color color;
  final double lifetime;
  double elapsed = 0;
  final double initialSize;

  SparkleParticle({
    required Vector2 position,
    required this.velocity,
    required this.color,
    required double size,
    required this.lifetime,
  }) : initialSize = size,
       super(
         position: position,
         size: Vector2.all(size),
         anchor: Anchor.center,
       );

  @override
  void update(double dt) {
    super.update(dt);

    elapsed += dt;

    // Update position
    position += velocity * dt;

    // Apply gravity
    velocity.y += 500 * dt;

    // Fade out and shrink
    final progress = elapsed / lifetime;
    final opacity = 1.0 - progress;
    size = Vector2.all(initialSize * (1.0 - progress * 0.5));

    // Remove when lifetime is over
    if (elapsed >= lifetime) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final progress = elapsed / lifetime;
    final opacity = (1.0 - progress).clamp(0.0, 1.0);

    final paint =
        Paint()
          ..color = color.withOpacity(opacity)
          ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
  }
}

/// Trail effect for falling stars
class StarTrailEffect extends Component {
  final PositionComponent parent;
  final List<TrailParticle> trail = [];
  final int maxTrailLength = 10;
  double timeSinceLastParticle = 0;
  final double particleInterval = 0.05;

  StarTrailEffect({required this.parent});

  @override
  void update(double dt) {
    super.update(dt);

    timeSinceLastParticle += dt;

    if (timeSinceLastParticle >= particleInterval) {
      timeSinceLastParticle = 0;

      // Add new trail particle at parent position
      final particle = TrailParticle(
        position: parent.position.clone(),
        lifetime: 0.3,
      );

      trail.add(particle);
      parent.parent?.add(particle);

      // Remove old particles
      if (trail.length > maxTrailLength) {
        trail.first.removeFromParent();
        trail.removeAt(0);
      }
    }
  }
}

/// Individual trail particle
class TrailParticle extends PositionComponent {
  final double lifetime;
  double elapsed = 0;

  TrailParticle({required Vector2 position, required this.lifetime})
    : super(position: position, size: Vector2.all(15), anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);

    elapsed += dt;

    if (elapsed >= lifetime) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final progress = elapsed / lifetime;
    final opacity = (1.0 - progress).clamp(0.0, 1.0);
    final currentSize = size.x * (1.0 - progress * 0.5);

    final paint =
        Paint()
          ..color = const Color(0xFFFFD700).withOpacity(opacity * 0.5)
          ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.x / 2, size.y / 2), currentSize / 2, paint);
  }
}

/// Power-up collection effect
class PowerUpCollectionEffect extends Component {
  final Vector2 position;
  final Color color;

  PowerUpCollectionEffect({required this.position, required this.color});

  @override
  Future<void> onLoad() async {
    final random = Random();

    // Create ring expansion effect
    for (int ring = 0; ring < 3; ring++) {
      Future.delayed(Duration(milliseconds: ring * 100), () {
        if (isMounted) {
          final ringEffect = RingExpansionParticle(
            position: position.clone(),
            color: color,
            delay: ring * 0.1,
          );
          parent?.add(ringEffect);
        }
      });
    }

    // Create sparkles
    for (int i = 0; i < 15; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final speed = random.nextDouble() * 150 + 100;
      final velocity = Vector2(cos(angle), sin(angle)) * speed;

      final particle = SparkleParticle(
        position: position.clone(),
        velocity: velocity,
        color: color,
        size: random.nextDouble() * 6 + 3,
        lifetime: random.nextDouble() * 0.6 + 0.4,
      );

      parent?.add(particle);
    }

    Future.delayed(const Duration(milliseconds: 1000), () {
      removeFromParent();
    });
  }
}

/// Ring expansion particle for power-ups
class RingExpansionParticle extends PositionComponent {
  final Color color;
  final double delay;
  double elapsed = 0;
  final double lifetime = 0.8;

  RingExpansionParticle({
    required Vector2 position,
    required this.color,
    required this.delay,
  }) : super(position: position, size: Vector2.all(20), anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);

    elapsed += dt;

    if (elapsed >= lifetime + delay) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    if (elapsed < delay) return;

    final progress = ((elapsed - delay) / lifetime).clamp(0.0, 1.0);
    final opacity = (1.0 - progress).clamp(0.0, 1.0);
    final radius = 20 + progress * 60;

    final paint =
        Paint()
          ..color = color.withOpacity(opacity * 0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;

    canvas.drawCircle(Offset(size.x / 2, size.y / 2), radius, paint);
  }
}
