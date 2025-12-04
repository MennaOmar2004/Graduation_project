import 'package:flutter/material.dart';
import '../../../colors.dart';

/// A button with a layered shadow effect and white border
class LayeredButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final bool showShadow;
  final String? image;
  final Color? backgroundColor;
  final Color? shadowColor;

  const LayeredButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width = 200,
    this.height = 50,
    this.showShadow = true,
    this.image,
    this.backgroundColor,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow:
              showShadow
                  ? [
                    BoxShadow(
                      color: shadowColor ?? AppColors.buttonShadow,
                      offset: const Offset(0, 6),
                      blurRadius: 0,
                      spreadRadius: 2,
                    ),
                  ]
                  : null,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.buttonPrimary,
            disabledBackgroundColor: AppColors.buttonDisabled,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: const BorderSide(color: AppColors.buttonBorder, width: 1),
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (image != null) ...[
                Image.asset(image!, width: 45, height: 45),
                // const SizedBox(width: 12),
              ],
              const SizedBox(width: 10),
              Text(text, style: AppTextStyles.buttonText),
            ],
          ),
        ),
      ),
    );
  }
}
