import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// A customizable chip widget.
///
/// Provides filter, input, and action chip variants with
/// consistent styling from the theme.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.variant = AppChipVariant.filled,
    this.selected = false,
    this.onSelected,
    this.onDeleted,
    this.avatar,
    this.deleteIcon,
    this.enabled = true,
    this.semanticLabel,
  });

  /// Creates an action chip for triggering actions
  factory AppChip.action({
    Key? key,
    required String label,
    required VoidCallback onPressed,
    Widget? avatar,
    bool enabled = true,
    String? semanticLabel,
  }) {
    return AppChip(
      key: key,
      label: label,
      onSelected: enabled ? (_) => onPressed() : null,
      avatar: avatar,
      enabled: enabled,
      semanticLabel: semanticLabel,
    );
  }

  /// Creates a filter chip for filtering content
  const AppChip.filter({
    super.key,
    required this.label,
    this.selected = false,
    required ValueChanged<bool> this.onSelected,
    this.avatar,
    this.enabled = true,
    this.semanticLabel,
  }) : variant = AppChipVariant.tonal,
       onDeleted = null,
       deleteIcon = null;

  /// Creates an input chip for representing user input
  const AppChip.input({
    super.key,
    required this.label,
    this.avatar,
    this.onDeleted,
    this.deleteIcon,
    this.enabled = true,
    this.semanticLabel,
  }) : variant = AppChipVariant.outlined,
       selected = false,
       onSelected = null;

  final String label;
  final AppChipVariant variant;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final VoidCallback? onDeleted;
  final Widget? avatar;
  final Widget? deleteIcon;
  final bool enabled;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color labelColor;
    BorderSide? side;

    switch (variant) {
      case AppChipVariant.filled:
        backgroundColor = selected ? colorScheme.primary : colorScheme.surface;
        labelColor = selected ? colorScheme.onPrimary : colorScheme.onSurface;
        side = selected ? null : BorderSide(color: colorScheme.outline);
      case AppChipVariant.outlined:
        backgroundColor = Colors.transparent;
        labelColor = colorScheme.onSurface;
        side = BorderSide(color: selected ? colorScheme.primary : colorScheme.outline);
      case AppChipVariant.tonal:
        backgroundColor = selected
            ? colorScheme.primary.withValues(alpha: 0.2)
            : colorScheme.surface;
        labelColor = selected ? colorScheme.primary : colorScheme.onSurface;
        side = BorderSide(color: selected ? colorScheme.primary : colorScheme.outline);
    }

    Widget chip;

    if (onDeleted != null) {
      // Input/deletable chip
      chip = InputChip(
        label: Text(label),
        avatar: avatar,
        onDeleted: enabled ? onDeleted : null,
        deleteIcon: deleteIcon ?? const Icon(Icons.close, size: 18),
        selected: selected,
        onSelected: enabled ? onSelected : null,
        backgroundColor: backgroundColor,
        selectedColor: backgroundColor,
        labelStyle: theme.textTheme.labelMedium?.copyWith(color: labelColor),
        side: side,
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusFull),
        isEnabled: enabled,
      );
    } else if (onSelected != null) {
      // Filter/selectable chip
      chip = FilterChip(
        label: Text(label),
        avatar: avatar,
        selected: selected,
        onSelected: enabled ? onSelected : null,
        backgroundColor: backgroundColor,
        selectedColor: backgroundColor,
        labelStyle: theme.textTheme.labelMedium?.copyWith(color: labelColor),
        side: side,
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusFull),
        showCheckmark: selected,
        checkmarkColor: labelColor,
      );
    } else {
      // Basic chip (no interaction)
      chip = Chip(
        label: Text(label),
        avatar: avatar,
        backgroundColor: backgroundColor,
        labelStyle: theme.textTheme.labelMedium?.copyWith(color: labelColor),
        side: side,
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusFull),
      );
    }

    return Semantics(
      button: onSelected != null || onDeleted != null,
      selected: selected,
      enabled: enabled,
      label: semanticLabel ?? label,
      child: chip,
    );
  }
}

/// Chip variant types
enum AppChipVariant { filled, outlined, tonal }
