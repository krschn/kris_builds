# Auth Package

A reusable authentication package with domain, data, and presentation layers following Clean Architecture principles.

## Features

- Login, Register, Logout, Forgot Password flows
- Abstract navigation delegate pattern (works with any router)
- Mock data source for development/testing
- BLoC state management

## Usage

### 1. Add dependency

```yaml
dependencies:
  auth:
    path: ../packages/auth
```

### 2. Create navigation delegate

Implement `AuthNavigationDelegate` for your app's routing solution:

```dart
class AppAuthNavigationDelegate implements AuthNavigationDelegate {
  @override
  void navigateToRegister(BuildContext context) {
    context.push('/register');
  }
  // ... implement other methods
}
```

### 3. Set up AuthModule

```dart
final authDataSource = MockAuthDataSource(hiveBox);
final authModule = AuthModule(dataSource: authDataSource);

// Create bloc
final authBloc = authModule.createAuthBloc();
```

### 4. Wrap your app

```dart
AuthNavigationProvider(
  delegate: AppAuthNavigationDelegate(),
  child: MaterialApp.router(...),
)
```

### 5. Use auth pages

Import and use the provided pages:
- `LoginPage`
- `RegisterPage`
- `ForgotPasswordPage`

## Architecture

```
lib/
├── auth.dart                    # Barrel export
└── src/
    ├── auth_module.dart         # Dependency factory
    ├── domain/                  # Business logic
    │   ├── entities/
    │   ├── repositories/
    │   └── usecases/
    ├── data/                    # Data layer
    │   ├── datasources/
    │   ├── models/
    │   └── repositories/
    └── presentation/            # UI layer
        ├── bloc/
        ├── pages/
        └── navigation/
```
