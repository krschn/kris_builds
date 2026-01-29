import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets/widgets.dart';

void main() {
  group('AppColors', () {
    group('default colors (no config)', () {
      const AppColors colors = AppColors();

      test('should provide default primary colors', () {
        expect(colors.primaryLight, const Color(0xFF6366F1));
        expect(colors.primaryDark, const Color(0xFF818CF8));
        expect(colors.onPrimaryLight, const Color(0xFFFFFFFF));
        expect(colors.onPrimaryDark, const Color(0xFF1E1E2E));
      });

      test('should provide default secondary colors', () {
        expect(colors.secondaryLight, const Color(0xFF8B5CF6));
        expect(colors.secondaryDark, const Color(0xFFA78BFA));
        expect(colors.onSecondaryLight, const Color(0xFFFFFFFF));
        expect(colors.onSecondaryDark, const Color(0xFF1E1E2E));
      });

      test('should provide default surface colors', () {
        expect(colors.surfaceLight, const Color(0xFFFAFAFA));
        expect(colors.surfaceDark, const Color(0xFF1E1E2E));
        expect(colors.onSurfaceLight, const Color(0xFF1F2937));
        expect(colors.onSurfaceDark, const Color(0xFFF9FAFB));
      });

      test('should provide default background colors', () {
        expect(colors.backgroundLight, const Color(0xFFFFFFFF));
        expect(colors.backgroundDark, const Color(0xFF121218));
        expect(colors.onBackgroundLight, const Color(0xFF1F2937));
        expect(colors.onBackgroundDark, const Color(0xFFF9FAFB));
      });

      test('should provide default error colors', () {
        expect(colors.errorLight, const Color(0xFFDC2626));
        expect(colors.errorDark, const Color(0xFFF87171));
        expect(colors.onErrorLight, const Color(0xFFFFFFFF));
        expect(colors.onErrorDark, const Color(0xFF1E1E2E));
      });

      test('should provide default success colors', () {
        expect(colors.successLight, const Color(0xFF16A34A));
        expect(colors.successDark, const Color(0xFF4ADE80));
      });

      test('should provide default warning colors', () {
        expect(colors.warningLight, const Color(0xFFD97706));
        expect(colors.warningDark, const Color(0xFFFBBF24));
      });

      test('should provide default outline colors', () {
        expect(colors.outlineLight, const Color(0xFFE5E7EB));
        expect(colors.outlineDark, const Color(0xFF374151));
      });

      test('should provide default card colors', () {
        expect(colors.cardLight, const Color(0xFFFFFFFF));
        expect(colors.cardDark, const Color(0xFF262633));
      });

      test('should provide default disabled colors', () {
        expect(colors.disabledLight, const Color(0xFF9CA3AF));
        expect(colors.disabledDark, const Color(0xFF6B7280));
      });
    });

    group('with custom config', () {
      test('should override primary colors when provided', () {
        const AppThemeConfig config = AppThemeConfig(
          primaryLight: Colors.blue,
          primaryDark: Colors.lightBlue,
        );
        const AppColors colors = AppColors(config);

        expect(colors.primaryLight, Colors.blue);
        expect(colors.primaryDark, Colors.lightBlue);
      });

      test('should use defaults for unset config values', () {
        const AppThemeConfig config = AppThemeConfig(
          primaryLight: Colors.blue,
        );
        const AppColors colors = AppColors(config);

        expect(colors.primaryLight, Colors.blue);
        expect(colors.primaryDark, const Color(0xFF818CF8)); // default
        expect(colors.secondaryLight, const Color(0xFF8B5CF6)); // default
      });
    });

    group('lightColorScheme', () {
      test('should create ColorScheme with light brightness', () {
        const AppColors colors = AppColors();
        final ColorScheme scheme = colors.lightColorScheme;

        expect(scheme.brightness, Brightness.light);
        expect(scheme.primary, colors.primaryLight);
        expect(scheme.onPrimary, colors.onPrimaryLight);
        expect(scheme.secondary, colors.secondaryLight);
        expect(scheme.onSecondary, colors.onSecondaryLight);
        expect(scheme.error, colors.errorLight);
        expect(scheme.onError, colors.onErrorLight);
        expect(scheme.surface, colors.surfaceLight);
        expect(scheme.onSurface, colors.onSurfaceLight);
        expect(scheme.outline, colors.outlineLight);
      });
    });

    group('darkColorScheme', () {
      test('should create ColorScheme with dark brightness', () {
        const AppColors colors = AppColors();
        final ColorScheme scheme = colors.darkColorScheme;

        expect(scheme.brightness, Brightness.dark);
        expect(scheme.primary, colors.primaryDark);
        expect(scheme.onPrimary, colors.onPrimaryDark);
        expect(scheme.secondary, colors.secondaryDark);
        expect(scheme.onSecondary, colors.onSecondaryDark);
        expect(scheme.error, colors.errorDark);
        expect(scheme.onError, colors.onErrorDark);
        expect(scheme.surface, colors.surfaceDark);
        expect(scheme.onSurface, colors.onSurfaceDark);
        expect(scheme.outline, colors.outlineDark);
      });
    });
  });
}
