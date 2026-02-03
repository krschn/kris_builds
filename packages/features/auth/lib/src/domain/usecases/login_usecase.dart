import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login.
class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  /// Execute login with credentials
  Future<User> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
