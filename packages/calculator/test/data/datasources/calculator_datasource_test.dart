import 'package:calculator/src/data/datasources/calculator_datasource.dart';
import 'package:calculator/src/domain/entities/calculation.dart';
import 'package:calculator/src/domain/entities/operation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CalculatorDataSource dataSource;

  setUp(() {
    dataSource = CalculatorDataSource();
  });

  group('CalculatorDataSource', () {
    group('appendNumber', () {
      test('should append number to empty current number', () {
        final Calculation result = dataSource.appendNumber('5');

        expect(result.currentNumber, '5');
      });

      test('should append multiple numbers', () {
        dataSource.appendNumber('1');
        dataSource.appendNumber('2');
        final Calculation result = dataSource.appendNumber('3');

        expect(result.currentNumber, '123');
      });

      test('should start new calculation after showing result', () {
        dataSource.appendNumber('5');
        dataSource.setOperation(Operation.add);
        dataSource.appendNumber('3');
        dataSource.calculate(); // Result is 8

        final Calculation result = dataSource.appendNumber('2');

        expect(result.currentNumber, '2');
        expect(result.previousNumber, '');
        expect(result.result, isNull);
      });
    });

    group('appendDecimal', () {
      test('should append decimal to empty number', () {
        final Calculation result = dataSource.appendDecimal();

        expect(result.currentNumber, '0.');
        expect(result.hasDecimal, true);
      });

      test('should append decimal to existing number', () {
        dataSource.appendNumber('5');
        final Calculation result = dataSource.appendDecimal();

        expect(result.currentNumber, '5.');
        expect(result.hasDecimal, true);
      });

      test('should not append second decimal', () {
        dataSource.appendNumber('5');
        dataSource.appendDecimal();
        final Calculation result = dataSource.appendDecimal();

        expect(result.currentNumber, '5.');
        expect(result.hasDecimal, true);
      });

      test('should start new calculation with 0. after result', () {
        dataSource.appendNumber('5');
        dataSource.setOperation(Operation.add);
        dataSource.appendNumber('3');
        dataSource.calculate(); // Result is 8

        final Calculation result = dataSource.appendDecimal();

        expect(result.currentNumber, '0.');
        expect(result.hasDecimal, true);
        expect(result.result, isNull);
      });
    });

    group('setOperation', () {
      test('should set operation and move current to previous', () {
        dataSource.appendNumber('5');
        final Calculation result = dataSource.setOperation(Operation.add);

        expect(result.previousNumber, '5');
        expect(result.currentNumber, '');
        expect(result.operation, Operation.add);
        expect(result.hasDecimal, false);
      });

      test('should calculate pending operation before setting new one', () {
        dataSource.appendNumber('5');
        dataSource.setOperation(Operation.add);
        dataSource.appendNumber('3');
        final Calculation result = dataSource.setOperation(Operation.multiply);

        expect(result.result, 8.0);
        expect(result.previousNumber, '8.0');
        expect(result.operation, Operation.multiply);
        expect(result.currentNumber, '');
      });
    });

    group('calculate', () {
      test('should calculate addition', () {
        dataSource.appendNumber('5');
        dataSource.setOperation(Operation.add);
        dataSource.appendNumber('3');
        final Calculation result = dataSource.calculate();

        expect(result.result, 8.0);
      });

      test('should calculate subtraction', () {
        dataSource.appendNumber('10');
        dataSource.setOperation(Operation.subtract);
        dataSource.appendNumber('3');
        final Calculation result = dataSource.calculate();

        expect(result.result, 7.0);
      });

      test('should calculate multiplication', () {
        dataSource.appendNumber('4');
        dataSource.setOperation(Operation.multiply);
        dataSource.appendNumber('5');
        final Calculation result = dataSource.calculate();

        expect(result.result, 20.0);
      });

      test('should calculate division', () {
        dataSource.appendNumber('10');
        dataSource.setOperation(Operation.divide);
        dataSource.appendNumber('2');
        final Calculation result = dataSource.calculate();

        expect(result.result, 5.0);
      });

      test('should throw exception on division by zero', () {
        dataSource.appendNumber('5');
        dataSource.setOperation(Operation.divide);
        dataSource.appendNumber('0');

        expect(() => dataSource.calculate(), throwsException);
      });

      test('should handle decimal operations', () {
        dataSource.appendNumber('5');
        dataSource.appendDecimal();
        dataSource.appendNumber('5');
        dataSource.setOperation(Operation.add);
        dataSource.appendNumber('2');
        dataSource.appendDecimal();
        dataSource.appendNumber('3');
        final Calculation result = dataSource.calculate();

        expect(result.result, 7.8);
      });
    });

    group('clear', () {
      test('should reset to initial state', () {
        dataSource.appendNumber('5');
        dataSource.setOperation(Operation.add);
        dataSource.appendNumber('3');
        final Calculation result = dataSource.clear();

        expect(result.currentNumber, '');
        expect(result.previousNumber, '');
        expect(result.operation, isNull);
        expect(result.result, isNull);
        expect(result.hasDecimal, false);
      });
    });

    group('clearEntry', () {
      test('should clear only current entry', () {
        dataSource.appendNumber('5');
        dataSource.setOperation(Operation.add);
        dataSource.appendNumber('3');
        final Calculation result = dataSource.clearEntry();

        expect(result.currentNumber, '');
        expect(result.previousNumber, '5');
        expect(result.operation, Operation.add);
        expect(result.hasDecimal, false);
      });
    });
  });
}
