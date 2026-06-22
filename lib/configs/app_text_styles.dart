import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized application typography tokens
class AppTextStyles {
  // Button text style
  static TextStyle buttonText = GoogleFonts.inriaSerif(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Link/secondary text style
  static TextStyle linkText = GoogleFonts.inriaSerif(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );

  // Number text style
  static TextStyle numberText = GoogleFonts.fredoka(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  // Snackbar text style
  static TextStyle snackbarText = GoogleFonts.cairo();
}
