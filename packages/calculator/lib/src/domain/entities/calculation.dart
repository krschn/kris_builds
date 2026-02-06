import 'package:equatable/equatable.dart';
import 'operation.dart';

/// Core calculator state entity
class Calculation extends Equatable {
  const Calculation({
    this.currentNumber = '',
    this.previousNumber = '',
    this.operation,
    this.result,
    this.hasDecimal = false,
  });

  final String currentNumber;
  final String previousNumber;
  final Operation? operation;
  final double? result;
  final bool hasDecimal;

  /// Display text showing current calculation expression
  String get displayText {
    if (result != null) {
      return _formatNumber(result!);
    }

    if (currentNumber.isEmpty && previousNumber.isEmpty) {
      return '0';
    }

    if (operation != null && currentNumber.isNotEmpty) {
      return '$previousNumber ${operation!.symbol} $currentNumber';
    }

    if (operation != null) {
      return '$previousNumber ${operation!.symbol}';
    }

    return currentNumber.isEmpty ? '0' : currentNumber;
  }

  /// Result text for display (if calculation is complete)
  String? get resultText {
    return result != null ? _formatNumber(result!) : null;
  }

  String _formatNumber(double value) {
    // Remove unnecessary trailing zeros and decimal point
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  Calculation copyWith({
    String? currentNumber,
    String? previousNumber,
    Operation? operation,
    double? result,
    bool? hasDecimal,
    bool clearOperation = false,
    bool clearResult = false,
  }) {
    return Calculation(
      currentNumber: currentNumber ?? this.currentNumber,
      previousNumber: previousNumber ?? this.previousNumber,
      operation: clearOperation ? null : (operation ?? this.operation),
      result: clearResult ? null : (result ?? this.result),
      hasDecimal: hasDecimal ?? this.hasDecimal,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        currentNumber,
        previousNumber,
        operation,
        result,
        hasDecimal,
      ];
}
