import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/qalqlah/qalqlah_cubit.dart';
import 'package:wanisi_app/blocs/qalqlah/qalqlah_state.dart';

/// Pulsing, animated mic button that drives startRecording / stopRecording.
class QalqlahMicButton extends StatefulWidget {
  const QalqlahMicButton({super.key});

  @override
  State<QalqlahMicButton> createState() => _QalqlahMicButtonState();
}

class _QalqlahMicButtonState extends State<QalqlahMicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _scale = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QalqlahCubit, QalqlahState>(
      builder: (context, state) {
        final isRecording = state is QalqlahRecording;

        final coreButton = GestureDetector(
          onTap: () {
            if (isRecording) {
              context.read<QalqlahCubit>().stopRecording();
            } else {
              context.read<QalqlahCubit>().startRecording();
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isRecording
                          ? Colors.redAccent
                          : Color.fromARGB(255, 202, 100, 134))
                      .withValues(alpha: 0.12),
                ),
              ),
              // Middle ring
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isRecording
                          ? Colors.redAccent
                          : Color.fromARGB(255, 202, 100, 134))
                      .withValues(alpha: 0.25),
                ),
              ),
              // Core button
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient:
                      isRecording
                          ? const LinearGradient(
                            colors: [Colors.redAccent, Color(0xFFFF6B6B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                          : const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 202, 100, 134),
                              Color.fromARGB(255, 202, 100, 134),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                  boxShadow: [
                    BoxShadow(
                      color: (isRecording ? Colors.red : Colors.red.shade50)
                          .withValues(alpha: 0.5),
                      blurRadius: isRecording ? 24 : 16,
                      spreadRadius: isRecording ? 4 : 2,
                    ),
                  ],
                ),
                child: Icon(
                  isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                  color: Colors.white,
                  size: 38,
                ),
              ),
            ],
          ),
        );

        if (isRecording) {
          return AnimatedBuilder(
            animation: _scale,
            builder:
                (_, __) =>
                    Transform.scale(scale: _scale.value, child: coreButton),
          );
        }
        return coreButton;
      },
    );
  }
}
