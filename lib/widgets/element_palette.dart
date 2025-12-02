import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/building_element.dart';
import '../data/building_elements_data.dart';

class ElementPalette extends StatelessWidget {
  final Function(BuildingElement) onElementSelected;
  final ElementType? selectedCategory;
  final Function(ElementType?) onCategoryChanged;

  const ElementPalette({
    super.key,
    required this.onElementSelected,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
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
          const SizedBox(height: 12),
          // Category tabs
          _buildCategoryTabs(),
          const SizedBox(height: 12),
          // Elements grid
          Expanded(child: _buildElementsGrid()),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = [
      (ElementType.dome, 'قباب', '🕌'),
      (ElementType.minaret, 'مآذن', '🗼'),
      (ElementType.wall, 'جدران', '🧱'),
      (ElementType.door, 'أبواب', '🚪'),
      (ElementType.window, 'نوافذ', '🪟'),
      (ElementType.decoration, 'زخارف', '✨'),
    ];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final (type, name, emoji) = categories[index];
          final isSelected = selectedCategory == type;

          return GestureDetector(
            onTap: () => onCategoryChanged(isSelected ? null : type),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF6B4CE6) : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    name,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildElementsGrid() {
    final elements =
        selectedCategory == null
            ? BuildingElementsData.getAllElements()
            : BuildingElementsData.getElementsByType(selectedCategory!);

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: elements.length,
      itemBuilder: (context, index) {
        final element = elements[index];
        return _buildElementCard(element);
      },
    );
  }

  Widget _buildElementCard(BuildingElement element) {
    return Draggable<BuildingElement>(
      data: element,
      feedback: Material(
        color: Colors.transparent,
        child: _buildElementIcon(element, isDragging: true),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildElementIcon(element),
      ),
      child: GestureDetector(
        onTap: () => onElementSelected(element),
        child: _buildElementIcon(element),
      ),
    );
  }

  Widget _buildElementIcon(BuildingElement element, {bool isDragging = false}) {
    return Container(
      decoration: BoxDecoration(
        color: element.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: element.color, width: 2),
        boxShadow:
            isDragging
                ? [
                  BoxShadow(
                    color: element.color.withValues(alpha: 0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
                : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(element.emoji, style: TextStyle(fontSize: isDragging ? 36 : 28)),
          const SizedBox(height: 4),
          Text(
            element.nameArabic,
            style: GoogleFonts.cairo(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: element.color,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
