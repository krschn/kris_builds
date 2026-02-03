import 'package:flutter/material.dart';

/// Typography system for the application.
///
/// Provides consistent text styles based on Material Design 3 type scale.
/// The font family can be customized by passing it to [textTheme].
class AppTypography {
  AppTypography._();

  static const String _defaultFontFamily = 'Roboto';

  /// Creates a TextTheme with all typography styles.
  ///
  /// Pass an optional [fontFamily] to customize the font used across all styles.
  static TextTheme textTheme([String? fontFamily]) {
    final String family = fontFamily ?? _defaultFontFamily;
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: family,
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: TextStyle(
        fontFamily: family,
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: TextStyle(
        fontFamily: family,
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
      ),
      headlineLarge: TextStyle(
        fontFamily: family,
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: TextStyle(
        fontFamily: family,
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: TextStyle(
        fontFamily: family,
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.33,
      ),
      titleLarge: TextStyle(
        fontFamily: family,
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: TextStyle(
        fontFamily: family,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.5,
      ),
      titleSmall: TextStyle(
        fontFamily: family,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      bodyLarge: TextStyle(
        fontFamily: family,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: family,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: TextStyle(
        fontFamily: family,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      ),
      labelLarge: TextStyle(
        fontFamily: family,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: TextStyle(
        fontFamily: family,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: TextStyle(
        fontFamily: family,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Returns a specific text style with optional font family override.
  static TextStyle labelLarge([String? fontFamily]) {
    final String family = fontFamily ?? _defaultFontFamily;
    return TextStyle(
      fontFamily: family,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
    );
  }

  /// Returns a specific text style with optional font family override.
  static TextStyle labelMedium([String? fontFamily]) {
    final String family = fontFamily ?? _defaultFontFamily;
    return TextStyle(
      fontFamily: family,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
    );
  }

  /// Returns a specific text style with optional font family override.
  static TextStyle bodyLarge([String? fontFamily]) {
    final String family = fontFamily ?? _defaultFontFamily;
    return TextStyle(
      fontFamily: family,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.5,
    );
  }

  /// Returns a specific text style with optional font family override.
  static TextStyle bodyMedium([String? fontFamily]) {
    final String family = fontFamily ?? _defaultFontFamily;
    return TextStyle(
      fontFamily: family,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
    );
  }

  /// Returns a specific text style with optional font family override.
  static TextStyle bodySmall([String? fontFamily]) {
    final String family = fontFamily ?? _defaultFontFamily;
    return TextStyle(
      fontFamily: family,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
    );
  }

  /// Returns a specific text style with optional font family override.
  static TextStyle headlineSmall([String? fontFamily]) {
    final String family = fontFamily ?? _defaultFontFamily;
    return TextStyle(
      fontFamily: family,
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.33,
    );
  }
}
