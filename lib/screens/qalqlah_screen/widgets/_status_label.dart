import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/qalqlah/qalqlah_cubit.dart';
import 'package:wanisi_app/blocs/qalqlah/qalqlah_state.dart';
import 'package:wanisi_app/colors.dart';

/// Instructional status label with animated color changes.
class QalqlahStatusLabel extends StatelessWidget {
  const QalqlahStatusLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QalqlahCubit, QalqlahState>(
      builder: (context, state) {
        final (text, color, bgColor) = switch (state) {
          QalqlahInitial() => (
              'أنت بطل! اضغط المايك وابدأ تلاوتك 🌟',
              const Color(0xFF2E7D32),
              const Color(0xFFE8F5E9),
            ),
          QalqlahRecording() => (
              '🔴  صوتك رائع! استمر في التلاوة...',
              Colors.redAccent,
              Colors.red.shade50,
            ),
          QalqlahRecorded() => (
              '✅  تلاوة ممتازة! اضغط «تحليل» لترى النتيجة',
              const Color(0xFF2E7D32),
              const Color(0xFFE8F5E9),
            ),
          QalqlahLoading() => (
              '⏳  نستمع لتلاوتك الجميلة...',
              AppColors.blue_,
              const Color(0xFFEEF2FF),
            ),
          QalqlahSuccess() => (
              '✨  رائع جداً! تم تحليل تلاوتك بنجاح',
              const Color(0xFF2E7D32),
              const Color(0xFFE8F5E9),
            ),
          QalqlahFailure() => (
              '❌  لا تيأس، حاول مرة أخرى يا بطل!',
              AppColors.red,
              const Color(0xFFFFF0F3),
            ),
        };

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: Container(
            key: ValueKey(text),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.snackbarText.copyWith(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      },
    );
  }
}
