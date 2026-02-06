import '../../domain/entities/calculation.dart';
import '../../domain/entities/operation.dart';
import '../../domain/repositories/calculator_repository.dart';
import '../datasources/calculator_datasource.dart';

/// Calculator repository implementation
class CalculatorRepositoryImpl implements CalculatorRepository {
  CalculatorRepositoryImpl(this._dataSource);

  final CalculatorDataSource _dataSource;

  @override
  Calculation getCurrentCalculation() {
    return _dataSource.getCurrentCalculation();
  }

  @override
  Calculation appendNumber(String number) {
    return _dataSource.appendNumber(number);
  }

  @override
  Calculation appendDecimal() {
    return _dataSource.appendDecimal();
  }

  @override
  Calculation setOperation(Operation operation) {
    return _dataSource.setOperation(operation);
  }

  @override
  Calculation calculate() {
    return _dataSource.calculate();
  }

  @override
  Calculation clear() {
    return _dataSource.clear();
  }

  @override
  Calculation clearEntry() {
    return _dataSource.clearEntry();
  }
}
