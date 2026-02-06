import '../entities/calculation.dart';
import '../repositories/calculator_repository.dart';

/// Append decimal point to current calculation
class AppendDecimalUseCase {
  AppendDecimalUseCase(this._repository);

  final CalculatorRepository _repository;

  Calculation call() {
    return _repository.appendDecimal();
  }
}
