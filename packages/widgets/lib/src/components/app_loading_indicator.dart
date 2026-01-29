import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// A customizable loading indicator widget.
///
/// Provides circular and linear progress indicators with
/// consistent styling from the theme.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.size = AppLoadingSize.medium,
    this.color,
    this.value,
    this.semanticLabel,
  }) : _isLinear = false;

  /// Creates a linear progress indicator
  const AppLoadingIndicator.linear({super.key, this.color, this.value, this.semanticLabel})
    : size = AppLoadingSize.medium,
      _isLinear = true;

  final AppLoadingSize size;
  final Color? color;
  final double? value;
  final String? semanticLabel;
  final bool _isLinear;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color effectiveColor = color ?? theme.colorScheme.primary;

    if (_isLinear) {
      return Semantics(
        label: semanticLabel ?? 'Loading',
        child: LinearProgressIndicator(
          value: value,
          color: effectiveColor,
          backgroundColor: effectiveColor.withValues(alpha: 0.2),
        ),
      );
    }

    final double indicatorSize = _getSize();
    final double strokeWidth = _getStrokeWidth();

    return Semantics(
      label: semanticLabel ?? 'Loading',
      child: SizedBox(
        width: indicatorSize,
        height: indicatorSize,
        child: CircularProgressIndicator(
          value: value,
          strokeWidth: strokeWidth,
          color: effectiveColor,
        ),
      ),
    );
  }

  double _getSize() {
    switch (size) {
      case AppLoadingSize.small:
        return 16;
      case AppLoadingSize.medium:
        return 24;
      case AppLoadingSize.large:
        return 40;
    }
  }

  double _getStrokeWidth() {
    switch (size) {
      case AppLoadingSize.small:
        return 2;
      case AppLoadingSize.medium:
        return 3;
      case AppLoadingSize.large:
        return 4;
    }
  }
}

/// A full-screen loading overlay
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    super.key,
    this.message,
    this.color,
    this.backgroundColor,
    this.semanticLabel,
  });

  final String? message;
  final Color? color;
  final Color? backgroundColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      label: semanticLabel ?? message ?? 'Loading',
      child: ColoredBox(
        color: backgroundColor ?? theme.colorScheme.surface.withValues(alpha: 0.9),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppLoadingIndicator(size: AppLoadingSize.large, color: color),
              if (message != null) ...<Widget>[
                AppSpacing.gapLg,
                Text(
                  message!,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Loading indicator size options
enum AppLoadingSize { small, medium, large }
