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

## Installation

Add this package as a dependency in your `pubspec.yaml`:

```yaml
dependencies:
  widgets:
    path: ../widgets  # Adjust path based on your location
```

Then run:

```bash
flutter pub get
```

## Quick Start

```dart
import 'package:widgets/widgets.dart';

// Apply the app theme
MaterialApp(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: ThemeMode.system,  // Respects system preference
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
├── widgets.dart                    # Main barrel export file
└── src/
    ├── theme/
    │   ├── app_theme.dart          # Theme data (light/dark)
    │   ├── app_colors.dart         # Color palette
    │   ├── app_typography.dart     # Text styles (Material 3)
    │   └── app_spacing.dart        # Spacing constants
    └── components/
        ├── app_button.dart         # Button variants
        ├── app_text_field.dart     # Text input fields
        ├── app_card.dart           # Card component
        ├── app_scaffold.dart       # App structure template
        ├── app_dialog.dart         # Modal dialogs
        ├── app_bottom_sheet.dart   # Bottom sheet dialogs
        ├── app_snackbar.dart       # Snackbar notifications
        ├── app_list_tile.dart      # List item component
        ├── app_chip.dart           # Chip/tag component
        ├── app_avatar.dart         # Avatar display
        └── app_loading_indicator.dart  # Loading spinners
```

---

## Theme Customization Guide

### Color System Overview

The color system is defined in `lib/src/theme/app_colors.dart` and follows Material 3 color roles. Each semantic color has both light and dark variants.

### Current Color Palette

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| **Primary** | `#6366F1` (Indigo) | `#818CF8` | Main brand color, buttons, links |
| **Secondary** | `#8B5CF6` (Purple) | `#A78BFA` | Accents, secondary actions |
| **Surface** | `#FAFAFA` | `#1E1E2E` | Cards, dialogs, sheets |
| **Background** | `#FFFFFF` | `#121218` | Scaffold background |
| **Error** | `#DC2626` | `#F87171` | Error states, validation |
| **Success** | `#16A34A` | `#4ADE80` | Success states |
| **Warning** | `#D97706` | `#FBBF24` | Warning states |
| **Outline** | `#E5E7EB` | `#374151` | Borders, dividers |

### How to Update Theme Colors

#### Step 1: Modify `app_colors.dart`

Open `lib/src/theme/app_colors.dart` and update the color constants:

```dart
class AppColors {
  AppColors._();

  // Primary colors - UPDATE THESE VALUES
  static const Color primaryLight = Color(0xFF6366F1);  // Your light primary
  static const Color primaryDark = Color(0xFF818CF8);   // Your dark primary
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onPrimaryDark = Color(0xFF1E1E2E);

  // Secondary colors - UPDATE THESE VALUES
  static const Color secondaryLight = Color(0xFF8B5CF6);  // Your light secondary
  static const Color secondaryDark = Color(0xFFA78BFA);   // Your dark secondary
  // ... continue for other color tokens
}
```

#### Step 2: Update ColorScheme Getters

The `lightColorScheme` and `darkColorScheme` getters automatically use the constants above, so they update automatically when you change the color values.

#### Step 3: Verify Component Themes in `app_theme.dart`

The `app_theme.dart` file uses these colors for component-level theming. Review and update if needed:

```dart
// Example: Button theme uses primary colors
elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryLight,  // Uses your updated color
    foregroundColor: AppColors.onPrimaryLight,
    // ...
  ),
),
```

### Adding New Semantic Colors

To add a new semantic color (e.g., "Tertiary"):

**1. Add constants in `app_colors.dart`:**

```dart
// Tertiary colors
static const Color tertiaryLight = Color(0xFFYOURCOLOR);
static const Color tertiaryDark = Color(0xFFYOURCOLOR);
static const Color onTertiaryLight = Color(0xFFFFFFFF);
static const Color onTertiaryDark = Color(0xFF1E1E2E);
```

**2. Add to ColorScheme (if using Material 3 tertiary):**

```dart
static ColorScheme get lightColorScheme => const ColorScheme(
  // ... existing colors
  tertiary: tertiaryLight,
  onTertiary: onTertiaryLight,
);
```

**3. Use in widgets:**

```dart
final tertiary = Theme.of(context).colorScheme.tertiary;
```

### Best Practices for Color Updates

