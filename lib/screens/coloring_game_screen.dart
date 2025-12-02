import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/coloring_page.dart';
import '../data/color_palette.dart';
import '../data/coloring_templates.dart';
import '../widgets/color_palette_widget.dart';
import '../widgets/coloring_canvas.dart';

class ColoringGameScreen extends StatefulWidget {
  final ColoringPage? initialPage;

  const ColoringGameScreen({super.key, this.initialPage});

  @override
  State<ColoringGameScreen> createState() => _ColoringGameScreenState();
}

class _ColoringGameScreenState extends State<ColoringGameScreen> {
  late ColoringPage _currentPage;
  ColorInfo? _selectedColor;
  final List<Map<String, Color>> _colorHistory = [];
  int _historyIndex = -1;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage ?? ColoringTemplates.getTemplates().first;
    _selectedColor = ColorPalette.colors.first;
  }

  void _handleRegionColored(String regionId, Color color) {
    setState(() {
      final regionIndex = _currentPage.regions.indexWhere(
        (r) => r.id == regionId,
      );
      if (regionIndex != -1) {
        final updatedRegions = List<ColorRegion>.from(_currentPage.regions);
        updatedRegions[regionIndex] = updatedRegions[regionIndex].copyWith(
          fillColor: color,
        );

        _currentPage = ColoringPage(
          id: _currentPage.id,
          title: _currentPage.title,
          titleArabic: _currentPage.titleArabic,
          category: _currentPage.category,
          difficulty: _currentPage.difficulty,
          regions: updatedRegions,
          thumbnailPath: _currentPage.thumbnailPath,
        );

        if (_historyIndex < _colorHistory.length - 1) {
          _colorHistory.removeRange(_historyIndex + 1, _colorHistory.length);
        }
        _colorHistory.add({regionId: color});
        _historyIndex++;

        _checkCompletion();
      }
    });
  }

  void _undo() {
    if (_historyIndex > 0) {
      setState(() {
        _historyIndex--;
        _rebuildFromHistory();
      });
    }
  }

  void _redo() {
    if (_historyIndex < _colorHistory.length - 1) {
      setState(() {
        _historyIndex++;
        _rebuildFromHistory();
      });
    }
  }

  void _rebuildFromHistory() {
    final updatedRegions = List<ColorRegion>.from(_currentPage.regions);

    for (int i = 0; i < updatedRegions.length; i++) {
      updatedRegions[i] = ColorRegion(
        id: updatedRegions[i].id,
        path: updatedRegions[i].path,
      );
    }

    for (int i = 0; i <= _historyIndex; i++) {
      final entry = _colorHistory[i];
      final regionId = entry.keys.first;
      final color = entry.values.first;

      final regionIndex = updatedRegions.indexWhere((r) => r.id == regionId);
      if (regionIndex != -1) {
        updatedRegions[regionIndex] = updatedRegions[regionIndex].copyWith(
          fillColor: color,
        );
      }
    }

    _currentPage = ColoringPage(
      id: _currentPage.id,
      title: _currentPage.title,
      titleArabic: _currentPage.titleArabic,
      category: _currentPage.category,
      difficulty: _currentPage.difficulty,
      regions: updatedRegions,
      thumbnailPath: _currentPage.thumbnailPath,
    );
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'مسح الكل؟',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            content: Text(
              'هل تريد مسح جميع الألوان؟',
              style: GoogleFonts.cairo(),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('إلغاء', style: GoogleFonts.cairo()),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _colorHistory.clear();
                    _historyIndex = -1;
                    _rebuildFromHistory();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                ),
                child: Text(
                  'مسح',
                  style: GoogleFonts.cairo(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _checkCompletion() {
    final coloredRegions =
        _currentPage.regions.where((r) => r.fillColor != null).length;
    final totalRegions = _currentPage.regions.length;

    if (coloredRegions == totalRegions) {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.celebration,
                  size: 80,
                  color: Color(0xFFFFD700),
                ),
                const SizedBox(height: 16),
                Text(
                  'أحسنت!',
                  style: GoogleFonts.cairo(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6B4CE6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'لقد أكملت التلوين بنجاح!',
                  style: GoogleFonts.cairo(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('العودة', style: GoogleFonts.cairo()),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B4CE6),
                ),
                child: Text(
                  'صفحة جديدة',
                  style: GoogleFonts.cairo(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              _buildHeader(),
              Expanded(
                child: ColoringCanvas(
                  page: _currentPage,
                  selectedColor: _selectedColor?.color,
                  onRegionColored: _handleRegionColored,
                ),
              ),
              _buildActionButtons(),
              ColorPaletteWidget(
                selectedColor: _selectedColor,
                onColorSelected: (color) {
                  setState(() {
                    _selectedColor = color;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _currentPage.titleArabic,
                  style: GoogleFonts.cairo(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6B4CE6),
                  ),
                ),
                Text(
                  'التلوين',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6B4CE6), Color(0xFF9C27B0)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6B4CE6).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.palette, color: Colors.white, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${_currentPage.regions.where((r) => r.fillColor != null).length}/${_currentPage.regions.length}',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.undo,
            label: 'تراجع',
            onTap: _historyIndex > 0 ? _undo : null,
            color: const Color(0xFF2196F3),
          ),
          _buildActionButton(
            icon: Icons.redo,
            label: 'إعادة',
            onTap: _historyIndex < _colorHistory.length - 1 ? _redo : null,
            color: const Color(0xFF4CAF50),
          ),
          _buildActionButton(
            icon: Icons.delete_outline,
            label: 'مسح',
            onTap: _clearAll,
            color: const Color(0xFFE53935),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    required Color color,
  }) {
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: isEnabled ? 1.0 : 0.4,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isEnabled ? color : Colors.grey,
            borderRadius: BorderRadius.circular(20),
            boxShadow:
                isEnabled
                    ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
