import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/ai_avatar/ai_avatar_cubit.dart';
import 'package:wanisi_app/colors.dart';

/// Displays the generated anime image in a circular layout and confirm/retry buttons.
class AiAvatarResultView extends StatelessWidget {
  final Uint8List animeImageBytes;
  const AiAvatarResultView({super.key, required this.animeImageBytes});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        // Header Text
        Text(
          'صورتك الأنمي الجديدة! 😍',
          style: AppTextStyles.linkText.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.blue_,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'هل تعجبك صورتك الأنمي؟ اضغطي صح لحفظها!',
          style: AppTextStyles.linkText.copyWith(
            fontSize: 15,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 30),
        
        // Circular Anime Image Preview with Yellow Halo and Border
        Center(
          child: Container(
            width: 230,
            height: 230,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFEDE2D), // Yellow aura / border shadow
                  blurRadius: 18,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFEDE2D),
                  width: 5,
                ),
              ),
              child: ClipOval(
                child: Image.memory(
                  animeImageBytes,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        
        // Retry / Confirm actions
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
            // Confirm — upload to Cloudinary and save
            _CircleBtn(
              iconAsset: 'assets/images/yes.png',
              shadowColor: AppColors.green,
              onTap: () => context.read<AiAvatarCubit>().confirmAnimeAvatar(),
            ),
          ],
        ),
        const SizedBox(height: 24),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: shadowColor.withValues(alpha: 0.4),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Image.asset(
          iconAsset,
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) => Icon(
            iconAsset.contains('Close') ? Icons.close : Icons.check,
            size: 50,
            color: shadowColor,
          ),
        ),
      ),
    );
  }
}
