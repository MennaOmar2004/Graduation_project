import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/building_element.dart';
import '../widgets/element_palette.dart';
import '../widgets/building_canvas.dart';

class MosqueBuilderScreen extends StatefulWidget {
  const MosqueBuilderScreen({super.key});

  @override
  State<MosqueBuilderScreen> createState() => _MosqueBuilderScreenState();
}

class _MosqueBuilderScreenState extends State<MosqueBuilderScreen> {
  final List<PlacedElement> _placedElements = [];
  final List<List<PlacedElement>> _history = [];
  int _historyIndex = -1;
  ElementType? _selectedCategory;

  void _handleElementPlaced(PlacedElement element) {
    setState(() {
      _placedElements.add(element);
      _addToHistory();
    });
  }

  void _handleElementRemoved(String id) {
    setState(() {
      _placedElements.removeWhere((e) => e.id == id);
      _addToHistory();
    });
  }

  void _handleElementMoved(PlacedElement updatedElement) {
    setState(() {
      final index = _placedElements.indexWhere(
        (e) => e.id == updatedElement.id,
      );
      if (index != -1) {
        _placedElements[index] = updatedElement;
        _addToHistory();
      }
    });
  }

  void _addToHistory() {
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }
    _history.add(List.from(_placedElements));
    _historyIndex++;
  }

  void _undo() {
    if (_historyIndex > 0) {
      setState(() {
        _historyIndex--;
        _placedElements.clear();
        _placedElements.addAll(_history[_historyIndex]);
      });
    }
  }

  void _redo() {
    if (_historyIndex < _history.length - 1) {
      setState(() {
        _historyIndex++;
        _placedElements.clear();
        _placedElements.addAll(_history[_historyIndex]);
      });
    }
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
              'هل تريد مسح جميع العناصر؟',
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
                    _placedElements.clear();
                    _addToHistory();
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

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mosque, size: 80, color: Color(0xFF00BCD4)),
                const SizedBox(height: 16),
                Text(
                  'مسجد رائع!',
                  style: GoogleFonts.cairo(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6B4CE6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'لقد بنيت مسجداً جميلاً!',
                  style: GoogleFonts.cairo(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('متابعة البناء', style: GoogleFonts.cairo()),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _placedElements.clear();
                    _addToHistory();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B4CE6),
                ),
                child: Text(
                  'مسجد جديد',
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
              const Color(0xFFE3F2FD).withValues(alpha: 0.5),
              const Color(0xFFFFF9C4).withValues(alpha: 0.3),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: BuildingCanvas(
                  placedElements: _placedElements,
                  onElementPlaced: _handleElementPlaced,
                  onElementRemoved: _handleElementRemoved,
                  onElementMoved: _handleElementMoved,
                ),
              ),
              _buildActionButtons(),
              ElementPalette(
                onElementSelected: (element) {
                  // Element selected from palette
                },
                selectedCategory: _selectedCategory,
                onCategoryChanged: (category) {
                  setState(() {
                    _selectedCategory = category;
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
                  'بناء المسجد',
                  style: GoogleFonts.cairo(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6B4CE6),
                  ),
                ),
                Text(
                  'اسحب العناصر للبناء',
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
                colors: [Color(0xFF00BCD4), Color(0xFF00ACC1)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00BCD4).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.architecture, color: Colors.white, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${_placedElements.length}',
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
            onTap: _historyIndex < _history.length - 1 ? _redo : null,
            color: const Color(0xFF4CAF50),
          ),
          _buildActionButton(
            icon: Icons.delete_outline,
            label: 'مسح',
            onTap: _clearAll,
            color: const Color(0xFFE53935),
          ),
          _buildActionButton(
            icon: Icons.check_circle,
            label: 'إنهاء',
            onTap: _placedElements.isNotEmpty ? _showCompletionDialog : null,
            color: const Color(0xFF00BCD4),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 14,
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
