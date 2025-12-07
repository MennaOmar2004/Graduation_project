import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';
import '../game/moon_phases/moon_phases_game.dart';
import '../game/moon_phases/data/moon_data.dart';
import '../utils/responsive_helper.dart';

class MoonPhasesScreen extends StatefulWidget {
  const MoonPhasesScreen({super.key});

  @override
  State<MoonPhasesScreen> createState() => _MoonPhasesScreenState();
}

class _MoonPhasesScreenState extends State<MoonPhasesScreen> {
  late MoonPhasesGame _game;
  int _score = 0;
  MoonPhase? _currentPhase;
  bool? _lastAnswerCorrect;

  @override
  void initState() {
    super.initState();
    _game =
        MoonPhasesGame()
          ..onScoreChanged = (score) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _score = score);
            });
          }
          ..onPhaseChanged = (phase) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _currentPhase = phase;
                  _lastAnswerCorrect = null;
                });
              }
            });
          }
          ..onAnswerSubmitted = (correct) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _lastAnswerCorrect = correct;
                });
              }
            });
          };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: _game),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const Spacer(),
                if (_currentPhase != null) _buildPhaseInfo(),
                SizedBox(height: ResponsiveHelper.height(context, 0.02)),
                _buildDaySelector(),
                SizedBox(height: ResponsiveHelper.height(context, 0.03)),
              ],
            ),
          ),
          if (_lastAnswerCorrect != null) _buildFeedback(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: ResponsiveHelper.padding(context, all: 12),
      padding: ResponsiveHelper.padding(context, all: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.2),
            Colors.white.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(context, 20),
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(ResponsiveHelper.size(context, 8)),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: const Color(0xFF6B4CE6),
                size: ResponsiveHelper.iconSize(context, 20),
              ),
            ),
          ),
          SizedBox(width: ResponsiveHelper.width(context, 0.03)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FittedBox(
                  child: Text(
                    '🌙 أطوار القمر',
                    style: GoogleFonts.cairo(
                      fontSize: ResponsiveHelper.fontSize(context, 22),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                FittedBox(
                  child: Text(
                    'تعلم التقويم القمري',
                    style: GoogleFonts.cairo(
                      fontSize: ResponsiveHelper.fontSize(context, 13),
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: ResponsiveHelper.width(context, 0.03)),
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
                ResponsiveHelper.borderRadius(context, 16),
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
                  size: ResponsiveHelper.iconSize(context, 18),
                ),
                SizedBox(width: ResponsiveHelper.size(context, 4)),
                FittedBox(
                  child: Text(
                    '$_score',
                    style: GoogleFonts.cairo(
                      fontSize: ResponsiveHelper.fontSize(context, 16),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  Widget _buildPhaseInfo() {
    if (_currentPhase == null) return const SizedBox();
    return Container(
      margin: ResponsiveHelper.padding(context, horizontal: 16),
      padding: ResponsiveHelper.padding(context, all: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6B4CE6).withValues(alpha: 0.9),
            const Color(0xFF9C27B0).withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(context, 20),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B4CE6).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          FittedBox(
            child: Text(
              _currentPhase!.nameArabic,
              style: GoogleFonts.cairo(
                fontSize: ResponsiveHelper.fontSize(context, 26),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.size(context, 8)),
          FittedBox(
            child: Text(
              _currentPhase!.fact,
              style: GoogleFonts.cairo(
                fontSize: ResponsiveHelper.fontSize(context, 14),
                color: Colors.white.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: ResponsiveHelper.size(context, 12)),
          FittedBox(
            child: Text(
              'في أي يوم من الشهر القمري؟',
              style: GoogleFonts.cairo(
                fontSize: ResponsiveHelper.fontSize(context, 16),
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFD700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return Container(
      height: ResponsiveHelper.height(context, 0.12),
      margin: ResponsiveHelper.padding(context, horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 30,
        itemBuilder: (context, index) {
          final day = index + 1;
          return GestureDetector(
            onTap: () => _game.checkAnswer(day),
            child: Container(
              width: ResponsiveHelper.size(context, 60),
              margin: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.size(context, 4),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.9),
                    Colors.white.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(context, 16),
                ),
                border: Border.all(
                  color: const Color(0xFF6B4CE6).withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: FittedBox(
                  child: Text(
                    '$day',
                    style: GoogleFonts.cairo(
                      fontSize: ResponsiveHelper.fontSize(context, 20),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6B4CE6),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeedback() {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        onEnd: () {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) setState(() => _lastAnswerCorrect = null);
          });
        },
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              padding: ResponsiveHelper.padding(context, all: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:
                      _lastAnswerCorrect!
                          ? [const Color(0xFF4CAF50), const Color(0xFF66BB6A)]
                          : [const Color(0xFFE53935), const Color(0xFFEF5350)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (_lastAnswerCorrect!
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFE53935))
                        .withValues(alpha: 0.5),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                _lastAnswerCorrect! ? Icons.check : Icons.close,
                color: Colors.white,
                size: ResponsiveHelper.iconSize(context, 60),
              ),
            ),
          );
        },
      ),
    );
  }
}
