import '../entities/calculation.dart';
import '../entities/operation.dart';

/// Repository interface for calculator operations
abstract class CalculatorRepository {
  /// Get current calculation state
  Calculation getCurrentCalculation();

  /// Append a number (0-9) to current entry
  Calculation appendNumber(String number);

  /// Append decimal point
  Calculation appendDecimal();

  /// Set operation (+, -, *, /)
  Calculation setOperation(Operation operation);

  /// Calculate result
  Calculation calculate();

  /// Clear all (C button)
  Calculation clear();

  /// Clear current entry only (CE button)
  Calculation clearEntry();
}
