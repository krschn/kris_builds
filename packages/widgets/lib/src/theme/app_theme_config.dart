import 'package:flutter/material.dart';

/// Configuration class for customizing the application theme.
///
/// Apps can create an instance of this class to override default colors
/// and typography. Any field left null will use the package defaults.
class AppThemeConfig {
  const AppThemeConfig({
    this.primaryLight,
    this.primaryDark,
    this.onPrimaryLight,
    this.onPrimaryDark,
    this.secondaryLight,
    this.secondaryDark,
    this.onSecondaryLight,
    this.onSecondaryDark,
    this.surfaceLight,
    this.surfaceDark,
    this.onSurfaceLight,
    this.onSurfaceDark,
    this.backgroundLight,
    this.backgroundDark,
    this.onBackgroundLight,
    this.onBackgroundDark,
    this.errorLight,
    this.errorDark,
    this.onErrorLight,
    this.onErrorDark,
    this.successLight,
    this.successDark,
    this.warningLight,
    this.warningDark,
    this.outlineLight,
    this.outlineDark,
    this.cardLight,
    this.cardDark,
    this.disabledLight,
    this.disabledDark,
    this.fontFamily,
  });

  /// Primary color for light theme
  final Color? primaryLight;

  /// Primary color for dark theme
  final Color? primaryDark;

  /// Color for content on primary light background
  final Color? onPrimaryLight;

  /// Color for content on primary dark background
  final Color? onPrimaryDark;

  /// Secondary color for light theme
  final Color? secondaryLight;

  /// Secondary color for dark theme
  final Color? secondaryDark;

  /// Color for content on secondary light background
  final Color? onSecondaryLight;

  /// Color for content on secondary dark background
  final Color? onSecondaryDark;

  /// Surface color for light theme
  final Color? surfaceLight;

  /// Surface color for dark theme
  final Color? surfaceDark;

  /// Color for content on surface light background
  final Color? onSurfaceLight;

  /// Color for content on surface dark background
  final Color? onSurfaceDark;

  /// Background color for light theme
  final Color? backgroundLight;

  /// Background color for dark theme
  final Color? backgroundDark;

  /// Color for content on background light
  final Color? onBackgroundLight;

  /// Color for content on background dark
  final Color? onBackgroundDark;

  /// Error color for light theme
  final Color? errorLight;

  /// Error color for dark theme
  final Color? errorDark;

  /// Color for content on error light background
  final Color? onErrorLight;

  /// Color for content on error dark background
  final Color? onErrorDark;

  /// Success color for light theme
  final Color? successLight;

  /// Success color for dark theme
  final Color? successDark;

  /// Warning color for light theme
  final Color? warningLight;

  /// Warning color for dark theme
  final Color? warningDark;

  /// Outline color for light theme
  final Color? outlineLight;

  /// Outline color for dark theme
  final Color? outlineDark;

  /// Card color for light theme
  final Color? cardLight;

  /// Card color for dark theme
  final Color? cardDark;

  /// Disabled color for light theme
  final Color? disabledLight;

  /// Disabled color for dark theme
  final Color? disabledDark;

  /// Font family to use for all text styles
  final String? fontFamily;
}
