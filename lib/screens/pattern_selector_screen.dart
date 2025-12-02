import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/coloring_page.dart';
import '../data/coloring_templates.dart';
import 'coloring_game_screen.dart';

class PatternSelectorScreen extends StatelessWidget {
  const PatternSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patterns = ColoringTemplates.getTemplates();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFFF9C4).withValues(alpha: 0.3),
              const Color(0xFFFFE0B2).withValues(alpha: 0.3),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(child: _buildPatternGrid(context, patterns)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Color(0xFF6B4CE6),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'اختر صفحة للتلوين',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6B4CE6),
              ),
            ),
          ),
          const SizedBox(width: 56),
        ],
      ),
    );
  }

  Widget _buildPatternGrid(BuildContext context, List<ColoringPage> patterns) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: patterns.length,
      itemBuilder: (context, index) {
        return _buildPatternCard(context, patterns[index]);
      },
    );
  }

  Widget _buildPatternCard(BuildContext context, ColoringPage pattern) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ColoringGameScreen(initialPage: pattern),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: _getCategoryColor(pattern.category).withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Pattern preview
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getCategoryColor(
                      pattern.category,
                    ).withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    _getPatternIcon(pattern.category),
                    style: const TextStyle(fontSize: 64),
                  ),
                ),
              ),
            ),
            // Pattern info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getCategoryColor(pattern.category),
                    _getCategoryColor(pattern.category).withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    pattern.titleArabic,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(
                        3,
                        (i) => Icon(
                          Icons.star,
                          size: 16,
                          color:
                              i < pattern.difficulty
                                  ? Colors.amber
                                  : Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'geometric':
        return const Color(0xFF6B4CE6);
      case 'architecture':
        return const Color(0xFF00BCD4);
      case 'nature':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFFE91E63);
    }
  }

  String _getPatternIcon(String category) {
    switch (category) {
      case 'geometric':
        return '⭐';
      case 'architecture':
        return '🕌';
      case 'nature':
        return '🌸';
      default:
        return '🎨';
    }
  }
}
