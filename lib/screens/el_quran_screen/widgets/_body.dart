import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/tajweed/tajweed_cubit.dart';
import 'package:wanisi_app/configs/app_colors.dart';
import 'package:wanisi_app/screens/qalqlah_screen/qalqlah_screen.dart';
import 'package:wanisi_app/screens/tajweed_analyzer_screen.dart';
import 'package:wanisi_app/screens/settings_screen.dart';
import 'quran_hero_header.dart';
import 'quran_grid_card.dart';

class QuranBody extends StatelessWidget {
  const QuranBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hero Header (Top Section)
        QuranHeroHeader(
          onAvatarTap:
              () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
        ),

        // Centered Content Area
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Vertically stacked Quran tools cards taking full width
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: QuranGridCard(
                      title: 'مصحف التجويد الذكي',
                      imagePath: 'assets/images/quran.png',
                      themeColor: AppColors.blue, // #3396FF
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
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: QuranGridCard(
                      title: 'كاشف القلقلة الذكي',
                      imagePath: 'assets/images/qalqalah.png',
                      themeColor: Color.fromARGB(255, 202, 100, 134), // #72C076
                      onTap:
                          () => Navigator.push(
                            context,
                            _fadeRoute(const QalqlahScreen()),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  PageRouteBuilder _fadeRoute(Widget page) => PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder:
        (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
    transitionDuration: const Duration(milliseconds: 300),
  );
}
