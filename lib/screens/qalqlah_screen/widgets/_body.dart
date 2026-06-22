import 'package:flutter/material.dart';
import 'package:wanisi_app/colors.dart';
import 'package:wanisi_app/screens/settings_screen.dart';

import '_action_bar.dart';
import '_header.dart';
import '_mic_button.dart';
import '_result_card.dart';
import '_status_label.dart';

/// Main body for the Qalqlah Detection screen.
class QalqlahBody extends StatelessWidget {
  const QalqlahBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: Column(
        children: [
          // ── Premium gradient header ──────────────────────────────
          Builder(
            builder:
                (ctx) => QalqlahHeader(
                  onAvatar:
                      () => Navigator.of(ctx).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      ),
                ),
          ),
          // ── Scrollable content ──────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 48),
              child: Column(
                children: [
                  // ── How-it-works card ──────────────────────────
                  const _HowItWorksCard(),
                  const SizedBox(height: 28),

                  // ── Recording panel ────────────────────────────
                  _RecordingPanel(),
                  const SizedBox(height: 20),

                  // ── Status pill ────────────────────────────────
                  const QalqlahStatusLabel(),
                  const SizedBox(height: 20),

                  // ── Analyze / Reset ────────────────────────────
                  const QalqlahActionBar(),
                  const SizedBox(height: 24),

                  // ── Result card ────────────────────────────────
                  const QalqlahResultCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── How-it-works card ───────────────────────────────────────────────────────

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard();

  static const List<_Step> _steps = [
    _Step(
      icon: Icons.mic_rounded,
      text: 'اضغط زر الميكروفون لبدء التسجيل',
      color: Colors.pink,
    ),
    _Step(
      icon: Icons.menu_book_rounded,
      text: 'اقرأ آيات تحتوي على أحرف القلقلة (ق ط ب ج د)',
      color: Color(0xFF5479FC),
    ),
    _Step(
      icon: Icons.stop_circle_rounded,
      text: 'اضغط مجدداً لإيقاف التسجيل',
      color: Color(0xFFE53935),
    ),
    _Step(
      icon: Icons.auto_fix_high_rounded,
      text: 'اضغط «تحليل القلقلة» لإرسال التسجيل',
      color: Colors.pink,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'كيف يعمل كاشف القلقلة؟',
                style: AppTextStyles.linkText.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D2D5E),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.pink, Colors.pinkAccent],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.help_outline_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Step list
          ..._steps.asMap().entries.map(
            (e) => _StepRow(index: e.key + 1, step: e.value),
          ),
        ],
      ),
    );
  }
}

class _Step {
  final IconData icon;
  final String text;
  final Color color;
  const _Step({required this.icon, required this.text, required this.color});
}

class _StepRow extends StatelessWidget {
  final int index;
  final _Step step;
  const _StepRow({required this.index, required this.step});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          // Number badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: step.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(child: Icon(step.icon, color: step.color, size: 16)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              step.text,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.snackbarText.copyWith(
                fontSize: 13,
                color: const Color(0xFF3D3D6E),
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Step number
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: step.color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$index',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Recording Panel ──────────────────────────────────────────────────────────

class _RecordingPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const QalqlahMicButton(),
          const SizedBox(height: 16),
          Text(
            'نحن متحمسون لسماع صوتك!',
            style: AppTextStyles.snackbarText.copyWith(
              color: Color.fromARGB(255, 202, 100, 134).withValues(alpha: 0.8),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'اضغط على المايك لتبدأ',
            style: AppTextStyles.snackbarText.copyWith(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
