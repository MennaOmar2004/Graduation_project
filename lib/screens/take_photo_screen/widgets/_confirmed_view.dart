import 'package:flutter/material.dart';
import 'package:wanisi_app/colors.dart';

/// Renders a premium celebration state for successfully confirmed and saved avatar.
class AiAvatarConfirmedView extends StatelessWidget {
  const AiAvatarConfirmedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.green.withValues(alpha: 0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.green.withValues(alpha: 0.1),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success icon with custom glow
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/yes.png',
                width: 72,
                height: 72,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.check_circle_rounded,
                  size: 72,
                  color: AppColors.green,
                ),
              ),
            ),
            const SizedBox(height: 28),
            // Confirmation text header
            Text(
              'رائع جداً! 🎉',
              style: AppTextStyles.linkText.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Description text
            Text(
              'تم حفظ صورتك السحرية كافتار بنجاح!',
              style: AppTextStyles.linkText.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
