import 'package:flutter/material.dart';

/// Semantic color tokens for the application theme.
///
/// These colors are designed to be used consistently across the app
/// and support both light and dark themes.
class AppColors {
  AppColors._();

  // Primary colors
  static const Color primaryLight = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF818CF8);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onPrimaryDark = Color(0xFF1E1E2E);

  // Secondary colors
  static const Color secondaryLight = Color(0xFF8B5CF6);
  static const Color secondaryDark = Color(0xFFA78BFA);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color onSecondaryDark = Color(0xFF1E1E2E);

  // Surface colors
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color surfaceDark = Color(0xFF1E1E2E);
  static const Color onSurfaceLight = Color(0xFF1F2937);
  static const Color onSurfaceDark = Color(0xFFF9FAFB);

  // Background colors
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121218);
  static const Color onBackgroundLight = Color(0xFF1F2937);
  static const Color onBackgroundDark = Color(0xFFF9FAFB);

  // Error colors
  static const Color errorLight = Color(0xFFDC2626);
  static const Color errorDark = Color(0xFFF87171);
  static const Color onErrorLight = Color(0xFFFFFFFF);
  static const Color onErrorDark = Color(0xFF1E1E2E);

  // Success colors
  static const Color successLight = Color(0xFF16A34A);
  static const Color successDark = Color(0xFF4ADE80);

  // Warning colors
  static const Color warningLight = Color(0xFFD97706);
  static const Color warningDark = Color(0xFFFBBF24);

  // Outline colors
  static const Color outlineLight = Color(0xFFE5E7EB);
  static const Color outlineDark = Color(0xFF374151);

  // Card colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF262633);

  // Disabled colors
  static const Color disabledLight = Color(0xFF9CA3AF);
  static const Color disabledDark = Color(0xFF6B7280);

  /// Creates a ColorScheme for light theme
  static ColorScheme get lightColorScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: primaryLight,
        onPrimary: onPrimaryLight,
        secondary: secondaryLight,
        onSecondary: onSecondaryLight,
        error: errorLight,
        onError: onErrorLight,
        surface: surfaceLight,
        onSurface: onSurfaceLight,
        outline: outlineLight,
      );

  /// Creates a ColorScheme for dark theme
  static ColorScheme get darkColorScheme => const ColorScheme(
        brightness: Brightness.dark,
        primary: primaryDark,
        onPrimary: onPrimaryDark,
        secondary: secondaryDark,
        onSecondary: onSecondaryDark,
        error: errorDark,
        onError: onErrorDark,
        surface: surfaceDark,
        onSurface: onSurfaceDark,
        outline: outlineDark,
      );
}
