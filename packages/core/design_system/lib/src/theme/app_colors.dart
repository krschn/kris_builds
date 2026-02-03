import 'package:flutter/material.dart';

import 'app_theme_config.dart';

/// Semantic color tokens for the application theme.
///
/// These colors are designed to be used consistently across the app
/// and support both light and dark themes. Colors can be customized
/// by passing an [AppThemeConfig] to the constructor.
class AppColors {
  const AppColors([this.config]);

  final AppThemeConfig? config;

  // Default color constants
  static const Color _defaultPrimaryLight = Color(0xFF6366F1);
  static const Color _defaultPrimaryDark = Color(0xFF818CF8);
  static const Color _defaultOnPrimaryLight = Color(0xFFFFFFFF);
  static const Color _defaultOnPrimaryDark = Color(0xFF1E1E2E);

  static const Color _defaultSecondaryLight = Color(0xFF8B5CF6);
  static const Color _defaultSecondaryDark = Color(0xFFA78BFA);
  static const Color _defaultOnSecondaryLight = Color(0xFFFFFFFF);
  static const Color _defaultOnSecondaryDark = Color(0xFF1E1E2E);

  static const Color _defaultSurfaceLight = Color(0xFFFAFAFA);
  static const Color _defaultSurfaceDark = Color(0xFF1E1E2E);
  static const Color _defaultOnSurfaceLight = Color(0xFF1F2937);
  static const Color _defaultOnSurfaceDark = Color(0xFFF9FAFB);

  static const Color _defaultBackgroundLight = Color(0xFFFFFFFF);
  static const Color _defaultBackgroundDark = Color(0xFF121218);
  static const Color _defaultOnBackgroundLight = Color(0xFF1F2937);
  static const Color _defaultOnBackgroundDark = Color(0xFFF9FAFB);

  static const Color _defaultErrorLight = Color(0xFFDC2626);
  static const Color _defaultErrorDark = Color(0xFFF87171);
  static const Color _defaultOnErrorLight = Color(0xFFFFFFFF);
  static const Color _defaultOnErrorDark = Color(0xFF1E1E2E);

  static const Color _defaultSuccessLight = Color(0xFF16A34A);
  static const Color _defaultSuccessDark = Color(0xFF4ADE80);

  static const Color _defaultWarningLight = Color(0xFFD97706);
  static const Color _defaultWarningDark = Color(0xFFFBBF24);

  static const Color _defaultOutlineLight = Color(0xFFE5E7EB);
  static const Color _defaultOutlineDark = Color(0xFF374151);

  static const Color _defaultCardLight = Color(0xFFFFFFFF);
  static const Color _defaultCardDark = Color(0xFF262633);

  static const Color _defaultDisabledLight = Color(0xFF9CA3AF);
  static const Color _defaultDisabledDark = Color(0xFF6B7280);

  // Primary colors
  Color get primaryLight => config?.primaryLight ?? _defaultPrimaryLight;
  Color get primaryDark => config?.primaryDark ?? _defaultPrimaryDark;
  Color get onPrimaryLight => config?.onPrimaryLight ?? _defaultOnPrimaryLight;
  Color get onPrimaryDark => config?.onPrimaryDark ?? _defaultOnPrimaryDark;

  // Secondary colors
  Color get secondaryLight => config?.secondaryLight ?? _defaultSecondaryLight;
  Color get secondaryDark => config?.secondaryDark ?? _defaultSecondaryDark;
  Color get onSecondaryLight => config?.onSecondaryLight ?? _defaultOnSecondaryLight;
  Color get onSecondaryDark => config?.onSecondaryDark ?? _defaultOnSecondaryDark;

  // Surface colors
  Color get surfaceLight => config?.surfaceLight ?? _defaultSurfaceLight;
  Color get surfaceDark => config?.surfaceDark ?? _defaultSurfaceDark;
  Color get onSurfaceLight => config?.onSurfaceLight ?? _defaultOnSurfaceLight;
  Color get onSurfaceDark => config?.onSurfaceDark ?? _defaultOnSurfaceDark;

  // Background colors
  Color get backgroundLight => config?.backgroundLight ?? _defaultBackgroundLight;
  Color get backgroundDark => config?.backgroundDark ?? _defaultBackgroundDark;
  Color get onBackgroundLight => config?.onBackgroundLight ?? _defaultOnBackgroundLight;
  Color get onBackgroundDark => config?.onBackgroundDark ?? _defaultOnBackgroundDark;

  // Error colors
  Color get errorLight => config?.errorLight ?? _defaultErrorLight;
  Color get errorDark => config?.errorDark ?? _defaultErrorDark;
  Color get onErrorLight => config?.onErrorLight ?? _defaultOnErrorLight;
  Color get onErrorDark => config?.onErrorDark ?? _defaultOnErrorDark;

  // Success colors
  Color get successLight => config?.successLight ?? _defaultSuccessLight;
  Color get successDark => config?.successDark ?? _defaultSuccessDark;

  // Warning colors
  Color get warningLight => config?.warningLight ?? _defaultWarningLight;
  Color get warningDark => config?.warningDark ?? _defaultWarningDark;

  // Outline colors
  Color get outlineLight => config?.outlineLight ?? _defaultOutlineLight;
  Color get outlineDark => config?.outlineDark ?? _defaultOutlineDark;

  // Card colors
  Color get cardLight => config?.cardLight ?? _defaultCardLight;
  Color get cardDark => config?.cardDark ?? _defaultCardDark;

  // Disabled colors
  Color get disabledLight => config?.disabledLight ?? _defaultDisabledLight;
  Color get disabledDark => config?.disabledDark ?? _defaultDisabledDark;

  /// Creates a ColorScheme for light theme
  ColorScheme get lightColorScheme => ColorScheme(
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
  ColorScheme get darkColorScheme => ColorScheme(
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
