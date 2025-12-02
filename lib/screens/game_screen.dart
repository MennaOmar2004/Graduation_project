import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';
import '../game/star_catcher_game.dart';
import '../game/components/power_up_component.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late StarCatcherGame _game;

  @override
  void initState() {
    super.initState();
    _game = StarCatcherGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // The Game
          GameWidget(
            game: _game,
            overlayBuilderMap: {
              'HUD': (BuildContext context, StarCatcherGame game) {
                return GameHUD(game: game);
              },
              'GameOver': (BuildContext context, StarCatcherGame game) {
                return GameOverOverlay(
                  game: game,
                  onRestart: () {
                    game.overlays.remove('GameOver');
                    game.overlays.add('HUD');
                    game.restartGame();
                    setState(() {});
                  },
                  onExit: () => Navigator.of(context).pop(),
                );
              },
            },
            initialActiveOverlays: const ['HUD'],
          ),

          // Back Button
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFFFF4081),
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GameHUD extends StatefulWidget {
  final StarCatcherGame game;

  const GameHUD({super.key, required this.game});

  @override
  State<GameHUD> createState() => _GameHUDState();
}

class _GameHUDState extends State<GameHUD> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(milliseconds: 50)),
      builder: (context, snapshot) {
        // Show game over overlay if game is over
        if (widget.game.isGameOver) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.game.overlays.remove('HUD');
            widget.game.overlays.add('GameOver');
          });
        }

        return Stack(
          children: [
            // Score
            Positioned(top: 40, left: 20, child: _buildScoreDisplay()),

            // Lives
            Positioned(top: 100, left: 20, child: _buildLivesDisplay()),

            // Combo
            if (widget.game.combo > 0)
              Positioned(top: 160, left: 20, child: _buildComboDisplay()),

            // Active Power-ups
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: _buildPowerUpsDisplay(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildScoreDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFF4081), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Color(0xFFFFD700), size: 30),
          const SizedBox(width: 10),
          Text(
            "النقاط: ${widget.game.score}",
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6A1B9A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLivesDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFF4081), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Icon(
              index < widget.game.lives
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: const Color(0xFFFF4081),
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComboDisplay() {
    final multiplier = widget.game.getComboMultiplier();
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 200),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFFFD93D)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.5),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.flash_on, color: Colors.white, size: 24),
                const SizedBox(width: 5),
                Text(
                  "×${multiplier + 1} كومبو: ${widget.game.combo}",
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPowerUpsDisplay() {
    final activePowerUps = widget.game.activePowerUps;
    if (activePowerUps.isEmpty) return const SizedBox.shrink();

    return Center(
      child: Wrap(
        spacing: 10,
        children:
            activePowerUps.map((powerUp) {
              return _buildPowerUpIndicator(powerUp);
            }).toList(),
      ),
    );
  }

  Widget _buildPowerUpIndicator(ActivePowerUp powerUp) {
    final color = _getPowerUpColor(powerUp.type);
    final icon = _getPowerUpIcon(powerUp.type);
    final name = _getPowerUpName(powerUp.type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 5),
          Text(
            "$name ${powerUp.remainingTime.toStringAsFixed(0)}s",
            style: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPowerUpColor(PowerUpType type) {
    switch (type) {
      case PowerUpType.magnet:
        return const Color(0xFF9C27B0);
      case PowerUpType.shield:
        return const Color(0xFF2196F3);
      case PowerUpType.doublePoints:
        return const Color(0xFFFF9800);
      case PowerUpType.speedBoost:
        return const Color(0xFF4CAF50);
    }
  }

  String _getPowerUpIcon(PowerUpType type) {
    switch (type) {
      case PowerUpType.magnet:
        return '🧲';
      case PowerUpType.shield:
        return '🛡️';
      case PowerUpType.doublePoints:
        return '×2';
      case PowerUpType.speedBoost:
        return '⚡';
    }
  }

  String _getPowerUpName(PowerUpType type) {
    switch (type) {
      case PowerUpType.magnet:
        return 'مغناطيس';
      case PowerUpType.shield:
        return 'درع';
      case PowerUpType.doublePoints:
        return 'نقاط مضاعفة';
      case PowerUpType.speedBoost:
        return 'سرعة';
    }
  }
}

class GameOverOverlay extends StatelessWidget {
  final StarCatcherGame game;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const GameOverOverlay({
    super.key,
    required this.game,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final stars = _calculateStars();

    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6A1B9A), Color(0xFF9C27B0), Color(0xFFBA68C8)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withValues(alpha: 0.5),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "انتهت اللعبة!",
                style: GoogleFonts.cairo(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => Icon(
                    index < stars ? Icons.star : Icons.star_border,
                    color: const Color(0xFFFFD700),
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Score
              _buildStatRow("النقاط النهائية", game.score.toString()),
              const SizedBox(height: 15),
              _buildStatRow("أعلى كومبو", "×${game.maxCombo}"),

              const SizedBox(height: 40),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: _buildButton(
                      "العب مرة أخرى",
                      Icons.replay,
                      const Color(0xFF4CAF50),
                      onRestart,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: _buildButton(
                      "خروج",
                      Icons.exit_to_app,
                      const Color(0xFFFF4081),
                      onExit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.cairo(fontSize: 20, color: Colors.white),
          ),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFFD700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
      ),
    );
  }

  int _calculateStars() {
    if (game.score >= 500) return 3;
    if (game.score >= 250) return 2;
    if (game.score >= 100) return 1;
    return 0;
  }
}
