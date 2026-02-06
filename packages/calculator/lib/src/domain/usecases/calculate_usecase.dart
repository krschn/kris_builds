import '../entities/calculation.dart';
import '../repositories/calculator_repository.dart';

/// Calculate result of pending operation
class CalculateUseCase {
  CalculateUseCase(this._repository);

  final CalculatorRepository _repository;

  Calculation call() {
    return _repository.calculate();
  }
}
