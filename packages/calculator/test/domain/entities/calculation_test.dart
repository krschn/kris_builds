import 'package:calculator/src/domain/entities/calculation.dart';
import 'package:calculator/src/domain/entities/operation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Calculation Entity', () {
    test('initial state should display "0"', () {
      const calculation = Calculation();

      expect(calculation.displayText, '0');
      expect(calculation.currentNumber, '');
      expect(calculation.previousNumber, '');
      expect(calculation.operation, isNull);
      expect(calculation.result, isNull);
      expect(calculation.hasDecimal, false);
    });

    test('displayText should show current number when entered', () {
      const calculation = Calculation(currentNumber: '123');

      expect(calculation.displayText, '123');
    });

    test('displayText should show expression with operation', () {
      const calculation = Calculation(
        previousNumber: '5',
        operation: Operation.add,
        currentNumber: '3',
      );

      expect(calculation.displayText, '5 + 3');
    });

    test('displayText should show result when calculated', () {
      const calculation = Calculation(
        previousNumber: '5',
        operation: Operation.add,
        currentNumber: '3',
        result: 8.0,
      );

      expect(calculation.displayText, '8');
    });

    test('displayText should format integer results without decimal', () {
      const calculation = Calculation(result: 10.0);

      expect(calculation.displayText, '10');
    });

    test('displayText should show decimal results with decimals', () {
      const calculation = Calculation(result: 10.5);

      expect(calculation.displayText, '10.5');
    });

    test('copyWith should update fields correctly', () {
      const calculation = Calculation(currentNumber: '5');
      final updated = calculation.copyWith(currentNumber: '10');

      expect(updated.currentNumber, '10');
    });

    test('copyWith should clear operation when clearOperation is true', () {
      const calculation = Calculation(operation: Operation.add);
      final updated = calculation.copyWith(clearOperation: true);

      expect(updated.operation, isNull);
    });

    test('copyWith should clear result when clearResult is true', () {
      const calculation = Calculation(result: 42.0);
      final updated = calculation.copyWith(clearResult: true);

      expect(updated.result, isNull);
    });
  });
}
