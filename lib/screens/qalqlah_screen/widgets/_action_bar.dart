import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/qalqlah/qalqlah_cubit.dart';
import 'package:wanisi_app/blocs/qalqlah/qalqlah_state.dart';
import 'package:wanisi_app/colors.dart';

/// Context-aware action bar: Analyze when recorded, Reset after result.
class QalqlahActionBar extends StatelessWidget {
  const QalqlahActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QalqlahCubit, QalqlahState>(
      builder: (context, state) {
        if (state is QalqlahRecorded) {
          return _PremiumButton(
            label: 'تحليل القلقلة',
            icon: Icons.auto_fix_high_rounded,
            gradientColors: const [Color(0xFF2E7D32), Color(0xFF66BB6A)],
            glowColor: const Color(0x554CAF50),
            onTap: () => context.read<QalqlahCubit>().analyzeRecording(),
          );
        }
        if (state is QalqlahSuccess || state is QalqlahFailure) {
          return _OutlineButton(
            label: 'تسجيل جديد',
            icon: Icons.refresh_rounded,
            onTap: () => context.read<QalqlahCubit>().reset(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ─── Premium filled button ────────────────────────────────────────────────────

class _PremiumButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<Color> gradientColors;
  final Color glowColor;
  final VoidCallback onTap;

  const _PremiumButton({
    required this.label,
    required this.icon,
    required this.gradientColors,
    required this.glowColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: glowColor,
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: AppTextStyles.buttonText.copyWith(fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Outline button ───────────────────────────────────────────────────────────

class _OutlineButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _OutlineButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF43A047).withValues(alpha: 0.6),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF43A047).withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.refresh_rounded, color: Color(0xFF43A047), size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.linkText.copyWith(
                fontSize: 15,
                color: const Color(0xFF2E7D32),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
