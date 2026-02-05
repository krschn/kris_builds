# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Philosophy

**TDD is mandatory.** Always follow Red-Green-Refactor:
1. **RED**: Write failing test first
2. **GREEN**: Write minimal code to pass
3. **REFACTOR**: Clean up while tests stay green

**Clean Architecture is required.** Each feature package has three layers:
- **Domain**: Entities, repository interfaces, use cases (framework-independent)
- **Data**: Models, datasources, repository implementations
- **Presentation**: BLoC, pages, widgets

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

## Architecture

### Monorepo Structure
- `packages/widgets/` - Design system (all UI components, themes, colors, spacing)
- `packages/auth/` - Authentication feature package
- `packages/todo/` - Todo management feature package
- `apps/example_app/` - Demo app integrating all packages

### Key Patterns

**Module Factory Pattern**: Each feature has a `*Module` class that creates dependencies:
```dart
final authModule = AuthModule(dataSource: MockAuthDataSource(box));
final authBloc = authModule.createAuthBloc();
```

**Navigation Abstraction**: Auth package uses `AuthNavigationDelegate` interface - apps implement it with their router (go_router, auto_route, etc).

**All UI from widgets package**: Never create UI components outside `packages/widgets`. Use `AppTheme`, `AppColors`, `AppSpacing`, `AppTypography` for styling.

### Package Dependencies
```
example_app
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

## Testing Conventions

- Unit tests: `test/domain/` and `test/data/`
- Widget tests: `test/presentation/`
- Integration tests: `patrol_test/` (Patrol framework)
- Use `bloc_test` for BLoC testing
- Mock datasources, not repositories

## Tech Stack

- State: BLoC 9.1+
- Routing: Go Router 17+
- Storage: Hive 2.2+
- Equality: Equatable
- Linting: Flutter Lints (strict rules in analysis_options.yaml)
