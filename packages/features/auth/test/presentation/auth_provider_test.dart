import 'package:auth/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthNotifier', () {
    late MockAuthRepository mockRepository;
    late MockAuthDataSource mockDataSource;
    late ProviderContainer container;

    final User testUser = const User(
      id: 'test-id',
      email: 'test@example.com',
      name: 'Test User',
    );

    setUp(() {
      mockRepository = MockAuthRepository();
      mockDataSource = MockAuthDataSource();
      container = ProviderContainer(
        overrides: <Override>[
          authRepositoryProvider.overrideWithValue(mockRepository),
          authDataSourceProvider.overrideWithValue(mockDataSource),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is AuthInitial', () {
      final AuthState state = container.read(authProvider);
      expect(state, isA<AuthInitial>());
    });

    group('checkAuthStatus', () {
      test('emits AuthAuthenticated when user exists', () async {
        mockDataSource.currentUser = testUser;

        await container.read(authProvider.notifier).checkAuthStatus();

        final AuthState state = container.read(authProvider);
        expect(state, isA<AuthAuthenticated>());
        expect((state as AuthAuthenticated).user, testUser);
      });

      test('emits AuthUnauthenticated when no user', () async {
        mockDataSource.currentUser = null;

        await container.read(authProvider.notifier).checkAuthStatus();

        final AuthState state = container.read(authProvider);
        expect(state, isA<AuthUnauthenticated>());
      });

      test('emits AuthUnauthenticated on error', () async {
        mockDataSource.error = Exception('Error');

        await container.read(authProvider.notifier).checkAuthStatus();

        final AuthState state = container.read(authProvider);
        expect(state, isA<AuthUnauthenticated>());
      });
    });

    group('login', () {
      test('emits AuthAuthenticated on success', () async {
        mockRepository.loginResult = testUser;

        await container.read(authProvider.notifier).login(
              email: 'test@example.com',
              password: 'password123',
            );

        final AuthState state = container.read(authProvider);
        expect(state, isA<AuthAuthenticated>());
      });

      test('emits AuthError on failure', () async {
        mockRepository.error = Exception('Login failed');

        await container.read(authProvider.notifier).login(
              email: 'test@example.com',
              password: 'wrong',
            );

        final AuthState state = container.read(authProvider);
        expect(state, isA<AuthError>());
      });
    });

    group('register', () {
      test('emits AuthAuthenticated on success', () async {
        mockRepository.registerResult = testUser;

        await container.read(authProvider.notifier).register(
              email: 'test@example.com',
              password: 'password123',
              name: 'Test User',
            );

        final AuthState state = container.read(authProvider);
        expect(state, isA<AuthAuthenticated>());
      });

      test('emits AuthError on failure', () async {
        mockRepository.error = Exception('Registration failed');

        await container.read(authProvider.notifier).register(
              email: 'test@example.com',
              password: 'password123',
              name: 'Test User',
            );

        final AuthState state = container.read(authProvider);
        expect(state, isA<AuthError>());
      });
    });

    group('forgotPassword', () {
      test('emits AuthPasswordResetSent on success', () async {
        await container
            .read(authProvider.notifier)
            .forgotPassword(email: 'test@example.com');

        final AuthState state = container.read(authProvider);
        expect(state, isA<AuthPasswordResetSent>());
      });

      test('emits AuthError on failure', () async {
        mockRepository.error = Exception('Reset failed');

        await container
            .read(authProvider.notifier)
            .forgotPassword(email: 'test@example.com');

        final AuthState state = container.read(authProvider);
        expect(state, isA<AuthError>());
      });
    });

    group('logout', () {
      test('emits AuthUnauthenticated on success', () async {
        await container.read(authProvider.notifier).logout();

        final AuthState state = container.read(authProvider);
        expect(state, isA<AuthUnauthenticated>());
      });

      test('emits AuthError on failure', () async {
        mockRepository.error = Exception('Logout failed');

        await container.read(authProvider.notifier).logout();

        final AuthState state = container.read(authProvider);
        expect(state, isA<AuthError>());
      });
    });
  });
}

class MockAuthRepository implements AuthRepository {
  User? loginResult;
  User? registerResult;
  User? currentUser;
  Exception? error;

  @override
  Future<User> login({required String email, required String password}) async {
    if (error != null) {
      throw error!;
    }
    return loginResult!;
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String name,
  }) async {
    if (error != null) {
      throw error!;
    }
    return registerResult!;
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    if (error != null) {
      throw error!;
    }
  }

  @override
  Future<void> logout() async {
    if (error != null) {
      throw error!;
    }
    currentUser = null;
  }

  @override
  Future<User?> getCurrentUser() async {
    if (error != null) {
      throw error!;
    }
    return currentUser;
  }

  @override
  Future<bool> isAuthenticated() async {
    return currentUser != null;
  }
}

class MockAuthDataSource implements AuthDataSource {
  User? currentUser;
  Exception? error;

  @override
  Future<UserModel?> getCurrentUser() async {
    if (error != null) {
      throw error!;
    }
    if (currentUser == null) {
      return null;
    }
    return UserModel(
      id: currentUser!.id,
      email: currentUser!.email,
      name: currentUser!.name,
    );
  }

  @override
  Future<bool> isAuthenticated() async {
    return currentUser != null;
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    throw UnimplementedError();
  }
}
