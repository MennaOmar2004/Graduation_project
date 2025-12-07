import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';
import '../game/number_circus/mini_games/balloon_pop_game.dart';
import '../utils/responsive_helper.dart';

/// Stunning Number Circus screen with beautiful UI
class NumberCircusScreen extends StatefulWidget {
  const NumberCircusScreen({super.key});

  @override
  State<NumberCircusScreen> createState() => _NumberCircusScreenState();
}

class _NumberCircusScreenState extends State<NumberCircusScreen> {
  late BalloonPopGame _game;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _game =
        BalloonPopGame()
          ..onScoreChanged = (score) {
            setState(() => _score = score);
          };
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
              const Color(0xFF87CEEB),
              const Color(0xFFB0E0E6),
              const Color(0xFFFFF8DC),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: GameWidget(game: _game)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: ResponsiveHelper.padding(context, all: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.3),
            Colors.white.withValues(alpha: 0.1),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(ResponsiveHelper.size(context, 10)),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_forward,
                color: const Color(0xFF6B4CE6),
                size: ResponsiveHelper.iconSize(context, 20),
              ),
            ),
          ),
          SizedBox(width: ResponsiveHelper.width(context, 0.03)),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FittedBox(
                  child: ShaderMask(
                    shaderCallback:
                        (bounds) => const LinearGradient(
                          colors: [Color(0xFFFF6B9D), Color(0xFF6B4CE6)],
                        ).createShader(bounds),
                    child: Text(
                      '🎪 سيرك الأرقام',
                      style: GoogleFonts.cairo(
                        fontSize: ResponsiveHelper.fontSize(context, 24),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  child: Text(
                    'افقع البالونات!',
                    style: GoogleFonts.cairo(
                      fontSize: ResponsiveHelper.fontSize(context, 14),
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: ResponsiveHelper.width(context, 0.03)),

          // Score display
          Container(
            padding: ResponsiveHelper.padding(
              context,
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
              ),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(context, 20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.5),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.white,
                  size: ResponsiveHelper.iconSize(context, 20),
                ),
                SizedBox(width: ResponsiveHelper.size(context, 6)),
                FittedBox(
                  child: Text(
                    _getArabicNumber(_score),
                    style: GoogleFonts.cairo(
                      fontSize: ResponsiveHelper.fontSize(context, 18),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getArabicNumber(int num) {
    if (num == 0) return '٠';

    String result = '';
    String numStr = num.toString();

    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < numStr.length; i++) {
      int digit = int.parse(numStr[i]);
      result += arabicDigits[digit];
    }

    return result;
  }
}
