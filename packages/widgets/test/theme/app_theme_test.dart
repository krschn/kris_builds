import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets/widgets.dart';

void main() {
  group('AppTheme', () {
    group('light theme', () {
      test('should return ThemeData with light brightness', () {
        final ThemeData theme = AppTheme.light();

        expect(theme.brightness, Brightness.light);
        expect(theme.useMaterial3, true);
      });

      test('should use light color scheme', () {
        final ThemeData theme = AppTheme.light();

        expect(theme.colorScheme.brightness, Brightness.light);
        expect(theme.colorScheme.primary, const Color(0xFF6366F1));
      });

      test('should use default background color', () {
        final ThemeData theme = AppTheme.light();

        expect(theme.scaffoldBackgroundColor, const Color(0xFFFFFFFF));
      });

      test('should configure appBarTheme', () {
        final ThemeData theme = AppTheme.light();

        expect(theme.appBarTheme.backgroundColor, const Color(0xFFFFFFFF));
        expect(theme.appBarTheme.elevation, 0);
        expect(theme.appBarTheme.centerTitle, true);
      });

      test('should configure elevatedButtonTheme', () {
        final ThemeData theme = AppTheme.light();

        expect(theme.elevatedButtonTheme.style, isNotNull);
      });

      test('should configure inputDecorationTheme', () {
        final ThemeData theme = AppTheme.light();

        expect(theme.inputDecorationTheme.filled, true);
      });
    });

    group('dark theme', () {
      test('should return ThemeData with dark brightness', () {
        final ThemeData theme = AppTheme.dark();

        expect(theme.brightness, Brightness.dark);
        expect(theme.useMaterial3, true);
      });

      test('should use dark color scheme', () {
        final ThemeData theme = AppTheme.dark();

        expect(theme.colorScheme.brightness, Brightness.dark);
        expect(theme.colorScheme.primary, const Color(0xFF818CF8));
      });

      test('should use default dark background color', () {
        final ThemeData theme = AppTheme.dark();

        expect(theme.scaffoldBackgroundColor, const Color(0xFF121218));
      });

      test('should configure appBarTheme for dark', () {
        final ThemeData theme = AppTheme.dark();

        expect(theme.appBarTheme.backgroundColor, const Color(0xFF121218));
        expect(theme.appBarTheme.elevation, 0);
      });
    });

    group('with custom config', () {
      test('light theme should use custom primary color', () {
        const AppThemeConfig config = AppThemeConfig(primaryLight: Colors.blue);
        final ThemeData theme = AppTheme.light(config);

        expect(theme.colorScheme.primary, Colors.blue);
      });

      test('dark theme should use custom primary color', () {
        const AppThemeConfig config = AppThemeConfig(primaryDark: Colors.lightBlue);
        final ThemeData theme = AppTheme.dark(config);

        expect(theme.colorScheme.primary, Colors.lightBlue);
      });

      test('should use custom background colors', () {
        const AppThemeConfig config = AppThemeConfig(
          backgroundLight: Colors.grey,
          backgroundDark: Colors.blueGrey,
        );
        final ThemeData lightTheme = AppTheme.light(config);
        final ThemeData darkTheme = AppTheme.dark(config);

        expect(lightTheme.scaffoldBackgroundColor, Colors.grey);
        expect(darkTheme.scaffoldBackgroundColor, Colors.blueGrey);
      });

      test('should use custom font family', () {
        const AppThemeConfig config = AppThemeConfig(fontFamily: 'Inter');
        final ThemeData theme = AppTheme.light(config);

        expect(theme.textTheme.bodyMedium?.fontFamily, 'Inter');
        expect(theme.textTheme.labelLarge?.fontFamily, 'Inter');
      });

      test('should use custom secondary colors', () {
        const AppThemeConfig config = AppThemeConfig(
          secondaryLight: Colors.green,
          secondaryDark: Colors.lightGreen,
        );
        final ThemeData lightTheme = AppTheme.light(config);
        final ThemeData darkTheme = AppTheme.dark(config);

        expect(lightTheme.colorScheme.secondary, Colors.green);
        expect(darkTheme.colorScheme.secondary, Colors.lightGreen);
      });
    });

    group('backward compatibility', () {
      test('light theme with no config should work', () {
        expect(() => AppTheme.light(), returnsNormally);
      });

      test('dark theme with no config should work', () {
        expect(() => AppTheme.dark(), returnsNormally);
      });

      test('light theme with null config should use defaults', () {
        final ThemeData theme = AppTheme.light();

        expect(theme.colorScheme.primary, const Color(0xFF6366F1));
      });
    });
  });
}
