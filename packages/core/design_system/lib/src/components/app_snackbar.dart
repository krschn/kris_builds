import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// A customizable snackbar widget.
///
/// Provides info, success, warning, and error variants with
/// consistent styling from the theme.
class AppSnackbar {
  AppSnackbar._();

  /// Shows an error snackbar
  static void error({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
    bool showCloseIcon = false,
  }) {
    show(
      context: context,
      message: message,
      variant: AppSnackbarVariant.error,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      showCloseIcon: showCloseIcon,
    );
  }

  /// Shows an info snackbar
  static void info({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
    bool showCloseIcon = false,
  }) {
    show(
      context: context,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      showCloseIcon: showCloseIcon,
    );
  }

  /// Shows a snackbar with the given message
  static void show({
    required BuildContext context,
    required String message,
    AppSnackbarVariant variant = AppSnackbarVariant.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
    bool showCloseIcon = false,
    String? semanticLabel,
  }) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color textColor;
    IconData? icon;

    switch (variant) {
      case AppSnackbarVariant.info:
        backgroundColor = colorScheme.inverseSurface;
        textColor = colorScheme.onInverseSurface;
        icon = Icons.info_outline;
      case AppSnackbarVariant.success:
        backgroundColor = const Color(0xFF16A34A);
        textColor = Colors.white;
        icon = Icons.check_circle_outline;
      case AppSnackbarVariant.warning:
        backgroundColor = const Color(0xFFD97706);
        textColor = Colors.white;
        icon = Icons.warning_amber_outlined;
      case AppSnackbarVariant.error:
        backgroundColor = colorScheme.error;
        textColor = colorScheme.onError;
        icon = Icons.error_outline;
    }

    final SnackBar snackBar = SnackBar(
      content: Semantics(
        label: semanticLabel ?? message,
        child: Row(
          children: <Widget>[
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(message, style: theme.textTheme.bodyMedium?.copyWith(color: textColor)),
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
      action: actionLabel != null
          ? SnackBarAction(label: actionLabel, textColor: textColor, onPressed: onAction ?? () {})
          : null,
      showCloseIcon: showCloseIcon,
      closeIconColor: textColor,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Shows a success snackbar
  static void success({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
    bool showCloseIcon = false,
  }) {
    show(
      context: context,
      message: message,
      variant: AppSnackbarVariant.success,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      showCloseIcon: showCloseIcon,
    );
  }

  /// Shows a warning snackbar
  static void warning({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
    bool showCloseIcon = false,
  }) {
    show(
      context: context,
      message: message,
      variant: AppSnackbarVariant.warning,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      showCloseIcon: showCloseIcon,
    );
  }
}

/// Snackbar variant types
enum AppSnackbarVariant { info, success, warning, error }
