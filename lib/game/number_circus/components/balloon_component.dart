import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Beautiful animated balloon component with stunning visuals
class BalloonComponent extends PositionComponent with HasPaint {
  final int number;
  final Color balloonColor;
  final VoidCallback onPopped;

  bool isPopped = false;
  late TextComponent numberText;
  late final Paint balloonPaint;
  late final Paint highlightPaint;
  late final Paint stringPaint;

  // Animation properties
  double bobOffset = 0;
  double rotationAngle = 0;

  BalloonComponent({
    required this.number,
    required this.balloonColor,
    required this.onPopped,
    required Vector2 position,
  }) : super(position: position, size: Vector2(80, 100), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Balloon gradient paint for 3D effect
    balloonPaint =
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.3, -0.4),
            radius: 0.8,
            colors: [
              Colors.white.withValues(alpha: 0.9),
              balloonColor.withValues(alpha: 0.95),
              balloonColor,
              balloonColor.withValues(alpha: 0.7),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ).createShader(Rect.fromLTWH(0, 0, size.x, size.y));

    // Highlight paint for shine effect
    highlightPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.6)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // String paint
    stringPaint =
        Paint()
          ..color = Colors.brown.withValues(alpha: 0.8)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    // Add Arabic number text with beautiful styling
    numberText = TextComponent(
      text: _getArabicNumber(number),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(color: Colors.black45, offset: Offset(2, 2), blurRadius: 4),
          ],
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2 - 10),
    );
    add(numberText);

    // Add floating animation
    add(
      MoveEffect.by(
        Vector2(0, -300),
        EffectController(duration: 8.0, curve: Curves.linear),
        onComplete: () => removeFromParent(),
      ),
    );

    // Add gentle bobbing animation
    add(
      SequenceEffect([
        MoveEffect.by(
          Vector2(0, -5),
          EffectController(duration: 1.5, curve: Curves.easeInOut),
        ),
        MoveEffect.by(
          Vector2(0, 5),
          EffectController(duration: 1.5, curve: Curves.easeInOut),
        ),
      ], infinite: true),
    );

    // Add subtle rotation
    add(
      RotateEffect.by(
        0.1,
        EffectController(duration: 2.0, curve: Curves.easeInOut),
        onComplete: () {
          add(
            RotateEffect.by(
              -0.2,
              EffectController(duration: 4.0, curve: Curves.easeInOut),
            ),
          );
        },
      ),
    );

    // Add scale pulse effect
    add(
      SequenceEffect([
        ScaleEffect.by(
          Vector2.all(1.05),
          EffectController(duration: 1.0, curve: Curves.easeInOut),
        ),
        ScaleEffect.by(
          Vector2.all(0.95),
          EffectController(duration: 1.0, curve: Curves.easeInOut),
        ),
      ], infinite: true),
    );
  }

  @override
  void render(Canvas canvas) {
    if (isPopped) return;

    // Draw balloon string
    final stringPath = Path();
    stringPath.moveTo(size.x / 2, size.y);
    stringPath.quadraticBezierTo(
      size.x / 2 + math.sin(bobOffset) * 5,
      size.y + 20,
      size.x / 2,
      size.y + 40,
    );
    canvas.drawPath(stringPath, stringPaint);

    // Draw balloon shadow
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.x / 2 + 3, size.y / 2 + 3),
        width: size.x * 0.9,
        height: size.y * 0.85,
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Draw main balloon body
    final balloonPath = Path();
    balloonPath.moveTo(size.x / 2, size.y * 0.1);

    // Top curve
    balloonPath.cubicTo(
      size.x * 0.2,
      size.y * 0.15,
      size.x * 0.1,
      size.y * 0.35,
      size.x * 0.1,
      size.y * 0.55,
    );

    // Bottom left
    balloonPath.cubicTo(
      size.x * 0.1,
      size.y * 0.75,
      size.x * 0.3,
      size.y * 0.85,
      size.x * 0.5,
      size.y * 0.9,
    );

    // Bottom right
    balloonPath.cubicTo(
      size.x * 0.7,
      size.y * 0.85,
      size.x * 0.9,
      size.y * 0.75,
      size.x * 0.9,
      size.y * 0.55,
    );

    // Top right curve
    balloonPath.cubicTo(
      size.x * 0.9,
      size.y * 0.35,
      size.x * 0.8,
      size.y * 0.15,
      size.x * 0.5,
      size.y * 0.1,
    );

    balloonPath.close();

    canvas.drawPath(balloonPath, balloonPaint);

    // Draw highlight for 3D effect
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.x * 0.35, size.y * 0.3),
        width: size.x * 0.25,
        height: size.y * 0.2,
      ),
      highlightPaint,
    );

    // Draw balloon knot
    final knotPaint = Paint()..color = balloonColor.withValues(alpha: 0.8);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.x / 2, size.y * 0.92),
        width: 12,
        height: 8,
      ),
      knotPaint,
    );

    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    bobOffset += dt * 2;
  }

  void pop() {
    if (isPopped) return;
    isPopped = true;

    // Create pop animation
    add(
      ScaleEffect.to(
        Vector2.all(1.5),
        EffectController(duration: 0.2, curve: Curves.easeOut),
        onComplete: () {
          // Simply remove after scale animation
          removeFromParent();
          onPopped();
        },
      ),
    );
  }

  String _getArabicNumber(int num) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    if (num >= 0 && num <= 9) {
      return arabicNumbers[num];
    } else if (num == 10) {
      return '١٠';
    }
    return num.toString();
  }

  @override
  bool containsPoint(Vector2 point) {
    if (isPopped) return false;

    // Use the component's actual bounds for accurate hit detection
    final rect = toRect();
    return rect.contains(point.toOffset());
  }
}
