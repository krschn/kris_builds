import '../repositories/auth_repository.dart';

/// Use case for user logout.
class LogoutUseCase {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  /// Execute logout
  Future<void> call() {
    return _repository.logout();
  }
}
