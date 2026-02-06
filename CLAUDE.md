# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Philosophy

**TDD is mandatory.** Use Per-Flow TDD approach - complete one flow before starting the next:

### Per-Flow TDD Cycle
For each user flow, complete the full Red-Green-Refactor cycle:

1. **RED**: Write ALL failing tests for the flow first:
   - Unit tests (use cases, repositories)
   - Widget tests (BLoC, pages, widgets)
   - Patrol integration test for the flow
2. **GREEN**: Write minimal code to pass all tests
3. **REFACTOR**: Clean up while tests stay green

**Example - Auth Feature:**
1. Sign In flow: Red → Green → Refactor (complete)
2. Sign Up flow: Red → Green → Refactor (complete)
3. Password Reset flow: Red → Green → Refactor (complete)

Each flow is fully tested end-to-end before moving to the next.

## Testing Conventions

- Unit tests: `test/domain/` and `test/data/`
- Widget tests: `test/presentation/`
- Use `bloc_test` for BLoC testing
- Mock datasources, not repositories
- Integration tests: `apps/*/patrol_test/` (Patrol framework) - **only in apps, not in feature packages** (apps are where feature packages are integrated and tested end-to-end)


## Architecture

**Clean Architecture is required.** Each feature package has three layers:
- **Domain**: Entities, repository interfaces, use cases (framework-independent)
- **Data**: Models, datasources, repository implementations
- **Presentation**: BLoC, pages, widgets

### Monorepo Structure
- `packages/widgets/` - Design system (all UI components, themes, colors, spacing)
- `packages/auth/` - Authentication feature package
- `packages/todo/` - Todo management feature package
- `apps/example_app/` - Consumer app

### Key Patterns

**Module Factory Pattern**: Each feature has a `*Module` class that creates dependencies:
```dart
final authModule = AuthModule(dataSource: MockAuthDataSource(box));
final authBloc = authModule.createAuthBloc();
```

**Navigation Abstraction**: Auth package uses `AuthNavigationDelegate` interface - apps implement it with their router (go_router, auto_route, etc).

**ALWAYS use widgets from design system (widgets) package**:
- Use design system components (`AppTextField`, `AppButton`, `AppCard`, `AppChip`, `AppScaffold`, `AppSnackbar`, `AppDialog`, `AppLoadingIndicator`, `AppListTile`, `AppAvatar`, `AppBottomSheet`) instead of raw Material widgets
- If a component is not available in the widgets package, **create it there first** before using it in feature packages
- Use `AppTheme`, `AppColors`, `AppSpacing`, `AppTypography` for all styling
- Never use raw `TextField`, `ElevatedButton`, `Card`, `Chip`, `Scaffold`, `SnackBar` directly in feature packages

### Package Dependencies
```
app
    ├── auth ──────┐
    ├── todo ──────┼── widgets
    └──────────────┘
```
Feature packages depend only on `widgets`. No cross-dependencies between features.

## Creating New Features

1. Create package in `packages/feature_name/` with `lib/src/{domain,data,presentation}/`
2. Add to workspace in root `pubspec.yaml`
3. Depend on `widgets` package for UI
4. Create `FeatureModule` class for dependency injection
5. Write tests in parallel structure under `test/`

## Commands

```bash
# Run all tests
flutter test

# Run tests for specific package
cd packages/auth && flutter test

# Run single test file
flutter test test/domain/usecases/login_usecase_test.dart

# Patrol integration tests
patrol test
patrol test -t patrol_test/feature_test.dart
patrol develop -t patrol_test/feature_test.dart  # Hot reload mode

# Code quality
flutter analyze
dart format .
```