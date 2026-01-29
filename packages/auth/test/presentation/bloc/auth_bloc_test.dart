import 'package:auth/auth.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

class MockLoginUseCase extends LoginUseCase {
  MockLoginUseCase() : super(_MockAuthRepository());

  User? result;
  Exception? error;

  @override
  Future<User> call({required String email, required String password}) async {
    if (error != null) throw error!;
    return result!;
  }
}

class MockRegisterUseCase extends RegisterUseCase {
  MockRegisterUseCase() : super(_MockAuthRepository());

  User? result;
  Exception? error;

  @override
  Future<User> call({
    required String email,
    required String password,
    required String name,
  }) async {
    if (error != null) throw error!;
    return result!;
  }
}

class MockForgotPasswordUseCase extends ForgotPasswordUseCase {
  MockForgotPasswordUseCase() : super(_MockAuthRepository());

  Exception? error;

  @override
  Future<void> call({required String email}) async {
    if (error != null) throw error!;
  }
}

class MockLogoutUseCase extends LogoutUseCase {
  MockLogoutUseCase() : super(_MockAuthRepository());

  Exception? error;

  @override
  Future<void> call() async {
    if (error != null) throw error!;
  }
}

class MockAuthDataSource implements AuthDataSource {
  UserModel? getCurrentUserResult;
  Exception? getCurrentUserError;

  @override
  Future<UserModel?> getCurrentUser() async {
    if (getCurrentUserError != null) throw getCurrentUserError!;
    return getCurrentUserResult;
  }

