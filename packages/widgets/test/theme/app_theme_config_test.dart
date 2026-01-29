import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets/widgets.dart';

void main() {
  group('AppThemeConfig', () {
    test('should create config with no parameters', () {
      const AppThemeConfig config = AppThemeConfig();

      expect(config.primaryLight, isNull);
      expect(config.primaryDark, isNull);
      expect(config.fontFamily, isNull);
    });

    test('should create config with primary colors', () {
      const AppThemeConfig config = AppThemeConfig(
        primaryLight: Colors.blue,
        primaryDark: Colors.lightBlue,
      );

      expect(config.primaryLight, Colors.blue);
      expect(config.primaryDark, Colors.lightBlue);
    });

    test('should create config with secondary colors', () {
      const AppThemeConfig config = AppThemeConfig(
        secondaryLight: Colors.green,
        secondaryDark: Colors.lightGreen,
        onSecondaryLight: Colors.white,
        onSecondaryDark: Colors.black,
      );

      expect(config.secondaryLight, Colors.green);
      expect(config.secondaryDark, Colors.lightGreen);
      expect(config.onSecondaryLight, Colors.white);
      expect(config.onSecondaryDark, Colors.black);
    });

    test('should create config with surface and background colors', () {
      const AppThemeConfig config = AppThemeConfig(
        surfaceLight: Colors.grey,
        surfaceDark: Colors.blueGrey,
        backgroundLight: Colors.white,
        backgroundDark: Colors.black,
      );

      expect(config.surfaceLight, Colors.grey);
      expect(config.surfaceDark, Colors.blueGrey);
      expect(config.backgroundLight, Colors.white);
      expect(config.backgroundDark, Colors.black);
    });

    test('should create config with error colors', () {
      const AppThemeConfig config = AppThemeConfig(
        errorLight: Colors.red,
        errorDark: Colors.redAccent,
        onErrorLight: Colors.white,
        onErrorDark: Colors.black,
      );

      expect(config.errorLight, Colors.red);
      expect(config.errorDark, Colors.redAccent);
      expect(config.onErrorLight, Colors.white);
      expect(config.onErrorDark, Colors.black);
    });

    test('should create config with success and warning colors', () {
      const AppThemeConfig config = AppThemeConfig(
        successLight: Colors.green,
        successDark: Colors.lightGreen,
        warningLight: Colors.orange,
        warningDark: Colors.deepOrange,
      );

      expect(config.successLight, Colors.green);
      expect(config.successDark, Colors.lightGreen);
      expect(config.warningLight, Colors.orange);
      expect(config.warningDark, Colors.deepOrange);
    });

    test('should create config with outline, card, and disabled colors', () {
      const AppThemeConfig config = AppThemeConfig(
        outlineLight: Colors.grey,
        outlineDark: Colors.blueGrey,
        cardLight: Colors.white,
        cardDark: Colors.grey,
        disabledLight: Colors.grey,
        disabledDark: Colors.blueGrey,
      );

      expect(config.outlineLight, Colors.grey);
      expect(config.outlineDark, Colors.blueGrey);
      expect(config.cardLight, Colors.white);
      expect(config.cardDark, Colors.grey);
      expect(config.disabledLight, Colors.grey);
      expect(config.disabledDark, Colors.blueGrey);
    });

    test('should create config with font family', () {
      const AppThemeConfig config = AppThemeConfig(
        fontFamily: 'Inter',
      );

      expect(config.fontFamily, 'Inter');
    });

    test('should create config with all properties', () {
      const AppThemeConfig config = AppThemeConfig(
        primaryLight: Colors.blue,
        primaryDark: Colors.lightBlue,
        onPrimaryLight: Colors.white,
        onPrimaryDark: Colors.black,
        fontFamily: 'Roboto',
      );

      expect(config.primaryLight, Colors.blue);
      expect(config.primaryDark, Colors.lightBlue);
      expect(config.onPrimaryLight, Colors.white);
      expect(config.onPrimaryDark, Colors.black);
      expect(config.fontFamily, 'Roboto');
    });
  });
}
