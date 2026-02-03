import '../domain/entities/user.dart';

/// Base class for all authentication states.
sealed class AuthState {
  const AuthState();
}

/// Initial authentication state.
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State when authentication is in progress.
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State when user is authenticated.
final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final User user;
}

/// State when user is not authenticated.
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// State when authentication fails.
final class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;
}

/// State when password reset email is sent successfully.
final class AuthPasswordResetSent extends AuthState {
  const AuthPasswordResetSent();
}
