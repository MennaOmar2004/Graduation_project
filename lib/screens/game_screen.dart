import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';
import '../game/star_catcher_game.dart';
import '../utils/responsive_helper.dart';

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

          // Back Button - RESPONSIVE
          Positioned(
            top:
                ResponsiveHelper.height(context, 0.05) +
                MediaQuery.of(context).padding.top,
            right: ResponsiveHelper.width(context, 0.05),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: EdgeInsets.all(ResponsiveHelper.size(context, 10)),
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
                child: Icon(
                  Icons.arrow_back,
                  color: const Color(0xFFFF4081),
                  size: ResponsiveHelper.iconSize(context, 24),
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
    final safeTop = MediaQuery.of(context).padding.top;

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
            // Score - RESPONSIVE
            Positioned(
              top: safeTop + ResponsiveHelper.height(context, 0.02),
              left: ResponsiveHelper.width(context, 0.04),
              child: _buildScoreDisplay(),
            ),

            // Lives - RESPONSIVE
            Positioned(
              top: safeTop + ResponsiveHelper.height(context, 0.1),
              left: ResponsiveHelper.width(context, 0.04),
              child: _buildLivesDisplay(),
            ),

            // Combo - RESPONSIVE
            if (widget.game.combo > 0)
              Positioned(
                top: safeTop + ResponsiveHelper.height(context, 0.18),
                left: ResponsiveHelper.width(context, 0.04),
                child: _buildComboDisplay(),
              ),

            // Active Power-ups - RESPONSIVE
            Positioned(
              top: safeTop + ResponsiveHelper.height(context, 0.02),
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
      padding: ResponsiveHelper.padding(context, horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(context, 16),
        ),
        border: Border.all(
          color: const Color(0xFFFF4081),
          width: ResponsiveHelper.size(context, 2),
        ),
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
          Icon(
            Icons.star,
            color: const Color(0xFFFFD700),
            size: ResponsiveHelper.iconSize(context, 24),
          ),
          SizedBox(width: ResponsiveHelper.size(context, 6)),
          FittedBox(
            child: Text(
              '${widget.game.score}',
              style: GoogleFonts.cairo(
                fontSize: ResponsiveHelper.fontSize(context, 22),
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF4081),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLivesDisplay() {
    return Container(
      padding: ResponsiveHelper.padding(context, horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(context, 16),
        ),
        border: Border.all(
          color: const Color(0xFFE91E63),
          width: ResponsiveHelper.size(context, 2),
        ),
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
          widget.game.lives,
          (index) => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.size(context, 2),
            ),
            child: Icon(
              Icons.favorite,
              color: const Color(0xFFE91E63),
              size: ResponsiveHelper.iconSize(context, 20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComboDisplay() {
    return Container(
      padding: ResponsiveHelper.padding(context, horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(context, 16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FittedBox(
        child: Text(
          'x${widget.game.combo} Combo!',
          style: GoogleFonts.cairo(
            fontSize: ResponsiveHelper.fontSize(context, 16),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildPowerUpsDisplay() {
    return Center(
      child: Wrap(
        spacing: ResponsiveHelper.size(context, 8),
        children:
            widget.game.activePowerUps.map((powerUp) {
              return Container(
                padding: ResponsiveHelper.padding(
                  context,
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: powerUp.color.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(context, 12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: powerUp.color.withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      powerUp.emoji,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 16),
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.size(context, 4)),
                    FittedBox(
                      child: Text(
                        '${powerUp.remainingTime.toInt()}s',
                        style: GoogleFonts.cairo(
                          fontSize: ResponsiveHelper.fontSize(context, 12),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
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
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          margin: ResponsiveHelper.padding(context, horizontal: 20),
          padding: ResponsiveHelper.padding(context, all: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.borderRadius(context, 24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star,
                size: ResponsiveHelper.iconSize(context, 70),
                color: const Color(0xFFFFD700),
              ),
              SizedBox(height: ResponsiveHelper.size(context, 16)),
              FittedBox(
                child: Text(
                  'انتهت اللعبة!',
                  style: GoogleFonts.cairo(
                    fontSize: ResponsiveHelper.fontSize(context, 32),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF4081),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.size(context, 16)),
              FittedBox(
                child: Text(
                  'النقاط: ${game.score}',
                  style: GoogleFonts.cairo(
                    fontSize: ResponsiveHelper.fontSize(context, 24),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.size(context, 24)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onExit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: ResponsiveHelper.padding(
                          context,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(context, 16),
                          ),
                        ),
                      ),
                      child: FittedBox(
                        child: Text(
                          'خروج',
                          style: GoogleFonts.cairo(
                            fontSize: ResponsiveHelper.fontSize(context, 16),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.size(context, 12)),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onRestart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4081),
                        padding: ResponsiveHelper.padding(
                          context,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(context, 16),
                          ),
                        ),
                      ),
                      child: FittedBox(
                        child: Text(
                          'إعادة',
                          style: GoogleFonts.cairo(
                            fontSize: ResponsiveHelper.fontSize(context, 16),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
}
