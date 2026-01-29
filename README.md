# Kris Builds - Flutter Monorepo

A modular Flutter monorepo demonstrating Clean Architecture principles with reusable packages for building scalable applications.

## Overview

This monorepo showcases best practices for:

- **Modular Architecture** - Independent, reusable packages
- **Clean Architecture** - Domain, Data, and Presentation layers
- **Design System** - Centralized UI components and theming
- **State Management** - BLoC pattern for predictable state
- **Local Storage** - Hive for persistent data
- **Navigation** - Go Router with abstract navigation delegates

## Project Structure

```
/
├── apps/
│   └── example_app/              # Demo app consuming all packages
├── packages/
│   ├── widgets/                  # Design system & UI components
│   ├── auth/                     # Authentication feature package
│   └── todo/                     # Todo management feature package
├── pubspec.yaml                  # Workspace configuration
├── analysis_options.yaml         # Lint rules
└── melos.yaml                    # Melos configuration (optional)
```

## Technology Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter |
| Language | Dart 3.10+ |
| State Management | BLoC 9.1+ |
| Routing | Go Router 17+ |
| Storage | Hive 2.2+ |
| Monorepo Tool | Pub Workspaces / Melos 7.3+ |
| Equality | Equatable 2.0+ |
| Linting | Flutter Lints 6.0+ |

---

## Getting Started

### Prerequisites

- Flutter SDK 3.10+
- Dart SDK 3.10+

### Installation

1. **Clone the repository:**

```bash
git clone https://github.com/your-repo/kris_builds.git
cd kris_builds
```

2. **Install dependencies:**

```bash
flutter pub get
```

This automatically installs dependencies for all workspace packages.

3. **Run the example app:**

```bash
cd apps/example_app
flutter run
```

---

## Packages

### @packages/widgets

The design system package - single source of truth for all UI components, themes, and styling.

**Key Features:**
- Material 3 light/dark themes
- Semantic color tokens
- Typography system
- Spacing constants
- Pre-built accessible components

**Documentation:** [packages/widgets/README.md](packages/widgets/README.md)

```dart
import 'package:widgets/widgets.dart';

MaterialApp(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
);
```

### @packages/auth

Complete authentication solution with login, register, and forgot password flows.

**Key Features:**
- Clean Architecture layers
- Abstract navigation delegate (works with any router)
- Mock datasource for development
- BLoC state management

**Documentation:** [packages/auth/README.md](packages/auth/README.md)

```dart
import 'package:auth/auth.dart';

final authModule = AuthModule(dataSource: MockAuthDataSource(box));
final authBloc = authModule.createAuthBloc();
```

### @packages/todo

Todo management feature with CRUD operations and local persistence.

**Key Features:**
- Hive-backed local storage
- BLoC state management
- Pre-built TodoPage UI
- Clean Architecture layers

**Documentation:** [packages/todo/README.md](packages/todo/README.md)

```dart
import 'package:todo/todo.dart';

final todoModule = TodoModule(dataSource: TodoLocalDataSource(box: todoBox));
final todoBloc = todoModule.createTodoBloc();
```

---

## Integration Guide

### Step 1: Add Package Dependencies

In your app's `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Local packages
  widgets:
    path: ../../packages/widgets
  auth:
    path: ../../packages/auth
  todo:
    path: ../../packages/todo

  # Required dependencies
  flutter_bloc: ^9.1.1
  go_router: ^17.0.1
  hive_flutter: ^1.1.0
```

### Step 2: Initialize Storage

```dart
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Open storage boxes
  final authBox = await Hive.openBox<Map>('auth');
  final todoBox = await Hive.openBox<Map>('todos');

  runApp(MyApp(authBox: authBox, todoBox: todoBox));
}
```

### Step 3: Create Dependency Injection

```dart
import 'package:auth/auth.dart';
import 'package:todo/todo.dart';

class Injection {
  late final AuthModule authModule;
  late final TodoModule todoModule;

  Future<void> init(Box<Map> authBox, Box<Map> todoBox) async {
    // Auth setup
    final authDataSource = MockAuthDataSource(authBox);
    authModule = AuthModule(dataSource: authDataSource);

    // Todo setup
    final todoDataSource = TodoLocalDataSource(box: todoBox);
    todoModule = TodoModule(dataSource: todoDataSource);
  }

  List<BlocProvider> get providers => [
    BlocProvider<AuthBloc>(
      create: (_) => authModule.createAuthBloc()..add(const CheckAuthStatus()),
    ),
    BlocProvider<TodoBloc>(
      create: (_) => todoModule.createTodoBloc()..add(const LoadTodos()),
    ),
  ];
}

