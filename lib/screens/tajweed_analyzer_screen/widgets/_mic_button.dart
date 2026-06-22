import 'package:flutter/material.dart';
import 'package:wanisi_app/configs/app_colors.dart';

/// Pulsing microphone button widget for audio recording in Tajweed analysis.
class TajweedMicButton extends StatelessWidget {
  final bool isListening;
  final Animation<double> pulseAnimation;
  final VoidCallback onTap;

  const TajweedMicButton({
    super.key,
    required this.isListening,
    required this.pulseAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isListening
          ? AnimatedBuilder(
              animation: pulseAnimation,
              builder: (_, __) => Transform.scale(
                scale: pulseAnimation.value,
                child: _buildMicContainer(true),
              ),
            )
          : _buildMicContainer(false),
    );
  }

  Widget _buildMicContainer(bool listening) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: listening
              ? AppColors.micListeningGradient
              : AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (listening ? Colors.red : AppColors.blue_).withValues(
              alpha: 0.35,
            ),
            blurRadius: listening ? 18 : 10,
            spreadRadius: listening ? 3 : 1,
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/recorder.png',
        width: 30,
        height: 30,
        errorBuilder: (_, __, ___) => Icon(
          listening ? Icons.mic : Icons.mic_none_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }
}
