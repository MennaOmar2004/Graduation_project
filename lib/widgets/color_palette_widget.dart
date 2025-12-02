import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/coloring_page.dart';
import '../data/color_palette.dart';

class ColorPaletteWidget extends StatefulWidget {
  final ColorInfo? selectedColor;
  final Function(ColorInfo) onColorSelected;

  const ColorPaletteWidget({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  State<ColorPaletteWidget> createState() => _ColorPaletteWidgetState();
}

class _ColorPaletteWidgetState extends State<ColorPaletteWidget> {
  ColorInfo? _hoveredColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Color name display
          if (_hoveredColor != null || widget.selectedColor != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: (_hoveredColor ?? widget.selectedColor)!.color
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                (_hoveredColor ?? widget.selectedColor)!.nameArabic,
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: (_hoveredColor ?? widget.selectedColor)!.color,
                ),
              ),
            ),
          const SizedBox(height: 12),
          // Color grid
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: ColorPalette.colors.length,
              itemBuilder: (context, index) {
                final colorInfo = ColorPalette.colors[index];
                final isSelected =
                    widget.selectedColor?.color == colorInfo.color;

                return GestureDetector(
                  onTap: () => widget.onColorSelected(colorInfo),
                  onTapDown: (_) => setState(() => _hoveredColor = colorInfo),
                  onTapUp: (_) => setState(() => _hoveredColor = null),
                  onTapCancel: () => setState(() => _hoveredColor = null),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: isSelected ? 60 : 50,
                    height: isSelected ? 60 : 50,
                    decoration: BoxDecoration(
                      color: colorInfo.color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isSelected ? const Color(0xFF6B4CE6) : Colors.white,
                        width: isSelected ? 4 : 2,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: colorInfo.color.withValues(alpha: 0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