final injection = Injection();
```

### Step 4: Implement Auth Navigation Delegate

Create a navigation delegate that bridges the auth package with your router:

```dart
import 'package:auth/auth.dart';
import 'package:go_router/go_router.dart';

class AppAuthNavigationDelegate implements AuthNavigationDelegate {
  @override
  void navigateToLogin(BuildContext context) {
    context.go('/login');
  }

  @override
  void navigateToRegister(BuildContext context) {
    context.go('/register');
  }

  @override
  void navigateToForgotPassword(BuildContext context) {
    context.go('/forgot-password');
  }

  @override
  void navigateToHome(BuildContext context) {
    context.go('/todos');
  }

  @override
  void pop(BuildContext context) {
    context.pop();
  }
}
```

### Step 5: Configure Router

```dart
import 'package:go_router/go_router.dart';
import 'package:auth/auth.dart';
import 'package:todo/todo.dart';

GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final isAuthenticated = authBloc.state is Authenticated;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password';

      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }
      if (isAuthenticated && isAuthRoute) {
        return '/todos';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/todos',
        builder: (context, state) => TodoPage(
          onLogout: () {
            context.read<AuthBloc>().add(const LogoutRequested());
          },
        ),
      ),
    ],
  );
}
```

### Step 6: Build the App

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';
import 'package:auth/auth.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: injection.providers,
      child: Builder(
        builder: (context) {
          final authBloc = context.read<AuthBloc>();
          final router = createRouter(authBloc);

          return AuthNavigationProvider(
            delegate: AppAuthNavigationDelegate(),
            child: MaterialApp.router(
              title: 'My App',
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: ThemeMode.system,
              routerConfig: router,
            ),
          );
        },
      ),
    );
  }
}
```

---

## Architecture Patterns

### Clean Architecture Layers

Each feature package follows Clean Architecture:

```
┌─────────────────────────────────────────┐
│           PRESENTATION LAYER            │
│  (BLoC, Pages, Widgets, Navigation)     │
├─────────────────────────────────────────┤
│             DOMAIN LAYER                │
│  (Entities, Repositories, Use Cases)    │
├─────────────────────────────────────────┤
│              DATA LAYER                 │
│  (Models, DataSources, Repository Impl) │
└─────────────────────────────────────────┘
```

### Dependency Flow

```
                    ┌─────────────┐
                    │  example_app │
                    └──────┬──────┘
           ┌───────────────┼───────────────┐
           ▼               ▼               ▼
    ┌──────────┐    ┌──────────┐    ┌──────────┐
    │   auth   │    │   todo   │    │ widgets  │
    └────┬─────┘    └────┬─────┘    └──────────┘
         │               │                ▲
         └───────────────┴────────────────┘
              (depends on widgets)
```

### Module Factory Pattern

Each feature package exposes a `Module` class that handles dependency injection:

```dart
class AuthModule {
  final AuthDataSource _dataSource;

  AuthModule({required AuthDataSource dataSource}) : _dataSource = dataSource;

  AuthBloc createAuthBloc() {
    final repository = AuthRepositoryImpl(dataSource: _dataSource);
    return AuthBloc(
      loginUseCase: LoginUseCase(repository),
      registerUseCase: RegisterUseCase(repository),
      // ... other use cases
    );
  }
}
```

### Abstract Navigation Delegate

The auth package uses an abstract navigation delegate to decouple from specific routing implementations:

```dart
// In auth package - defines the contract
abstract class AuthNavigationDelegate {
  void navigateToLogin(BuildContext context);
  void navigateToRegister(BuildContext context);
  void navigateToHome(BuildContext context);
  // ...
}

// In your app - implements with go_router, auto_route, etc.
class AppAuthNavigationDelegate implements AuthNavigationDelegate {
  @override
  void navigateToLogin(BuildContext context) => context.go('/login');
  // ...
}
```

---

## Commands

### Run Example App

```bash
cd apps/example_app && flutter run
```

### Run Tests

```bash
# All packages
flutter test

# Specific package
cd packages/auth && flutter test
```

### Analyze Code

```bash
flutter analyze
```

### Format Code

```bash
dart format .
```

---

## Best Practices

### Do's

- **Use widgets package** for all UI components
- **Follow Clean Architecture** layers in feature packages
- **Use BLoC** for state management
- **Implement abstract interfaces** for external dependencies
- **Write tests** for each layer

### Don'ts

- **Don't create UI components** outside the widgets package
- **Don't hardcode colors or styles** - use theme tokens
- **Don't skip semantic labels** - accessibility matters
- **Don't couple packages** to specific routing solutions
- **Don't store sensitive data** in plain Hive boxes (use encrypted boxes for production)

---

## Contributing

1. Create a feature branch from `develop`
2. Make your changes
3. Ensure all tests pass
4. Submit a pull request

---

## License

This project is for demonstration and educational purposes.
