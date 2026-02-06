import 'package:bloc/bloc.dart';
import '../../domain/entities/calculation.dart';
import '../../domain/usecases/append_decimal_usecase.dart';
import '../../domain/usecases/append_number_usecase.dart';
import '../../domain/usecases/calculate_usecase.dart';
import '../../domain/usecases/clear_entry_usecase.dart';
import '../../domain/usecases/clear_usecase.dart';
import '../../domain/usecases/set_operation_usecase.dart';
import 'calculator_event.dart';
import 'calculator_state.dart';

/// Calculator BLoC
class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc({
    required AppendNumberUseCase appendNumberUseCase,
    required AppendDecimalUseCase appendDecimalUseCase,
    required SetOperationUseCase setOperationUseCase,
    required CalculateUseCase calculateUseCase,
    required ClearUseCase clearUseCase,
    required ClearEntryUseCase clearEntryUseCase,
  })  : _appendNumberUseCase = appendNumberUseCase,
        _appendDecimalUseCase = appendDecimalUseCase,
        _setOperationUseCase = setOperationUseCase,
        _calculateUseCase = calculateUseCase,
        _clearUseCase = clearUseCase,
        _clearEntryUseCase = clearEntryUseCase,
        super(const CalculatorInitial()) {
    on<NumberPressed>(_onNumberPressed);
    on<DecimalPressed>(_onDecimalPressed);
    on<OperationPressed>(_onOperationPressed);
    on<EqualsPressed>(_onEqualsPressed);
    on<ClearPressed>(_onClearPressed);
    on<ClearEntryPressed>(_onClearEntryPressed);
  }

  final AppendNumberUseCase _appendNumberUseCase;
  final AppendDecimalUseCase _appendDecimalUseCase;
  final SetOperationUseCase _setOperationUseCase;
  final CalculateUseCase _calculateUseCase;
  final ClearUseCase _clearUseCase;
  final ClearEntryUseCase _clearEntryUseCase;

  Future<void> _onNumberPressed(
    NumberPressed event,
    Emitter<CalculatorState> emit,
  ) async {
    try {
      final Calculation calculation = _appendNumberUseCase(event.number);
      emit(CalculatorDisplay(calculation));
    } catch (e) {
      emit(CalculatorError(e.toString()));
    }
  }

  Future<void> _onDecimalPressed(
    DecimalPressed event,
    Emitter<CalculatorState> emit,
  ) async {
    try {
      final Calculation calculation = _appendDecimalUseCase();
      emit(CalculatorDisplay(calculation));
    } catch (e) {
      emit(CalculatorError(e.toString()));
    }
  }

  Future<void> _onOperationPressed(
    OperationPressed event,
    Emitter<CalculatorState> emit,
  ) async {
    try {
      final Calculation calculation = _setOperationUseCase(event.operation);
      emit(CalculatorDisplay(calculation));
    } catch (e) {
      emit(CalculatorError(e.toString()));
    }
  }

  Future<void> _onEqualsPressed(
    EqualsPressed event,
    Emitter<CalculatorState> emit,
  ) async {
    try {
      final Calculation calculation = _calculateUseCase();
      emit(CalculatorDisplay(calculation));
    } catch (e) {
      emit(CalculatorError(e.toString()));
    }
  }

  Future<void> _onClearPressed(
    ClearPressed event,
    Emitter<CalculatorState> emit,
  ) async {
    try {
      final Calculation calculation = _clearUseCase();
      emit(CalculatorDisplay(calculation));
    } catch (e) {
      emit(CalculatorError(e.toString()));
    }
  }

  Future<void> _onClearEntryPressed(
    ClearEntryPressed event,
    Emitter<CalculatorState> emit,
  ) async {
    try {
      final Calculation calculation = _clearEntryUseCase();
      emit(CalculatorDisplay(calculation));
    } catch (e) {
      emit(CalculatorError(e.toString()));
    }
  }
}
