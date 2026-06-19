import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wanisi_app/colors.dart';
import 'package:wanisi_app/cubit_of_child/child_cubit.dart';
import 'package:wanisi_app/cubit_of_child/child_state.dart';
import 'package:wanisi_app/screens/settings_screen.dart';
import 'package:wanisi_app/screens/stories/stories_list_screen.dart';
import 'package:wanisi_app/widgets/back_ground_widget.dart';

class StoriesCategoryScreen extends StatelessWidget {
  const StoriesCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const BackGroundWidget(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),
                Text(
                  'قصص ونيسي',
                  style: GoogleFonts.cairo(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    children: [
                      _CategoryCard(
                        title: 'قصص تربوية',
                        image: 'assets/images/first_bunny.png',
                        color: AppColors.purple,
                        onTap: () => _onCategoryTap(context, 'قصص تربوية'),
                      ),
                      const SizedBox(height: 30),
                      _CategoryCard(
                        title: 'قصص دينية',
                        image:
                            'assets/images/secound_bunny.png', // noted spelling
                        color: AppColors.blue,
                        onTap: () => _onCategoryTap(context, 'قصص دينية'),
                      ),
                      const SizedBox(height: 30),
                      _CategoryCard(
                        title: 'قصص تعليمية',
                        image: 'assets/images/third_bunny.png',
                        color: AppColors.green,
                        onTap: () => _onCategoryTap(context, 'قصص تعليمية'),
                      ),
                      const SizedBox(height: 20), // Standard bottom padding
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          const SizedBox(width: 8),
          // Dynamic Avatar — navigates to Settings on tap
          BlocBuilder<ChildCubit, ChildState>(
            builder: (context, state) {
              final String? url = state is ChildSelectedSuccess
                  ? state.data.avatarUrl
                  : null;
              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                ),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.pink2, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.pink2.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: url != null
                        ? Image.network(
                            url,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              'assets/images/image_profile.png',
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            'assets/images/image_profile.png',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  void _onCategoryTap(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoriesListScreen(category: category),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String image;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.image,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Image.asset(image),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    title,
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
