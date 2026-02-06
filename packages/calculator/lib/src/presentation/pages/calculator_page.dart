import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';
import '../../domain/entities/operation.dart';
import '../bloc/calculator_bloc.dart';
import '../bloc/calculator_event.dart';
import '../bloc/calculator_state.dart';
import '../widgets/calculator_button.dart';
import '../widgets/calculator_display.dart';

/// Calculator page with full calculator UI
class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalculatorBloc, CalculatorState>(
      listener: (BuildContext context, CalculatorState state) {
        if (state is CalculatorError) {
          AppSnackbar.error(
            context: context,
            message: state.message,
          );
        }
      },
      child: AppScaffold(
        appBar: AppBar(
          title: const Text('Calculator'),
        ),
        body: Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          children: <Widget>[
            // Display
            BlocBuilder<CalculatorBloc, CalculatorState>(
              builder: (BuildContext context, CalculatorState state) {
                final String displayText = switch (state) {
                  CalculatorInitial() => '0',
                  CalculatorDisplay(:final calculation) =>
                    calculation.displayText,
                  CalculatorError() => 'Error',
                };

                return CalculatorDisplayWidget(
                  key: const Key('calculator_display'),
                  text: displayText,
                );
              },
            ),
            AppSpacing.gapLg,

            // Button grid
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return GridView.count(
                    crossAxisCount: 4,
                    childAspectRatio: 1.2,
                    mainAxisSpacing: AppSpacing.sm,
                    crossAxisSpacing: AppSpacing.sm,
                    children: <Widget>[
                      // Row 1: C, CE, ←, /
                      _buildButton(
                        context,
                        'C',
                        const ClearPressed(),
                        CalculatorButtonVariant.clear,
                      ),
                      _buildButton(
                        context,
                        'CE',
                        const ClearEntryPressed(),
                        CalculatorButtonVariant.clear,
                      ),
                      Container(), // Empty space for backspace (future)
                      _buildButton(
                        context,
                        '/',
                        OperationPressed(Operation.divide),
                        CalculatorButtonVariant.operation,
                      ),

                      // Row 2: 7, 8, 9, *
                      _buildButton(context, '7', const NumberPressed('7')),
                      _buildButton(context, '8', const NumberPressed('8')),
                      _buildButton(context, '9', const NumberPressed('9')),
                      _buildButton(
                        context,
                        '*',
                        OperationPressed(Operation.multiply),
                        CalculatorButtonVariant.operation,
                      ),

                      // Row 3: 4, 5, 6, -
                      _buildButton(context, '4', const NumberPressed('4')),
                      _buildButton(context, '5', const NumberPressed('5')),
                      _buildButton(context, '6', const NumberPressed('6')),
                      _buildButton(
                        context,
                        '-',
                        OperationPressed(Operation.subtract),
                        CalculatorButtonVariant.operation,
                      ),

                      // Row 4: 1, 2, 3, +
                      _buildButton(context, '1', const NumberPressed('1')),
                      _buildButton(context, '2', const NumberPressed('2')),
                      _buildButton(context, '3', const NumberPressed('3')),
                      _buildButton(
                        context,
                        '+',
                        OperationPressed(Operation.add),
                        CalculatorButtonVariant.operation,
                      ),

                      // Row 5: 0 (wide), ., =
                      _buildButton(context, '0', const NumberPressed('0')),
                      Container(), // Empty to make 0 appear centered
                      _buildButton(context, '.', const DecimalPressed()),
                      _buildButton(
                        context,
                        '=',
                        const EqualsPressed(),
                        CalculatorButtonVariant.equals,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String label,
    CalculatorEvent event, [
    CalculatorButtonVariant variant = CalculatorButtonVariant.number,
  ]) {
    // Create key from label
    final String keyName = 'calculator_button_${_getKeyName(label)}';

    return CalculatorButton(
      key: Key(keyName),
      label: label,
      variant: variant,
      onPressed: () => context.read<CalculatorBloc>().add(event),
    );
  }

  String _getKeyName(String label) {
    return switch (label) {
      '0' => '0',
      '1' => '1',
      '2' => '2',
      '3' => '3',
      '4' => '4',
      '5' => '5',
      '6' => '6',
      '7' => '7',
      '8' => '8',
      '9' => '9',
      '+' => 'add',
      '-' => 'subtract',
      '*' => 'multiply',
      '/' => 'divide',
      '=' => 'equals',
      'C' => 'clear',
      'CE' => 'clear_entry',
      '.' => 'decimal',
      _ => label.toLowerCase(),
    };
  }
}
