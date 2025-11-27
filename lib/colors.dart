import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App color palette
class AppColors {
  // Text and primary colors
  static const Color text = Color(0xFF3396FF);

  // Button colors
  static const Color buttonPrimary = Color(0xFF3396FF);
  static const Color buttonShadow = Color(0xFFB3D9FF);
  static const Color buttonDisabled = Color(0xFFE0E0E0);
  static const Color buttonBorder = Colors.white;

  // Background colors
  static const Color backgroundLight = Color(0xFFD6EAF8);
}

/// App text styles
class AppTextStyles {
  // Button text style
  static TextStyle buttonText = GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Link/secondary text style
  static TextStyle linkText = GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );

  // Snackbar text style
  static TextStyle snackbarText = GoogleFonts.cairo();
}
