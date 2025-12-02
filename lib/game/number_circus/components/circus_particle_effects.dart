import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Spectacular particle effects for circus celebrations
class CircusParticleEffects {
  static final _random = math.Random();

  /// Balloon pop explosion with confetti
  static Component balloonPopExplosion(Vector2 position, Color balloonColor) {
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: 30,
        lifespan: 1.5,
        generator: (i) {
          final angle = _random.nextDouble() * math.pi * 2;
          final speed = 100 + _random.nextDouble() * 150;

          return AcceleratedParticle(
            acceleration: Vector2(0, 200), // Gravity
            speed: Vector2(
              math.cos(angle) * speed,
              math.sin(angle) * speed - 100,
            ),
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final progress = particle.progress;
                final size = 8 * (1 - progress);

                // Rotating confetti pieces
                canvas.save();
                canvas.rotate(progress * math.pi * 4);

                final paint =
                    Paint()
                      ..color = _getConfettiColor(
                        i,
                      ).withValues(alpha: 1 - progress);

                canvas.drawRect(
                  Rect.fromCenter(
                    center: Offset.zero,
                    width: size,
                    height: size * 2,
                  ),
                  paint,
                );
                canvas.restore();
              },
            ),
          );
        },
      ),
      position: position,
    );
  }

  /// Celebration fireworks
  static Component celebrationFireworks(Vector2 position) {
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: 50,
        lifespan: 2.0,
        generator: (i) {
          final angle = (i / 50) * math.pi * 2;
          final speed = 150 + _random.nextDouble() * 100;

          return AcceleratedParticle(
            acceleration: Vector2(0, 50),
            speed: Vector2(math.cos(angle) * speed, math.sin(angle) * speed),
            child: CircleParticle(
              radius: 4,
              paint:
                  Paint()
                    ..color = _getFireworkColor(i)
                    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
            ),
          );
        },
      ),
      position: position,
    );
  }

  /// Glitter trail effect
  static Component glitterTrail(Vector2 position) {
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: 20,
        lifespan: 0.8,
        generator: (i) {
          return MovingParticle(
            from: Vector2.zero(),
            to: Vector2(
              (_random.nextDouble() - 0.5) * 40,
              (_random.nextDouble() - 0.5) * 40,
            ),
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final size = 6 * (1 - particle.progress);
                final paint =
                    Paint()
                      ..color = Colors.yellow.withValues(
                        alpha: 1 - particle.progress,
                      )
                      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

                canvas.drawCircle(Offset.zero, size, paint);

                // Draw star shape
                _drawStar(canvas, Vector2.zero(), size, paint);
              },
            ),
          );
        },
      ),
      position: position,
    );
  }

  /// Continuous confetti rain
  static Component confettiRain(Vector2 startPosition, double width) {
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: 100,
        lifespan: 3.0,
        generator: (i) {
          return AcceleratedParticle(
            acceleration: Vector2(
              (_random.nextDouble() - 0.5) * 20,
              100 + _random.nextDouble() * 50,
            ),
            speed: Vector2((_random.nextDouble() - 0.5) * 50, 0),
            child: ComputedParticle(
              lifespan: 3.0,
              renderer: (canvas, particle) {
                final progress = particle.progress;
                final size = 6.0;

                canvas.save();
                canvas.rotate(progress * math.pi * 6);

                final paint =
                    Paint()
                      ..color = _getConfettiColor(i).withValues(alpha: 0.9);

                canvas.drawRect(
                  Rect.fromCenter(
                    center: Offset.zero,
                    width: size,
                    height: size * 2,
                  ),
                  paint,
                );
                canvas.restore();
              },
            ),
          );
        },
      ),
      position: startPosition,
    );
  }

  /// Star burst effect
  static Component starBurst(Vector2 position, {Color color = Colors.yellow}) {
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: 12,
        lifespan: 1.0,
        generator: (i) {
          final angle = (i / 12) * math.pi * 2;

          return MovingParticle(
            from: Vector2.zero(),
            to: Vector2(math.cos(angle) * 80, math.sin(angle) * 80),
            curve: Curves.easeOut,
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final size = 8 * (1 - particle.progress);
                final paint =
                    Paint()
                      ..color = color.withValues(alpha: 1 - particle.progress)
                      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

                _drawStar(canvas, Vector2.zero(), size, paint);
              },
            ),
          );
        },
      ),
      position: position,
    );
  }

  /// Number pop effect
  static Component numberPopEffect(Vector2 position, String number) {
    return ParticleSystemComponent(
      particle: ScalingParticle(
        to: 2.0,
        curve: Curves.elasticOut,
        lifespan: 0.8,
        child: ComputedParticle(
          renderer: (canvas, particle) {
            final textPainter = TextPainter(
              text: TextSpan(
                text: number,
                style: TextStyle(
                  fontSize: 60.0 * particle.progress,
                  fontWeight: FontWeight.bold,
                  foreground:
                      Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Colors.white.withValues(
                          alpha: 1 - particle.progress,
                        ),
                ),
              ),
              textDirection: TextDirection.ltr,
            );

            textPainter.layout();
            textPainter.paint(
              canvas,
              Offset(-textPainter.width / 2, -textPainter.height / 2),
            );
          },
        ),
      ),
      position: position,
    );
  }

  static Color _getConfettiColor(int index) {
    final colors = [
      const Color(0xFFFF6B9D),
      const Color(0xFFFFC93C),
      const Color(0xFF6BCB77),
      const Color(0xFF4D96FF),
      const Color(0xFFB983FF),
      const Color(0xFFFF6B6B),
    ];
    return colors[index % colors.length];
  }

  static Color _getFireworkColor(int index) {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.pink,
    ];
    return colors[index % colors.length];
  }

  static void _drawStar(
    Canvas canvas,
    Vector2 position,
    double size,
    Paint paint,
  ) {
    final path = Path();
    for (int i = 0; i < 10; i++) {
      final angle = (i * math.pi / 5) - math.pi / 2;
      final radius = i.isEven ? size : size * 0.5;
      final x = position.x + radius * math.cos(angle);
      final y = position.y + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }
}
