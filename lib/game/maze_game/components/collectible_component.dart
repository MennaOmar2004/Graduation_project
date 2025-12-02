import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../maze_game.dart';
import '../data/values_data.dart';
import 'particle_effects.dart';

class CollectibleStar extends PositionComponent
    with HasGameReference<MazeGame>, CollisionCallbacks {
  final ValueData value;
  final bool isGood;

  CollectibleStar({
    required Vector2 position,
    required this.value,
    this.isGood = true,
  }) : super(position: position, size: Vector2(60, 60), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(CircleHitbox(radius: 40));

    add(
      ScaleEffect.by(
        Vector2.all(1.2),
        EffectController(
          duration: 0.8,
          infinite: true,
          reverseDuration: 0.8,
          curve: Curves.easeInOut,
        ),
      ),
    );

    add(RotateEffect.by(6.28, EffectController(duration: 3, infinite: true)));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final center = Offset(size.x / 2, size.y / 2);

    if (isGood) {
      _drawStar(canvas, center, 25, isGood);
    } else {
      _drawX(canvas, center, 25);
    }

    final textPainter = TextPainter(
      text: TextSpan(text: value.emoji, style: const TextStyle(fontSize: 30)),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  void _drawStar(Canvas canvas, Offset center, double radius, bool isGood) {
    final glowPaint =
        Paint()
          ..color = (isGood ? const Color(0xFFFFD700) : Colors.red).withOpacity(
            0.3,
          )
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(center, radius + 10, glowPaint);

    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * 3.14159 / 5) - 3.14159 / 2;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    final starPaint =
        Paint()
          ..shader = RadialGradient(
            colors:
                isGood
                    ? [const Color(0xFFFFD700), const Color(0xFFFFA500)]
                    : [Colors.red, Colors.orange],
          ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawPath(path, starPaint);

    final borderPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
    canvas.drawPath(path, borderPaint);
  }

  void _drawX(Canvas canvas, Offset center, double size) {
    final paint =
        Paint()
          ..color = Colors.red
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(center.dx - size, center.dy - size),
      Offset(center.dx + size, center.dy + size),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + size, center.dy - size),
      Offset(center.dx - size, center.dy + size),
      paint,
    );
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is PlayerCharacter) {
      print(
        '🎯 Collision detected! isGood: $isGood, value: ${value.arabicName}',
      );
      game.onCollectibleCollected(this);

      game.add(
        CollectionParticles(
          position: position.clone(),
          color: isGood ? const Color(0xFFFFD700) : Colors.red,
          isGood: isGood,
        ),
      );

      if (isGood) {
        game.add(StarBurstEffect(position: position.clone()));
      }

      add(ScaleEffect.to(Vector2.all(2.5), EffectController(duration: 0.15)));

      Future.delayed(const Duration(milliseconds: 150), () {
        if (isMounted) removeFromParent();
      });
    }
  }
}

class PlayerCharacter extends PositionComponent
    with HasGameReference<MazeGame>, CollisionCallbacks {
  Vector2 targetPosition;

  PlayerCharacter({required Vector2 position})
    : targetPosition = position,
      super(position: position, size: Vector2(50, 50), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(CircleHitbox(radius: 35));
  }

  void moveTo(Vector2 newTarget) {
    targetPosition = newTarget;
  }

  @override
  void update(double dt) {
    super.update(dt);

    final diff = targetPosition - position;
    if (diff.length > 5) {
      position += diff.normalized() * 300 * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final center = Offset(size.x / 2, size.y / 2);

    final glowPaint =
        Paint()
          ..color = const Color(0xFF4CAF50).withOpacity(0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center, 30, glowPaint);

    final gradientPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [const Color(0xFF81C784), const Color(0xFF4CAF50)],
          ).createShader(Rect.fromCircle(center: center, radius: 25));
    canvas.drawCircle(center, 25, gradientPaint);

    final facePaint = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(center.dx - 8, center.dy - 5), 4, facePaint);
    canvas.drawCircle(Offset(center.dx + 8, center.dy - 5), 4, facePaint);

    final smilePath = Path();
    smilePath.moveTo(center.dx - 10, center.dy + 5);
    smilePath.quadraticBezierTo(
      center.dx,
      center.dy + 12,
      center.dx + 10,
      center.dy + 5,
    );

    final smilePaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round;
    canvas.drawPath(smilePath, smilePaint);
  }
}
