import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class TreatDeciderTheme {
  TreatDeciderTheme._();

  static const _greyBlack = Color(0xFF1A1A1A);
  static const _lightGrey = Color(0xFFF5F5F5);
  static const _mediumGrey = Color(0xFF424242);
  static const _borderGrey = Color(0xFFE0E0E0);
  static const _accentGrey = Color(0xFF757575);

  static AppThemeConfig get config => const AppThemeConfig(
        primaryLight: _greyBlack,
        onPrimaryLight: Colors.white,
        backgroundLight: _lightGrey,
        surfaceLight: Colors.white,
        onSurfaceLight: _greyBlack,
        outlineLight: _borderGrey,
        cardLight: Colors.white,
        secondaryLight: _mediumGrey,
        onSecondaryLight: Colors.white,
        disabledLight: _accentGrey,
        primaryDark: Colors.white,
        onPrimaryDark: _greyBlack,
        backgroundDark: _greyBlack,
        surfaceDark: _mediumGrey,
        onSurfaceDark: Colors.white,
        outlineDark: _accentGrey,
        cardDark: _mediumGrey,
        secondaryDark: _lightGrey,
        onSecondaryDark: _greyBlack,
        disabledDark: _accentGrey,
      );

  static ThemeData get light => AppTheme.light(config);

  static ThemeData get dark => AppTheme.dark(config);
}
