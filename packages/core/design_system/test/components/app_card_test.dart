import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppCard', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: Center(child: child)),
      );
    }

    group('rendering', () {
      testWidgets('should render child content', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          const AppCard(
            child: Text('Card Content'),
          ),
        ));

        expect(find.text('Card Content'), findsOneWidget);
      });

      testWidgets('should render Card widget', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          const AppCard(
            child: Text('Card Content'),
          ),
        ));

        expect(find.byType(Card), findsOneWidget);
      });
    });

    group('variants', () {
      testWidgets('elevated variant should render Card', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          const AppCard.elevated(
            child: Text('Elevated'),
          ),
        ));

        expect(find.byType(Card), findsOneWidget);
      });

      testWidgets('outlined variant should render Card', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          const AppCard.outlined(
            child: Text('Outlined'),
          ),
        ));

        expect(find.byType(Card), findsOneWidget);
      });

      testWidgets('filled variant should render Card', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          const AppCard.filled(
            child: Text('Filled'),
          ),
        ));

        expect(find.byType(Card), findsOneWidget);
      });
    });

    group('interactions', () {
      testWidgets('should call onTap when tapped', (WidgetTester tester) async {
        bool tapped = false;
        await tester.pumpWidget(createTestWidget(
          AppCard(
            onTap: () => tapped = true,
            child: const Text('Tappable Card'),
          ),
        ));

        await tester.tap(find.text('Tappable Card'));
        expect(tapped, true);
      });

      testWidgets('should call onLongPress when long pressed', (WidgetTester tester) async {
        bool longPressed = false;
        await tester.pumpWidget(createTestWidget(
          AppCard(
            onLongPress: () => longPressed = true,
            child: const Text('Long Press Card'),
          ),
        ));

        await tester.longPress(find.text('Long Press Card'));
        expect(longPressed, true);
      });

      testWidgets('should render InkWell when onTap is provided', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          AppCard(
            onTap: () {},
            child: const Text('Tappable'),
          ),
        ));

        expect(find.byType(InkWell), findsOneWidget);
      });
    });

    group('padding and margin', () {
      testWidgets('should apply custom padding', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          const AppCard(
            padding: EdgeInsets.all(32),
            child: Text('Padded Card'),
          ),
        ));

        expect(find.text('Padded Card'), findsOneWidget);
      });

      testWidgets('should apply custom margin', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          const AppCard(
            margin: EdgeInsets.all(16),
            child: Text('Margined Card'),
          ),
        ));

        expect(find.text('Margined Card'), findsOneWidget);
      });
    });

    group('semantics', () {
      testWidgets('should apply semantic label', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          const AppCard(
            semanticLabel: 'Test Card',
            child: Text('Card Content'),
          ),
        ));

        expect(find.bySemanticsLabel('Test Card'), findsOneWidget);
      });
    });
  });

  group('AppCardVariant', () {
    test('should have all expected values', () {
      expect(AppCardVariant.values, contains(AppCardVariant.elevated));
      expect(AppCardVariant.values, contains(AppCardVariant.outlined));
      expect(AppCardVariant.values, contains(AppCardVariant.filled));
    });
  });
}
