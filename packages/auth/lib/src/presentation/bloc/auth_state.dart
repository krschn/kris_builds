part of 'auth_bloc.dart';

/// Base class for all authentication states.
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
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

  @override
  List<Object?> get props => [user];
}

/// State when user is not authenticated.
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// State when authentication fails.
final class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// State when password reset email is sent successfully.
final class AuthPasswordResetSent extends AuthState {
  const AuthPasswordResetSent();
}
