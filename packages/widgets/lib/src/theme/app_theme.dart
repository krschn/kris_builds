import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Application theme configuration.
///
/// Provides light and dark theme data with consistent styling.
class AppTheme {
  AppTheme._();

  /// Dark theme for the application
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: AppColors.darkColorScheme,
    textTheme: AppTypography.textTheme,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.onBackgroundDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.onBackgroundDark,
      ),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.cardDark,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusLg),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.onPrimaryDark,
        minimumSize: const Size(88, 48),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
        textStyle: AppTypography.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryDark,
        minimumSize: const Size(88, 48),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
        side: const BorderSide(color: AppColors.primaryDark),
        textStyle: AppTypography.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryDark,
        minimumSize: const Size(64, 40),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        textStyle: AppTypography.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      border: const OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: AppColors.outlineDark),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: AppColors.outlineDark),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: AppColors.primaryDark, width: 2),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: AppColors.errorDark),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: AppColors.errorDark, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.disabledDark),
      labelStyle: AppTypography.bodyLarge.copyWith(color: AppColors.onSurfaceDark),
      errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.errorDark),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedColor: AppColors.primaryDark.withValues(alpha: 0.2),
      labelStyle: AppTypography.labelMedium,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusFull),
      side: const BorderSide(color: AppColors.outlineDark),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceDark,
      elevation: 3,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusXl),
      titleTextStyle: AppTypography.headlineSmall.copyWith(color: AppColors.onSurfaceDark),
      contentTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceDark),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceDark,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.xl)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.onSurfaceDark,
      contentTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.surfaceDark),
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
      behavior: SnackBarBehavior.floating,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      titleTextStyle: AppTypography.bodyLarge.copyWith(color: AppColors.onSurfaceDark),
      subtitleTextStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.onSurfaceDark.withValues(alpha: 0.7),
      ),
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.outlineDark, thickness: 1, space: 1),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: AppColors.onPrimaryDark,
    ),
  );

  /// Light theme for the application
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: AppColors.lightColorScheme,
    textTheme: AppTypography.textTheme,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.onBackgroundLight,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.onBackgroundLight,
      ),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.cardLight,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusLg),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.onPrimaryLight,
        minimumSize: const Size(88, 48),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
        textStyle: AppTypography.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        minimumSize: const Size(88, 48),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
        side: const BorderSide(color: AppColors.primaryLight),
        textStyle: AppTypography.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        minimumSize: const Size(64, 40),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        textStyle: AppTypography.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,
      border: const OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: AppColors.outlineLight),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: AppColors.outlineLight),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: AppColors.errorLight),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: AppColors.errorLight, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.disabledLight),
      labelStyle: AppTypography.bodyLarge.copyWith(color: AppColors.onSurfaceLight),
      errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.errorLight),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceLight,
      selectedColor: AppColors.primaryLight.withValues(alpha: 0.2),
      labelStyle: AppTypography.labelMedium,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusFull),
      side: const BorderSide(color: AppColors.outlineLight),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceLight,
      elevation: 3,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusXl),
      titleTextStyle: AppTypography.headlineSmall.copyWith(color: AppColors.onSurfaceLight),
      contentTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceLight),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceLight,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.xl)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.onSurfaceLight,
      contentTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.surfaceLight),
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
      behavior: SnackBarBehavior.floating,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      titleTextStyle: AppTypography.bodyLarge.copyWith(color: AppColors.onSurfaceLight),
      subtitleTextStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.onSurfaceLight.withValues(alpha: 0.7),
      ),
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.outlineLight, thickness: 1, space: 1),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryLight,
      foregroundColor: AppColors.onPrimaryLight,
    ),
  );
}
