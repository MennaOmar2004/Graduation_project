import 'package:flutter/material.dart';
import 'package:wanisi_app/configs/app_text_styles.dart';
import 'package:wanisi_app/screens/widgets/score_indicator.dart';
import 'package:wanisi_app/widgets/avatar_circle.dart';

class QuranHeroHeader extends StatelessWidget {
  final VoidCallback onAvatarTap;

  const QuranHeroHeader({super.key, required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.blue),
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
                  // Score indicator matching the standard screens
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'نقاطك',
                        style: AppTextStyles.linkText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const ScoreIndicator(backgroundColor: Colors.white),
                    ],
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
