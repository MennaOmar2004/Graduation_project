import 'package:flutter/material.dart';
import 'dart:math' as math;

// Enhanced custom painters for beautiful Islamic architectural elements

class DomePainter extends CustomPainter {
  final Color color;
  final bool isLarge;

  DomePainter({required this.color, this.isLarge = false});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw shadow for depth
    final shadowPaint =
        Paint()
          ..color = Colors.black.withValues(alpha: 0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawOval(
      Rect.fromLTWH(
        size.width * 0.15,
        size.height * 0.55,
        size.width * 0.7,
        size.height * 0.3,
      ),
      shadowPaint,
    );

    // Draw dome base with 3D effect
    final basePaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withValues(alpha: 0.9),
              color,
              color.withValues(alpha: 0.7),
            ],
          ).createShader(
            Rect.fromLTWH(0, size.height * 0.5, size.width, size.height * 0.4),
          );

    final baseRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(
        size.width * 0.1,
        size.height * 0.5,
        size.width * 0.8,
        size.height * 0.4,
      ),
      topLeft: const Radius.circular(4),
      topRight: const Radius.circular(4),
    );
    canvas.drawRRect(baseRect, basePaint);

    // Draw decorative band on base
    final bandPaint =
        Paint()..color = const Color(0xFFFFD700).withValues(alpha: 0.6);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.08,
        size.height * 0.48,
        size.width * 0.84,
        size.height * 0.04,
      ),
      bandPaint,
    );

    // Draw ISLAMIC ONION/BULBOUS dome shape (NOT rounded church dome!)
    final domePath = Path();
    domePath.moveTo(size.width * 0.1, size.height * 0.5);

    // Left side - bulbous curve: goes OUT then IN (onion shape)
    domePath.cubicTo(
      size.width * 0.0,
      size.height * 0.38, // Bulge outward
      size.width * 0.2,
      size.height * 0.15, // Curve inward
      size.width * 0.5,
      size.height * 0.08, // Peak
    );

    // Right side - mirror of left
    domePath.cubicTo(
      size.width * 0.8,
      size.height * 0.15, // Curve inward
      size.width * 1.0,
      size.height * 0.38, // Bulge outward
      size.width * 0.9,
      size.height * 0.5, // Base
    );

    domePath.close();

    final domeGradient = RadialGradient(
      center: const Alignment(0, -0.5),
      radius: 1.2,
      colors: [
        Colors.white.withValues(alpha: 0.4),
        color.withValues(alpha: 0.8),
        color,
        color.withValues(alpha: 0.6),
      ],
      stops: const [0.0, 0.3, 0.7, 1.0],
    );

    canvas.drawPath(
      domePath,
      Paint()
        ..shader = domeGradient.createShader(
          Rect.fromLTWH(0, 0, size.width, size.height * 0.5),
        ),
    );

    // Draw dome outline for definition
    canvas.drawPath(
      domePath,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = color.withValues(alpha: 0.4)
        ..strokeWidth = 2,
    );

    // Draw decorative ribs on dome
    for (int i = 1; i < 5; i++) {
      final x = size.width * (0.1 + i * 0.16);
      final ribPath = Path();
      ribPath.moveTo(x, size.height * 0.5);
      ribPath.quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.1,
        size.width * 0.9 - (x - size.width * 0.1),
        size.height * 0.5,
      );

      canvas.drawPath(
        ribPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = color.withValues(alpha: 0.3)
          ..strokeWidth = 1.5,
      );
    }

    // Draw ornate crescent with glow
    final crescentCenter = Offset(size.width * 0.5, size.height * 0.08);

    // Glow effect
    canvas.drawCircle(
      crescentCenter,
      size.width * 0.12,
      Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Crescent shape
    final crescentPath = Path();
    crescentPath.addOval(
      Rect.fromCenter(
        center: crescentCenter,
        width: size.width * 0.15,
        height: size.height * 0.15,
      ),
    );
    crescentPath.addOval(
      Rect.fromCenter(
        center: crescentCenter.translate(size.width * 0.05, 0),
        width: size.width * 0.12,
        height: size.height * 0.12,
      ),
    );
    crescentPath.fillType = PathFillType.evenOdd;

    canvas.drawPath(
      crescentPath,
      Paint()
        ..shader = LinearGradient(
          colors: [const Color(0xFFFFD700), const Color(0xFFFFA500)],
        ).createShader(
          Rect.fromCenter(
            center: crescentCenter,
            width: size.width * 0.15,
            height: size.height * 0.15,
          ),
        ),
    );

    // Crescent outline
    canvas.drawPath(
      crescentPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color(0xFFCC8800)
        ..strokeWidth = 1.5,
    );

    // Add star next to crescent
    _drawStar(
      canvas,
      crescentCenter.translate(size.width * 0.12, -size.height * 0.02),
      size.width * 0.04,
    );
  }

  void _drawStar(Canvas canvas, Offset center, double radius) {
    final path = Path();
    for (int i = 0; i < 10; i++) {
      final angle = (i * math.pi / 5) - math.pi / 2;
      final r = i.isEven ? radius : radius * 0.5;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, Paint()..color = const Color(0xFFFFD700));
  }

  @override
  bool shouldRepaint(DomePainter oldDelegate) => false;
}

