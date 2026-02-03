import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppButton', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: Center(child: child)),
      );
    }

    group('rendering', () {
      testWidgets('should render button with label', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(AppButton(onPressed: () {}, label: 'Test Button')),
        );

        expect(find.text('Test Button'), findsOneWidget);
      });

      testWidgets('should render button with icon', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(AppButton(onPressed: () {}, label: 'Test Button', icon: Icons.add)),
        );

        expect(find.byIcon(Icons.add), findsOneWidget);
      });

      testWidgets('should render loading indicator when isLoading is true', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(AppButton(onPressed: () {}, label: 'Test Button', isLoading: true)),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('variants', () {
      testWidgets('primary variant should render ElevatedButton', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(AppButton.primary(onPressed: () {}, label: 'Primary')),
        );

        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('secondary variant should render ElevatedButton', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(AppButton.secondary(onPressed: () {}, label: 'Secondary')),
        );

        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('text variant should render TextButton', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(AppButton.text(onPressed: () {}, label: 'Text')));

        expect(find.byType(TextButton), findsOneWidget);
      });

      testWidgets('outlined variant should render OutlinedButton', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(AppButton.outlined(onPressed: () {}, label: 'Outlined')),
        );

        expect(find.byType(OutlinedButton), findsOneWidget);
      });
    });

    group('interactions', () {
      testWidgets('should call onPressed when tapped', (WidgetTester tester) async {
        bool pressed = false;
        await tester.pumpWidget(
          createTestWidget(AppButton(onPressed: () => pressed = true, label: 'Test Button')),
        );

        await tester.tap(find.text('Test Button'));
        expect(pressed, true);
      });

      testWidgets('should not call onPressed when disabled', (WidgetTester tester) async {
        const bool pressed = false;
        await tester.pumpWidget(
          createTestWidget(const AppButton(onPressed: null, label: 'Disabled Button')),
        );

        await tester.tap(find.text('Disabled Button'));
        expect(pressed, false);
      });

      testWidgets('should not call onPressed when loading', (WidgetTester tester) async {
        bool pressed = false;
        await tester.pumpWidget(
          createTestWidget(
            AppButton(onPressed: () => pressed = true, label: 'Loading Button', isLoading: true),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();
        expect(pressed, false);
      });
    });

    group('sizes', () {
      testWidgets('should render small button', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(AppButton(onPressed: () {}, label: 'Small', size: AppButtonSize.small)),
        );

        expect(find.text('Small'), findsOneWidget);
      });

      testWidgets('should render medium button (default)', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(AppButton(onPressed: () {}, label: 'Medium')));

        expect(find.text('Medium'), findsOneWidget);
      });

      testWidgets('should render large button', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(AppButton(onPressed: () {}, label: 'Large', size: AppButtonSize.large)),
        );

        expect(find.text('Large'), findsOneWidget);
      });
    });

    group('expanded', () {
      testWidgets('should expand to full width when isExpanded is true', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(AppButton(onPressed: () {}, label: 'Expanded', isExpanded: true)),
        );

        final SizedBox sizedBox = tester.widget<SizedBox>(
          find.ancestor(of: find.byType(ElevatedButton), matching: find.byType(SizedBox)).first,
        );
        expect(sizedBox.width, double.infinity);
      });
    });

    group('semantics', () {
      testWidgets('should use label as default semantic label', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(AppButton(onPressed: () {}, label: 'Test Button')),
        );

        final Semantics semantics = tester.widget<Semantics>(
          find.ancestor(of: find.byType(ElevatedButton), matching: find.byType(Semantics)).first,
        );
        expect(semantics.properties.label, 'Test Button');
      });

      testWidgets('should use custom semantic label when provided', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            AppButton(onPressed: () {}, label: 'Test Button', semanticLabel: 'Custom Label'),
          ),
        );

        final Semantics semantics = tester.widget<Semantics>(
          find.ancestor(of: find.byType(ElevatedButton), matching: find.byType(Semantics)).first,
        );
        expect(semantics.properties.label, 'Custom Label');
      });
    });
  });

  group('AppButtonVariant', () {
    test('should have all expected values', () {
      expect(AppButtonVariant.values, contains(AppButtonVariant.primary));
      expect(AppButtonVariant.values, contains(AppButtonVariant.secondary));
      expect(AppButtonVariant.values, contains(AppButtonVariant.text));
      expect(AppButtonVariant.values, contains(AppButtonVariant.outlined));
    });
  });

  group('AppButtonSize', () {
    test('should have all expected values', () {
      expect(AppButtonSize.values, contains(AppButtonSize.small));
      expect(AppButtonSize.values, contains(AppButtonSize.medium));
      expect(AppButtonSize.values, contains(AppButtonSize.large));
    });
  });
}
