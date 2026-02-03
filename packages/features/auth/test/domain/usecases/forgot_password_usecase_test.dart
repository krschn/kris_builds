import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAuthRepository implements AuthRepository {
  Exception? forgotPasswordError;
  String? lastForgotPasswordEmail;
  bool forgotPasswordCalled = false;

  @override
  Future<void> forgotPassword({required String email}) async {
    lastForgotPasswordEmail = email;
    forgotPasswordCalled = true;
    if (forgotPasswordError != null) {
      throw forgotPasswordError!;
    }
  }

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
  group('ForgotPasswordUseCase', () {
    late MockAuthRepository mockRepository;
    late ForgotPasswordUseCase useCase;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = ForgotPasswordUseCase(mockRepository);
    });

    test('should call repository.forgotPassword with correct email', () async {
      await useCase(email: 'test@example.com');

      expect(mockRepository.forgotPasswordCalled, true);
      expect(mockRepository.lastForgotPasswordEmail, 'test@example.com');
    });

    test('should complete successfully when repository succeeds', () async {
      expect(
        () async => useCase(email: 'test@example.com'),
        returnsNormally,
      );
    });

    test('should propagate exception from repository', () async {
      mockRepository.forgotPasswordError = Exception('User not found');

      expect(
        () => useCase(email: 'nonexistent@example.com'),
        throwsException,
      );
    });
  });
}
