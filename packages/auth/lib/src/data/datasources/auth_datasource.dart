import '../models/user_model.dart';

/// Abstract interface for authentication data source.
///
/// Implementations can use mock data, Firebase, REST API, etc.
abstract class AuthDataSource {
  /// Authenticate with email and password
  Future<UserModel> login({
    required String email,
    required String password,
  });

  /// Register a new user
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  });

  /// Send password reset email
  Future<void> forgotPassword({required String email});

  /// Clear current user session
  Future<void> logout();

  /// Get current authenticated user
  Future<UserModel?> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();
}
