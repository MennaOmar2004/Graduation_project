import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/game_card.dart';
import '../models/game_item.dart';
import 'alphabet_game_screen.dart';
import 'game_screen.dart';
import 'maze_game_screen.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFF8BBD0).withValues(alpha: 0.3),
              const Color(0xFFE1F5FE).withValues(alpha: 0.3),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(child: _buildGamesGrid(context)),
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
              'نقاطك',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6B4CE6),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.white, size: 20),
                const SizedBox(width: 4),
                Text(
                  '70',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
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

  Widget _buildGamesGrid(BuildContext context) {
    final games = _getGames();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: games.length,
      itemBuilder: (context, index) {
        return GameCard(
          game: games[index],
          onTap: () => _navigateToGame(context, games[index]),
        );
      },
    );
  }

  List<GameItem> _getGames() {
    return [
      GameItem(
        id: 'alphabet',
        title: 'الحروف',
        description: 'تعلم الحروف العربية',
        icon: '📚',
        color: const Color(0xFF4CAF50),
      ),
      GameItem(
        id: 'star_catcher',
        title: 'صائد النجوم',
        description: 'العب والتقط النجوم',
        icon: '⭐',
        color: const Color(0xFFFF9800),
      ),
      GameItem(
        id: 'values',
        title: 'طريق القيم',
        description: 'تعلم القيم الحميدة',
        icon: '🌟',
        color: const Color(0xFF00BCD4),
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
    }
  }
}