class MinaretPainter extends CustomPainter {
  final Color color;
  final bool isTall;

  MinaretPainter({required this.color, this.isTall = true});

  @override
  void paint(Canvas canvas, Size size) {
    // Shadow
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.32,
        size.height * 0.32,
        size.width * 0.4,
        size.height * 0.6,
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Main body with 3D gradient
    final bodyGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        color.withValues(alpha: 0.7),
        color,
        color.withValues(alpha: 0.8),
      ],
    );

    final bodyRect = Rect.fromLTWH(
      size.width * 0.3,
      size.height * 0.3,
      size.width * 0.4,
      size.height * 0.6,
    );
    canvas.drawRect(
      bodyRect,
      Paint()..shader = bodyGradient.createShader(bodyRect),
    );

    // Decorative bands with patterns
    final bandColors = [
      const Color(0xFFFFD700),
      color.withValues(alpha: 0.5),
      const Color(0xFFFFD700),
    ];

    for (int i = 0; i < 3; i++) {
      final y = size.height * (0.4 + i * 0.15);
      final bandRect = Rect.fromLTWH(
        size.width * 0.25,
        y,
        size.width * 0.5,
        size.height * 0.06,
      );

      canvas.drawRect(bandRect, Paint()..color = bandColors[i]);

      // Add geometric pattern on bands
      for (
        double x = size.width * 0.28;
        x < size.width * 0.72;
        x += size.width * 0.08
      ) {
        canvas.drawCircle(
          Offset(x, y + size.height * 0.03),
          size.width * 0.02,
          Paint()..color = color.withValues(alpha: 0.6),
        );
      }
    }

    // Ornate balcony
    final balconyPath = Path();
    balconyPath.moveTo(size.width * 0.15, size.height * 0.3);
    balconyPath.lineTo(size.width * 0.85, size.height * 0.3);
    balconyPath.lineTo(size.width * 0.8, size.height * 0.36);
    balconyPath.lineTo(size.width * 0.2, size.height * 0.36);
    balconyPath.close();

    canvas.drawPath(
      balconyPath,
      Paint()
        ..shader = LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
        ).createShader(
          Rect.fromLTWH(0, size.height * 0.3, size.width, size.height * 0.06),
        ),
    );

    // Balcony railing
    for (
      double x = size.width * 0.25;
      x < size.width * 0.75;
      x += size.width * 0.08
    ) {
      canvas.drawLine(
        Offset(x, size.height * 0.3),
        Offset(x, size.height * 0.36),
        Paint()
          ..color = const Color(0xFFFFD700)
          ..strokeWidth = 2,
      );
    }

    // Top dome with shine
    final topDomePath = Path();
    topDomePath.moveTo(size.width * 0.2, size.height * 0.2);
    topDomePath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.02,
      size.width * 0.8,
      size.height * 0.2,
    );
    topDomePath.lineTo(size.width * 0.8, size.height * 0.25);
    topDomePath.lineTo(size.width * 0.2, size.height * 0.25);
    topDomePath.close();

    canvas.drawPath(
      topDomePath,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, -0.5),
          colors: [Colors.white.withValues(alpha: 0.5), color],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.25)),
    );

    // Crescent on top with glow
    final crescentCenter = Offset(size.width * 0.5, size.height * 0.05);
    canvas.drawCircle(
      crescentCenter,
      size.width * 0.1,
      Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    canvas.drawCircle(
      crescentCenter,
      size.width * 0.08,
      Paint()
        ..shader = RadialGradient(
          colors: [const Color(0xFFFFD700), const Color(0xFFFFA500)],
        ).createShader(
          Rect.fromCenter(
            center: crescentCenter,
            width: size.width * 0.16,
            height: size.width * 0.16,
          ),
        ),
    );
  }

  @override
  bool shouldRepaint(MinaretPainter oldDelegate) => false;
}

