import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/ai_avatar/ai_avatar_cubit.dart';
import 'package:wanisi_app/blocs/ai_avatar/ai_avatar_state.dart';
import 'package:wanisi_app/widgets/back_ground_widget.dart';

import '_confirmed_view.dart';
import '_error_view.dart';
import '_initial_view.dart';
import '_loading_view.dart';
import '_picked_view.dart';
import '_result_view.dart';
import '_source_bar.dart';
import '_top_bar.dart';

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
          body: Stack(
            children: [
              // Beautiful illustration background
              const BackGroundWidget(),
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    AiAvatarTopBar(state: state),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildContent(context, state),
                      ),
                    ),
                    // Show source selection only when idle (Initial State)
                    if (state is AiAvatarInitial) const AiAvatarSourceBar(),
                    if (state is! AiAvatarInitial) const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, AiAvatarState state) {
    return switch (state) {
      AiAvatarInitial() => const AiAvatarInitialView(),
      AiAvatarPhotoPicked(:final pickedFile) => AiAvatarPickedView(
        pickedFile: pickedFile,
      ),
      AiAvatarGenerating() => const AiAvatarLoadingView(),
      AiAvatarSuccess(:final animeImageBytes) => AiAvatarResultView(
        animeImageBytes: animeImageBytes,
      ),
      AiAvatarFailure(:final message) => AiAvatarErrorView(message: message),
      AiAvatarConfirmed() => const AiAvatarConfirmedView(),
    };
  }
}
