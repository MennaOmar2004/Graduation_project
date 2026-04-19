import 'package:flutter/material.dart';
import '../../colors.dart';

/// Reusable story card widget with bunny image and styled button
class StoryCard extends StatelessWidget {
  final String imagePath;
  final String buttonText;
  final Color buttonColor;

  const StoryCard({
    super.key,
    required this.imagePath,
    required this.buttonText,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.buttonShadow, width: 2),
      ),
      child: Column(
        children: [
          // Bunny image
          Image.asset(imagePath, height: 120, fit: BoxFit.contain),
          const SizedBox(height: 16),
          // Use LayeredButton with custom color
          _CustomColorButton(text: buttonText, color: buttonColor),
        ],
      ),
    );
  }
}

/// Custom wrapper to override LayeredButton color
class _CustomColorButton extends StatelessWidget {
  final String text;
  final Color color;

  const _CustomColorButton({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              offset: const Offset(0, 6),
              blurRadius: 0,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: const BorderSide(color: Colors.white, width: 1),
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          child: Text(text, style: AppTextStyles.buttonText),
        ),
      ),
    );
  }
}
