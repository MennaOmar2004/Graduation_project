import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/game_item.dart';
import 'alphabet_game_screen.dart';
import 'pattern_selector_screen.dart';
import 'mosque_builder_screen.dart';
import 'game_screen.dart';
import 'maze_game_screen.dart';
import 'number_circus_screen.dart';
import 'moon_phases_screen.dart';
import 'prayer_garden_screen.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF667eea),
              const Color(0xFF764ba2),
              const Color(0xFFf093fb),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(child: _buildGamesList(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.95),
            Colors.white.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667eea).withValues(alpha: 0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback:
                      (bounds) => const LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFFf093fb)],
                      ).createShader(bounds),
                  child: Text(
                    'الألعاب التعليمية',
                    style: GoogleFonts.cairo(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'اختر لعبتك المفضلة واستمتع',
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Score display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars_rounded, color: Colors.white, size: 24),
                const SizedBox(width: 6),
                Text(
                  '70',
                  style: GoogleFonts.cairo(
                    fontSize: 20,
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

  Widget _buildGamesList(BuildContext context) {
    final games = _getGames();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      itemCount: games.length,
      itemBuilder: (context, index) {
        return _buildStunningGameCard(context, games[index], index);
      },
    );
  }

  Widget _buildStunningGameCard(
    BuildContext context,
    GameItem game,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        elevation: 0,
        child: InkWell(
          onTap: () => _navigateToGame(context, game),
          borderRadius: BorderRadius.circular(30),
          splashColor: game.color.withValues(alpha: 0.2),
          highlightColor: game.color.withValues(alpha: 0.1),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.white.withValues(alpha: 0.95)],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: game.color.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  spreadRadius: -5,
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.9),
                  blurRadius: 15,
                  offset: const Offset(-8, -8),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Icon container with stunning gradient
                  Container(
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [game.color, game.color.withValues(alpha: 0.8)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: game.color.withValues(alpha: 0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        game.icon,
                        style: const TextStyle(fontSize: 42),
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.title,
                          style: GoogleFonts.cairo(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D3142),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          game.description,
                          style: GoogleFonts.cairo(
                            fontSize: 15,
                            color: Colors.grey[600],
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Arrow indicator with gradient
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          game.color.withValues(alpha: 0.15),
                          game.color.withValues(alpha: 0.08),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: game.color.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: game.color,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<GameItem> _getGames() {
    return [
      GameItem(
        id: 'alphabet',
        title: 'الحروف',
        description: 'تعلم الحروف العربية بطريقة ممتعة وتفاعلية',
        icon: '📚',
        color: const Color(0xFF4CAF50),
      ),
      GameItem(
        id: 'number_circus',
        title: 'سيرك الأرقام',
        description: 'تعلم الأرقام في سيرك مليء بالمرح والإثارة',
        icon: '🎈',
        color: const Color(0xFFFF6B9D),
      ),
      GameItem(
        id: 'moon_phases',
        title: 'أطوار القمر',
        description: 'اكتشف التقويم القمري وأطوار القمر الجميلة',
        icon: '🌙',
        color: const Color(0xFF6B4CE6),
      ),
      GameItem(
        id: 'prayer_garden',
        title: 'حديقة الصلاة',
        description: 'تعلم أوقات الصلاة في حديقة سحرية',
        icon: '🌸',
        color: const Color(0xFF4CAF50),
      ),
      GameItem(
        id: 'coloring',
        title: 'التلوين',
        description: 'لون الأنماط الإسلامية الجميلة بألوان رائعة',
        icon: '🎨',
        color: const Color(0xFFE91E63),
      ),
      GameItem(
        id: 'mosque_builder',
        title: 'بناء المسجد',
        description: 'ابنِ مسجدك الخاص بإبداعك وخيالك',
        icon: '🕌',
        color: const Color(0xFF00BCD4),
      ),
      GameItem(
        id: 'star_catcher',
        title: 'صائد النجوم',
        description: 'العب والتقط النجوم اللامعة في السماء',
        icon: '⭐',
        color: const Color(0xFFFF9800),
      ),
      GameItem(
        id: 'values',
        title: 'طريق القيم',
        description: 'تعلم القيم الحميدة في متاهة مشوقة',
        icon: '❤️',
        color: const Color(0xFF9C27B0),
      ),
    ];
  }

  void _navigateToGame(BuildContext context, GameItem game) {
    switch (game.id) {
      case 'alphabet':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AlphabetGameScreen()),
        );
        break;
      case 'coloring':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PatternSelectorScreen(),
          ),
        );
        break;
      case 'mosque_builder':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MosqueBuilderScreen()),
        );
        break;
      case 'star_catcher':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GameScreen()),
        );
        break;
      case 'values':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MazeGameScreen()),
        );
        break;
      case 'number_circus':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NumberCircusScreen()),
        );
        break;
      case 'moon_phases':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MoonPhasesScreen()),
        );
        break;
      case 'prayer_garden':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PrayerGardenScreen()),
        );
        break;
    }
  }
}
