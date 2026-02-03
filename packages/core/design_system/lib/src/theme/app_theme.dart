import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_theme_config.dart';
import 'app_typography.dart';

/// Application theme configuration.
///
/// Provides light and dark theme data with consistent styling.
/// Pass an optional [AppThemeConfig] to customize colors and typography.
class AppTheme {
  AppTheme._();

  /// Dark theme for the application.
  ///
  /// Pass an optional [config] to customize colors and typography.
  static ThemeData dark([AppThemeConfig? config]) {
    final AppColors colors = AppColors(config);
    final TextTheme textTheme = AppTypography.textTheme(config?.fontFamily);
    final String? fontFamily = config?.fontFamily;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colors.darkColorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colors.backgroundDark,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.backgroundDark,
        foregroundColor: colors.onBackgroundDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: colors.onBackgroundDark,
          fontFamily: fontFamily,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.cardDark,
        elevation: 1,
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusLg),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primaryDark,
          foregroundColor: colors.onPrimaryDark,
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
          textStyle: AppTypography.labelLarge(fontFamily),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primaryDark,
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
          side: BorderSide(color: colors.primaryDark),
          textStyle: AppTypography.labelLarge(fontFamily),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primaryDark,
          minimumSize: const Size(64, 40),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          textStyle: AppTypography.labelLarge(fontFamily),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide(color: colors.outlineDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide(color: colors.outlineDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide(color: colors.primaryDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide(color: colors.errorDark),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide(color: colors.errorDark, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTypography.bodyLarge(fontFamily).copyWith(color: colors.disabledDark),
        labelStyle: AppTypography.bodyLarge(fontFamily).copyWith(color: colors.onSurfaceDark),
        errorStyle: AppTypography.bodySmall(fontFamily).copyWith(color: colors.errorDark),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceDark,
        selectedColor: colors.primaryDark.withValues(alpha: 0.2),
        labelStyle: AppTypography.labelMedium(fontFamily),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusFull),
        side: BorderSide(color: colors.outlineDark),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surfaceDark,
        elevation: 3,
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusXl),
        titleTextStyle: AppTypography.headlineSmall(fontFamily).copyWith(color: colors.onSurfaceDark),
        contentTextStyle: AppTypography.bodyMedium(fontFamily).copyWith(color: colors.onSurfaceDark),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surfaceDark,
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.xl)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.onSurfaceDark,
        contentTextStyle: AppTypography.bodyMedium(fontFamily).copyWith(color: colors.surfaceDark),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
        behavior: SnackBarBehavior.floating,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        titleTextStyle: AppTypography.bodyLarge(fontFamily).copyWith(color: colors.onSurfaceDark),
        subtitleTextStyle: AppTypography.bodyMedium(fontFamily).copyWith(
          color: colors.onSurfaceDark.withValues(alpha: 0.7),
        ),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
      ),
      dividerTheme: DividerThemeData(color: colors.outlineDark, thickness: 1, space: 1),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primaryDark,
        foregroundColor: colors.onPrimaryDark,
      ),
    );
  }

  /// Light theme for the application.
  ///
  /// Pass an optional [config] to customize colors and typography.
  static ThemeData light([AppThemeConfig? config]) {
    final AppColors colors = AppColors(config);
    final TextTheme textTheme = AppTypography.textTheme(config?.fontFamily);
    final String? fontFamily = config?.fontFamily;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colors.lightColorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colors.backgroundLight,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.backgroundLight,
        foregroundColor: colors.onBackgroundLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: colors.onBackgroundLight,
          fontFamily: fontFamily,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.cardLight,
        elevation: 1,
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusLg),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primaryLight,
          foregroundColor: colors.onPrimaryLight,
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
          textStyle: AppTypography.labelLarge(fontFamily),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primaryLight,
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
          side: BorderSide(color: colors.primaryLight),
          textStyle: AppTypography.labelLarge(fontFamily),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primaryLight,
          minimumSize: const Size(64, 40),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          textStyle: AppTypography.labelLarge(fontFamily),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide(color: colors.outlineLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide(color: colors.outlineLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide(color: colors.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide(color: colors.errorLight),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide(color: colors.errorLight, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTypography.bodyLarge(fontFamily).copyWith(color: colors.disabledLight),
        labelStyle: AppTypography.bodyLarge(fontFamily).copyWith(color: colors.onSurfaceLight),
        errorStyle: AppTypography.bodySmall(fontFamily).copyWith(color: colors.errorLight),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceLight,
        selectedColor: colors.primaryLight.withValues(alpha: 0.2),
        labelStyle: AppTypography.labelMedium(fontFamily),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusFull),
        side: BorderSide(color: colors.outlineLight),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surfaceLight,
        elevation: 3,
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusXl),
        titleTextStyle: AppTypography.headlineSmall(fontFamily).copyWith(color: colors.onSurfaceLight),
        contentTextStyle: AppTypography.bodyMedium(fontFamily).copyWith(color: colors.onSurfaceLight),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surfaceLight,
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.xl)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.onSurfaceLight,
        contentTextStyle: AppTypography.bodyMedium(fontFamily).copyWith(color: colors.surfaceLight),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
        behavior: SnackBarBehavior.floating,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        titleTextStyle: AppTypography.bodyLarge(fontFamily).copyWith(color: colors.onSurfaceLight),
        subtitleTextStyle: AppTypography.bodyMedium(fontFamily).copyWith(
          color: colors.onSurfaceLight.withValues(alpha: 0.7),
        ),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
      ),
      dividerTheme: DividerThemeData(color: colors.outlineLight, thickness: 1, space: 1),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primaryLight,
        foregroundColor: colors.onPrimaryLight,
      ),
    );
  }
}
