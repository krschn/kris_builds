import '../entities/calculation.dart';
import '../repositories/calculator_repository.dart';

/// Clear current entry only (CE button)
class ClearEntryUseCase {
  ClearEntryUseCase(this._repository);

  final CalculatorRepository _repository;

  Calculation call() {
    return _repository.clearEntry();
  }
}
