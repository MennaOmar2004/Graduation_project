import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/ai_avatar/ai_avatar_cubit.dart';
import 'package:wanisi_app/colors.dart';

/// Shows the picked photo preview and a "Generate" action button.
class AiAvatarPickedView extends StatelessWidget {
  final File pickedFile;
  const AiAvatarPickedView({super.key, required this.pickedFile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.file(
              pickedFile,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 24),
        _ActionRow(file: pickedFile),
        const SizedBox(height: 12),
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
        // Retry / pick again
        _CircleAction(
          iconAsset: 'assets/images/Close.png',
          shadowColor: AppColors.red,
          onTap: () => context.read<AiAvatarCubit>().reset(),
        ),
        const SizedBox(width: 40),
        // Generate anime
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
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: shadowColor, blurRadius: 8),
          ],
        ),
        child: Image.asset(iconAsset, width: 60, height: 60),
      ),
    );
  }
}
