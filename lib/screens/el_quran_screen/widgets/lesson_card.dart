import 'package:flutter/material.dart';
import 'package:wanisi_app/configs/app_text_styles.dart';

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

class QuranLessonCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final Color color;

  const QuranLessonCard({
    super.key,
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
