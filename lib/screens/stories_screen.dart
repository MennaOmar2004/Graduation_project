import 'package:flutter/material.dart';
import '../colors.dart';
import 'widgets/story_card.dart';

/// Stories screen with three bunny character cards and custom bottom navigation
class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Column(
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
                      // Coins/points indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.stars,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '70',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Story cards
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
                        const SizedBox(height: 120), // Space for bottom nav
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Custom bottom navigation
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Bottom background image
                  Image.asset(
                    'assets/images/bottom.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  // Navigation icons positioned on the background
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Home icon
                        GestureDetector(
                          onTap: () {},
                          child: Image.asset(
                            'assets/images/Home.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        // Messaging icon
                        GestureDetector(
                          onTap: () {},
                          child: Image.asset(
                            'assets/images/Messaging.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        // Trophy icon
                        GestureDetector(
                          onTap: () {},
                          child: Image.asset(
                            'assets/images/Trophy.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
