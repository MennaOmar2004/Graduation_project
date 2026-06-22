import 'package:flutter/material.dart';
import 'package:wanisi_app/configs/app_colors.dart';
import 'package:wanisi_app/configs/app_text_styles.dart';
import 'package:wanisi_app/configs/app_spacing.dart';

/// Row of action buttons (Listen to Sheikh / Analyze Tajweed)
class TajweedActionBar extends StatelessWidget {
  final bool isLoadingAudio;
  final bool isPlayingAudio;
  final VoidCallback onAnalyze;
  final VoidCallback onListen;

  const TajweedActionBar({
    super.key,
    required this.isLoadingAudio,
    required this.isPlayingAudio,
    required this.onAnalyze,
    required this.onListen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Listen Button
        Expanded(
          child: _PremiumButton(
            label: isLoadingAudio
                ? 'جاري التحميل...'
                : (isPlayingAudio ? 'إيقاف الاستماع' : 'استماع للشيخ'),
            icon: isLoadingAudio
                ? Icons.hourglass_top_rounded
                : (isPlayingAudio
                    ? Icons.stop_rounded
                    : Icons.volume_up_rounded),
            gradient: const LinearGradient(
              colors: AppColors.secondaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shadowColor: const Color(0x553DB88B),
            onTap: onListen,
          ),
        ),
        const SizedBox(width: 12),
        // Analyze Button
        Expanded(
          child: _PremiumButton(
            label: 'تحليل التجويد',
            icon: Icons.auto_fix_high_rounded,
            gradient: const LinearGradient(
              colors: AppColors.accentGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shadowColor: const Color(0x55D9527A),
            onTap: onAnalyze,
          ),
        ),
      ],
    );
  }
}

class _PremiumButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final LinearGradient gradient;
  final Color shadowColor;
  final VoidCallback onTap;

  const _PremiumButton({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.shadowColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.buttonText.copyWith(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
