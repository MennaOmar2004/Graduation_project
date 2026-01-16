import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/avatar_selection/avatar_selection_cubit.dart';
import '../blocs/avatar_selection/avatar_selection_state.dart';
import '../colors.dart';

class AvatarCircle extends StatelessWidget {
  final VoidCallback onTap;
  final double size;

  const AvatarCircle({
    super.key,
    required this.onTap,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.purple, width: 3),
        ),
        child: BlocBuilder<AvatarSelectionCubit, AvatarSelectionState>(
          builder: (context, state) {
            final avatarPath =
                state.selectedAvatar ?? "assets/images/image_profile.png";
            return ClipOval(
              child: Image.asset(
                avatarPath,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}
