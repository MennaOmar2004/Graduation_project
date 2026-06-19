import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanisi_app/blocs/ai_avatar/ai_avatar_cubit.dart';
import 'package:wanisi_app/blocs/ai_avatar/ai_avatar_state.dart';
import 'package:wanisi_app/cubit_of_child/child_cubit.dart';
import 'package:wanisi_app/screens/options_screen.dart';
import 'package:wanisi_app/screens/settings_screen.dart';

import '../../cubit_of_child/child_state.dart';
import '../avatar_selection_screen/avatar_selection_screen.dart';
import 'widgets/_body.dart';

/// Entry screen for AI avatar creation using AnimeGANv2.
/// Provides [AiAvatarCubit] and listens for [AiAvatarConfirmed]
/// to update the child's avatar and navigate away.
class TakePhotoScreen extends StatelessWidget {
  final AvatarMode mode;

  const TakePhotoScreen({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AiAvatarCubit(),
      child: BlocListener<AiAvatarCubit, AiAvatarState>(
        listenWhen: (_, s) => s is AiAvatarConfirmed,
        listener: (context, state) async {
          if (state is! AiAvatarConfirmed) return;
          await _saveAndNavigate(context, state.cloudinaryUrl);
        },
        child: const AiAvatarBody(),
      ),
    );
  }

  /// Reads temp prefs, calls [ChildCubit.updateChild], then navigates.
  Future<void> _saveAndNavigate(BuildContext context,
      String cloudinaryUrl,) async {
    final childCubit = context.read<ChildCubit>();
    final childState = childCubit.state;

    if (mode == AvatarMode.create) {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('temp_child_name') ?? '';
      final age = prefs.getInt('temp_child_age') ?? 0;
      final preferences = prefs.getString('temp_child_prefs') ?? '';
      final childId = prefs.getInt('childId');

      if (childId != null) {
        await childCubit.updateChild(
          childId: childId,
          name: name,
          age: age,
          avatarUrl: cloudinaryUrl,
          preferences: preferences,
        );

        await prefs.remove('temp_child_name');
        await prefs.remove('temp_child_age');

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OptionsScreen(),
            ),
          );
        }
      }
    }

    else if (mode == AvatarMode.edit) {
      if (childState is ChildSelectedSuccess) {
        await childCubit.updateChild(
          childId: childState.data.id,
          avatarUrl: cloudinaryUrl,
        );

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => SettingsScreen(),
            ),
          );
        }
      }
    }
  }
}