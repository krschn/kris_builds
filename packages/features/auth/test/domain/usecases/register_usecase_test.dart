import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAuthRepository implements AuthRepository {
  User? registerResult;
  Exception? registerError;
  String? lastRegisterEmail;
  String? lastRegisterPassword;
  String? lastRegisterName;

  @override
  Future<User> register({
    required String email,
    required String password,
    required String name,
  }) async {
    lastRegisterEmail = email;
    lastRegisterPassword = password;
    lastRegisterName = name;
    if (registerError != null) {
      throw registerError!;
    }
    return registerResult!;
  }

  @override
  Future<User> login({required String email, required String password}) {
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
  group('RegisterUseCase', () {
    late MockAuthRepository mockRepository;
    late RegisterUseCase useCase;

    const User testUser = User(
      id: 'test-id',
      email: 'test@example.com',
      name: 'Test User',
    );

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = RegisterUseCase(mockRepository);
    });

    test('should call repository.register with correct parameters', () async {
      mockRepository.registerResult = testUser;

      await useCase(
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
      );

      expect(mockRepository.lastRegisterEmail, 'test@example.com');
      expect(mockRepository.lastRegisterPassword, 'password123');
      expect(mockRepository.lastRegisterName, 'Test User');
    });

    test('should return User from repository on success', () async {
      mockRepository.registerResult = testUser;

      final User result = await useCase(
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
      );

      expect(result, testUser);
    });

    test('should propagate exception from repository', () async {
      mockRepository.registerError = Exception('Email already exists');

      expect(
        () => useCase(
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        ),
        throwsException,
      );
    });
  });
}
