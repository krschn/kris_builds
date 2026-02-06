import '../entities/calculation.dart';
import '../repositories/calculator_repository.dart';

/// Append a number (0-9) to current calculation
class AppendNumberUseCase {
  AppendNumberUseCase(this._repository);

  final CalculatorRepository _repository;

  Calculation call(String number) {
    return _repository.appendNumber(number);
  }
}