1. **Always provide both light AND dark variants** - Ensure contrast ratios work in both themes
2. **Maintain contrast ratios** - Use tools like [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
3. **Test on real devices** - Colors render differently on various screens
4. **Update `on*` colors** - When changing a background color, verify its foreground (`on*`) color still provides adequate contrast
5. **Hot reload to preview** - Changes to theme files are reflected immediately with hot reload

---

## Typography System

### Available Text Styles (Material 3)

| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| `displayLarge` | 57sp | Regular | Hero text |
| `displayMedium` | 45sp | Regular | Large titles |
| `displaySmall` | 36sp | Regular | Section headers |
| `headlineLarge` | 32sp | Regular | Page titles |
| `headlineMedium` | 28sp | Regular | Card titles |
| `headlineSmall` | 24sp | Regular | Subsection titles |
| `titleLarge` | 22sp | Medium | App bar titles |
| `titleMedium` | 16sp | Medium | List item titles |
| `titleSmall` | 14sp | Medium | Subtitles |
| `bodyLarge` | 16sp | Regular | Primary body text |
| `bodyMedium` | 14sp | Regular | Secondary body text |
| `bodySmall` | 12sp | Regular | Captions |
| `labelLarge` | 14sp | Medium | Button text |
| `labelMedium` | 12sp | Medium | Chip labels |
| `labelSmall` | 11sp | Medium | Small labels |

### Usage

```dart
// Through theme (recommended)
Text(
  'Hello World',
  style: Theme.of(context).textTheme.headlineMedium,
);

// Direct reference (when theme context unavailable)
Text(
  'Hello World',
  style: AppTypography.headlineMedium,
);
```

### Customizing Typography

Modify `lib/src/theme/app_typography.dart`:

```dart
class AppTypography {
  // Change font family
  static const String _fontFamily = 'YourCustomFont';

  // Modify specific styles
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,              // Adjust size
    fontWeight: FontWeight.w600,  // Adjust weight
    letterSpacing: -0.5,       // Adjust tracking
    height: 1.29,              // Adjust line height
  );
}
```

---

## Spacing System

### Spacing Scale (4px base unit)

| Token | Value | Usage |
|-------|-------|-------|
| `xxs` | 2px | Minimal gaps |
| `xs` | 4px | Tight spacing |
| `sm` | 8px | Small gaps |
| `md` | 12px | Default spacing |
| `lg` | 16px | Section spacing |
| `xl` | 24px | Large gaps |
| `xxl` | 32px | Major sections |
| `xxxl` | 48px | Page-level spacing |

### Padding Helpers

```dart
// All sides padding
Padding(padding: AppSpacing.paddingMd, child: ...)  // 12px all sides
Padding(padding: AppSpacing.paddingLg, child: ...)  // 16px all sides

// Directional padding
Padding(padding: AppSpacing.paddingHorizontalLg, child: ...)  // 16px left/right
Padding(padding: AppSpacing.paddingVerticalXl, child: ...)    // 24px top/bottom
```

### Gap Widgets (for Column/Row)

```dart
Column(
  children: [
    Text('First'),
    AppSpacing.gapMd,  // 12px vertical gap
    Text('Second'),
    AppSpacing.gapLg,  // 16px vertical gap
    Text('Third'),
  ],
)

Row(
  children: [
    Icon(Icons.star),
    AppSpacing.gapHorizontalSm,  // 8px horizontal gap
    Text('Rating'),
  ],
)
```

### Border Radius Presets

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: AppSpacing.borderRadiusSm,   // 4px
    borderRadius: AppSpacing.borderRadiusMd,   // 8px
    borderRadius: AppSpacing.borderRadiusLg,   // 12px
    borderRadius: AppSpacing.borderRadiusXl,   // 16px
    borderRadius: AppSpacing.borderRadiusFull, // 999px (pill shape)
  ),
)
```

---

## Available Components

### AppButton

```dart
// Primary (filled) button
AppButton(
  label: 'Submit',
  onPressed: () {},
  semanticLabel: 'Submit form',  // Optional accessibility label
);

// Secondary button
AppButton.secondary(
  label: 'Cancel',
  onPressed: () {},
);

// Text button
AppButton.text(
  label: 'Learn more',
  onPressed: () {},
);

// Outlined button
AppButton.outlined(
  label: 'View details',
  onPressed: () {},
);

// Disabled state (pass null to onPressed)
AppButton(
  label: 'Submit',
  onPressed: null,  // Disabled
);
```

### AppTextField

```dart
AppTextField(
  label: 'Email',
  hint: 'Enter your email',
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
  validator: (value) => value?.isEmpty == true ? 'Required' : null,
  semanticLabel: 'Email input field',
);

// Password field
AppTextField(
  label: 'Password',
  obscureText: true,
  controller: _passwordController,
);
```

### AppCard

```dart
AppCard(
  child: Column(
    children: [
      Text('Card Title'),
      Text('Card content goes here'),
    ],
  ),
);
```

### AppDialog

```dart
AppDialog.show(
  context: context,
  title: 'Confirm Action',
  content: Text('Are you sure you want to proceed?'),
  actions: [
    AppButton.text(label: 'Cancel', onPressed: () => Navigator.pop(context)),
    AppButton(label: 'Confirm', onPressed: () => handleConfirm()),
  ],
);
```

### AppBottomSheet

```dart
AppBottomSheet.show(
  context: context,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('Select an option'),
      ListTile(title: Text('Option 1'), onTap: () {}),
      ListTile(title: Text('Option 2'), onTap: () {}),
    ],
  ),
);
```

### AppSnackbar

```dart
AppSnackbar.show(
  context: context,
  message: 'Item saved successfully',
);

// Error variant
AppSnackbar.showError(
  context: context,
  message: 'Something went wrong',
);
```

### AppLoadingIndicator

```dart
// Circular spinner
const AppLoadingIndicator();

// With custom size
const AppLoadingIndicator(size: 48);
```

---

## Widget Guidelines

### Creating New Widgets

1. **Semantics** - Always wrap interactive elements with `Semantics` widget
2. **Theme** - Use `Theme.of(context)` for colors and text styles
3. **Spacing** - Use `AppSpacing` constants, never hardcoded values
4. **Documentation** - Add dartdoc comments explaining usage
5. **Tests** - Include widget tests for all components

### Example Widget Implementation

```dart
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

/// A custom info banner widget.
///
/// Displays an informational message with an icon.
class AppInfoBanner extends StatelessWidget {
  const AppInfoBanner({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.semanticLabel,
  });

  final String message;
  final IconData icon;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: semanticLabel ?? message,
      child: Container(
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(color: theme.colorScheme.primary),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            AppSpacing.gapHorizontalSm,
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Consumers

This package should be used by:

- All apps in `/apps`
- All feature packages in `/packages`
- Any module requiring UI components

**Do not** duplicate widgets or create local UI components outside this package.
