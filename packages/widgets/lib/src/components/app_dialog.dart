import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import 'app_button.dart';

/// A customizable dialog widget with consistent styling.
///
/// Provides alert, confirmation, and custom dialog variants.
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    this.content,
    this.contentWidget,
    this.actions,
    this.semanticLabel,
    this.barrierDismissible = true,
  });

  /// Creates an alert dialog with a single action button
  factory AppDialog.alert({
    Key? key,
    required String title,
    String? content,
    Widget? contentWidget,
    String actionLabel = 'OK',
    VoidCallback? onAction,
    String? semanticLabel,
  }) {
    return AppDialog(
      key: key,
      title: title,
      content: content,
      contentWidget: contentWidget,
      semanticLabel: semanticLabel,
      actions: <Widget>[AppButton.primary(onPressed: onAction, label: actionLabel)],
    );
  }

  /// Creates a confirmation dialog with confirm and cancel buttons
  factory AppDialog.confirm({
    Key? key,
    required String title,
    String? content,
    Widget? contentWidget,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
    String? semanticLabel,
  }) {
    return AppDialog(
      key: key,
      title: title,
      content: content,
      contentWidget: contentWidget,
      semanticLabel: semanticLabel,
      actions: <Widget>[
        AppButton.text(onPressed: onCancel, label: cancelLabel),
        if (isDestructive)
          _DestructiveButton(onPressed: onConfirm, label: confirmLabel)
        else
          AppButton.primary(onPressed: onConfirm, label: confirmLabel),
      ],
    );
  }

  final String title;
  final String? content;
  final Widget? contentWidget;
  final List<Widget>? actions;
  final String? semanticLabel;
  final bool barrierDismissible;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      container: true,
      label: semanticLabel ?? 'Dialog: $title',
      child: AlertDialog(
        title: Text(title, style: theme.textTheme.headlineSmall),
        content:
            contentWidget ??
            (content != null ? Text(content!, style: theme.textTheme.bodyMedium) : null),
        contentPadding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.lg,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
        actions: actions,
      ),
    );
  }

  /// Shows this dialog
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? content,
    Widget? contentWidget,
    List<Widget>? actions,
    bool barrierDismissible = true,
    String? semanticLabel,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => AppDialog(
        title: title,
        content: content,
        contentWidget: contentWidget,
        actions: actions,
        semanticLabel: semanticLabel,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  /// Shows an alert dialog
  static Future<void> showAlert({
    required BuildContext context,
    required String title,
    String? content,
    Widget? contentWidget,
    String actionLabel = 'OK',
    String? semanticLabel,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AppDialog.alert(
        title: title,
        content: content,
        contentWidget: contentWidget,
        actionLabel: actionLabel,
        onAction: () => Navigator.of(context).pop(),
        semanticLabel: semanticLabel,
      ),
    );
  }

  /// Shows a confirmation dialog
  static Future<bool> showConfirm({
    required BuildContext context,
    required String title,
    String? content,
    Widget? contentWidget,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
    String? semanticLabel,
  }) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AppDialog.confirm(
        title: title,
        content: content,
        contentWidget: contentWidget,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
        semanticLabel: semanticLabel,
      ),
    );
    return result ?? false;
  }
}

/// Internal widget for destructive action buttons
class _DestructiveButton extends StatelessWidget {
  const _DestructiveButton({required this.onPressed, required this.label});

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.error,
        foregroundColor: theme.colorScheme.onError,
      ),
      child: Text(label),
    );
  }
}
