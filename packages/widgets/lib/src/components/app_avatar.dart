import 'package:flutter/material.dart';

/// A customizable avatar widget.
///
/// Displays user avatars with image, initials, or icon fallback.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.icon,
    this.size = AppAvatarSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.semanticLabel,
  });

  /// Creates an avatar with an icon
  const AppAvatar.icon({
    super.key,
    required IconData this.icon,
    this.size = AppAvatarSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.semanticLabel,
  }) : imageUrl = null,
       initials = null;

  /// Creates an avatar with an image
  const AppAvatar.image({
    super.key,
    required String this.imageUrl,
    this.size = AppAvatarSize.medium,
    this.backgroundColor,
    this.onTap,
    this.semanticLabel,
  }) : initials = null,
       icon = null,
       foregroundColor = null;

  /// Creates an avatar with initials
  const AppAvatar.initials({
    super.key,
    required String this.initials,
    this.size = AppAvatarSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.semanticLabel,
  }) : imageUrl = null,
       icon = null;

  final String? imageUrl;
  final String? initials;
  final IconData? icon;
  final AppAvatarSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final double avatarSize = _getSize();

    final Color effectiveBackgroundColor = backgroundColor ?? colorScheme.primary;
    final Color effectiveForegroundColor = foregroundColor ?? colorScheme.onPrimary;

    Widget avatarContent;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatarContent = CircleAvatar(
        radius: avatarSize / 2,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: effectiveBackgroundColor,
        onBackgroundImageError: (_, _) {},
      );
    } else if (initials != null && initials!.isNotEmpty) {
      avatarContent = CircleAvatar(
        radius: avatarSize / 2,
        backgroundColor: effectiveBackgroundColor,
        child: Text(
          initials!.length > 2 ? initials!.substring(0, 2).toUpperCase() : initials!.toUpperCase(),
          style: TextStyle(
            fontSize: _getFontSize(),
            fontWeight: FontWeight.w500,
            color: effectiveForegroundColor,
          ),
        ),
      );
    } else {
      avatarContent = CircleAvatar(
        radius: avatarSize / 2,
        backgroundColor: effectiveBackgroundColor,
        child: Icon(icon ?? Icons.person, size: _getIconSize(), color: effectiveForegroundColor),
      );
    }

    Widget avatar = SizedBox(width: avatarSize, height: avatarSize, child: avatarContent);

    if (onTap != null) {
      avatar = InkWell(onTap: onTap, customBorder: const CircleBorder(), child: avatar);
    }

    return Semantics(
      image: imageUrl != null,
      label: semanticLabel ?? (initials != null ? 'Avatar for $initials' : 'Avatar'),
      button: onTap != null,
      child: avatar,
    );
  }

  double _getFontSize() {
    switch (size) {
      case AppAvatarSize.small:
        return 12;
      case AppAvatarSize.medium:
        return 16;
      case AppAvatarSize.large:
        return 22;
      case AppAvatarSize.extraLarge:
        return 32;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppAvatarSize.small:
        return 16;
      case AppAvatarSize.medium:
        return 20;
      case AppAvatarSize.large:
        return 28;
      case AppAvatarSize.extraLarge:
        return 40;
    }
  }

  double _getSize() {
    switch (size) {
      case AppAvatarSize.small:
        return 32;
      case AppAvatarSize.medium:
        return 40;
      case AppAvatarSize.large:
        return 56;
      case AppAvatarSize.extraLarge:
        return 80;
    }
  }
}

/// Avatar size options
enum AppAvatarSize { small, medium, large, extraLarge }
