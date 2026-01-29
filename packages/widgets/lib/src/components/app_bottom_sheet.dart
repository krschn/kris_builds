import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// A customizable bottom sheet widget.
///
/// Provides modal and persistent bottom sheet variants with
/// consistent styling from the theme.
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.showHandle = true,
    this.showCloseButton = false,
    this.padding,
    this.semanticLabel,
  });

  final Widget child;
  final String? title;
  final bool showHandle;
  final bool showCloseButton;
  final EdgeInsetsGeometry? padding;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      container: true,
      label: semanticLabel ?? (title != null ? 'Bottom sheet: $title' : 'Bottom sheet'),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (showHandle)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Center(
                  child: Container(
                    width: 32,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline,
                      borderRadius: AppSpacing.borderRadiusFull,
                    ),
                  ),
                ),
              ),
            if (title != null || showCloseButton)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (title != null)
                      Expanded(child: Text(title!, style: theme.textTheme.titleLarge)),
                    if (showCloseButton)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: 'Close',
                      ),
                  ],
                ),
              ),
            Flexible(
              child: Padding(padding: padding ?? AppSpacing.paddingLg, child: child),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows a modal bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool showHandle = true,
    bool showCloseButton = false,
    EdgeInsetsGeometry? padding,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    String? semanticLabel,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (BuildContext context) => AppBottomSheet(
        title: title,
        showHandle: showHandle,
        showCloseButton: showCloseButton,
        padding: padding,
        semanticLabel: semanticLabel,
        child: child,
      ),
    );
  }

  /// Shows a scrollable modal bottom sheet that can expand
  static Future<T?> showScrollable<T>({
    required BuildContext context,
    required Widget Function(ScrollController) builder,
    String? title,
    bool showHandle = true,
    bool showCloseButton = false,
    EdgeInsetsGeometry? padding,
    double initialChildSize = 0.5,
    double minChildSize = 0.25,
    double maxChildSize = 0.9,
    bool isDismissible = true,
    bool enableDrag = true,
    String? semanticLabel,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (BuildContext context) => DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) => AppBottomSheet(
          title: title,
          showHandle: showHandle,
          showCloseButton: showCloseButton,
          padding: padding,
          semanticLabel: semanticLabel,
          child: builder(scrollController),
        ),
      ),
    );
  }
}
