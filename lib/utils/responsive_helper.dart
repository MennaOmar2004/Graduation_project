import 'package:flutter/material.dart';

/// Responsive utility helper for consistent sizing across all screens
class ResponsiveHelper {
  // Base dimensions (iPhone SE as reference)
  static const double baseWidth = 375.0;
  static const double baseHeight = 667.0;

  /// Get responsive font size based on screen width
  static double fontSize(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    return size * (width / baseWidth);
  }

  /// Get responsive width as percentage of screen width
  static double width(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }

  /// Get responsive height as percentage of screen height
  static double height(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }

  /// Get responsive padding
  static EdgeInsets padding(
    BuildContext context, {
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    final scale = MediaQuery.of(context).size.width / baseWidth;

    return EdgeInsets.only(
      top: (top ?? vertical ?? all ?? 0) * scale,
      bottom: (bottom ?? vertical ?? all ?? 0) * scale,
      left: (left ?? horizontal ?? all ?? 0) * scale,
      right: (right ?? horizontal ?? all ?? 0) * scale,
    );
  }

  /// Get responsive size for square elements
  static double size(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    return baseSize * (width / baseWidth);
  }

  /// Check if screen is small (width < 360)
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 360;
  }

  /// Check if screen is large (width > 400)
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 400;
  }

  /// Get safe area padding
  static EdgeInsets safeArea(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Get responsive icon size
  static double iconSize(BuildContext context, double baseSize) {
    return size(context, baseSize);
  }

  /// Get responsive border radius
  static double borderRadius(BuildContext context, double baseRadius) {
    return size(context, baseRadius);
  }
}
