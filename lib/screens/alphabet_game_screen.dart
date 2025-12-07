import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';
import '../game/alphabet_game/alphabet_learning_game.dart';
import '../utils/responsive_helper.dart';

class AlphabetGameScreen extends StatefulWidget {
  const AlphabetGameScreen({super.key});

  @override
  State<AlphabetGameScreen> createState() => _AlphabetGameScreenState();
}

class _AlphabetGameScreenState extends State<AlphabetGameScreen> {
  late AlphabetLearningGame _game;

  @override
  void initState() {
    super.initState();
    _game = AlphabetLearningGame();
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
              'HUD': (BuildContext context, AlphabetLearningGame game) {
                return AlphabetGameHUD(game: game);
              },
            },
            initialActiveOverlays: const ['HUD'],
          ),

          // Back Button - Responsive positioning
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
                  color: Colors.white.withValues(alpha: 0.9),
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

class AlphabetGameHUD extends StatefulWidget {
  final AlphabetLearningGame game;

  const AlphabetGameHUD({super.key, required this.game});

  @override
  State<AlphabetGameHUD> createState() => _AlphabetGameHUDState();
}

class _AlphabetGameHUDState extends State<AlphabetGameHUD> {
  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;

    return StreamBuilder(
      stream: Stream.periodic(const Duration(milliseconds: 50)),
      builder: (context, snapshot) {
        return Stack(
          children: [
            // Top bar with score and level - RESPONSIVE
            Positioned(
              top: safeTop + ResponsiveHelper.height(context, 0.02),
              left: ResponsiveHelper.width(context, 0.04),
              right: ResponsiveHelper.width(context, 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: _buildScoreDisplay()),
                  SizedBox(width: ResponsiveHelper.width(context, 0.02)),
                  Flexible(child: _buildLevelDisplay()),
                ],
              ),
            ),

            // Lives in center top - RESPONSIVE
            Positioned(
              top: safeTop + ResponsiveHelper.height(context, 0.12),
              left: 0,
              right: 0,
              child: Center(child: _buildLivesDisplay()),
            ),

            // Encouragement Message - RESPONSIVE
            if (widget.game.showEncouragement)
              Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.5, end: 1.0),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        margin: ResponsiveHelper.padding(
                          context,
                          horizontal: 20,
                        ),
                        padding: ResponsiveHelper.padding(
                          context,
                          horizontal: 30,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFFD700),
                              Color(0xFFFFA500),
                              Color(0xFFFF6B9D),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(context, 30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withValues(alpha: 0.6),
                              blurRadius: 25,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white,
                            width: ResponsiveHelper.size(context, 3),
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.game.encouragementMessage,
                            style: GoogleFonts.cairo(
                              fontSize: ResponsiveHelper.fontSize(context, 36),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                const Shadow(
                                  color: Colors.black26,
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
        gradient: const LinearGradient(
          colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(context, 20),
        ),
        border: Border.all(
          color: Colors.white,
          width: ResponsiveHelper.size(context, 2),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4ECDC4).withValues(alpha: 0.4),
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
            color: const Color(0xFFFFD700),
            size: ResponsiveHelper.iconSize(context, 24),
          ),
          SizedBox(width: ResponsiveHelper.width(context, 0.02)),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "${widget.game.score}",
              style: GoogleFonts.cairo(
                fontSize: ResponsiveHelper.fontSize(context, 24),
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  const Shadow(
                    color: Colors.black26,
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelDisplay() {
    return Container(
      padding: ResponsiveHelper.padding(context, horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(context, 20),
        ),
        border: Border.all(
          color: Colors.white,
          width: ResponsiveHelper.size(context, 2),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.emoji_events,
            color: const Color(0xFFFFD700),
            size: ResponsiveHelper.iconSize(context, 24),
          ),
          SizedBox(width: ResponsiveHelper.width(context, 0.02)),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "مستوى ${widget.game.level}",
              style: GoogleFonts.cairo(
                fontSize: ResponsiveHelper.fontSize(context, 20),
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  const Shadow(
                    color: Colors.black26,
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLivesDisplay() {
    return Container(
      padding: ResponsiveHelper.padding(context, horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B9D), Color(0xFFFF8E53)],
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(context, 25),
        ),
        border: Border.all(
          color: Colors.white,
          width: ResponsiveHelper.size(context, 3),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B9D).withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          widget.game.lives,
          (index) => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.width(context, 0.01),
            ),
            child: Icon(
              Icons.favorite,
              color: Colors.white,
              size: ResponsiveHelper.iconSize(context, 28),
            ),
          ),
        ),
      ),
    );
  }
}
