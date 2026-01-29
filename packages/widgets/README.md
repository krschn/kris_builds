# Widgets

The official design system package for the project. All UI components, themes, and styling standards are defined here and consumed by apps and other local packages.

## Overview

This package serves as the single source of truth for:

- **Design Tokens** - Colors, typography, spacing, and other design primitives
- **Theme** - Light/dark theme configurations following Material 3 standards
- **Pre-built Widgets** - Reusable UI components with built-in accessibility
- **Semantics** - Accessibility labels and semantic annotations for all widgets

## Principles

### Single Source of Truth

All apps and local packages **must** consume widgets from this package. Never create one-off UI components in feature packages or apps.

### Accessibility First

Every widget includes proper semantic labels and supports screen readers. Widgets follow WCAG guidelines and Flutter's accessibility best practices.

### Theme Compliance

All widgets respect the app theme. No hardcoded colors or text styles—always reference theme tokens.

## Usage

Add this package as a dependency:

```yaml
dependencies:
  widgets:
    path: ../widgets
```

Import and use:

```dart
import 'package:widgets/widgets.dart';

// Apply the app theme
MaterialApp(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  // ...
);

// Use pre-built widgets
AppButton(
  label: 'Submit',
  onPressed: () {},
);
```

## Project Structure

```
lib/
├── widgets.dart              # Main barrel export file
├── src/
│   ├── theme/
│   │   ├── app_theme.dart    # Theme data (light/dark)
│   │   ├── app_colors.dart   # Color palette
│   │   ├── app_typography.dart
│   │   └── app_spacing.dart  # Spacing constants
│   ├── tokens/
│   │   └── design_tokens.dart
│   ├── components/
│   │   ├── buttons/          # Button variants
│   │   ├── inputs/           # Text fields, dropdowns, etc.
│   │   ├── cards/            # Card components
│   │   ├── dialogs/          # Modals and dialogs
│   │   ├── navigation/       # App bars, bottom nav, etc.
│   │   └── feedback/         # Snackbars, loaders, etc.
│   └── extensions/
│       └── context_extensions.dart  # Theme access helpers
```

## Widget Guidelines

### Creating New Widgets

1. **Semantics** - Always wrap interactive elements with `Semantics` widget
2. **Theme** - Use `Theme.of(context)` for colors and text styles
3. **Spacing** - Use `AppSpacing` constants, never hardcoded values
4. **Documentation** - Add dartdoc comments explaining usage
5. **Tests** - Include widget tests for all components

### Example Widget

```dart
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel ?? label,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
```

## Theme Tokens

### Colors

Access colors through the theme:

```dart
final primary = Theme.of(context).colorScheme.primary;
final surface = Theme.of(context).colorScheme.surface;
```

### Typography

Use predefined text styles:

```dart
final headline = Theme.of(context).textTheme.headlineMedium;
final body = Theme.of(context).textTheme.bodyLarge;
```

### Spacing

Use consistent spacing values:

```dart
const AppSpacing.xs   // 4.0
const AppSpacing.sm   // 8.0
const AppSpacing.md   // 16.0
const AppSpacing.lg   // 24.0
const AppSpacing.xl   // 32.0
```

## Consumers

This package should be used by:

- All apps in `/apps`
- All feature packages in `/packages`
- Any module requiring UI components

**Do not** duplicate widgets or create local UI components outside this package.