class WallPainter extends CustomPainter {
  final Color color;
  final bool hasArch;

  WallPainter({required this.color, this.hasArch = false});

  @override
  void paint(Canvas canvas, Size size) {
    // Base wall with texture
    final wallGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color.withValues(alpha: 0.9),
        color,
        color.withValues(alpha: 0.8),
      ],
    );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = wallGradient.createShader(
          Rect.fromLTWH(0, 0, size.width, size.height),
        ),
    );

    // Detailed brick pattern
    final brickPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = color.withValues(alpha: 0.4)
          ..strokeWidth = 1.5;

    final mortarPaint = Paint()..color = Colors.grey.withValues(alpha: 0.3);

    for (double y = 0; y < size.height; y += size.height / 10) {
      // Mortar line
      canvas.drawLine(Offset(0, y), Offset(size.width, y), mortarPaint);

      final offset =
          (y / (size.height / 10)).floor().isEven ? 0.0 : size.width / 8;
      for (double x = offset; x < size.width; x += size.width / 4) {
        canvas.drawLine(
          Offset(x, y),
          Offset(x, y + size.height / 10),
          brickPaint,
        );
      }
    }

    if (hasArch) {
      // Beautiful Islamic arch
      final archPath = Path();
      archPath.moveTo(size.width * 0.15, size.height * 0.85);
      archPath.lineTo(size.width * 0.15, size.height * 0.45);

      // Pointed arch
      archPath.quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.25,
        size.width * 0.5,
        size.height * 0.2,
      );
      archPath.quadraticBezierTo(
        size.width * 0.65,
        size.height * 0.25,
        size.width * 0.85,
        size.height * 0.45,
      );

      archPath.lineTo(size.width * 0.85, size.height * 0.85);
      archPath.close();

      // Arch fill with gradient
      canvas.drawPath(
        archPath,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: 0.4),
              Colors.white.withValues(alpha: 0.2),
            ],
          ).createShader(
            Rect.fromLTWH(0, size.height * 0.2, size.width, size.height * 0.65),
          ),
      );

      // Arch decorative border
      canvas.drawPath(
        archPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = const Color(0xFFFFD700)
          ..strokeWidth = 3,
      );

      // Inner arch detail
      final innerArchPath = Path();
      innerArchPath.moveTo(size.width * 0.2, size.height * 0.8);
      innerArchPath.lineTo(size.width * 0.2, size.height * 0.48);
      innerArchPath.quadraticBezierTo(
        size.width * 0.37,
        size.height * 0.28,
        size.width * 0.5,
        size.height * 0.25,
      );
      innerArchPath.quadraticBezierTo(
        size.width * 0.63,
        size.height * 0.28,
        size.width * 0.8,
        size.height * 0.48,
      );
      innerArchPath.lineTo(size.width * 0.8, size.height * 0.8);

      canvas.drawPath(
        innerArchPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = const Color(0xFFFFD700).withValues(alpha: 0.5)
          ..strokeWidth = 2,
      );
    }

    // Wall outline
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..style = PaintingStyle.stroke
        ..color = color.withValues(alpha: 0.6)
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(WallPainter oldDelegate) => false;
}

