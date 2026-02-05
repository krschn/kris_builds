---
name: flutter-tdd
description: Test-Driven Development (TDD) methodology for Flutter apps. Use when implementing Flutter features with TDD red-green-refactor cycle, writing unit tests, widget tests, or following test-first methodology. Triggers include "write tests first", "use TDD", "red-green-refactor", "unit test", "widget test", "flutter test".
---

# Flutter TDD Testing Workflow

Complete guide for implementing Flutter features using Test-Driven Development methodology with unit and widget tests.

## Overview

This skill provides a comprehensive TDD workflow for Flutter development using `flutter_test` for unit and widget testing. It emphasizes the discipline of test-first development following the Red-Green-Refactor cycle.

## Core TDD Workflow

Follow the **Red-Green-Refactor** cycle strictly:

### 1. RED Phase - Write Failing Test
- Write the test FIRST before any implementation code
- Test should fail initially (red) because feature doesn't exist yet
- Test should describe the expected behavior clearly
- Use descriptive test names that explain what's being tested

### 2. GREEN Phase - Minimal Implementation
- Write the simplest code possible to make the test pass
- Don't add extra features or optimizations yet
- Focus solely on making the current test green
- Run tests frequently to verify progress

### 3. REFACTOR Phase - Improve Code Quality
- Improve code structure while keeping tests green
- Extract methods, rename variables, improve readability
- Remove duplication and apply design patterns
- Run tests after each refactor to ensure nothing breaks

## Test Organization

### Directory Structure
```
lib/
  features/
    auth/
      domain/
      data/
      presentation/
test/
  unit/                # Unit tests
    auth/
      auth_repository_test.dart
      login_usecase_test.dart
  widget/              # Widget tests
    auth/
      login_screen_test.dart
      login_form_test.dart
```

### Test Levels

**Unit Tests** (`test/unit/`)
- Test individual functions, classes, methods
- Use `flutter_test` package
- Mock dependencies
- Fast execution
- Test business logic in isolation

**Widget Tests** (`test/widget/`)
- Test individual widgets in isolation
- Use `flutter_test` package
- Verify widget behavior and rendering
- Test UI interactions without full app

## Running Tests

### Standard Flutter Test Commands

**Run all tests:**
```bash
flutter test
```

**Run unit tests:**
```bash
flutter test test/unit/
```

**Run widget tests:**
```bash
flutter test test/widget/
```

**Run single test file:**
```bash
flutter test test/unit/auth/login_usecase_test.dart
```

**Run tests with coverage:**
```bash
flutter test --coverage
```

**Run tests with verbose output:**
```bash
flutter test --reporter expanded
```

## Unit Test Patterns

### Basic Test Structure

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginUseCase', () {
    late LoginUseCase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = LoginUseCase(mockRepository);
    });

    test('returns User when login succeeds', () async {
      // Arrange
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => Right(testUser));

      // Act
      final result = await useCase(email: 'test@example.com', password: 'pass');

      // Assert
      expect(result, Right(testUser));
      verify(() => mockRepository.login('test@example.com', 'pass')).called(1);
    });

    test('returns AuthFailure when login fails', () async {
      // Arrange
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => Left(AuthFailure.invalidCredentials));

      // Act
      final result = await useCase(email: 'test@example.com', password: 'wrong');

      // Assert
      expect(result, Left(AuthFailure.invalidCredentials));
    });
  });
}
```

### Testing with Mocks

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
  });

  test('calls repository with correct parameters', () async {
    when(() => mockRepo.login(any(), any())).thenAnswer((_) async => result);

    await useCase.execute('email', 'password');

    verify(() => mockRepo.login('email', 'password')).called(1);
  });
}
```

## Widget Test Patterns

### Basic Widget Test

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LoginButton displays correct text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginButton(),
      ),
    );

    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('LoginButton calls onPressed when tapped', (tester) async {
    var wasTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: LoginButton(
          onPressed: () => wasTapped = true,
        ),
      ),
    );

    await tester.tap(find.byType(LoginButton));
    await tester.pump();

    expect(wasTapped, true);
  });
}
```

### Testing Form Input

```dart
testWidgets('displays error when email is invalid', (tester) async {
  await tester.pumpWidget(
    const MaterialApp(home: LoginForm()),
  );

  // Enter invalid email
  await tester.enterText(find.byKey(Key('emailField')), 'invalid');
  await tester.tap(find.byKey(Key('submitButton')));
  await tester.pump();

  // Verify error displayed
  expect(find.text('Invalid email'), findsOneWidget);
});
```

### Testing with BLoC

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockBloc;

  setUp(() {
    mockBloc = MockAuthBloc();
  });

  testWidgets('shows loading indicator when state is loading', (tester) async {
    when(() => mockBloc.state).thenReturn(AuthLoading());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockBloc,
          child: const LoginPage(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

## BLoC Testing Patterns

### Using bloc_test

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthBloc', () {
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login succeeds',
      build: () {
        when(() => mockRepository.login(any(), any()))
            .thenAnswer((_) async => Right(testUser));
        return AuthBloc(mockRepository);
      },
      act: (bloc) => bloc.add(LoginRequested(email: 'test@example.com', password: 'pass')),
      expect: () => [
        AuthLoading(),
        AuthAuthenticated(testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(() => mockRepository.login(any(), any()))
            .thenAnswer((_) async => Left(AuthFailure.invalidCredentials));
        return AuthBloc(mockRepository);
      },
      act: (bloc) => bloc.add(LoginRequested(email: 'test@example.com', password: 'wrong')),
      expect: () => [
        AuthLoading(),
        AuthError('Invalid credentials'),
      ],
    );
  });
}
```

## Best Practices

### TDD Practices
- Always write test first, never skip RED phase
- Keep test cases focused on single behavior
- Use descriptive test names
- Run tests frequently (after each small change)
- Commit when tests are green
- Write only enough code to pass current test

### Code Organization
- Keep test files parallel to implementation
- Group related tests with `group()`
- Use `setUp()` and `tearDown()` for common setup
- Extract test helpers to reduce duplication
- Keep tests independent from each other

### Naming Conventions
- Test files: `*_test.dart`
- Test groups: describe the class/feature being tested
- Test cases: describe expected behavior in plain English

### What to Test
- Test behavior, not implementation
- Focus on public API of classes
- Test edge cases in unit tests
- Test happy path and error states
- Don't test framework code

## TDD Anti-Patterns to Avoid

**Writing implementation before tests**
- Write test first, then implement

**Writing tests for already-written code**
- Follow Red-Green-Refactor strictly

**Testing implementation details**
- Test user-visible behavior

**Skipping refactor phase**
- Always clean up code while tests are green

**Large test cases**
- Keep tests focused on single behavior

**Dependent tests**
- Each test should be independent

## Resources

### Bundled Resources

**references/tdd_examples.md** - Complete TDD cycle examples with real-world scenarios demonstrating Red-Green-Refactor with Flutter

Refer to this resource for detailed step-by-step TDD examples.
