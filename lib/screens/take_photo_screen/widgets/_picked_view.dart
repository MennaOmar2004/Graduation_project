import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/ai_avatar/ai_avatar_cubit.dart';
import 'package:wanisi_app/colors.dart';

/// Shows the picked photo preview in a circular format with border and a "Generate" action button.
class AiAvatarPickedView extends StatelessWidget {
  final File pickedFile;
  const AiAvatarPickedView({super.key, required this.pickedFile});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        // Header Instruction
        Text(
          'صورتك المختارة 📸',
          style: AppTextStyles.linkText.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.blue_,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'اضغطي على علامة الصح للبدء في تحويلها!',
          style: AppTextStyles.linkText.copyWith(
            fontSize: 15,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        
        // Circular Photo Preview with Yellow Halo and Border
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
                child: Image.file(
                  pickedFile,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        
        // Action buttons
        _ActionRow(file: pickedFile),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  final File file;
  const _ActionRow({required this.file});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Retry / pick again (Close button)
        _CircleAction(
          iconAsset: 'assets/images/Close.png',
          shadowColor: AppColors.red,
          onTap: () => context.read<AiAvatarCubit>().reset(),
        ),
        const SizedBox(width: 40),
        // Generate anime (Yes button)
        _CircleAction(
          iconAsset: 'assets/images/yes.png',
          shadowColor: AppColors.green,
          onTap: () => context.read<AiAvatarCubit>().generateAnime(),
        ),
      ],
    );
  }
}

class _CircleAction extends StatelessWidget {
  final String iconAsset;
  final Color shadowColor;
  final VoidCallback onTap;

  const _CircleAction({
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
