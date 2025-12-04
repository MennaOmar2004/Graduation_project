import 'package:flutter/material.dart';
import 'package:wanisi_app/colors.dart';

/// Compact pixel-perfect score indicator widget
class ScoreIndicator extends StatelessWidget {
  final String score;

  const ScoreIndicator({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 85,
      height: 30,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x4F9D9D9D), // rgba(157, 157, 157, 0.31)
          border: Border.all(color: const Color(0xFFFCBAD3), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // Glowing star image
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Image.asset(
                'assets/images/Glowing Star.png',
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
            ),

            // Vertical divider
            Container(
              width: 1,
              height: 20,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              color: const Color(0x96333333), // rgba(51, 51, 51, 0.59)
            ),

            // Score number
            Expanded(
              child: Text(
                score,
                textAlign: TextAlign.center,
                style: AppTextStyles.numberText
              ),
            ),
          ],
        ),
      ),
    );
  }
}
