import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/ai_avatar/ai_avatar_cubit.dart';
import 'package:wanisi_app/colors.dart';

/// Bottom bar showing the two source selection buttons (Camera / Gallery).
class AiAvatarSourceBar extends StatelessWidget {
  const AiAvatarSourceBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _SourceButton(
            iconAsset: 'assets/images/Camera.png',
            label: 'كاميرا',
            shadowColor: AppColors.purple,
            onTap: () => context.read<AiAvatarCubit>().pickImageFromCamera(),
          ),
          const SizedBox(width: 50),
          _SourceButton(
            iconAsset: 'assets/images/Camera.png',
            label: 'معرض',
            shadowColor: AppColors.blue_,
            onTap: () => context.read<AiAvatarCubit>().pickImageFromGallery(),
          ),
        ],
      ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  final String iconAsset;
  final String label;
  final Color shadowColor;
  final VoidCallback onTap;

  const _SourceButton({
    required this.iconAsset,
    required this.label,
    required this.shadowColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: shadowColor, blurRadius: 8, spreadRadius: 1),
              ],
            ),
            child: Image.asset(iconAsset, width: 55, height: 55),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.linkText.copyWith(
              fontSize: 14,
              color: AppColors.blue_,
            ),
          ),
        ],
      ),
    );
  }
}
