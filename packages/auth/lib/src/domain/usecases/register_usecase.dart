import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for user registration.
class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  /// Execute registration with user details
  Future<User> call({
    required String email,
    required String password,
    required String name,
  }) {
    return _repository.register(
      email: email,
      password: password,
      name: name,
    );
  }
}
