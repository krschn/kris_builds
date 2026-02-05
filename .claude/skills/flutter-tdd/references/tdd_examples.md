# TDD Examples with Flutter Test

Real-world examples demonstrating the complete Red-Green-Refactor cycle using `flutter_test`.

## Example 1: Counter App - Unit Test

A simple counter demonstrating the full TDD cycle with unit tests.

### RED Phase - Write Failing Test

```dart
// test/unit/counter_bloc_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/counter_bloc.dart';

void main() {
  group('CounterBloc', () {
    late CounterBloc bloc;

    setUp(() {
      bloc = CounterBloc();
    });

    test('initial value is 0', () {
      expect(bloc.value, 0);
    });

    test('increment increases value by 1', () {
      bloc.increment();
      expect(bloc.value, 1);
    });

    test('multiple increments accumulate', () {
      bloc.increment();
      bloc.increment();
      bloc.increment();
      expect(bloc.value, 3);
    });
  });
}
```

**Run test:** `flutter test test/unit/counter_bloc_test.dart`

**Expected result:** Test fails - CounterBloc doesn't exist yet

### GREEN Phase - Minimal Implementation

```dart
// lib/counter_bloc.dart
class CounterBloc {
  int _value = 0;

  int get value => _value;

  void increment() {
    _value++;
  }
}
```

**Run test:** `flutter test test/unit/counter_bloc_test.dart`

**Result:** ✅ All tests pass!

### REFACTOR Phase - Improve Code

Add decrement and reset functionality following TDD:

```dart
// test/unit/counter_bloc_test.dart (add more tests)
test('decrement decreases value by 1', () {
  bloc.increment();
  bloc.increment();
  bloc.decrement();
  expect(bloc.value, 1);
});

test('reset sets value to 0', () {
  bloc.increment();
  bloc.increment();
  bloc.reset();
  expect(bloc.value, 0);
});

// lib/counter_bloc.dart (implement)
class CounterBloc {
  int _value = 0;

  int get value => _value;

  void increment() => _value++;

  void decrement() => _value--;

  void reset() => _value = 0;
}
```

## Example 2: Counter App - Widget Test

Testing the counter widget with `flutter_test`.

### RED Phase - Write Failing Test

```dart
// test/widget/counter_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/counter_page.dart';

void main() {
  group('CounterPage', () {
    testWidgets('displays initial counter value of 0', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: CounterPage()),
      );

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('increments counter when FAB is tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: CounterPage()),
      );

      // Initial state
      expect(find.text('0'), findsOneWidget);

      // Tap FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      // Counter should increment
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('decrements counter when minus button is tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: CounterPage()),
      );

      // Increment first
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);

      // Tap minus button
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      // Counter should decrement
      expect(find.text('0'), findsOneWidget);
    });
  });
}
```

### GREEN Phase - Minimal Implementation

```dart
// lib/counter_page.dart
import 'package:flutter/material.dart';
import 'counter_bloc.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final _bloc = CounterBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Text(
          '${_bloc.value}',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () => setState(() => _bloc.increment()),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => setState(() => _bloc.decrement()),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
```

## Example 3: Login Form Validation - Unit Test

Testing form validation logic in isolation.

### RED Phase - Write Failing Tests

```dart
// test/unit/validators_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/validators.dart';

void main() {
  group('EmailValidator', () {
    test('returns true for valid email', () {
      expect(EmailValidator.isValid('user@example.com'), true);
      expect(EmailValidator.isValid('test.user@domain.co.uk'), true);
    });

    test('returns false for invalid email', () {
      expect(EmailValidator.isValid('invalid'), false);
      expect(EmailValidator.isValid('missing@domain'), false);
      expect(EmailValidator.isValid('@nodomain.com'), false);
      expect(EmailValidator.isValid(''), false);
    });
  });

  group('PasswordValidator', () {
    test('returns true for valid password (8+ chars)', () {
      expect(PasswordValidator.isValid('password123'), true);
      expect(PasswordValidator.isValid('12345678'), true);
    });

    test('returns false for short password', () {
      expect(PasswordValidator.isValid('short'), false);
      expect(PasswordValidator.isValid('1234567'), false);
      expect(PasswordValidator.isValid(''), false);
    });
  });
}
```

### GREEN Phase - Minimal Implementation

```dart
// lib/validators.dart
class EmailValidator {
  static bool isValid(String email) {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}

class PasswordValidator {
  static bool isValid(String password) {
    return password.length >= 8;
  }
}
```

## Example 4: Login Form - Widget Test

Testing the login form widget behavior.

### RED Phase - Write Failing Tests