class DoorPainter extends CustomPainter {
  final Color color;
  final bool isArched;

  DoorPainter({required this.color, this.isArched = false});

  @override
  void paint(Canvas canvas, Size size) {
    final doorPath = Path();

    if (isArched) {
      // Pointed Islamic arch door
      doorPath.moveTo(size.width * 0.1, size.height);
      doorPath.lineTo(size.width * 0.1, size.height * 0.35);
      doorPath.quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.15,
        size.width * 0.5,
        size.height * 0.1,
      );
      doorPath.quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.15,
        size.width * 0.9,
        size.height * 0.35,
      );
      doorPath.lineTo(size.width * 0.9, size.height);
      doorPath.close();
    } else {
      doorPath.addRect(
        Rect.fromLTWH(
          size.width * 0.1,
          size.height * 0.15,
          size.width * 0.8,
          size.height * 0.85,
        ),
      );
    }

    // Door with wood texture gradient
    canvas.drawPath(
      doorPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            color.withValues(alpha: 0.8),
            color,
            color.withValues(alpha: 0.7),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Door panels with depth
    final panelPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = color.withValues(alpha: 0.5)
          ..strokeWidth = 3;

    // Vertical center line
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.25),
      Offset(size.width * 0.5, size.height * 0.95),
      panelPaint,
    );

    // Decorative panels
    final panelRects = [
      Rect.fromLTWH(
        size.width * 0.15,
        size.height * 0.3,
        size.width * 0.3,
        size.height * 0.25,
      ),
      Rect.fromLTWH(
        size.width * 0.55,
        size.height * 0.3,
        size.width * 0.3,
        size.height * 0.25,
      ),
      Rect.fromLTWH(
        size.width * 0.15,
        size.height * 0.6,
        size.width * 0.3,
        size.height * 0.25,
      ),
      Rect.fromLTWH(
        size.width * 0.55,
        size.height * 0.6,
        size.width * 0.3,
        size.height * 0.25,
      ),
    ];

    for (final rect in panelRects) {
      canvas.drawRect(rect, panelPaint);
      // Inner shadow effect
      canvas.drawRect(
        rect.deflate(3),
        Paint()..color = Colors.black.withValues(alpha: 0.1),
      );
    }

    // Ornate door handles with glow
    final handlePositions = [
      Offset(size.width * 0.35, size.height * 0.55),
      Offset(size.width * 0.65, size.height * 0.55),
    ];

    for (final pos in handlePositions) {
      // Glow
      canvas.drawCircle(
        pos,
        size.width * 0.06,
        Paint()
          ..color = const Color(0xFFFFD700).withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      // Handle
      canvas.drawCircle(
        pos,
        size.width * 0.05,
        Paint()
          ..shader = RadialGradient(
            colors: [const Color(0xFFFFD700), const Color(0xFFCC8800)],
          ).createShader(
            Rect.fromCenter(
              center: pos,
              width: size.width * 0.1,
              height: size.width * 0.1,
            ),
          ),
      );

      // Handle highlight
      canvas.drawCircle(
        pos.translate(-size.width * 0.015, -size.width * 0.015),
        size.width * 0.02,
        Paint()..color = Colors.white.withValues(alpha: 0.6),
      );
    }

    // Door outline
    canvas.drawPath(
      doorPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = color.withValues(alpha: 0.8)
        ..strokeWidth = 3,
    );

    // Decorative arch border if arched
    if (isArched) {
      canvas.drawPath(
        doorPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = const Color(0xFFFFD700)
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(DoorPainter oldDelegate) => false;
}

class WindowPainter extends CustomPainter {
  final Color color;
  final bool isRound;

  WindowPainter({required this.color, this.isRound = false});

  @override
  void paint(Canvas canvas, Size size) {
    if (isRound) {
      _paintRoundWindow(canvas, size);
    } else {
      _paintArchedWindow(canvas, size);
    }
  }

  void _paintRoundWindow(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final radius = size.width * 0.4;

    // Shadow
    canvas.drawCircle(
      center.translate(2, 2),
      radius,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Frame
    canvas.drawCircle(center, radius, Paint()..color = color);

    // Glass with reflection
    canvas.drawCircle(
      center,
      radius * 0.85,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.3),
          colors: [
            Colors.white.withValues(alpha: 0.6),
            const Color(0xFF87CEEB).withValues(alpha: 0.7),
            const Color(0xFF4682B4).withValues(alpha: 0.5),
          ],
        ).createShader(
          Rect.fromCenter(
            center: center,
            width: radius * 2,
            height: radius * 2,
          ),
        ),
    );

    // Decorative pattern
    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      canvas.drawLine(
        center,
        Offset(
          center.dx + radius * 0.8 * math.cos(angle),
          center.dy + radius * 0.8 * math.sin(angle),
        ),
        Paint()
          ..color = color
          ..strokeWidth = 2,
      );
    }

    // Center ornament
    canvas.drawCircle(center, radius * 0.15, Paint()..color = color);
  }

  void _paintArchedWindow(Canvas canvas, Size size) {
    final windowPath = Path();
    windowPath.moveTo(size.width * 0.15, size.height * 0.85);
    windowPath.lineTo(size.width * 0.15, size.height * 0.45);
    windowPath.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.25,
      size.width * 0.5,
      size.height * 0.2,
    );
    windowPath.quadraticBezierTo(
      size.width * 0.65,
      size.height * 0.25,
      size.width * 0.85,
      size.height * 0.45,
    );
    windowPath.lineTo(size.width * 0.85, size.height * 0.85);
    windowPath.close();

    // Frame
    canvas.drawPath(windowPath, Paint()..color = color);

    // Glass
    final glassPath = Path();
    glassPath.moveTo(size.width * 0.2, size.height * 0.8);
    glassPath.lineTo(size.width * 0.2, size.height * 0.48);
    glassPath.quadraticBezierTo(
      size.width * 0.37,
      size.height * 0.28,
      size.width * 0.5,
      size.height * 0.25,
    );
    glassPath.quadraticBezierTo(
      size.width * 0.63,
      size.height * 0.28,
      size.width * 0.8,
      size.height * 0.48,
    );
    glassPath.lineTo(size.width * 0.8, size.height * 0.8);
    glassPath.close();

    canvas.drawPath(
      glassPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.5),
            const Color(0xFF87CEEB).withValues(alpha: 0.6),
            const Color(0xFF4682B4).withValues(alpha: 0.4),
          ],
        ).createShader(
          Rect.fromLTWH(0, size.height * 0.2, size.width, size.height * 0.65),
        ),
    );

    // Grid pattern
    final gridPaint =
        Paint()
          ..color = color
          ..strokeWidth = 2.5;

    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.25),
      Offset(size.width * 0.5, size.height * 0.85),
      gridPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.55),
      Offset(size.width * 0.8, size.height * 0.55),
      gridPaint,
    );

    // Decorative border
    canvas.drawPath(
      windowPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color(0xFFFFD700)
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(WindowPainter oldDelegate) => false;
}

