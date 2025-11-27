import 'package:flutter/material.dart';
import '../colors.dart';
import 'widgets/story_card.dart';
import 'widgets/score_indicator.dart';

/// Stories screen with three bunny character cards and custom bottom navigation
class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Back button with avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.purple, width: 2),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: AppColors.purple,
                    ),
                  ),
                  const Spacer(),
                  // Title
                  Text(
                    'قصص وانيسي',
                    style: AppTextStyles.linkText.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Pixel-perfect score indicator
                  const ScoreIndicator(score: '70'),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Story cards - scrollable area
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    StoryCard(
                      imagePath: 'assets/images/first_bunny.png',
                      buttonText: 'قصص تربوية',
                      buttonColor: AppColors.purple,
                    ),
                    StoryCard(
                      imagePath: 'assets/images/secound_bunny.png',
                      buttonText: 'قصص دينية',
                      buttonColor: AppColors.blue,
                    ),
                    StoryCard(
                      imagePath: 'assets/images/third_bunny.png',
                      buttonText: 'قصص تعليمية',
                      buttonColor: AppColors.green,
                    ),
                    const SizedBox(height: 20), // Bottom padding
                  ],
                ),
              ),
            ),

            // Custom bottom navigation bar (always on top)
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Bottom background image
                Image.asset(
                  'assets/images/bottom.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Navigation icons
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Home icon
                      _NavIcon(
                        imagePath: 'assets/images/Home.png',
                        isSelected: _selectedIndex == 0,
                        onTap: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                      ),
                      // Messaging icon
                      _NavIcon(
                        imagePath: 'assets/images/Messaging.png',
                        isSelected: _selectedIndex == 1,
                        onTap: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                      ),
                      // Trophy icon
                      _NavIcon(
                        imagePath: 'assets/images/Trophy.png',
                        isSelected: _selectedIndex == 2,
                        onTap: () {
                          setState(() {
                            _selectedIndex = 2;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Navigation icon widget with scaling animation
class _NavIcon extends StatelessWidget {
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavIcon({
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.3 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Image.asset(imagePath, width: 70, height: 70),
      ),
    );
  }
}
