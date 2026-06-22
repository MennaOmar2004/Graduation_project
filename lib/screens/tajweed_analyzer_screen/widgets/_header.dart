import 'package:flutter/material.dart';
import 'package:wanisi_app/configs/app_colors.dart';
import 'package:wanisi_app/configs/app_text_styles.dart';
import 'package:wanisi_app/configs/app_spacing.dart';
import 'package:wanisi_app/widgets/avatar_circle.dart';

/// Premium header widget for the Tajweed Analyzer Screen.
class TajweedHeader extends StatelessWidget {
  final VoidCallback onAvatar;

  const TajweedHeader({
    super.key,
    required this.onAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSpacing.radiusXxl),
          bottomRight: Radius.circular(AppSpacing.radiusXxl),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x335479FC),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: AppSpacing.headerPadding,
          child: Row(
            children: [
              AvatarCircle(onTap: onAvatar),
              const Spacer(),
              // Title with icon
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'مصحف التجويد الذكي',
                    style: AppTextStyles.buttonText.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'حلل تلاوتك بالذكاء الاصطناعي',
                    style: AppTextStyles.snackbarText.copyWith(
                      fontSize: 12,
                      color: AppColors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: const Text('📖', style: TextStyle(fontSize: 22)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
