# CLAUDE.md

## Project Overview

This is a **modular Flutter monorepo** designed for building multiple applications from shared, pluggable feature packages. The architecture follows the **"Batteries Included, Optionally Swappable"** principle using Riverpod for state management and dependency injection.

---

## What NOT to Do

- ❌ Don't put business logic in apps — apps only orchestrate
- ❌ Don't use raw Material/Cupertino widgets — use design system
- ❌ Don't create circular dependencies between feature packages
- ❌ Don't override providers unless necessary — use defaults
- ❌ Don't export internal implementations from packages
- ❌ Don't use `GetIt`, `get_it`, or service locators — use Riverpod
- ❌ Don't use BLoC for new features — use Riverpod Notifiers
- ❌ Don't use code generation (`build_runner`, `freezed`, `@riverpod` annotations) — use manual providers
- ❌ Don't create `.g.dart` or `.freezed.dart` files — write explicit code

## Architecture Philosophy

> **Packages are self-contained and work on import. Apps configure only when they need to differ.**

### Core Principles

- **Zero-Config Default** — Every package works immediately with sensible defaults
- **Explicit Over Implicit** — Dependencies are declared, not hidden
- **Feature Isolation** — Business logic stays in feature packages, not host apps
- **Design System Enforcement** — All UI must use the shared design system

---

## Repository Structure

```
kris_builds/
│
├── apps/                           # Host applications
│   ├── consumer_app/               # Public-facing app
│   ├── enterprise_app/             # B2B app with SSO
│   └── admin_app/                  # Internal admin tools
│
├── packages/
│   │
│   ├── core/                       # ━━━ SHARED FOUNDATION ━━━
│   │   │                           # Every package and app depends on these
│   │   │
│   │   ├── design_system/          # UI components, themes, typography
│   │   │   ├── lib/
│   │   │   │   ├── components/     # AppButton, AppCard, AppTextField, etc.
│   │   │   │   ├── theme/          # AppTheme, AppColors, AppSpacing
│   │   │   │   └── tokens/         # Design tokens (if using)
│   │   │   └── pubspec.yaml
│   │   │
│   │   ├── networking/             # HTTP client, interceptors, error handling
│   │   ├── storage/                # Local storage abstractions (Hive, SecureStorage)
│   │   └── utils/                  # Extensions, helpers, constants
│   │
│   └── features/                   # ━━━ PLUGGABLE FEATURES ━━━
│       │                           # Independent, self-contained business logic
│       │
│       ├── auth/                   # Authentication & authorization
│       ├── todo/                   # Todo management
│       ├── profile/                # User profile
│       ├── settings/               # App settings
│       └── payments/               # Payment processing
│
├── melos.yaml                      # Monorepo tooling
├── pubspec.yaml                    # Root dependencies
├── architecture.md                 # Detailed architecture documentation
└── CLAUDE.md                       # This file
```

---

## Dependency Rules

### The Dependency Graph

```
                    ┌─────────────────────────────────┐
                    │            APPS                 │
                    │  (consumer, enterprise, admin)  │
                    └───────────────┬─────────────────┘
                                    │ depends on
                                    ▼
                    ┌─────────────────────────────────┐
                    │       FEATURE PACKAGES          │
                    │   (auth, todo, profile, etc.)   │
                    └───────────────┬─────────────────┘
                                    │ depends on
                                    ▼
                    ┌─────────────────────────────────┐
                    │        CORE PACKAGES            │
                    │ (design_system, networking,     │
                    │  storage, utils)                │
                    └───────────────┬─────────────────┘
                                    │ depends on
                                    ▼
                    ┌─────────────────────────────────┐
                    │          FLUTTER SDK            │
                    └─────────────────────────────────┘
```

### Dependency Rules (MUST FOLLOW)

| Package Type | Can Depend On | Cannot Depend On |
|--------------|---------------|------------------|
| **Apps** | Features, Core, Flutter | Nothing — it's the top |
| **Features** | Other Features*, Core, Flutter | Apps |
| **Core** | Other Core*, Flutter | Apps, Features |

*Cross-dependencies within the same layer should be minimal and explicit.

### Design System Requirement

> **ALL packages and apps MUST use the design system (`core/design_system`).**

- ❌ Never use raw `Material` widgets directly (e.g., `ElevatedButton`, `TextField`)
- ✅ Always use design system components (e.g., `AppButton`, `AppTextField`)
- ❌ Never hardcode colors, spacing, or typography
- ✅ Always use `AppColors`, `AppSpacing`, `AppTypography`

