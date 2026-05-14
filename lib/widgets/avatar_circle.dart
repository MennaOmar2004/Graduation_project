import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/avatar_selection/avatar_selection_cubit.dart';
import '../blocs/avatar_selection/avatar_selection_state.dart';
import '../colors.dart';
import '../cubit_of_child/child_cubit.dart';
import '../cubit_of_child/child_state.dart';

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
        child: BlocBuilder<ChildCubit, ChildState>(
          builder: (context, state) {
            print("OPTIONS STATE = $state");
            if (state is ChildSelectedSuccess) {
              return Image.network(
                state.data.avatarUrl,
                height: 100,
                width: 100,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/images/image_profile.png",
                    height: 100,
                    width: 100,
                  );
                },
              );
            }
            return Image.asset(
              "assets/images/image_profile.png",
              height: 100,
              width: 100,
            );
          },
        ),
      ),
    );
  }
}
