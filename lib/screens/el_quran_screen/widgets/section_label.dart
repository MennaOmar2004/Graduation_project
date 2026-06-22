import 'package:flutter/material.dart';
import 'package:wanisi_app/configs/app_colors.dart';
import 'package:wanisi_app/configs/app_spacing.dart';
import 'package:wanisi_app/configs/app_text_styles.dart';

class SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  const SectionLabel({
    super.key,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          label,
          style: AppTextStyles.linkText.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.sectionLabelText,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.xs + 2), // 6.0
          decoration: BoxDecoration(
            color: AppColors.sectionLabelBg,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: AppColors.blue_,
            size: 18,
          ),
        ),
      ],
    );
  }
}
