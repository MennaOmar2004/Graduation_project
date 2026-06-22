import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/tajweed/tajweed_cubit.dart';
import 'package:wanisi_app/screens/qalqlah_screen/qalqlah_screen.dart';
import 'package:wanisi_app/screens/settings_screen.dart';
import 'package:wanisi_app/screens/widgets/score_indicator.dart';
import 'package:wanisi_app/screens/tajweed_analyzer_screen.dart';

import '../colors.dart';
import '../widgets/avatar_circle.dart';

class ElQuranScreen extends StatelessWidget {
  const ElQuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: CustomScrollView(
        slivers: [
          // ── Hero Header SliverAppBar ────────────────────────────
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: const Color(0xFF5479FC),
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: _QuranHeroHeader(
                onAvatarTap:
                    () => Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => SettingsScreen())),
              ),
            ),
          ),

          // ── Content ─────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Section label
                _SectionLabel(
                  label: 'أدوات الذكاء الاصطناعي',
                  icon: Icons.auto_awesome,
                ),
                const SizedBox(height: 14),

                // ── AI Feature Cards ─────────────────────────────
                _FeatureCard(
                  title: 'مصحف التجويد الذكي',
                  subtitle: 'تحليل تلاوتك بالذكاء الاصطناعي',
                  icon: Icons.menu_book_rounded,
                  gradientColors: const [Color(0xFF5479FC), Color(0xFF7B9BFF)],
                  glowColor: Color(0x445479FC),
                  onTap:
                      () => Navigator.push(
                        context,
                        _fadeRoute(
                          BlocProvider(
                            create: (_) => TajweedCubit(),
                            child: const TajweedAnalyzerScreen(),
                          ),
                        ),
                      ),
                ),
                const SizedBox(height: 14),

                _FeatureCard(
                  title: 'كاشف القلقلة الذكي',
                  subtitle: 'سجّل تلاوتك وافحص أحرف القلقلة',
                  icon: Icons.graphic_eq_rounded,
                  gradientColors: const [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                  glowColor: Color(0x444CAF50),
                  onTap:
                      () => Navigator.push(
                        context,
                        _fadeRoute(const QalqlahScreen()),
                      ),
                ),
                const SizedBox(height: 30),

                // Section label – lessons
              ]),
            ),
          ),
        ],
      ),
    );
  }

  PageRouteBuilder _fadeRoute(Widget page) => PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder:
        (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
    transitionDuration: const Duration(milliseconds: 300),
  );
}

// ─── Hero Header ─────────────────────────────────────────────────────────────

class _QuranHeroHeader extends StatelessWidget {
  final VoidCallback onAvatarTap;
  const _QuranHeroHeader({required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3D5AFE), Color(0xFF7C4DFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  AvatarCircle(onTap: onAvatarTap),
                  const Spacer(),
                  // Score pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const ScoreIndicator(),
                        const SizedBox(width: 6),
                        Text(
                          'نقاطك',
                          style: AppTextStyles.snackbarText.copyWith(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'ركن القرآن الكريم',
                        style: AppTextStyles.buttonText.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'تعلّم أحكام التجويد بالذكاء الاصطناعي',
                        style: AppTextStyles.snackbarText.copyWith(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text('📖', style: TextStyle(fontSize: 28)),
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

// ─── Section Label ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SectionLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          label,
          style: AppTextStyles.linkText.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2D2D5E),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.blue_, size: 18),
        ),
      ],
    );
  }
}

// ─── Feature Card ────────────────────────────────────────────────────────────

class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final Color glowColor;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.glowColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: glowColor,
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Decorative circle
              Positioned(
                left: -20,
                top: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                left: 30,
                bottom: -30,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Arrow
                    Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 16,
                    ),
                    const Spacer(),
                    // Text block
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.buttonText.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: AppTextStyles.snackbarText.copyWith(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    // Icon circle
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Lesson Card ─────────────────────────────────────────────────────────────

class _LessonCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final Color color;

  const _LessonCard({
    required this.imagePath,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title strip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.linkText.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D2D5E),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.bookmark_rounded,
                    color: Color(0xFF5479FC),
                    size: 18,
                  ),
                ],
              ),
            ),
            // Image
            Image.asset(
              imagePath,
              height: 150,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}

// Keep old LessonCard for backward compat if referenced elsewhere
class LessonCard extends StatelessWidget {
  final String imagePath;
  const LessonCard({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) => Image.asset(
    imagePath,
    height: 160,
    width: double.infinity,
    fit: BoxFit.fill,
  );
}
