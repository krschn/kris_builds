import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for getting the current authenticated user.
class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  /// Get current authenticated user, returns null if not authenticated
  Future<User?> call() {
    return _repository.getCurrentUser();
  }
}
