import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// A customizable list tile widget.
///
/// Provides consistent list item styling with support for
/// leading/trailing widgets and various tap actions.
class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.selected = false,
    this.dense = false,
    this.contentPadding,
    this.semanticLabel,
  });

  /// Creates a list tile with a leading avatar
  factory AppListTile.avatar({
    Key? key,
    required String title,
    String? subtitle,
    required Widget avatar,
    Widget? trailing,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    bool enabled = true,
    bool selected = false,
    bool dense = false,
    EdgeInsetsGeometry? contentPadding,
    String? semanticLabel,
  }) {
    return AppListTile(
      key: key,
      title: title,
      subtitle: subtitle,
      leading: avatar,
      trailing: trailing,
      onTap: onTap,
      onLongPress: onLongPress,
      enabled: enabled,
      selected: selected,
      dense: dense,
      contentPadding: contentPadding,
      semanticLabel: semanticLabel,
    );
  }

  /// Creates a list tile with a leading icon
  factory AppListTile.icon({
    Key? key,
    required String title,
    String? subtitle,
    required IconData icon,
    Widget? trailing,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    bool enabled = true,
    bool selected = false,
    bool dense = false,
    EdgeInsetsGeometry? contentPadding,
    String? semanticLabel,
  }) {
    return AppListTile(
      key: key,
      title: title,
      subtitle: subtitle,
      leading: Icon(icon),
      trailing: trailing,
      onTap: onTap,
      onLongPress: onLongPress,
      enabled: enabled,
      selected: selected,
      dense: dense,
      contentPadding: contentPadding,
      semanticLabel: semanticLabel,
    );
  }

  /// Creates a navigation list tile with a trailing chevron
  factory AppListTile.navigation({
    Key? key,
    required String title,
    String? subtitle,
    Widget? leading,
    required VoidCallback onTap,
    bool enabled = true,
    bool dense = false,
    EdgeInsetsGeometry? contentPadding,
    String? semanticLabel,
  }) {
    return AppListTile(
      key: key,
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      enabled: enabled,
      dense: dense,
      contentPadding: contentPadding,
      semanticLabel: semanticLabel,
    );
  }

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;
  final bool selected;
  final bool dense;
  final EdgeInsetsGeometry? contentPadding;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Semantics(
      button: onTap != null,
      enabled: enabled,
      selected: selected,
      label: semanticLabel ?? title,
      child: ListTile(
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: enabled
                ? (selected ? colorScheme.primary : colorScheme.onSurface)
                : colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: enabled
                      ? colorScheme.onSurface.withValues(alpha: 0.7)
                      : colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              )
            : null,
        leading: leading,
        trailing: trailing,
        onTap: enabled ? onTap : null,
        onLongPress: enabled ? onLongPress : null,
        enabled: enabled,
        selected: selected,
        selectedTileColor: colorScheme.primary.withValues(alpha: 0.1),
        dense: dense,
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
      ),
    );
  }
}
