import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

/// Calculator button wrapping AppButton with calculator-specific styling
class CalculatorButton extends StatelessWidget {
  const CalculatorButton({
    required this.label,
    required this.onPressed,
    this.variant = CalculatorButtonVariant.number,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final CalculatorButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      variant: _getButtonVariant(),
      size: AppButtonSize.large,
    );
  }

  AppButtonVariant _getButtonVariant() {
    return switch (variant) {
      CalculatorButtonVariant.number => AppButtonVariant.primary,
      CalculatorButtonVariant.operation => AppButtonVariant.secondary,
      CalculatorButtonVariant.clear => AppButtonVariant.outlined,
      CalculatorButtonVariant.equals => AppButtonVariant.primary,
    };
  }
}

/// Calculator button variants
enum CalculatorButtonVariant {
  /// Number buttons (0-9)
  number,

  /// Operation buttons (+, -, *, /)
  operation,

  /// Clear buttons (C, CE)
  clear,

  /// Equals button
  equals,
}
