import 'package:flutter/widgets.dart';

/// Abstract delegate for auth navigation.
///
/// Apps implement this to provide their own navigation logic
/// (e.g., using go_router, Navigator 2.0, etc.).
abstract class AuthNavigationDelegate {
  /// Navigate to the registration page
  void navigateToRegister(BuildContext context);

  /// Navigate to the forgot password page
  void navigateToForgotPassword(BuildContext context);

  /// Navigate to the login page
  void navigateToLogin(BuildContext context);

  /// Navigate back to the previous page
  void navigateBack(BuildContext context);

  /// Navigate to the home/main page after successful authentication
  void navigateToHome(BuildContext context);
}
