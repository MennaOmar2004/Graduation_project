import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/coloring_page.dart';

class ColoringCanvas extends StatefulWidget {
  final ColoringPage page;
  final Color? selectedColor;
  final Function(String regionId, Color color) onRegionColored;

  const ColoringCanvas({
    super.key,
    required this.page,
    required this.selectedColor,
    required this.onRegionColored,
  });

  @override
  State<ColoringCanvas> createState() => _ColoringCanvasState();
}

class _ColoringCanvasState extends State<ColoringCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String? _lastColoredRegion;
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _handleTap(TapDownDetails details) {
    if (widget.selectedColor == null) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);

    // Find which region was tapped
    for (final region in widget.page.regions) {
      if (_isPointInRegion(localPosition, region.path)) {
        setState(() {
          _lastColoredRegion = region.id;
        });
        widget.onRegionColored(region.id, widget.selectedColor!);
        _animationController.forward(from: 0);
        break;
      }
    }
  }

  bool _isPointInRegion(Offset point, List<Offset> path) {
    if (path.length < 3) return false;

    bool inside = false;
    for (int i = 0, j = path.length - 1; i < path.length; j = i++) {
      if (((path[i].dy > point.dy) != (path[j].dy > point.dy)) &&
          (point.dx <
              (path[j].dx - path[i].dx) *
                      (point.dy - path[i].dy) /
                      (path[j].dy - path[i].dy) +
                  path[i].dx)) {
        inside = !inside;
      }
    }
    return inside;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTap,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: 0.5,
        maxScale: 3.0,
        child: Container(
          color: Colors.grey[100],
          child: CustomPaint(
            size: Size.infinite,
            painter: ColoringPainter(
              page: widget.page,
              lastColoredRegion: _lastColoredRegion,
              animation: _animationController,
            ),
          ),
        ),
      ),
    );
  }
}

class ColoringPainter extends CustomPainter {
  final ColoringPage page;
  final String? lastColoredRegion;
  final Animation<double> animation;

  ColoringPainter({
    required this.page,
    required this.lastColoredRegion,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final outlinePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = Colors.black87;

    // Draw each region
    for (final region in page.regions) {
      final path = Path();
      if (region.path.isNotEmpty) {
        path.moveTo(region.path.first.dx, region.path.first.dy);
        for (int i = 1; i < region.path.length; i++) {
          path.lineTo(region.path[i].dx, region.path[i].dy);
        }
        path.close();

        // Fill with color if colored
        if (region.fillColor != null) {
          paint.color = region.fillColor!;

          // Add animation effect for newly colored region
          if (region.id == lastColoredRegion) {
            final scale = 1.0 + (math.sin(animation.value * math.pi) * 0.1);
            canvas.save();
            final center = _getPathCenter(region.path);
            canvas.translate(center.dx, center.dy);
            canvas.scale(scale);
            canvas.translate(-center.dx, -center.dy);
            canvas.drawPath(path, paint);
            canvas.restore();
          } else {
            canvas.drawPath(path, paint);
          }
        } else {
          // Draw white background for uncolored regions
          paint.color = Colors.white;
          canvas.drawPath(path, paint);
        }

        // Draw outline
        canvas.drawPath(path, outlinePaint);
      }
    }
  }

  Offset _getPathCenter(List<Offset> path) {
    if (path.isEmpty) return Offset.zero;
    double sumX = 0, sumY = 0;
    for (final point in path) {
      sumX += point.dx;
      sumY += point.dy;
    }
    return Offset(sumX / path.length, sumY / path.length);
  }

  @override
  bool shouldRepaint(ColoringPainter oldDelegate) {
    return oldDelegate.page != page ||
        oldDelegate.lastColoredRegion != lastColoredRegion;
  }
}
