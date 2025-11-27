import 'package:flutter/material.dart';
import '../../../colors.dart';

/// A button with a layered shadow effect and white border
class LayeredButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final bool showShadow;

  const LayeredButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width = 200,
    this.height = 50,
    this.showShadow = true,
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
                      color: AppColors.buttonShadow,
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
            backgroundColor: AppColors.buttonPrimary,
            disabledBackgroundColor: AppColors.buttonDisabled,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: const BorderSide(color: AppColors.buttonBorder, width: 1),
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          child: Text(text, style: AppTextStyles.buttonText),
        ),
      ),
    );
  }
}
