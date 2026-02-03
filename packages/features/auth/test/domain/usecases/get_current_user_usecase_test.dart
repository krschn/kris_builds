import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAuthRepository implements AuthRepository {
  User? getCurrentUserResult;
  Exception? getCurrentUserError;
  bool getCurrentUserCalled = false;

  @override
  Future<User?> getCurrentUser() async {
    getCurrentUserCalled = true;
    if (getCurrentUserError != null) {
      throw getCurrentUserError!;
    }
    return getCurrentUserResult;
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
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isAuthenticated() {
    throw UnimplementedError();
  }
}

void main() {
  group('GetCurrentUserUseCase', () {
    late MockAuthRepository mockRepository;
    late GetCurrentUserUseCase useCase;

    const User testUser = User(
      id: 'test-id',
      email: 'test@example.com',
      name: 'Test User',
    );

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = GetCurrentUserUseCase(mockRepository);
    });

    test('should call repository.getCurrentUser', () async {
      mockRepository.getCurrentUserResult = testUser;

      await useCase();

      expect(mockRepository.getCurrentUserCalled, true);
    });

    test('should return User when user is authenticated', () async {
      mockRepository.getCurrentUserResult = testUser;

      final User? result = await useCase();

      expect(result, testUser);
    });

    test('should return null when user is not authenticated', () async {
      mockRepository.getCurrentUserResult = null;

      final User? result = await useCase();

      expect(result, isNull);
    });

    test('should propagate exception from repository', () async {
      mockRepository.getCurrentUserError = Exception('Failed to get user');

      expect(
        () => useCase(),
        throwsException,
      );
    });
  });
}
