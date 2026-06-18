import 'package:flutter/material.dart';
import 'package:wanisi_app/colors.dart';

/// Full-screen loading overlay while the AI is generating the avatar.
class AiAvatarLoadingView extends StatelessWidget {
  const AiAvatarLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        CircularProgressIndicator(
          color: AppColors.pink2,
          strokeWidth: 4,
        ),
        const SizedBox(height: 32),
        Text(
          'الذكاء الاصطناعي بيحوّل صورتك...',
          style: AppTextStyles.linkText.copyWith(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'ممكن يأخد من 30 ثانية لدقيقتين',
          style: AppTextStyles.snackbarText.copyWith(
            color: AppColors.gray,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
