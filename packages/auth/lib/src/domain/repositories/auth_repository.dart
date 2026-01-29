import '../entities/user.dart';

/// Repository interface for authentication operations.
abstract class AuthRepository {
  /// Attempt to log in with email and password
  Future<User> login({
    required String email,
    required String password,
  });

  /// Register a new user
  Future<User> register({
    required String email,
    required String password,
    required String name,
  });

  /// Send password reset email
  Future<void> forgotPassword({required String email});

  /// Log out the current user
  Future<void> logout();

  /// Get the currently authenticated user (if any)
  Future<User?> getCurrentUser();

  /// Check if a user is currently authenticated
  Future<bool> isAuthenticated();
}