```dart
// ❌ WRONG
ElevatedButton(
  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
  child: Text('Submit', style: TextStyle(fontSize: 16)),
)

// ✅ CORRECT
AppButton(
  label: 'Submit',
  onPressed: () {},
)
```

---

## State Management: Riverpod

### Why Riverpod

- **Auto-registration** — Providers self-register, no manual wiring
- **Override pattern** — Apps customize via `ProviderScope` overrides
- **Compile-time safety** — No runtime provider errors
- **Cross-feature deps** — Simple `ref.watch` between features

### Provider Structure Per Feature

Each feature package follows this provider hierarchy using **manual providers** (no code generation):

```dart
// 1. CONFIG (Overridable by host app)
final featureConfigProvider = Provider<FeatureConfig>((ref) {
  return const FeatureConfig();
});

// 2. DATA SOURCE (Uses config or default)
final featureDataSourceProvider = Provider<FeatureDataSource>((ref) {
  final config = ref.watch(featureConfigProvider);
  return config.customDataSource ?? DefaultDataSource();
});

// 3. REPOSITORY (Internal)
final featureRepositoryProvider = Provider<FeatureRepository>((ref) {
  return FeatureRepositoryImpl(ref.watch(featureDataSourceProvider));
});

// 4. NOTIFIER (Public API)
final featureProvider = NotifierProvider<FeatureNotifier, FeatureState>(
  FeatureNotifier.new,
);

class FeatureNotifier extends Notifier<FeatureState> {
  @override
  FeatureState build() => const FeatureInitial();

  Future<void> doSomething() async { /* ... */ }
}
```

### State Classes (Dart 3 Sealed Classes)

Use Dart 3 sealed classes instead of freezed:

```dart
// No code generation needed — pure Dart
sealed class FeatureState {
  const FeatureState();
}

final class FeatureInitial extends FeatureState {
  const FeatureInitial();
}

final class FeatureLoading extends FeatureState {
  const FeatureLoading();
}

final class FeatureSuccess extends FeatureState {
  final Data data;
  const FeatureSuccess(this.data);
}

final class FeatureError extends FeatureState {
  final String message;
  const FeatureError(this.message);
}
```

### Host App Usage

```dart
// Zero config — just works
void main() => runApp(ProviderScope(child: App()));

// With customization
void main() => runApp(ProviderScope(
  overrides: [
    authConfigProvider.overrideWithValue(AuthConfig(
      customDataSource: EnterpriseAuthDataSource(),
    )),
  ],
  child: App(),
));
```

---

## Feature Package Structure

Every feature package follows this structure:

```
packages/features/auth/
├── lib/
│   ├── auth.dart                   # Public barrel file
│   └── src/
│       ├── providers/              # Riverpod providers
│       │   ├── auth_providers.dart # Config, DataSource, Repository, Notifier
│       │   └── auth_state.dart     # State classes
│       │
│       ├── domain/                 # Business logic (pure Dart)
│       │   ├── entities/           # Business objects
│       │   ├── repositories/       # Abstract interfaces
│       │   └── usecases/           # Optional: use case classes
│       │
│       ├── data/                   # Data layer
│       │   ├── datasources/        # Remote/local data sources
│       │   ├── models/             # DTOs, JSON models
│       │   └── repositories/       # Repository implementations
│       │
│       └── presentation/           # UI layer
│           ├── pages/              # Full-screen pages
│           └── widgets/            # Feature-specific widgets
│
├── test/                           # Tests mirror src/ structure
└── pubspec.yaml
```

### Barrel File Exports

Only export public API:

```dart
// auth.dart
export 'src/providers/auth_providers.dart'
    show authProvider, authConfigProvider, AuthConfig;
export 'src/providers/auth_state.dart';
export 'src/domain/entities/user.dart';
export 'src/presentation/pages/login_page.dart';

// DO NOT export: datasources, repositories, internal implementations
```

---

## Cross-Feature Communication

### Pattern 1: Direct Provider Watching (Recommended)

```dart
// In todo package — watching auth state
class TodoNotifier extends Notifier<TodoState> {
  @override
  TodoState build() {
    final authState = ref.watch(authProvider);
    if (authState is! AuthAuthenticated) {
      return const TodoUnauthorized();
    }
    return const TodoReady();
  }
}
```

