import 'data/datasources/calculator_datasource.dart';
import 'data/repositories/calculator_repository_impl.dart';
import 'domain/repositories/calculator_repository.dart';
import 'domain/usecases/append_decimal_usecase.dart';
import 'domain/usecases/append_number_usecase.dart';
import 'domain/usecases/calculate_usecase.dart';
import 'domain/usecases/clear_entry_usecase.dart';
import 'domain/usecases/clear_usecase.dart';
import 'domain/usecases/set_operation_usecase.dart';
import 'presentation/bloc/calculator_bloc.dart';

/// Calculator module for dependency injection
class CalculatorModule {
  CalculatorModule({CalculatorDataSource? dataSource}) {
    // Data layer
    _dataSource = dataSource ?? CalculatorDataSource();
    _repository = CalculatorRepositoryImpl(_dataSource);

    // Use cases
    _appendNumberUseCase = AppendNumberUseCase(_repository);
    _appendDecimalUseCase = AppendDecimalUseCase(_repository);
    _setOperationUseCase = SetOperationUseCase(_repository);
    _calculateUseCase = CalculateUseCase(_repository);
    _clearUseCase = ClearUseCase(_repository);
    _clearEntryUseCase = ClearEntryUseCase(_repository);
  }

  late final CalculatorDataSource _dataSource;
  late final CalculatorRepository _repository;
  late final AppendNumberUseCase _appendNumberUseCase;
  late final AppendDecimalUseCase _appendDecimalUseCase;
  late final SetOperationUseCase _setOperationUseCase;
  late final CalculateUseCase _calculateUseCase;
  late final ClearUseCase _clearUseCase;
  late final ClearEntryUseCase _clearEntryUseCase;

  /// Public repository accessor
  CalculatorRepository get repository => _repository;

  /// Create CalculatorBloc instance
  CalculatorBloc createCalculatorBloc() {
    return CalculatorBloc(
      appendNumberUseCase: _appendNumberUseCase,
      appendDecimalUseCase: _appendDecimalUseCase,
      setOperationUseCase: _setOperationUseCase,
      calculateUseCase: _calculateUseCase,
      clearUseCase: _clearUseCase,
      clearEntryUseCase: _clearEntryUseCase,
    );
  }
}
