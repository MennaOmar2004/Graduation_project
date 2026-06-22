import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/qalqlah/qalqlah_cubit.dart';
import 'package:wanisi_app/blocs/qalqlah/qalqlah_state.dart';
import 'package:wanisi_app/colors.dart';

/// Shows the analysis result: loading spinner, error, success card, or empty.
class QalqlahResultCard extends StatelessWidget {
  const QalqlahResultCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QalqlahCubit, QalqlahState>(
      builder: (context, state) {
        return switch (state) {
          QalqlahLoading() => _LoadingCard(),
          QalqlahFailure(:final message) => _ErrorCard(message: message),
          QalqlahSuccess(:final resultText) => _SuccessCard(
            resultText: resultText,
          ),
          _ => _EmptyCard(),
        };
      },
    );
  }
}

// ─── Loading ────────────────────────────────────────────────────────────────

class _LoadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              color: Color(0xFFCA6486),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'جارٍ تحليل التسجيل...',
            style: AppTextStyles.linkText.copyWith(
              fontSize: 15,
              color: const Color(0xFFCA6486),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'قد يستغرق بضع ثوان',
            style: AppTextStyles.snackbarText.copyWith(
              fontSize: 12,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Error ──────────────────────────────────────────────────────────────────

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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

// ─── Success ────────────────────────────────────────────────────────────────

class _SuccessCard extends StatelessWidget {
  final String resultText;
  const _SuccessCard({required this.resultText});

  @override
  Widget build(BuildContext context) {
    // Split the raw text into lines and filter blanks
    final lines =
        resultText
            .split('\n')
            .map((l) => l.trim())
            .where((l) => l.isNotEmpty)
            .toList();

    // First line is the summary/header; the rest are bullet items
    final header = lines.isNotEmpty ? lines.first : resultText;
    final bullets = lines.length > 1 ? lines.sublist(1) : <String>[];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCA6486).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Gradient header bar ─────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.redAccent, Color.fromARGB(255, 161, 67, 81)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'نتيجة كشف القلقلة',
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
          // ── Result body ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Header/summary line
                Text(
                  header,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.linkText.copyWith(
                    fontSize: 16,
                    color: const Color(0xFF2D2D5E),
                    fontWeight: FontWeight.bold,
                    height: 1.6,
                  ),
                ),
                if (bullets.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 14),
                  // Word + confidence bullet list
                  ...bullets.map(
                    (line) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsetsDirectional.only(end: 10),
                            decoration: const BoxDecoration(
                              color: Color(0xFFCA6486),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              line.replaceAll(RegExp(r'^[-\s]+'), ''),
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              style: AppTextStyles.snackbarText.copyWith(
                                fontSize: 15,
                                color: const Color(0xFF3D3D6E),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty ──────────────────────────────────────────────────────────────────

class _EmptyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: const Text('🔊', style: TextStyle(fontSize: 36)),
          ),
          const SizedBox(height: 14),
          Text(
            'نتيجة القلقلة ستظهر هنا',
            style: AppTextStyles.linkText.copyWith(
              fontSize: 15,
              color: Colors.red.shade50,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'سجّل تلاوتك واضغط «تحليل»',
            style: AppTextStyles.snackbarText.copyWith(
              color: Colors.red.shade400,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared shell ────────────────────────────────────────────────────────────

class _CardShell extends StatelessWidget {
  final Widget child;
  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCA6486).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
