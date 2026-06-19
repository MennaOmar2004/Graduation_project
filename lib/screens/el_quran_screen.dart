import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/tajweed/tajweed_cubit.dart';
import 'package:wanisi_app/screens/settings_screen.dart';
import 'package:wanisi_app/screens/widgets/score_indicator.dart';
import 'package:wanisi_app/screens/tajweed_analyzer_screen.dart';

import '../colors.dart';
import '../widgets/avatar_circle.dart';
import '../widgets/back_ground_widget.dart';

class ElQuranScreen extends StatefulWidget {
  const ElQuranScreen({super.key});

  @override
  State<ElQuranScreen> createState() => _ElQuranScreenState();
}

class _ElQuranScreenState extends State<ElQuranScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
          child: Stack(
            children: [
              BackGroundWidget(),
              Column(
                children: [
                  const SizedBox(height: 16),
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        AvatarCircle(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SettingsScreen(),
                              ),
                            );
                          },
                        ),
                        const Spacer(),
                        // Title
                        Text(
                          'التجويد',
                          style: AppTextStyles.linkText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        // Score section with label
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'نقاطك',
                              style: AppTextStyles.linkText.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const ScoreIndicator(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(45, 16, 45, 100), // مساحة أسفل القائمة
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => TajweedCubit(),
                                  child: const TajweedAnalyzerScreen(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppColors.lightGreen,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.menu_book, size: 50, color: AppColors.blue),
                                const SizedBox(width: 15),
                                Text(
                                  'مصحف التجويد الذكي',
                                  style: AppTextStyles.numberText.copyWith(fontSize: 22),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const LessonCard(
                          imagePath: 'assets/images/qalqalah.png',
                        ),
                        SizedBox(height: 16),
                        LessonCard(
                          imagePath: 'assets/images/mudood.png',
                        ),
                        SizedBox(height: 16),
                        LessonCard(
                          imagePath: 'assets/images/idghaam.png',
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          )
      ),
    );
  }
}
class LessonCard extends StatelessWidget {
  final String imagePath;

  const LessonCard({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      height: 160,
      width: double.infinity,
      fit: BoxFit.fill
    );
  }
}