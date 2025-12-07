import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/building_element.dart';
import '../data/building_elements_data.dart';
import '../utils/responsive_helper.dart';

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
    // Responsive height - 25% of screen height, max 200
    final paletteHeight = ResponsiveHelper.height(
      context,
      0.25,
    ).clamp(150.0, 200.0);

    return Container(
      height: paletteHeight,
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
            margin: EdgeInsets.only(top: ResponsiveHelper.size(context, 12)),
            width: ResponsiveHelper.size(context, 40),
            height: ResponsiveHelper.size(context, 4),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: ResponsiveHelper.size(context, 8)),
          // Category tabs
          _buildCategoryTabs(context),
          SizedBox(height: ResponsiveHelper.size(context, 8)),
          // Elements grid
          Expanded(child: _buildElementsGrid(context)),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context) {
    final categories = [
      (ElementType.dome, 'قباب', '🕌'),
      (ElementType.minaret, 'مآذن', '🗼'),
      (ElementType.wall, 'جدران', '🧱'),
      (ElementType.door, 'أبواب', '🚪'),
      (ElementType.window, 'نوافذ', '🪟'),
      (ElementType.decoration, 'زخارف', '✨'),
    ];

    return SizedBox(
      height: ResponsiveHelper.size(context, 45),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: ResponsiveHelper.padding(context, horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final (type, name, emoji) = categories[index];
          final isSelected = selectedCategory == type;

          return GestureDetector(
            onTap: () => onCategoryChanged(isSelected ? null : type),
            child: Container(
              margin: EdgeInsets.only(right: ResponsiveHelper.size(context, 6)),
              padding: ResponsiveHelper.padding(
                context,
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF6B4CE6) : Colors.grey[200],
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(context, 16),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    emoji,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 18),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.size(context, 6)),
                  Text(
                    name,
                    style: GoogleFonts.cairo(
                      fontSize: ResponsiveHelper.fontSize(context, 13),
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

  Widget _buildElementsGrid(BuildContext context) {
    final elements =
        selectedCategory == null
            ? BuildingElementsData.getAllElements()
            : BuildingElementsData.getElementsByType(selectedCategory!);

    // Responsive cross axis count
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 360 ? 3 : 4;

    return GridView.builder(
      padding: ResponsiveHelper.padding(context, horizontal: 12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1,
        crossAxisSpacing: ResponsiveHelper.size(context, 8),
        mainAxisSpacing: ResponsiveHelper.size(context, 8),
      ),
      itemCount: elements.length,
      itemBuilder: (context, index) {
        final element = elements[index];
        return _buildElementCard(context, element);
      },
    );
  }

  Widget _buildElementCard(BuildContext context, BuildingElement element) {
    return Draggable<BuildingElement>(
      data: element,
      feedback: Material(
        color: Colors.transparent,
        child: _buildElementIcon(context, element, isDragging: true),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildElementIcon(context, element),
      ),
      child: GestureDetector(
        onTap: () => onElementSelected(element),
        child: _buildElementIcon(context, element),
      ),
    );
  }

  Widget _buildElementIcon(
    BuildContext context,
    BuildingElement element, {
    bool isDragging = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: element.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(context, 10),
        ),
        border: Border.all(
          color: element.color,
          width: ResponsiveHelper.size(context, 2),
        ),
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
          FittedBox(
            child: Text(
              element.emoji,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(
                  context,
                  isDragging ? 28 : 22,
                ),
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.size(context, 2)),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.size(context, 2),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                element.nameArabic,
                style: GoogleFonts.cairo(
                  fontSize: ResponsiveHelper.fontSize(context, 9),
                  fontWeight: FontWeight.bold,
                  color: element.color,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
