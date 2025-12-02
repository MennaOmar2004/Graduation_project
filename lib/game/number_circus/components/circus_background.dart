import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Stunning animated circus background with moving elements
class CircusBackground extends Component {
  late final Paint skyPaint;
  late final Paint tentPaint;
  late final Paint stripePaint;

  double cloudOffset = 0;
  double flagWave = 0;
  final List<_Cloud> clouds = [];
  final List<_Flag> flags = [];

  @override
  Future<void> onLoad() async {
    // Create gradient sky
    skyPaint =
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87CEEB), // Sky blue
              Color(0xFFB0E0E6), // Powder blue
              Color(0xFFFFF8DC), // Cornsilk (horizon)
            ],
          ).createShader(Rect.fromLTWH(0, 0, 400, 800));

    // Tent colors
    tentPaint = Paint()..color = const Color(0xFFDC143C); // Crimson red

    stripePaint = Paint()..color = Colors.white;

    // Create clouds
    for (int i = 0; i < 5; i++) {
      clouds.add(
        _Cloud(
          position: Vector2(
            math.Random().nextDouble() * 400,
            50 + math.Random().nextDouble() * 150,
          ),
          speed: 10 + math.Random().nextDouble() * 20,
        ),
      );
    }

    // Create decorative flags
    for (int i = 0; i < 10; i++) {
      flags.add(
        _Flag(
          position: Vector2(i * 40.0, 180),
          color: _getFlagColor(i),
          phase: i * 0.5,
        ),
      );
    }
  }

  @override
  void render(Canvas canvas) {
    // Draw sky
    canvas.drawRect(Rect.fromLTWH(0, 0, 400, 800), skyPaint);

    // Draw clouds
    for (final cloud in clouds) {
      _drawCloud(canvas, cloud);
    }

    // Draw circus tent
    _drawCircusTent(canvas);

    // Draw decorative flags
    for (final flag in flags) {
      _drawFlag(canvas, flag);
    }

    // Draw ground
    final groundPaint =
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF90EE90), // Light green
              Color(0xFF228B22), // Forest green
            ],
          ).createShader(Rect.fromLTWH(0, 600, 400, 200));

    canvas.drawRect(Rect.fromLTWH(0, 600, 400, 200), groundPaint);

    // Draw grass details
    _drawGrass(canvas);
  }

  void _drawCircusTent(Canvas canvas) {
    // Main tent body
    final tentPath = Path();
    tentPath.moveTo(50, 500);
    tentPath.lineTo(200, 250);
    tentPath.lineTo(350, 500);
    tentPath.close();

    // Tent gradient
    final tentGradient =
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFDC143C), Color(0xFF8B0000)],
          ).createShader(Rect.fromLTWH(50, 250, 300, 250));

    canvas.drawPath(tentPath, tentGradient);

    // Draw stripes
    for (int i = 0; i < 6; i++) {
      final stripePath = Path();
      final x1 = 80 + i * 45;
      final x2 = 200;
      final x3 = 320 - i * 45;

      stripePath.moveTo(x1.toDouble(), 500);
      stripePath.lineTo(x2.toDouble(), 250);
      stripePath.lineTo(x3.toDouble(), 500);
      stripePath.close();

      if (i.isEven) {
        canvas.drawPath(stripePath, stripePaint);
      }
    }

    // Tent top ornament
    final topOrnament = Paint()..color = const Color(0xFFFFD700); // Gold

    canvas.drawCircle(const Offset(200, 240), 15, topOrnament);

    // Draw flag on top
    final flagPath = Path();
    flagPath.moveTo(200, 220);
    flagPath.lineTo(200, 180);
    flagPath.lineTo(230, 195);
    flagPath.lineTo(200, 210);
    flagPath.close();

    canvas.drawPath(flagPath, Paint()..color = const Color(0xFFFFD700));

    // Tent entrance
    final entrancePath = Path();
    entrancePath.moveTo(170, 500);
    entrancePath.lineTo(180, 400);
    entrancePath.lineTo(220, 400);
    entrancePath.lineTo(230, 500);
    entrancePath.close();

    canvas.drawPath(
      entrancePath,
      Paint()..color = Colors.black.withValues(alpha: 0.5),
    );
  }

  void _drawCloud(Canvas canvas, _Cloud cloud) {
    final cloudPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.8)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Draw fluffy cloud
    canvas.drawCircle(
      Offset(cloud.position.x, cloud.position.y),
      20,
      cloudPaint,
    );
    canvas.drawCircle(
      Offset(cloud.position.x + 15, cloud.position.y - 5),
      25,
      cloudPaint,
    );
    canvas.drawCircle(
      Offset(cloud.position.x + 30, cloud.position.y),
      20,
      cloudPaint,
    );
    canvas.drawCircle(
      Offset(cloud.position.x + 20, cloud.position.y + 10),
      18,
      cloudPaint,
    );
  }

  void _drawFlag(Canvas canvas, _Flag flag) {
    final waveOffset = math.sin(flagWave + flag.phase) * 5;

    // Flag pole
    canvas.drawLine(
      Offset(flag.position.x, flag.position.y),
      Offset(flag.position.x, flag.position.y - 40),
      Paint()
        ..color = Colors.brown
        ..strokeWidth = 2,
    );

    // Waving flag
    final flagPath = Path();
    flagPath.moveTo(flag.position.x, flag.position.y - 40);
    flagPath.quadraticBezierTo(
      flag.position.x + 10 + waveOffset,
      flag.position.y - 35,
      flag.position.x + 20,
      flag.position.y - 30,
    );
    flagPath.lineTo(flag.position.x + 20, flag.position.y - 20);
    flagPath.quadraticBezierTo(
      flag.position.x + 10 + waveOffset,
      flag.position.y - 25,
      flag.position.x,
      flag.position.y - 30,
    );
    flagPath.close();

    canvas.drawPath(flagPath, Paint()..color = flag.color);
  }

  void _drawGrass(Canvas canvas) {
    final grassPaint =
        Paint()
          ..color = const Color(0xFF228B22)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    for (int i = 0; i < 40; i++) {
      final x = i * 10.0;
      final height = 10 + math.sin(i * 0.5) * 5;

      canvas.drawLine(Offset(x, 600), Offset(x + 2, 600 - height), grassPaint);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Animate clouds
    for (final cloud in clouds) {
      cloud.position.x += cloud.speed * dt;
      if (cloud.position.x > 450) {
        cloud.position.x = -50;
      }
    }

    // Animate flags
    flagWave += dt * 3;
  }

  Color _getFlagColor(int index) {
    final colors = [
      Colors.red,
      Colors.yellow,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
    ];
    return colors[index % colors.length];
  }
}

class _Cloud {
  Vector2 position;
  double speed;

  _Cloud({required this.position, required this.speed});
}

class _Flag {
  Vector2 position;
  Color color;
  double phase;

  _Flag({required this.position, required this.color, required this.phase});
}
