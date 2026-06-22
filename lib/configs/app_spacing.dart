import 'package:flutter/material.dart';

/// Centralized layout spacing, padding, and layout dimensions tokens
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 28.0;
  static const double huge = 32.0;

  // Common Edge Insets
  static const EdgeInsets screenPadding = EdgeInsets.fromLTRB(20, 24, 20, 32);
  static const EdgeInsets cardPadding = EdgeInsets.all(18);
  static const EdgeInsets headerPadding = EdgeInsets.fromLTRB(8, 12, 16, 22);

  // Common border radii
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXxl = 28.0;
}
