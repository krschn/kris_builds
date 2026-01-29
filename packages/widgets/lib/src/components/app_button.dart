import 'package:flutter/material.dart';

/// A customizable button widget with semantic variants.
///
/// Provides primary, secondary, text, and outlined variants with
/// consistent styling from the theme.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.semanticLabel,
  });

  /// Creates an outlined button (border only)
  const AppButton.outlined({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.semanticLabel,
    this.size = AppButtonSize.medium,
  }) : variant = AppButtonVariant.outlined;

  /// Creates a primary button (filled with primary color)
  const AppButton.primary({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.semanticLabel,
    this.size = AppButtonSize.medium,
  }) : variant = AppButtonVariant.primary;

  /// Creates a secondary button (filled with secondary color)
  const AppButton.secondary({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.semanticLabel,
    this.size = AppButtonSize.medium,
  }) : variant = AppButtonVariant.secondary;

  /// Creates a text button (no background)
  const AppButton.text({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.semanticLabel,
    this.size = AppButtonSize.medium,
  }) : variant = AppButtonVariant.text;

  final VoidCallback? onPressed;
  final String label;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final Widget buttonChild = Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (isLoading)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  variant == AppButtonVariant.primary || variant == AppButtonVariant.secondary
                      ? colorScheme.onPrimary
                      : colorScheme.primary,
                ),
              ),
            ),
          )
        else if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(icon, size: size == AppButtonSize.small ? 16 : 20),
          ),
        Text(label),
      ],
    );

    Widget button;
    final Size minimumSize = _getMinimumSize();
    final TextStyle? textStyle = _getTextStyle(context);

    switch (variant) {
      case AppButtonVariant.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(minimumSize: minimumSize, textStyle: textStyle),
          child: buttonChild,
        );
      case AppButtonVariant.secondary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: minimumSize,
            backgroundColor: colorScheme.secondary,
            foregroundColor: colorScheme.onSecondary,
            textStyle: textStyle,
          ),
          child: buttonChild,
        );
      case AppButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(minimumSize: minimumSize, textStyle: textStyle),
          child: buttonChild,
        );
      case AppButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(minimumSize: minimumSize, textStyle: textStyle),
          child: buttonChild,
        );
    }

    if (isExpanded) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return Semantics(
      button: true,
      enabled: onPressed != null && !isLoading,
      label: semanticLabel ?? label,
      child: button,
    );
  }

  Size _getMinimumSize() {
    switch (size) {
      case AppButtonSize.small:
        return const Size(64, 36);
      case AppButtonSize.medium:
        return const Size(88, 48);
      case AppButtonSize.large:
        return const Size(120, 56);
    }
  }

  TextStyle? _getTextStyle(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    switch (size) {
      case AppButtonSize.small:
        return theme.textTheme.labelMedium;
      case AppButtonSize.medium:
        return theme.textTheme.labelLarge;
      case AppButtonSize.large:
        return theme.textTheme.titleMedium;
    }
  }
}

/// Button size options
enum AppButtonSize { small, medium, large }

/// Button variant types
enum AppButtonVariant { primary, secondary, text, outlined }
