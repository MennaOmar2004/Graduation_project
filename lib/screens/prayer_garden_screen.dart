import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';
import '../game/prayer_garden/prayer_garden_game.dart';
import '../game/prayer_garden/data/prayer_times_data.dart';
import '../utils/responsive_helper.dart';

class PrayerGardenScreen extends StatefulWidget {
  const PrayerGardenScreen({super.key});

  @override
  State<PrayerGardenScreen> createState() => _PrayerGardenScreenState();
}

class _PrayerGardenScreenState extends State<PrayerGardenScreen> {
  late PrayerGardenGame _game;
  int _score = 0;
  PrayerTime? _currentPrayer;
  bool? _lastAnswerCorrect;

  @override
  void initState() {
    super.initState();
    _game =
        PrayerGardenGame()
          ..onScoreChanged = (score) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _score = score);
            });
          }
          ..onPrayerChanged = (prayer) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _currentPrayer = prayer;
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
                if (_currentPrayer != null) _buildPrayerInfo(),
                SizedBox(height: ResponsiveHelper.height(context, 0.02)),
                _buildTimeSelector(),
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
            Colors.white.withValues(alpha: 0.3),
            Colors.white.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(context, 20),
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
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
                color: const Color(0xFF4CAF50),
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
                    '🌸 حديقة الصلاة',
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
                    'تعلم أوقات الصلاة',
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
                colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
              ),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(context, 16),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.5),
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

  Widget _buildPrayerInfo() {
    if (_currentPrayer == null) return const SizedBox();
    return Container(
      margin: ResponsiveHelper.padding(context, horizontal: 16),
      padding: ResponsiveHelper.padding(context, all: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _currentPrayer!.color.withValues(alpha: 0.9),
            _currentPrayer!.color.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(context, 20),
        ),
        boxShadow: [
          BoxShadow(
            color: _currentPrayer!.color.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _currentPrayer!.emoji,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(context, 32),
                ),
              ),
              SizedBox(width: ResponsiveHelper.size(context, 8)),
              FittedBox(
                child: Text(
                  _currentPrayer!.nameArabic,
                  style: GoogleFonts.cairo(
                    fontSize: ResponsiveHelper.fontSize(context, 26),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.size(context, 8)),
          FittedBox(
            child: Text(
              _currentPrayer!.description,
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
              'في أي ساعة من اليوم؟',
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

  Widget _buildTimeSelector() {
    return Container(
      height: ResponsiveHelper.height(context, 0.12),
      margin: ResponsiveHelper.padding(context, horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 24,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _game.checkAnswer(index),
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
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
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
                    '$index:00',
                    style: GoogleFonts.cairo(
                      fontSize: ResponsiveHelper.fontSize(context, 18),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4CAF50),
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
