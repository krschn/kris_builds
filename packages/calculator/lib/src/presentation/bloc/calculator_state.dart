import 'package:equatable/equatable.dart';
import '../../domain/entities/calculation.dart';

/// Calculator BLoC states
sealed class CalculatorState extends Equatable {
  const CalculatorState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Initial state showing "0"
final class CalculatorInitial extends CalculatorState {
  const CalculatorInitial();
}

/// Display state showing calculation or result
final class CalculatorDisplay extends CalculatorState {
  const CalculatorDisplay(this.calculation);

  final Calculation calculation;

  @override
  List<Object?> get props => <Object?>[calculation];
}

/// Error state (e.g., division by zero)
final class CalculatorError extends CalculatorState {
  const CalculatorError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
