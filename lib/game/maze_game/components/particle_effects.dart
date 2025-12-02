import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CollectionParticles extends Component {
  final Vector2 position;
  final Color color;
  final bool isGood;

  CollectionParticles({
    required this.position,
    required this.color,
    required this.isGood,
  });

  @override
  Future<void> onLoad() async {
    final random = Random();

    // Create burst of particles
    for (int i = 0; i < 20; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final speed = random.nextDouble() * 200 + 100;

      add(
        ParticleSystemComponent(
          particle: AcceleratedParticle(
            acceleration: Vector2(0, 200),
            speed: Vector2(cos(angle) * speed, sin(angle) * speed),
            position: position,
            child: CircleParticle(
              radius: random.nextDouble() * 4 + 2,
              paint: Paint()..color = color.withOpacity(0.8),
            ),
            lifespan: 0.8,
          ),
        ),
      );
    }

    // Remove after particles are done
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (isMounted) removeFromParent();
    });
  }
}

class StarBurstEffect extends Component {
  final Vector2 position;

  StarBurstEffect({required this.position});

  @override
  Future<void> onLoad() async {
    final random = Random();

    // Create star burst
    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * 2 * pi;

      add(
        ParticleSystemComponent(
          particle: AcceleratedParticle(
            acceleration: Vector2(0, 100),
            speed: Vector2(cos(angle) * 150, sin(angle) * 150),
            position: position,
            child: CircleParticle(
              radius: 6,
              paint:
                  Paint()
                    ..color = const Color(0xFFFFD700)
                    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
            ),
            lifespan: 0.6,
          ),
        ),
      );
    }

    Future.delayed(const Duration(milliseconds: 700), () {
      if (isMounted) removeFromParent();
    });
  }
}