### Pattern 2: Callback/Navigation (for UI flows)

```dart
// Feature exposes callback, host app wires navigation
class LoginPage extends ConsumerWidget {
  final VoidCallback onLoginSuccess;

  // Host app provides: onLoginSuccess: () => context.go('/home')
}
```

---

## Testing Standards

### Unit Tests (Providers)

```dart
void main() {
  test('auth login updates state', () async {
    final container = ProviderContainer(
      overrides: [
        authDataSourceProvider.overrideWithValue(MockAuthDataSource()),
      ],
    );

    await container.read(authProvider.notifier).login('test@test.com', 'pass');

    expect(container.read(authProvider), isA<AuthAuthenticated>());
  });
}
```

### Widget Tests

```dart
void main() {
  testWidgets('login page shows error on failure', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => MockAuthNotifier()),
        ],
        child: MaterialApp(home: LoginPage()),
      ),
    );

    expect(find.text('Failed'), findsOneWidget);
  });
}
```

---

## No Code Generation Policy

This project intentionally avoids code generation to:

- **Reduce AI context noise** — No `.g.dart` or `.freezed.dart` files cluttering the codebase
- **Simplify onboarding** — No "run build_runner first" step
- **Faster CI/CD** — No generation step in builds
- **Explicit code** — What you see is what runs

### What We Use Instead

| Instead of | We use |
|------------|--------|
| `@riverpod` annotations | Manual `Provider`, `NotifierProvider` |
| `freezed` for states | Dart 3 `sealed class` |
| `json_serializable` | Manual `fromJson`/`toJson` or `dart_mappable` (no codegen) |

---

## Common Commands

```bash
# Get all dependencies
melos bootstrap

# Run all tests
melos run test

# Run tests with coverage
melos run test:coverage

# Analyze all packages
melos run analyze

# Format all code
melos run format
```

---

## Adding a New Feature Package

1. **Create package structure:**
   ```bash
   mkdir -p packages/features/new_feature/{lib/src/{providers,domain,data,presentation},test}
   ```

2. **Create `pubspec.yaml`:**
   ```yaml
   name: new_feature
   dependencies:
     flutter:
       sdk: flutter
     flutter_riverpod: ^2.5.0
     design_system:
       path: ../../core/design_system
   ```

3. **Create providers** following the 4-layer pattern (Config → DataSource → Repository → Notifier)

4. **Create barrel file** (`lib/new_feature.dart`)

5. **Run `melos bootstrap`**

6. **Import in app** — no other wiring needed

---

## Multi-App Configuration

### Environment-Based Overrides

```dart
// main.dart
void main() {
  final overrides = switch (Environment.current) {
    Environment.dev => [
      authConfigProvider.overrideWithValue(AuthConfig(
        customDataSource: MockAuthDataSource(),
      )),
    ],
    Environment.prod => [
      analyticsConfigProvider.overrideWithValue(AnalyticsConfig(enabled: true)),
    ],
  };

  runApp(ProviderScope(overrides: overrides, child: App()));
}
```

### App-Specific Overrides

```dart
// Enterprise app with SSO
ProviderScope(
  overrides: [
    authConfigProvider.overrideWithValue(AuthConfig(
      customDataSource: SSOAuthDataSource(),
    )),
  ],
  child: EnterpriseApp(),
)

// Consumer app with social login
ProviderScope(
  overrides: [
    authConfigProvider.overrideWithValue(AuthConfig(
      customDataSource: SocialAuthDataSource(),
    )),
  ],
  child: ConsumerApp(),
)
```

---

## Architecture Decisions Record

| Decision | Choice | Rationale |
|----------|--------|-----------|
| State Management | Riverpod (manual) | Auto-registration, override pattern, compile-time safety |
| Package Structure | core/ + features/ | Clear separation of infrastructure vs business logic |
| DI Approach | Provider overrides | No service locator, explicit dependencies |
| Cross-Feature Deps | Direct `ref.watch` | Explicit, traceable, type-safe |
| Design System | Mandatory | Consistency across all apps |
| Code Generation | None | Reduces context noise, simpler builds, explicit code |
| State Classes | Dart 3 sealed classes | Native pattern matching, no freezed dependency |

---


## References

- [architecture.md](./architecture.md) — Detailed architecture documentation with diagrams
- [Riverpod Documentation](https://riverpod.dev)
- [Melos Documentation](https://melos.invertase.dev)
