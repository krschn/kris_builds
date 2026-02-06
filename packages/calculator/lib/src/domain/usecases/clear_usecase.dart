import '../entities/calculation.dart';
import '../repositories/calculator_repository.dart';

/// Clear all calculator state (C button)
class ClearUseCase {
  ClearUseCase(this._repository);

  final CalculatorRepository _repository;

  Calculation call() {
    return _repository.clear();
  }
}