class DecorationPainter extends CustomPainter {
  final String type;
  final Color color;

  DecorationPainter({required this.type, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case 'crescent':
        _drawCrescent(canvas, size);
        break;
      case 'star':
        _drawStar(canvas, size);
        break;
      case 'pattern':
        _drawPattern(canvas, size);
        break;
      case 'calligraphy':
        _drawCalligraphy(canvas, size);
        break;
    }
  }

  void _drawCrescent(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.5);

    // Glow effect
    canvas.drawCircle(
      center,
      size.width * 0.45,
      Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    final crescentPath = Path();
    crescentPath.addOval(
      Rect.fromCenter(
        center: center,
        width: size.width * 0.7,
        height: size.height * 0.7,
      ),
    );
    crescentPath.addOval(
      Rect.fromCenter(
        center: center.translate(size.width * 0.15, 0),
        width: size.width * 0.6,
        height: size.height * 0.6,
      ),
    );
    crescentPath.fillType = PathFillType.evenOdd;

    canvas.drawPath(
      crescentPath,
      Paint()
        ..shader = LinearGradient(
          colors: [const Color(0xFFFFD700), const Color(0xFFFFA500)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    canvas.drawPath(
      crescentPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color(0xFFCC8800)
        ..strokeWidth = 2,
    );
  }

  void _drawStar(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final outerRadius = size.width * 0.45;
    final innerRadius = size.width * 0.22;

    // Glow
    canvas.drawCircle(
      center,
      outerRadius + 5,
      Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    final path = Path();
    for (int i = 0; i < 16; i++) {
      final angle = (i * math.pi / 8) - math.pi / 2;
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white,
            const Color(0xFFFFD700),
            const Color(0xFFFFA500),
          ],
        ).createShader(
          Rect.fromCenter(
            center: center,
            width: size.width,
            height: size.height,
          ),
        ),
    );

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color(0xFFCC8800)
        ..strokeWidth = 2,
    );
  }

  void _drawPattern(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.5);

    // Outer circle
    canvas.drawCircle(
      center,
      size.width * 0.45,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = color
        ..strokeWidth = 3,
    );

    // Inner pattern
    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final x1 = center.dx + size.width * 0.15 * math.cos(angle);
      final y1 = center.dy + size.height * 0.15 * math.sin(angle);
      final x2 = center.dx + size.width * 0.45 * math.cos(angle);
      final y2 = center.dy + size.height * 0.45 * math.sin(angle);

      canvas.drawLine(
        Offset(x1, y1),
        Offset(x2, y2),
        Paint()
          ..color = color
          ..strokeWidth = 2.5,
      );
    }

