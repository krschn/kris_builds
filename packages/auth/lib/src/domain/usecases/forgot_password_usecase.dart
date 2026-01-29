import '../repositories/auth_repository.dart';

/// Use case for password reset.
class ForgotPasswordUseCase {
  const ForgotPasswordUseCase(this._repository);

  final AuthRepository _repository;

  /// Send password reset email
  Future<void> call({required String email}) {
    return _repository.forgotPassword(email: email);
  }
}
