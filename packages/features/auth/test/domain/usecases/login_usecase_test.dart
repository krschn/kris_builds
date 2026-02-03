import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAuthRepository implements AuthRepository {
  User? loginResult;
  Exception? loginError;
  String? lastLoginEmail;
  String? lastLoginPassword;

  @override
  Future<User> login({required String email, required String password}) async {
    lastLoginEmail = email;
    lastLoginPassword = password;
    if (loginError != null) {
      throw loginError!;
    }
    return loginResult!;
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
  group('LoginUseCase', () {
    late MockAuthRepository mockRepository;
    late LoginUseCase useCase;

    const User testUser = User(
      id: 'test-id',
      email: 'test@example.com',
      name: 'Test User',
    );

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = LoginUseCase(mockRepository);
    });

    test('should call repository.login with correct parameters', () async {
      mockRepository.loginResult = testUser;

      await useCase(email: 'test@example.com', password: 'password123');

      expect(mockRepository.lastLoginEmail, 'test@example.com');
      expect(mockRepository.lastLoginPassword, 'password123');
    });

    test('should return User from repository on success', () async {
      mockRepository.loginResult = testUser;

      final User result = await useCase(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result, testUser);
    });

    test('should propagate exception from repository', () async {
      mockRepository.loginError = Exception('Invalid credentials');

      expect(
        () => useCase(email: 'test@example.com', password: 'wrong'),
        throwsException,
      );
    });
  });
}
