import 'package:flutter/material.dart';

/// Spacing constants for consistent layout throughout the application.
///
/// Uses a 4px base unit for all spacing values.
class AppSpacing {
  AppSpacing._();

  /// Base unit: 4px
  static const double unit = 4.0;

  /// Extra extra small: 2px
  static const double xxs = unit * 0.5;

  /// Extra small: 4px
  static const double xs = unit;

  /// Small: 8px
  static const double sm = unit * 2;

  /// Medium: 12px
  static const double md = unit * 3;

  /// Large: 16px
  static const double lg = unit * 4;

  /// Extra large: 24px
  static const double xl = unit * 6;

  /// Extra extra large: 32px
  static const double xxl = unit * 8;

  /// Extra extra extra large: 48px
  static const double xxxl = unit * 12;

  // Padding helpers

  /// Padding of 4px on all sides
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);

  /// Padding of 8px on all sides
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);

  /// Padding of 12px on all sides
  static const EdgeInsets paddingMd = EdgeInsets.all(md);

  /// Padding of 16px on all sides
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);

  /// Padding of 24px on all sides
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  /// Horizontal padding of 16px
  static const EdgeInsets paddingHorizontalLg =
      EdgeInsets.symmetric(horizontal: lg);

  /// Vertical padding of 16px
  static const EdgeInsets paddingVerticalLg =
      EdgeInsets.symmetric(vertical: lg);

  /// Horizontal padding of 24px
  static const EdgeInsets paddingHorizontalXl =
      EdgeInsets.symmetric(horizontal: xl);

  /// Vertical padding of 24px
  static const EdgeInsets paddingVerticalXl =
      EdgeInsets.symmetric(vertical: xl);

  // Gap helpers for use with Column/Row

  /// Vertical gap of 4px
  static const SizedBox gapXs = SizedBox(height: xs);

  /// Vertical gap of 8px
  static const SizedBox gapSm = SizedBox(height: sm);

  /// Vertical gap of 12px
  static const SizedBox gapMd = SizedBox(height: md);

  /// Vertical gap of 16px
  static const SizedBox gapLg = SizedBox(height: lg);

  /// Vertical gap of 24px
  static const SizedBox gapXl = SizedBox(height: xl);

  /// Vertical gap of 32px
  static const SizedBox gapXxl = SizedBox(height: xxl);

  /// Horizontal gap of 4px
  static const SizedBox gapHorizontalXs = SizedBox(width: xs);

  /// Horizontal gap of 8px
  static const SizedBox gapHorizontalSm = SizedBox(width: sm);

  /// Horizontal gap of 12px
  static const SizedBox gapHorizontalMd = SizedBox(width: md);

  /// Horizontal gap of 16px
  static const SizedBox gapHorizontalLg = SizedBox(width: lg);

  /// Horizontal gap of 24px
  static const SizedBox gapHorizontalXl = SizedBox(width: xl);

  // Border radius constants

  /// Small border radius: 4px
  static const BorderRadius borderRadiusSm =
      BorderRadius.all(Radius.circular(xs));

  /// Medium border radius: 8px
  static const BorderRadius borderRadiusMd =
      BorderRadius.all(Radius.circular(sm));

  /// Large border radius: 12px
  static const BorderRadius borderRadiusLg =
      BorderRadius.all(Radius.circular(md));

  /// Extra large border radius: 16px
  static const BorderRadius borderRadiusXl =
      BorderRadius.all(Radius.circular(lg));

  /// Full/pill border radius: 999px
  static const BorderRadius borderRadiusFull =
      BorderRadius.all(Radius.circular(999));
}
