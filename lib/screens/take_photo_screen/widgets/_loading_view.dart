import 'package:flutter/material.dart';
import 'package:wanisi_app/colors.dart';

/// Full-screen styled loading overlay while the AI is generating or uploading the avatar.
class AiAvatarLoadingView extends StatelessWidget {
  const AiAvatarLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.pink2.withValues(alpha: 0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.pink.withValues(alpha: 0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            // Custom Loading Indicator
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    color: AppColors.pink2,
                    backgroundColor: AppColors.pink.withValues(alpha: 0.2),
                    strokeWidth: 6,
                  ),
                ),
                const Icon(
                  Icons.auto_awesome_rounded,
                  size: 32,
                  color: AppColors.pink2,
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Primary Loading Text
            Text(
              'الذكاء الاصطناعي بيحوّل صورتك...',
              style: AppTextStyles.linkText.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.blue_,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Subtitle / helper note
            Text(
              'ممكن يأخذ من 30 ثانية لدقيقتين، انتظري قليلاً من فضلك',
              style: AppTextStyles.snackbarText.copyWith(
                color: Colors.grey[600],
                fontSize: 13,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
