import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../data/moon_data.dart';

/// Beautiful 3D-style moon component with phases
class MoonComponent extends PositionComponent {
  final MoonPhase phase;
  final bool isInteractive;
  final VoidCallback? onTap;

  MoonComponent({
    required this.phase,
    required Vector2 position,
    required Vector2 size,
    this.isInteractive = false,
    this.onTap,
  }) : super(position: position, size: size, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Add gentle pulsing animation
    add(
      ScaleEffect.by(
        Vector2.all(1.1),
        EffectController(
          duration: 2.0,
          infinite: true,
          reverseDuration: 2.0,
          curve: Curves.easeInOut,
        ),
      ),
    );

    // Add subtle rotation
    add(
      RotateEffect.by(
        math.pi * 2,
        EffectController(duration: 60.0, infinite: true),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final radius = size.x / 2;

    // Draw moon shadow (3D effect)
    final shadowPaint =
        Paint()
          ..color = Colors.black.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(center + const Offset(5, 5), radius, shadowPaint);

    // Draw moon base (full circle)
    final basePaint =
        Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFFFFF8DC),
              const Color(0xFFFFE4B5),
              const Color(0xFFFFDAB9),
            ],
          ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, basePaint);

    // Draw phase shadow
    if (phase.illumination < 1.0) {
      final shadowPath = Path();
      final shadowWidth = radius * 2 * (1 - phase.illumination);

      if (phase.illumination < 0.5) {
        // Waning - shadow from right
        shadowPath.addOval(
          Rect.fromCenter(
            center: center + Offset(shadowWidth / 2, 0),
            width: shadowWidth,
            height: radius * 2,
          ),
        );
      } else {
        // Waxing - shadow from left
        shadowPath.addOval(
          Rect.fromCenter(
            center: center - Offset(shadowWidth / 2, 0),
            width: shadowWidth,
            height: radius * 2,
          ),
        );
      }

      final phasePaint =
          Paint()
            ..color = const Color(0xFF1A1F3A).withValues(alpha: 0.8)
            ..blendMode = BlendMode.multiply;
      canvas.drawPath(shadowPath, phasePaint);
    }

    // Draw moon glow
    final glowPaint =
        Paint()
          ..color = const Color(0xFFFFE4B5).withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(center, radius + 10, glowPaint);

    // Draw craters for realism
    _drawCraters(canvas, center, radius);
  }

  void _drawCraters(Canvas canvas, Offset center, double radius) {
    final craterPaint =
        Paint()..color = const Color(0xFFD3D3D3).withValues(alpha: 0.3);

    // Fixed crater positions for consistency
    final craters = [
      (Offset(0.3, -0.2), 0.15),
      (Offset(-0.4, 0.1), 0.1),
      (Offset(0.1, 0.4), 0.12),
      (Offset(-0.2, -0.3), 0.08),
    ];

    for (final (offset, size) in craters) {
      final craterCenter =
          center + Offset(offset.dx * radius, offset.dy * radius);
      canvas.drawCircle(craterCenter, radius * size, craterPaint);
    }
  }

  @override
  bool containsPoint(Vector2 point) {
    if (!isInteractive) return false;
    final center = position;
    final distance = (point - center).length;
    return distance <= size.x / 2;
  }
}