```dart
// test/widget/login_form_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/login_form.dart';

void main() {
  group('LoginForm', () {
    testWidgets('displays email and password fields', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoginForm())),
      );

      expect(find.byKey(const Key('emailField')), findsOneWidget);
      expect(find.byKey(const Key('passwordField')), findsOneWidget);
      expect(find.byKey(const Key('loginButton')), findsOneWidget);
    });

    testWidgets('shows error when email is invalid', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoginForm())),
      );

      // Enter invalid email
      await tester.enterText(find.byKey(const Key('emailField')), 'invalid');
      await tester.enterText(find.byKey(const Key('passwordField')), 'password123');
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump();

      expect(find.text('Invalid email'), findsOneWidget);
    });

    testWidgets('shows error when password is too short', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoginForm())),
      );

      await tester.enterText(find.byKey(const Key('emailField')), 'user@example.com');
      await tester.enterText(find.byKey(const Key('passwordField')), 'short');
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump();

      expect(find.text('Password must be at least 8 characters'), findsOneWidget);
    });

    testWidgets('calls onSubmit with valid credentials', (tester) async {
      String? submittedEmail;
      String? submittedPassword;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginForm(
              onSubmit: (email, password) {
                submittedEmail = email;
                submittedPassword = password;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byKey(const Key('emailField')), 'user@example.com');
      await tester.enterText(find.byKey(const Key('passwordField')), 'password123');
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump();

      expect(submittedEmail, 'user@example.com');
      expect(submittedPassword, 'password123');
    });
  });
}
```

### GREEN Phase - Minimal Implementation

```dart
// lib/login_form.dart
import 'package:flutter/material.dart';
import 'validators.dart';

class LoginForm extends StatefulWidget {
  final void Function(String email, String password)? onSubmit;

  const LoginForm({super.key, this.onSubmit});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  void _submit() {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (!EmailValidator.isValid(email)) {
      setState(() => _errorMessage = 'Invalid email');
      return;
    }

    if (!PasswordValidator.isValid(password)) {
      setState(() => _errorMessage = 'Password must be at least 8 characters');
      return;
    }

    setState(() => _errorMessage = null);
    widget.onSubmit?.call(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            key: const Key('emailField'),
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextField(
            key: const Key('passwordField'),
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            key: const Key('loginButton'),
            onPressed: _submit,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

## Example 5: BLoC Testing with bloc_test

Testing a BLoC using the `bloc_test` package.

### RED Phase - Write Failing Tests

```dart
// test/unit/auth_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/auth_bloc.dart';
import 'package:my_app/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

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
            .thenAnswer((_) async => User(id: '1', email: 'test@example.com'));
        return AuthBloc(mockRepository);
      },
      act: (bloc) => bloc.add(LoginRequested(
        email: 'test@example.com',
        password: 'password123',
      )),
      expect: () => [
        AuthLoading(),
        isA<AuthAuthenticated>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(() => mockRepository.login(any(), any()))
            .thenThrow(Exception('Invalid credentials'));
        return AuthBloc(mockRepository);
      },
      act: (bloc) => bloc.add(LoginRequested(
        email: 'test@example.com',
        password: 'wrong',
      )),
      expect: () => [
        AuthLoading(),
        isA<AuthError>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthInitial] when logout is requested',
      build: () {
        when(() => mockRepository.logout()).thenAnswer((_) async {});
        return AuthBloc(mockRepository);
      },
      seed: () => AuthAuthenticated(User(id: '1', email: 'test@example.com')),
      act: (bloc) => bloc.add(LogoutRequested()),
      expect: () => [AuthInitial()],
    );
  });
}
```

### GREEN Phase - Minimal Implementation

```dart
// lib/auth_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'auth_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogoutRequested extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _repository.login(event.email, event.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _repository.logout();
    emit(AuthInitial());
  }
}
```

## Key Takeaways

1. **Always start with RED** - Write the test first, see it fail
2. **Keep GREEN simple** - Write minimal code to pass
3. **REFACTOR with confidence** - Tests protect your changes
4. **Test in isolation** - Unit tests mock dependencies
5. **Use descriptive names** - Tests document expected behavior
6. **One assertion per concept** - Keep tests focused

## TDD Anti-Patterns to Avoid

- **Writing implementation before tests** - Write test first, then implement
- **Writing tests for already-written code** - Follow Red-Green-Refactor strictly
- **Testing implementation details** - Test behavior, not internals
- **Skipping refactor phase** - Always clean up while tests are green
- **Large test cases** - Keep tests focused on single behavior
- **Dependent tests** - Each test should be independent
