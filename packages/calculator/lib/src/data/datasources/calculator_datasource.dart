import '../../domain/entities/calculation.dart';
import '../../domain/entities/operation.dart';

/// Calculator data source managing state and arithmetic
class CalculatorDataSource {
  Calculation _calculation = const Calculation();

  /// Get current calculation state
  Calculation getCurrentCalculation() => _calculation;

  /// Append a number (0-9) to current entry
  Calculation appendNumber(String number) {
    // If showing result, start new calculation
    if (_calculation.result != null) {
      _calculation = Calculation(currentNumber: number);
      return _calculation;
    }

    _calculation = _calculation.copyWith(
      currentNumber: _calculation.currentNumber + number,
    );
    return _calculation;
  }

  /// Append decimal point
  Calculation appendDecimal() {
    // Can't add decimal if already has one
    if (_calculation.hasDecimal) {
      return _calculation;
    }

    // If showing result, start new calculation with "0."
    if (_calculation.result != null) {
      _calculation = const Calculation(currentNumber: '0.', hasDecimal: true);
      return _calculation;
    }

    final String current = _calculation.currentNumber.isEmpty
        ? '0.'
        : '${_calculation.currentNumber}.';

    _calculation = _calculation.copyWith(
      currentNumber: current,
      hasDecimal: true,
    );
    return _calculation;
  }

  /// Set operation (+, -, *, /)
  Calculation setOperation(Operation operation) {
    // If there's a pending calculation, execute it first
    if (_calculation.operation != null &&
        _calculation.currentNumber.isNotEmpty) {
      _calculation = _executeCalculation();
    }

    // Move current number to previous, set operation
    final String previous = _calculation.result?.toString() ??
        (_calculation.currentNumber.isEmpty
            ? _calculation.previousNumber
            : _calculation.currentNumber);

    _calculation = _calculation.copyWith(
      previousNumber: previous,
      currentNumber: '',
      operation: operation,
      hasDecimal: false,
    );

    return _calculation;
  }

  /// Calculate result
  Calculation calculate() {
    return _executeCalculation();
  }

  /// Clear all (C button)
  Calculation clear() {
    _calculation = const Calculation();
    return _calculation;
  }

  /// Clear current entry only (CE button)
  Calculation clearEntry() {
    _calculation = _calculation.copyWith(
      currentNumber: '',
      hasDecimal: false,
    );
    return _calculation;
  }

  /// Execute pending calculation
  Calculation _executeCalculation() {
    if (_calculation.operation == null ||
        _calculation.currentNumber.isEmpty) {
      return _calculation;
    }

    final double? previous = double.tryParse(_calculation.previousNumber);
    final double? current = double.tryParse(_calculation.currentNumber);

    if (previous == null || current == null) {
      return _calculation;
    }

    double result;
    switch (_calculation.operation!) {
      case Operation.add:
        result = previous + current;
      case Operation.subtract:
        result = previous - current;
      case Operation.multiply:
        result = previous * current;
      case Operation.divide:
        if (current == 0) {
          throw Exception('Cannot divide by zero');
        }
        result = previous / current;
    }

    _calculation = _calculation.copyWith(
      result: result,
      hasDecimal: false,
    );

    return _calculation;
  }
}
