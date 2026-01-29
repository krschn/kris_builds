import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets/widgets.dart';

void main() {
  group('AppSpacing', () {
    group('spacing constants', () {
      test('unit should be 4.0', () {
        expect(AppSpacing.unit, 4.0);
      });

      test('xxs should be half unit (2px)', () {
        expect(AppSpacing.xxs, 2.0);
      });

      test('xs should be 1 unit (4px)', () {
        expect(AppSpacing.xs, 4.0);
      });

      test('sm should be 2 units (8px)', () {
        expect(AppSpacing.sm, 8.0);
      });

      test('md should be 3 units (12px)', () {
        expect(AppSpacing.md, 12.0);
      });

      test('lg should be 4 units (16px)', () {
        expect(AppSpacing.lg, 16.0);
      });

      test('xl should be 6 units (24px)', () {
        expect(AppSpacing.xl, 24.0);
      });

      test('xxl should be 8 units (32px)', () {
        expect(AppSpacing.xxl, 32.0);
      });

      test('xxxl should be 12 units (48px)', () {
        expect(AppSpacing.xxxl, 48.0);
      });
    });

    group('padding helpers', () {
      test('paddingXs should be EdgeInsets.all(4)', () {
        expect(AppSpacing.paddingXs, const EdgeInsets.all(4.0));
      });

      test('paddingSm should be EdgeInsets.all(8)', () {
        expect(AppSpacing.paddingSm, const EdgeInsets.all(8.0));
      });

      test('paddingMd should be EdgeInsets.all(12)', () {
        expect(AppSpacing.paddingMd, const EdgeInsets.all(12.0));
      });

      test('paddingLg should be EdgeInsets.all(16)', () {
        expect(AppSpacing.paddingLg, const EdgeInsets.all(16.0));
      });

      test('paddingXl should be EdgeInsets.all(24)', () {
        expect(AppSpacing.paddingXl, const EdgeInsets.all(24.0));
      });

      test('paddingHorizontalLg should be symmetric horizontal 16', () {
        expect(AppSpacing.paddingHorizontalLg, const EdgeInsets.symmetric(horizontal: 16.0));
      });

      test('paddingVerticalLg should be symmetric vertical 16', () {
        expect(AppSpacing.paddingVerticalLg, const EdgeInsets.symmetric(vertical: 16.0));
      });

      test('paddingHorizontalXl should be symmetric horizontal 24', () {
        expect(AppSpacing.paddingHorizontalXl, const EdgeInsets.symmetric(horizontal: 24.0));
      });

      test('paddingVerticalXl should be symmetric vertical 24', () {
        expect(AppSpacing.paddingVerticalXl, const EdgeInsets.symmetric(vertical: 24.0));
      });
    });

    group('gap helpers', () {
      test('gapXs should be SizedBox with height 4', () {
        expect(AppSpacing.gapXs, isA<SizedBox>());
        expect(AppSpacing.gapXs.height, 4.0);
      });

      test('gapSm should be SizedBox with height 8', () {
        expect(AppSpacing.gapSm.height, 8.0);
      });

      test('gapMd should be SizedBox with height 12', () {
        expect(AppSpacing.gapMd.height, 12.0);
      });

      test('gapLg should be SizedBox with height 16', () {
        expect(AppSpacing.gapLg.height, 16.0);
      });

      test('gapXl should be SizedBox with height 24', () {
        expect(AppSpacing.gapXl.height, 24.0);
      });

      test('gapXxl should be SizedBox with height 32', () {
        expect(AppSpacing.gapXxl.height, 32.0);
      });

      test('gapHorizontalXs should be SizedBox with width 4', () {
        expect(AppSpacing.gapHorizontalXs.width, 4.0);
      });

      test('gapHorizontalSm should be SizedBox with width 8', () {
        expect(AppSpacing.gapHorizontalSm.width, 8.0);
      });

      test('gapHorizontalMd should be SizedBox with width 12', () {
        expect(AppSpacing.gapHorizontalMd.width, 12.0);
      });

      test('gapHorizontalLg should be SizedBox with width 16', () {
        expect(AppSpacing.gapHorizontalLg.width, 16.0);
      });

      test('gapHorizontalXl should be SizedBox with width 24', () {
        expect(AppSpacing.gapHorizontalXl.width, 24.0);
      });
    });

    group('border radius constants', () {
      test('borderRadiusSm should have 4px radius', () {
        expect(AppSpacing.borderRadiusSm, const BorderRadius.all(Radius.circular(4.0)));
      });

      test('borderRadiusMd should have 8px radius', () {
        expect(AppSpacing.borderRadiusMd, const BorderRadius.all(Radius.circular(8.0)));
      });

      test('borderRadiusLg should have 12px radius', () {
        expect(AppSpacing.borderRadiusLg, const BorderRadius.all(Radius.circular(12.0)));
      });

      test('borderRadiusXl should have 16px radius', () {
        expect(AppSpacing.borderRadiusXl, const BorderRadius.all(Radius.circular(16.0)));
      });

      test('borderRadiusFull should have 999px radius', () {
        expect(AppSpacing.borderRadiusFull, const BorderRadius.all(Radius.circular(999)));
      });
    });
  });
}
