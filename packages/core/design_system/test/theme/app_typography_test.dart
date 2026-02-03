import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTypography', () {
    group('textTheme with default font', () {
      test('should return TextTheme with all styles', () {
        final TextTheme theme = AppTypography.textTheme();

        expect(theme.displayLarge, isNotNull);
        expect(theme.displayMedium, isNotNull);
        expect(theme.displaySmall, isNotNull);
        expect(theme.headlineLarge, isNotNull);
        expect(theme.headlineMedium, isNotNull);
        expect(theme.headlineSmall, isNotNull);
        expect(theme.titleLarge, isNotNull);
        expect(theme.titleMedium, isNotNull);
        expect(theme.titleSmall, isNotNull);
        expect(theme.bodyLarge, isNotNull);
        expect(theme.bodyMedium, isNotNull);
        expect(theme.bodySmall, isNotNull);
        expect(theme.labelLarge, isNotNull);
        expect(theme.labelMedium, isNotNull);
        expect(theme.labelSmall, isNotNull);
      });

      test('should use Roboto as default font family', () {
        final TextTheme theme = AppTypography.textTheme();

        expect(theme.displayLarge?.fontFamily, 'Roboto');
        expect(theme.bodyMedium?.fontFamily, 'Roboto');
        expect(theme.labelLarge?.fontFamily, 'Roboto');
      });

      test('displayLarge should have correct properties', () {
        final TextTheme theme = AppTypography.textTheme();
        final TextStyle? style = theme.displayLarge;

        expect(style?.fontSize, 57);
        expect(style?.fontWeight, FontWeight.w400);
        expect(style?.letterSpacing, -0.25);
      });

      test('bodyLarge should have correct properties', () {
        final TextTheme theme = AppTypography.textTheme();
        final TextStyle? style = theme.bodyLarge;

        expect(style?.fontSize, 16);
        expect(style?.fontWeight, FontWeight.w400);
        expect(style?.letterSpacing, 0.5);
      });

      test('labelLarge should have correct properties', () {
        final TextTheme theme = AppTypography.textTheme();
        final TextStyle? style = theme.labelLarge;

        expect(style?.fontSize, 14);
        expect(style?.fontWeight, FontWeight.w500);
        expect(style?.letterSpacing, 0.1);
      });
    });

    group('textTheme with custom font', () {
      test('should use custom font family when provided', () {
        final TextTheme theme = AppTypography.textTheme('Inter');

        expect(theme.displayLarge?.fontFamily, 'Inter');
        expect(theme.bodyMedium?.fontFamily, 'Inter');
        expect(theme.labelLarge?.fontFamily, 'Inter');
        expect(theme.headlineSmall?.fontFamily, 'Inter');
      });
    });

    group('individual style methods', () {
      test('labelLarge should return correct style', () {
        final TextStyle style = AppTypography.labelLarge();

        expect(style.fontFamily, 'Roboto');
        expect(style.fontSize, 14);
        expect(style.fontWeight, FontWeight.w500);
        expect(style.letterSpacing, 0.1);
      });

      test('labelLarge with custom font should use custom font', () {
        final TextStyle style = AppTypography.labelLarge('Inter');

        expect(style.fontFamily, 'Inter');
        expect(style.fontSize, 14);
      });

      test('labelMedium should return correct style', () {
        final TextStyle style = AppTypography.labelMedium();

        expect(style.fontFamily, 'Roboto');
        expect(style.fontSize, 12);
        expect(style.fontWeight, FontWeight.w500);
        expect(style.letterSpacing, 0.5);
      });

      test('bodyLarge should return correct style', () {
        final TextStyle style = AppTypography.bodyLarge();

        expect(style.fontFamily, 'Roboto');
        expect(style.fontSize, 16);
        expect(style.fontWeight, FontWeight.w400);
        expect(style.letterSpacing, 0.5);
      });

      test('bodyMedium should return correct style', () {
        final TextStyle style = AppTypography.bodyMedium();

        expect(style.fontFamily, 'Roboto');
        expect(style.fontSize, 14);
        expect(style.fontWeight, FontWeight.w400);
        expect(style.letterSpacing, 0.25);
      });

      test('bodySmall should return correct style', () {
        final TextStyle style = AppTypography.bodySmall();

        expect(style.fontFamily, 'Roboto');
        expect(style.fontSize, 12);
        expect(style.fontWeight, FontWeight.w400);
        expect(style.letterSpacing, 0.4);
      });

      test('headlineSmall should return correct style', () {
        final TextStyle style = AppTypography.headlineSmall();

        expect(style.fontFamily, 'Roboto');
        expect(style.fontSize, 24);
        expect(style.fontWeight, FontWeight.w400);
        expect(style.letterSpacing, 0);
      });
    });
  });
}
