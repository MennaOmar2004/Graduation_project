import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/ai_avatar/ai_avatar_cubit.dart';
import 'package:wanisi_app/colors.dart';

/// Displays the generated anime image and confirm/retry buttons.
class AiAvatarResultView extends StatelessWidget {
  final Uint8List animeImageBytes;
  const AiAvatarResultView({super.key, required this.animeImageBytes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.memory(
              animeImageBytes,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'هل تعجبك صورتك الأنمي؟',
          style: AppTextStyles.linkText.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Retry — go back to initial
            _CircleBtn(
              iconAsset: 'assets/images/Close.png',
              shadowColor: AppColors.red,
              onTap: () => context.read<AiAvatarCubit>().reset(),
            ),
            const SizedBox(width: 40),
            // Confirm — upload to Cloudinary
            _CircleBtn(
              iconAsset: 'assets/images/yes.png',
              shadowColor: AppColors.green,
              onTap: () =>
                  context.read<AiAvatarCubit>().confirmAnimeAvatar(),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final String iconAsset;
  final Color shadowColor;
  final VoidCallback onTap;

  const _CircleBtn({
    required this.iconAsset,
    required this.shadowColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: shadowColor, blurRadius: 8)],
        ),
        child: Image.asset(iconAsset, width: 60, height: 60),
      ),
    );
  }
}