    // Center ornament
    canvas.drawCircle(
      center,
      size.width * 0.15,
      Paint()
        ..shader = RadialGradient(
          colors: [color, color.withValues(alpha: 0.6)],
        ).createShader(
          Rect.fromCenter(
            center: center,
            width: size.width * 0.3,
            height: size.width * 0.3,
          ),
        ),
    );

    canvas.drawCircle(
      center,
      size.width * 0.15,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color(0xFFFFD700)
        ..strokeWidth = 2,
    );
  }

  void _drawCalligraphy(Canvas canvas, Size size) {
    final path = Path();

    // Stylized Arabic calligraphy strokes
    path.moveTo(size.width * 0.15, size.height * 0.5);
    path.cubicTo(
      size.width * 0.25,
      size.height * 0.25,
      size.width * 0.4,
      size.height * 0.35,
      size.width * 0.5,
      size.height * 0.4,
    );
    path.cubicTo(
      size.width * 0.6,
      size.height * 0.45,
      size.width * 0.75,
      size.height * 0.3,
      size.width * 0.85,
      size.height * 0.35,
    );

    final strokePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = color
          ..strokeWidth = size.width * 0.12
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, strokePaint);

    // Add decorative dots
    final dotPositions = [
      Offset(size.width * 0.3, size.height * 0.6),
      Offset(size.width * 0.5, size.height * 0.65),
      Offset(size.width * 0.7, size.height * 0.55),
    ];

    for (final pos in dotPositions) {
      canvas.drawCircle(pos, size.width * 0.05, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(DecorationPainter oldDelegate) => false;
}
