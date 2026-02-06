import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:example_app/app.dart';
import 'package:example_app/core/di/injection.dart';
import 'package:example_app/core/storage/hive_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  patrolWidgetTest('Calculator complete flow', ($) async {
    // Initialize Hive storage
    await HiveService.init();

    // Start the app with DI
    await $.pumpWidgetAndSettle(
      MultiBlocProvider(
        providers: Injection.providers,
        child: const App(),
      ),
    );

    // Login first (auth required)
    await $(Key('emailField')).enterText('test@example.com');
    await $(Key('passwordField')).enterText('password123');
    await $(Key('loginButton')).tap();
    await $.pumpAndSettle();

    // Navigate to calculator tab
    await $(Icons.calculate).tap();
    await $.pumpAndSettle();

    // Verify initial display shows "0"
    expect($(Key('calculator_display')).text, contains('0'));

    // Test 1: Basic Addition - 2 + 3 = 5
    await $(Key('calculator_button_2')).tap();
    await $.pump();
    expect($(Key('calculator_display')).text, contains('2'));

    await $(Key('calculator_button_add')).tap();
    await $.pump();

    await $(Key('calculator_button_3')).tap();
    await $.pump();

    await $(Key('calculator_button_equals')).tap();
    await $.pumpAndSettle();
    expect($(Key('calculator_display')).text, contains('5'));

    // Test 2: Subtraction - C then 8 - 3 = 5
    await $(Key('calculator_button_clear')).tap();
    await $.pump();
    expect($(Key('calculator_display')).text, contains('0'));

    await $(Key('calculator_button_8')).tap();
    await $.pump();

    await $(Key('calculator_button_subtract')).tap();
    await $.pump();

    await $(Key('calculator_button_3')).tap();
    await $.pump();

    await $(Key('calculator_button_equals')).tap();
    await $.pumpAndSettle();
    expect($(Key('calculator_display')).text, contains('5'));

    // Test 3: Multiplication - C then 4 * 5 = 20
    await $(Key('calculator_button_clear')).tap();
    await $.pump();

    await $(Key('calculator_button_4')).tap();
    await $.pump();

    await $(Key('calculator_button_multiply')).tap();
    await $.pump();

    await $(Key('calculator_button_5')).tap();
    await $.pump();

    await $(Key('calculator_button_equals')).tap();
    await $.pumpAndSettle();
    expect($(Key('calculator_display')).text, contains('20'));

    // Test 4: Division - C then 10 / 2 = 5
    await $(Key('calculator_button_clear')).tap();
    await $.pump();

    await $(Key('calculator_button_1')).tap();
    await $.pump();
    await $(Key('calculator_button_0')).tap();
    await $.pump();

    await $(Key('calculator_button_divide')).tap();
    await $.pump();

    await $(Key('calculator_button_2')).tap();
    await $.pump();

    await $(Key('calculator_button_equals')).tap();
    await $.pumpAndSettle();
    expect($(Key('calculator_display')).text, contains('5'));

    // Test 5: Decimal Operation - C then 5.5 + 2.3 = 7.8
    await $(Key('calculator_button_clear')).tap();
    await $.pump();

    await $(Key('calculator_button_5')).tap();
    await $.pump();
    await $(Key('calculator_button_decimal')).tap();
    await $.pump();
    await $(Key('calculator_button_5')).tap();
    await $.pump();

    await $(Key('calculator_button_add')).tap();
    await $.pump();

    await $(Key('calculator_button_2')).tap();
    await $.pump();
    await $(Key('calculator_button_decimal')).tap();
    await $.pump();
    await $(Key('calculator_button_3')).tap();
    await $.pump();

    await $(Key('calculator_button_equals')).tap();
    await $.pumpAndSettle();
    expect($(Key('calculator_display')).text, contains('7.8'));

    // Test 6: Clear Entry (CE) - Start calculation and clear current entry
    await $(Key('calculator_button_clear')).tap();
    await $.pump();

    await $(Key('calculator_button_5')).tap();
    await $.pump();
    await $(Key('calculator_button_add')).tap();
    await $.pump();
    await $(Key('calculator_button_9')).tap();
    await $.pump();
    await $(Key('calculator_button_9')).tap();
    await $.pump();

    // Clear entry should remove the "99" but keep the operation
    await $(Key('calculator_button_clear_entry')).tap();
    await $.pump();

    // Now enter 3 and equals - should be 5 + 3 = 8
    await $(Key('calculator_button_3')).tap();
    await $.pump();
    await $(Key('calculator_button_equals')).tap();
    await $.pumpAndSettle();
    expect($(Key('calculator_display')).text, contains('8'));

    // Test 7: Division by zero error handling
    await $(Key('calculator_button_clear')).tap();
    await $.pump();

    await $(Key('calculator_button_5')).tap();
    await $.pump();
    await $(Key('calculator_button_divide')).tap();
    await $.pump();
    await $(Key('calculator_button_0')).tap();
    await $.pump();
    await $(Key('calculator_button_equals')).tap();
    await $.pumpAndSettle();

    // Verify error state (Error message should be displayed)
    expect($(Key('calculator_display')).text, contains('Error'));
  });
}
