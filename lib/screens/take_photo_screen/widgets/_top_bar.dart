import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/ai_avatar/ai_avatar_cubit.dart';
import 'package:wanisi_app/blocs/ai_avatar/ai_avatar_state.dart';
import 'package:wanisi_app/colors.dart';
import 'package:wanisi_app/static/app_assets.dart';

/// Top bar with back button, center title, and small brand icon.
class AiAvatarTopBar extends StatelessWidget {
  final AiAvatarState state;
  const AiAvatarTopBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final showBackButton = state is! AiAvatarGenerating;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              onPressed: () {
                if (state is AiAvatarInitial) {
                  Navigator.pop(context);
                } else {
                  context.read<AiAvatarCubit>().reset();
                }
              },
              icon: const Icon(Icons.arrow_back_ios_rounded),
              color: AppColors.blue_,
            )
          else
            const SizedBox(width: 48), // Spacer to match back button size

          const Spacer(),
          // Center screen title matching page styling
          Text(
            'انشئ صورتك بالذكاء الاصطناعي 🪄',
            style: AppTextStyles.linkText.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.blue_,
            ),
          ),
          const Spacer(),

          // Brand Logo
          Image.asset(
            AppAssets.smallIcon,
            height: 48,
            errorBuilder: (context, error, stackTrace) => const SizedBox(width: 48),
          ),
        ],
      ),
    );
  }
}
