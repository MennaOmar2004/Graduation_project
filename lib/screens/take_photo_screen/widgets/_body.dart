import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/ai_avatar/ai_avatar_cubit.dart';
import 'package:wanisi_app/blocs/ai_avatar/ai_avatar_state.dart';
import 'package:wanisi_app/colors.dart';
import 'package:wanisi_app/static/app_assets.dart';

import '_loading_view.dart';
import '_picked_view.dart';
import '_result_view.dart';
import '_source_bar.dart';

/// Main body widget for the AI Avatar (Take Photo) screen.
/// Switches between substates via BlocBuilder.
class AiAvatarBody extends StatelessWidget {
  const AiAvatarBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiAvatarCubit, AiAvatarState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _TopBar(state: state),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildContent(context, state),
                  ),
                ),
                // Show source selection only when idle
                if (state is AiAvatarInitial) const AiAvatarSourceBar(),
                if (state is! AiAvatarInitial) const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, AiAvatarState state) {
    return switch (state) {
      AiAvatarInitial() => const _PlaceholderHint(),
      AiAvatarPhotoPicked(:final pickedFile) => AiAvatarPickedView(
        pickedFile: pickedFile,
      ),
      AiAvatarGenerating() => const AiAvatarLoadingView(),
      AiAvatarSuccess(:final animeImageBytes) => AiAvatarResultView(
        animeImageBytes: animeImageBytes,
      ),
      AiAvatarFailure(:final message) => _ErrorView(message: message),
      AiAvatarConfirmed() => const _ConfirmedView(),
    };
  }
}

// ─── Sub-widgets ────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final AiAvatarState state;
  const _TopBar({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (state is! AiAvatarInitial && state is! AiAvatarGenerating)
            IconButton(
              onPressed: () => context.read<AiAvatarCubit>().reset(),
              icon: const Icon(Icons.arrow_back_ios_rounded),
              color: AppColors.blue,
            ),
          const Spacer(),
          Image.asset(AppAssets.smallIcon, height: 60),
          const Spacer(),
          // placeholder to balance back button width
          if (state is! AiAvatarInitial && state is! AiAvatarGenerating)
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _PlaceholderHint extends StatelessWidget {
  const _PlaceholderHint();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.camera_alt_outlined, size: 80, color: AppColors.pink2),
        const SizedBox(height: 24),
        Text(
          'اختاري صورتك من الكاميرا أو المعرض\nوالـ AI هيحوّلها لصورة أنمي!',
          style: AppTextStyles.linkText.copyWith(fontSize: 15),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: 70, color: AppColors.red),
        const SizedBox(height: 20),
        Text(
          message,
          style: AppTextStyles.linkText.copyWith(
            color: AppColors.red,
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: () => context.read<AiAvatarCubit>().reset(),
          icon: const Icon(Icons.refresh),
          label: const Text('حاولي مرة تانية'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonPrimary,
          ),
        ),
      ],
    );
  }
}

class _ConfirmedView extends StatelessWidget {
  const _ConfirmedView();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, size: 80, color: AppColors.green),
        const SizedBox(height: 20),
        Text(
          'تم حفظ صورتك بنجاح! 🎉',
          style: AppTextStyles.linkText.copyWith(
            fontSize: 18,
            color: AppColors.green,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
