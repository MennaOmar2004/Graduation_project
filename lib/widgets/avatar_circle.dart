import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            if (state is ChildSelectedSuccess) {
              return ClipOval(
                child: Image.network(
                  state.data.avatarUrl,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => ClipOval(
                    child: Image.asset(
                      'assets/images/image_profile.png',
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }
            return ClipOval(
              child: Image.asset(
                'assets/images/image_profile.png',
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}
