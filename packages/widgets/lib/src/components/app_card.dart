import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// A customizable card widget with semantic variants.
///
/// Provides elevated, outlined, and filled variants with
/// consistent styling from the theme.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.semanticLabel,
  });

  /// Creates an elevated card (with shadow)
  const AppCard.elevated({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.semanticLabel,
  }) : variant = AppCardVariant.elevated;

  /// Creates a filled card (solid background, no shadow)
  const AppCard.filled({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.semanticLabel,
  }) : variant = AppCardVariant.filled;

  /// Creates an outlined card (with border, no shadow)
  const AppCard.outlined({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.semanticLabel,
  }) : variant = AppCardVariant.outlined;

  final Widget child;
  final AppCardVariant variant;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final Widget cardContent = Padding(padding: padding ?? AppSpacing.paddingLg, child: child);

    Widget card;

    switch (variant) {
      case AppCardVariant.elevated:
        card = Card(margin: margin ?? EdgeInsets.zero, child: cardContent);
      case AppCardVariant.outlined:
        card = Card(
          margin: margin ?? EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusLg,
            side: BorderSide(color: colorScheme.outline),
          ),
          child: cardContent,
        );
      case AppCardVariant.filled:
        card = Card(
          margin: margin ?? EdgeInsets.zero,
          elevation: 0,
          color: colorScheme.surface,
          child: cardContent,
        );
    }

    if (onTap != null || onLongPress != null) {
      card = InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: AppSpacing.borderRadiusLg,
        child: card,
      );
    }

    return Semantics(container: true, label: semanticLabel, button: onTap != null, child: card);
  }
}

/// Card variant types
enum AppCardVariant { elevated, outlined, filled }
