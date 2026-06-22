import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wanisi_app/blocs/tajweed/tajweed_cubit.dart';
import 'package:wanisi_app/configs/app_colors.dart';
import 'package:wanisi_app/configs/app_text_styles.dart';
import 'package:wanisi_app/configs/app_spacing.dart';

/// Renders the result of Tajweed analysis based on the current [TajweedState].
class TajweedResultCard extends StatelessWidget {
  const TajweedResultCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TajweedCubit, TajweedState>(
      builder: (context, state) {
        if (state is TajweedLoading) {
          return const _LoadingResult();
        } else if (state is TajweedFailureState) {
          return _ErrorResult(message: state.message);
        } else if (state is TajweedSuccessState) {
          return _SuccessResult(htmlContent: state.htmlContent);
        }
        return const _EmptyResult();
      },
    );
  }
}

class _LoadingResult extends StatelessWidget {
  const _LoadingResult();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue_.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              color: AppColors.blue_,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'جارٍ تحليل الآية...',
            style: AppTextStyles.linkText.copyWith(
              fontSize: 15,
              color: AppColors.blue_,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorResult extends StatelessWidget {
  final String message;
  const _ErrorResult({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.red.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.red.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Text(
              message,
              style: AppTextStyles.snackbarText.copyWith(
                color: AppColors.red,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: AppColors.red,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessResult extends StatelessWidget {
  final String htmlContent;
  const _SuccessResult({required this.htmlContent});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue_.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Result header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.primaryGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusXl),
                topRight: Radius.circular(AppSpacing.radiusXl),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'نتيجة التحليل',
                  style: AppTextStyles.buttonText.copyWith(fontSize: 15),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
          // Result body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Html(
              data: htmlContent,
              style: {
                'body': Style(
                  textAlign: TextAlign.center,
                  fontSize: FontSize(26),
                  fontFamily: 'Amiri',
                  lineHeight: LineHeight(1.8),
                  color: const Color(0xFF2D2D5E),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyResult extends StatelessWidget {
  const _EmptyResult();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue_.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF0F3FF),
              shape: BoxShape.circle,
            ),
            child: const Text('📖', style: TextStyle(fontSize: 36)),
          ),
          const SizedBox(height: 14),
          Text(
            'نتيجة التجويد ستظهر هنا',
            style: AppTextStyles.linkText.copyWith(
              fontSize: 15,
              color: AppColors.blue_.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'اكتب آية واضغط "تحليل التجويد"',
            style: AppTextStyles.snackbarText.copyWith(
              color: Colors.grey.shade400,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