  @override
  Future<UserModel> login({required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> forgotPassword({required String email}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isAuthenticated() {
    throw UnimplementedError();
  }
}

class _MockAuthRepository implements AuthRepository {
  @override
  Future<User> login({required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String name,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> forgotPassword({required String email}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<User?> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isAuthenticated() {
    throw UnimplementedError();
  }
}

void main() {
  group('AuthBloc', () {
    late MockLoginUseCase mockLoginUseCase;
    late MockRegisterUseCase mockRegisterUseCase;
    late MockForgotPasswordUseCase mockForgotPasswordUseCase;
    late MockLogoutUseCase mockLogoutUseCase;
    late MockAuthDataSource mockAuthDataSource;

    const UserModel testUser = UserModel(
      id: 'test-id',
      email: 'test@example.com',
      name: 'Test User',
    );

    setUp(() {
      mockLoginUseCase = MockLoginUseCase();
      mockRegisterUseCase = MockRegisterUseCase();
      mockForgotPasswordUseCase = MockForgotPasswordUseCase();
      mockLogoutUseCase = MockLogoutUseCase();
      mockAuthDataSource = MockAuthDataSource();
    });

    AuthBloc createBloc() => AuthBloc(
          loginUseCase: mockLoginUseCase,
          registerUseCase: mockRegisterUseCase,
          forgotPasswordUseCase: mockForgotPasswordUseCase,
          logoutUseCase: mockLogoutUseCase,
          authDataSource: mockAuthDataSource,
        );

    test('initial state is AuthInitial', () {
      expect(createBloc().state, const AuthInitial());
    });

    group('CheckAuthStatus', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when user is authenticated',
        build: () {
          mockAuthDataSource.getCurrentUserResult = testUser;
          return createBloc();
        },
        act: (AuthBloc bloc) => bloc.add(const CheckAuthStatus()),
        expect: () => [
          const AuthLoading(),
          const AuthAuthenticated(testUser),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when user is not authenticated',
        build: () {
          mockAuthDataSource.getCurrentUserResult = null;
          return createBloc();
        },
        act: (AuthBloc bloc) => bloc.add(const CheckAuthStatus()),
        expect: () => [
          const AuthLoading(),
          const AuthUnauthenticated(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when error occurs',
        build: () {
          mockAuthDataSource.getCurrentUserError = Exception('Error');
          return createBloc();
        },
        act: (AuthBloc bloc) => bloc.add(const CheckAuthStatus()),
        expect: () => [
          const AuthLoading(),
          const AuthUnauthenticated(),
        ],
      );
    });

    group('LoginRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when login succeeds',
        build: () {
          mockLoginUseCase.result = testUser;
          return createBloc();
        },
        act: (AuthBloc bloc) => bloc.add(const LoginRequested(
          email: 'test@example.com',
          password: 'password123',
        )),
        expect: () => [
          const AuthLoading(),
          const AuthAuthenticated(testUser),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when login fails',
        build: () {
          mockLoginUseCase.error = Exception('Invalid credentials');
          return createBloc();
        },
        act: (AuthBloc bloc) => bloc.add(const LoginRequested(
          email: 'test@example.com',
          password: 'wrong',
        )),
        expect: () => [
          const AuthLoading(),
          isA<AuthError>(),
        ],
      );
    });

    group('RegisterRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when registration succeeds',
        build: () {
          mockRegisterUseCase.result = testUser;
          return createBloc();
        },
        act: (AuthBloc bloc) => bloc.add(const RegisterRequested(
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        )),
        expect: () => [
          const AuthLoading(),
          const AuthAuthenticated(testUser),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when registration fails',
        build: () {
          mockRegisterUseCase.error = Exception('Email already exists');
          return createBloc();
        },
        act: (AuthBloc bloc) => bloc.add(const RegisterRequested(
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        )),
        expect: () => [
          const AuthLoading(),
          isA<AuthError>(),
        ],
      );
    });

    group('ForgotPasswordRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthPasswordResetSent] when request succeeds',
        build: createBloc,
        act: (AuthBloc bloc) => bloc.add(const ForgotPasswordRequested(
          email: 'test@example.com',
        )),
        expect: () => [
          const AuthLoading(),
          const AuthPasswordResetSent(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when request fails',
        build: () {
          mockForgotPasswordUseCase.error = Exception('User not found');
          return createBloc();
        },
        act: (AuthBloc bloc) => bloc.add(const ForgotPasswordRequested(
          email: 'unknown@example.com',
        )),
        expect: () => [
          const AuthLoading(),
          isA<AuthError>(),
        ],
      );
    });

    group('LogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when logout succeeds',
        build: createBloc,
        act: (AuthBloc bloc) => bloc.add(const LogoutRequested()),
        expect: () => [
          const AuthLoading(),
          const AuthUnauthenticated(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when logout fails',
        build: () {
          mockLogoutUseCase.error = Exception('Logout failed');
          return createBloc();
        },
        act: (AuthBloc bloc) => bloc.add(const LogoutRequested()),
        expect: () => [
          const AuthLoading(),
          isA<AuthError>(),
        ],
      );
    });
  });

  group('AuthEvent', () {
    test('CheckAuthStatus props are empty', () {
      expect(const CheckAuthStatus().props, isEmpty);
    });

    test('LoginRequested props contain email and password', () {
      const LoginRequested event = LoginRequested(
        email: 'test@example.com',
        password: 'password123',
      );
      expect(event.props, ['test@example.com', 'password123']);
    });

    test('RegisterRequested props contain email, password, and name', () {
      const RegisterRequested event = RegisterRequested(
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
      );
      expect(event.props, ['test@example.com', 'password123', 'Test User']);
    });

    test('ForgotPasswordRequested props contain email', () {
      const ForgotPasswordRequested event = ForgotPasswordRequested(
        email: 'test@example.com',
      );
      expect(event.props, ['test@example.com']);
    });

    test('LogoutRequested props are empty', () {
      expect(const LogoutRequested().props, isEmpty);
    });
  });

  group('AuthState', () {
    test('AuthInitial props are empty', () {
      expect(const AuthInitial().props, isEmpty);
    });

    test('AuthLoading props are empty', () {
      expect(const AuthLoading().props, isEmpty);
    });

    test('AuthAuthenticated props contain user', () {
      const User user = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
      );
      expect(const AuthAuthenticated(user).props, [user]);
    });

    test('AuthUnauthenticated props are empty', () {
      expect(const AuthUnauthenticated().props, isEmpty);
    });

    test('AuthError props contain message', () {
      const AuthError error = AuthError('Error message');
      expect(error.props, ['Error message']);
    });

    test('AuthPasswordResetSent props are empty', () {
      expect(const AuthPasswordResetSent().props, isEmpty);
    });
  });
}
