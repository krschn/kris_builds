import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAuthRepository implements AuthRepository {
  Exception? logoutError;
  bool logoutCalled = false;

  @override
  Future<void> logout() async {
    logoutCalled = true;
    if (logoutError != null) {
      throw logoutError!;
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
  Future<void> forgotPassword({required String email}) {
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
  group('LogoutUseCase', () {
    late MockAuthRepository mockRepository;
    late LogoutUseCase useCase;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = LogoutUseCase(mockRepository);
    });

    test('should call repository.logout', () async {
      await useCase();

      expect(mockRepository.logoutCalled, true);
    });

    test('should complete successfully when repository succeeds', () async {
      expect(
        () async => useCase(),
        returnsNormally,
      );
    });

    test('should propagate exception from repository', () async {
      mockRepository.logoutError = Exception('Logout failed');

      expect(
        () => useCase(),
        throwsException,
      );
    });
  });
}
