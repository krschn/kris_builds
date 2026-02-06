import 'package:equatable/equatable.dart';
import '../../domain/entities/operation.dart';

/// Calculator BLoC events
sealed class CalculatorEvent extends Equatable {
  const CalculatorEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Number button pressed (0-9)
final class NumberPressed extends CalculatorEvent {
  const NumberPressed(this.number);

  final String number;

  @override
  List<Object?> get props => <Object?>[number];
}

/// Decimal point button pressed
final class DecimalPressed extends CalculatorEvent {
  const DecimalPressed();
}

/// Operation button pressed (+, -, *, /)
final class OperationPressed extends CalculatorEvent {
  const OperationPressed(this.operation);

  final Operation operation;

  @override
  List<Object?> get props => <Object?>[operation];
}

/// Equals button pressed
final class EqualsPressed extends CalculatorEvent {
  const EqualsPressed();
}

/// Clear button pressed (C)
final class ClearPressed extends CalculatorEvent {
  const ClearPressed();
}

/// Clear entry button pressed (CE)
final class ClearEntryPressed extends CalculatorEvent {
  const ClearEntryPressed();
}
