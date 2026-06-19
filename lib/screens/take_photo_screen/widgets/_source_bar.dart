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
      height: 180,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'اختر مصدر الصورة 📥',
            style: AppTextStyles.linkText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.blue_,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SourceButton(
                iconAsset: 'assets/images/Camera.png',
                label: 'كاميرا',
                shadowColor: AppColors.purple,
                onTap: () => context.read<AiAvatarCubit>().pickImageFromCamera(),
              ),
              const SizedBox(width: 60),
              _SourceButton(
                iconAsset: 'assets/images/Camera.png', // Fallback as there is no specific gallery icon
                label: 'معرض الصور',
                shadowColor: AppColors.blue_,
                onTap: () => context.read<AiAvatarCubit>().pickImageFromGallery(),
              ),
            ],
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
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset(
              iconAsset,
              width: 48,
              height: 48,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.image,
                size: 48,
                color: shadowColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: AppTextStyles.linkText.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.blue_,
            ),
          ),
        ],
      ),
    );
  }
}
