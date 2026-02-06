import '../entities/calculation.dart';
import '../entities/operation.dart';
import '../repositories/calculator_repository.dart';

/// Set operation (+, -, *, /)
class SetOperationUseCase {
  SetOperationUseCase(this._repository);

  final CalculatorRepository _repository;

  Calculation call(Operation operation) {
    return _repository.setOperation(operation);
  }
}
