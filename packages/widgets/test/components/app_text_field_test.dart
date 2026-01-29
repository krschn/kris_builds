import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets/widgets.dart';

void main() {
  group('AppTextField', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: Center(child: child)),
      );
    }

    group('rendering', () {
      testWidgets('should render TextField', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(const AppTextField()));

        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('should render with label', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(const AppTextField(label: 'Email')));

        expect(find.text('Email'), findsOneWidget);
      });

      testWidgets('should render with hint', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(const AppTextField(hint: 'Enter email')));

        expect(find.text('Enter email'), findsOneWidget);
      });

      testWidgets('should render with error text', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(const AppTextField(errorText: 'Invalid email')));

        expect(find.text('Invalid email'), findsOneWidget);
      });

      testWidgets('should render with helper text', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(const AppTextField(helperText: 'Enter a valid email')),
        );

        expect(find.text('Enter a valid email'), findsOneWidget);
      });

      testWidgets('should render with prefix icon', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(const AppTextField(prefixIcon: Icons.email)));

        expect(find.byIcon(Icons.email), findsOneWidget);
      });

      testWidgets('should render with suffix icon', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(const AppTextField(suffixIcon: Icons.clear)));

        expect(find.byIcon(Icons.clear), findsOneWidget);
      });
    });

    group('email variant', () {
      testWidgets('should configure for email input', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(const AppTextField.email()));

        expect(find.byType(TextField), findsOneWidget);
      });
    });

    group('multiline variant', () {
      testWidgets('should configure for multiline input', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(const AppTextField.multiline(label: 'Description')),
        );

        expect(find.byType(TextField), findsOneWidget);
      });
    });

    group('interactions', () {
      testWidgets('should call onChanged when text changes', (WidgetTester tester) async {
        String? changedValue;
        await tester.pumpWidget(
          createTestWidget(AppTextField(onChanged: (String value) => changedValue = value)),
        );

        await tester.enterText(find.byType(TextField), 'test');
        expect(changedValue, 'test');
      });

      testWidgets('should call onSubmitted when submitted', (WidgetTester tester) async {
        String? submittedValue;
        await tester.pumpWidget(
          createTestWidget(AppTextField(onSubmitted: (String value) => submittedValue = value)),
        );

        await tester.enterText(find.byType(TextField), 'test');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        expect(submittedValue, 'test');
      });
    });

    group('controller', () {
      testWidgets('should use provided controller', (WidgetTester tester) async {
        final TextEditingController controller = TextEditingController(text: 'initial');
        await tester.pumpWidget(createTestWidget(AppTextField(controller: controller)));

        expect(find.text('initial'), findsOneWidget);

        controller.dispose();
      });
    });

    group('disabled state', () {
      testWidgets('should be disabled when enabled is false', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(const AppTextField(enabled: false)));

        final TextField textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.enabled, false);
      });
    });

    group('readOnly state', () {
      testWidgets('should be readOnly when readOnly is true', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(const AppTextField(readOnly: true)));

        final TextField textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.readOnly, true);
      });
    });

    group('obscureText', () {
      testWidgets('should obscure text when obscureText is true', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(const AppTextField(obscureText: true)));

        final TextField textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.obscureText, true);
      });
    });
  });

  group('AppPasswordField', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: Center(child: child)),
      );
    }

    testWidgets('should initially obscure text', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const AppPasswordField()));

      final TextField textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, true);
    });

    testWidgets('should toggle visibility when icon is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const AppPasswordField()));

      // Initially obscured
      TextField textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, true);

      // Find and tap the visibility icon
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // Now visible
      textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, false);

      // Tap again to obscure
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, true);
    });
  });
}
