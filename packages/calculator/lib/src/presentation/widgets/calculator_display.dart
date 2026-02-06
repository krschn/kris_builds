import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

/// Calculator display widget showing current calculation or result
class CalculatorDisplayWidget extends StatelessWidget {
  const CalculatorDisplayWidget({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Container(
        width: double.infinity,
        padding: AppSpacing.paddingLg,
        child: Text(
          text,
          style: AppTypography.headlineSmall().copyWith(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}
