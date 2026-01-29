import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAuthDataSource implements AuthDataSource {
  UserModel? loginResult;
  UserModel? registerResult;
  UserModel? getCurrentUserResult;
  bool? isAuthenticatedResult;
  Exception? error;

  String? lastLoginEmail;
  String? lastLoginPassword;
  String? lastRegisterEmail;
  String? lastRegisterPassword;
  String? lastRegisterName;
  String? lastForgotPasswordEmail;
  bool logoutCalled = false;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    lastLoginEmail = email;
    lastLoginPassword = password;
    if (error != null) throw error!;
    return loginResult!;
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    lastRegisterEmail = email;
    lastRegisterPassword = password;
    lastRegisterName = name;
    if (error != null) throw error!;
    return registerResult!;
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    lastForgotPasswordEmail = email;
    if (error != null) throw error!;
  }

  @override
  Future<void> logout() async {
    logoutCalled = true;
    if (error != null) throw error!;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    if (error != null) throw error!;
    return getCurrentUserResult;
  }

  @override
  Future<bool> isAuthenticated() async {
    if (error != null) throw error!;
    return isAuthenticatedResult!;
  }
}

void main() {
  group('AuthRepositoryImpl', () {
    late MockAuthDataSource mockDataSource;
    late AuthRepositoryImpl repository;

    const UserModel testUserModel = UserModel(
      id: 'test-id',
      email: 'test@example.com',
      name: 'Test User',
    );

    setUp(() {
      mockDataSource = MockAuthDataSource();
      repository = AuthRepositoryImpl(mockDataSource);
    });

    group('login', () {
      test('should delegate to data source with correct parameters', () async {
        mockDataSource.loginResult = testUserModel;

        await repository.login(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(mockDataSource.lastLoginEmail, 'test@example.com');
        expect(mockDataSource.lastLoginPassword, 'password123');
      });

      test('should return User from data source', () async {
        mockDataSource.loginResult = testUserModel;

        final User result = await repository.login(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(result, testUserModel);
        expect(result, isA<User>());
      });

      test('should propagate exception from data source', () async {
        mockDataSource.error = Exception('Invalid credentials');

        expect(
          () => repository.login(
            email: 'test@example.com',
            password: 'wrong',
          ),
          throwsException,
        );
      });
    });

    group('register', () {
      test('should delegate to data source with correct parameters', () async {
        mockDataSource.registerResult = testUserModel;

        await repository.register(
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        );

        expect(mockDataSource.lastRegisterEmail, 'test@example.com');
        expect(mockDataSource.lastRegisterPassword, 'password123');
        expect(mockDataSource.lastRegisterName, 'Test User');
      });

      test('should return User from data source', () async {
        mockDataSource.registerResult = testUserModel;

        final User result = await repository.register(
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        );

        expect(result, testUserModel);
      });

      test('should propagate exception from data source', () async {
        mockDataSource.error = Exception('Email already exists');

        expect(
          () => repository.register(
            email: 'test@example.com',
            password: 'password123',
            name: 'Test User',
          ),
          throwsException,
        );
      });
    });

    group('forgotPassword', () {
      test('should delegate to data source with correct email', () async {
        await repository.forgotPassword(email: 'test@example.com');

        expect(mockDataSource.lastForgotPasswordEmail, 'test@example.com');
      });

      test('should propagate exception from data source', () async {
        mockDataSource.error = Exception('User not found');

        expect(
          () => repository.forgotPassword(email: 'unknown@example.com'),
          throwsException,
        );
      });
    });

    group('logout', () {
      test('should delegate to data source', () async {
        await repository.logout();

        expect(mockDataSource.logoutCalled, true);
      });

      test('should propagate exception from data source', () async {
        mockDataSource.error = Exception('Logout failed');

        expect(
          () => repository.logout(),
          throwsException,
        );
      });
    });

    group('getCurrentUser', () {
      test('should return User when authenticated', () async {
        mockDataSource.getCurrentUserResult = testUserModel;

        final User? result = await repository.getCurrentUser();

        expect(result, testUserModel);
      });

      test('should return null when not authenticated', () async {
        mockDataSource.getCurrentUserResult = null;

        final User? result = await repository.getCurrentUser();

        expect(result, isNull);
      });

      test('should propagate exception from data source', () async {
        mockDataSource.error = Exception('Error getting user');

        expect(
          () => repository.getCurrentUser(),
          throwsException,
        );
      });
    });

    group('isAuthenticated', () {
      test('should return true when authenticated', () async {
        mockDataSource.isAuthenticatedResult = true;

        final bool result = await repository.isAuthenticated();

        expect(result, true);
      });

      test('should return false when not authenticated', () async {
        mockDataSource.isAuthenticatedResult = false;

        final bool result = await repository.isAuthenticated();

        expect(result, false);
      });

      test('should propagate exception from data source', () async {
        mockDataSource.error = Exception('Error checking authentication');

        expect(
          () => repository.isAuthenticated(),
          throwsException,
        );
      });
    });
  });
}
