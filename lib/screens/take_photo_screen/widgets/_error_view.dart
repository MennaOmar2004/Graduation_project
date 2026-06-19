import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/ai_avatar/ai_avatar_cubit.dart';
import 'package:wanisi_app/colors.dart';
import 'package:wanisi_app/screens/avatar_selection_screen/widgets/layered_button.dart';

/// Renders a premium error state with description and retry button.
class AiAvatarErrorView extends StatelessWidget {
  final String message;
  const AiAvatarErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.red.withValues(alpha: 0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.red.withValues(alpha: 0.1),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error illustration / icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: AppColors.red,
              ),
            ),
            const SizedBox(height: 24),
            // Error message header
            Text(
              'أوبس! حصلت مشكلة 😢',
              style: AppTextStyles.linkText.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Detailed message
            Text(
              message,
              style: AppTextStyles.linkText.copyWith(
                fontSize: 15,
                color: Colors.grey[700],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Retry button
            LayeredButton(
              text: 'حاولي مرة تانية',
              backgroundColor: AppColors.red,
              shadowColor: AppColors.red.withValues(alpha: 0.4),
              onPressed: () => context.read<AiAvatarCubit>().reset(),
            ),
          ],
        ),
      ),
    );
  }
}
