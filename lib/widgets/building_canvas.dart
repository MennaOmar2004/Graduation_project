import 'package:flutter/material.dart';
import '../models/building_element.dart';
import 'mosque_element_painters.dart';

class BuildingCanvas extends StatefulWidget {
  final List<PlacedElement> placedElements;
  final Function(PlacedElement) onElementPlaced;
  final Function(String) onElementRemoved;
  final Function(PlacedElement) onElementMoved;

  const BuildingCanvas({
    super.key,
    required this.placedElements,
    required this.onElementPlaced,
    required this.onElementRemoved,
    required this.onElementMoved,
  });

  @override
  State<BuildingCanvas> createState() => _BuildingCanvasState();
}

class _BuildingCanvasState extends State<BuildingCanvas> {
  String? _selectedElementId;
  final double _gridSize = 40.0;

  @override
  Widget build(BuildContext context) {
    return DragTarget<BuildingElement>(
      onAcceptWithDetails: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localPosition = box.globalToLocal(details.offset);
        _placeElement(details.data, localPosition);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFE3F2FD).withValues(alpha: 0.5),
                const Color(0xFFFFF9C4).withValues(alpha: 0.3),
                Colors.white,
              ],
            ),
          ),
          child: CustomPaint(
            painter: GridPainter(gridSize: _gridSize),
            child: Stack(
              children: [
                ...widget.placedElements.map((placedElement) {
                  return _buildPlacedElement(placedElement);
                }),
                if (candidateData.isNotEmpty)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF6B4CE6),
                          width: 3,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlacedElement(PlacedElement placedElement) {
    final isSelected = _selectedElementId == placedElement.id;
    final element = placedElement.element;
    final position = placedElement.position;

    return Positioned(
      left: position.dx * _gridSize,
      top: position.dy * _gridSize,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedElementId = isSelected ? null : placedElement.id;
          });
        },
        onLongPress: () {
          widget.onElementRemoved(placedElement.id);
        },
        child: Draggable<PlacedElement>(
          data: placedElement,
          feedback: Material(
            color: Colors.transparent,
            child: _buildElementWidget(
              element,
              isSelected: true,
              isDragging: true,
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: _buildElementWidget(element, isSelected: isSelected),
          ),
          onDragEnd: (details) {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final localPosition = box.globalToLocal(details.offset);
            final gridPosition = Offset(
              (localPosition.dx / _gridSize).roundToDouble(),
              (localPosition.dy / _gridSize).roundToDouble(),
            );
            widget.onElementMoved(
              placedElement.copyWith(position: gridPosition),
            );
          },
          child: _buildElementWidget(element, isSelected: isSelected),
        ),
      ),
    );
  }

  Widget _buildElementWidget(
    BuildingElement element, {
    bool isSelected = false,
    bool isDragging = false,
  }) {
    final width = element.size.width * _gridSize;
    final height = element.size.height * _gridSize;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: element.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              isSelected
                  ? const Color(0xFF6B4CE6)
                  : element.color.withValues(alpha: 0.5),
          width: isSelected ? 3 : 2,
        ),
        boxShadow:
            isDragging || isSelected
                ? [
                  BoxShadow(
                    color: element.color.withValues(alpha: 0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
                : [],
      ),
      child: CustomPaint(
        painter: _getPainterForElement(element),
        size: Size(width, height),
      ),
    );
  }

  CustomPainter _getPainterForElement(BuildingElement element) {
    switch (element.type) {
      case ElementType.dome:
        return DomePainter(
          color: element.color,
          isLarge: element.id.contains('large'),
        );
      case ElementType.minaret:
        return MinaretPainter(
          color: element.color,
          isTall: element.id.contains('tall'),
        );
      case ElementType.wall:
        return WallPainter(
          color: element.color,
          hasArch: element.id.contains('arched'),
        );
      case ElementType.door:
        return DoorPainter(
          color: element.color,
          isArched: element.id.contains('arched'),
        );
      case ElementType.window:
        return WindowPainter(
          color: element.color,
          isRound: element.id.contains('round'),
        );
      case ElementType.decoration:
        String decorType = 'pattern';
        if (element.id.contains('crescent')) decorType = 'crescent';
        if (element.id.contains('star')) decorType = 'star';
        if (element.id.contains('calligraphy')) decorType = 'calligraphy';
        return DecorationPainter(type: decorType, color: element.color);
    }
  }

  void _placeElement(BuildingElement element, Offset position) {
    final gridPosition = Offset(
      (position.dx / _gridSize).roundToDouble(),
      (position.dy / _gridSize).roundToDouble(),
    );

    final placedElement = PlacedElement(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      element: element,
      position: gridPosition,
    );

    widget.onElementPlaced(placedElement);
  }
}

class GridPainter extends CustomPainter {
  final double gridSize;

  GridPainter({required this.gridSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey.withValues(alpha: 0.2)
          ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => false;
}
