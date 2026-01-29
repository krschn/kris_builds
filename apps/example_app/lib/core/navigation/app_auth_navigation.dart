import 'package:auth/auth.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';

/// App's implementation of AuthNavigationDelegate using go_router.
class AppAuthNavigationDelegate implements AuthNavigationDelegate {
  const AppAuthNavigationDelegate();

  @override
  void navigateToRegister(BuildContext context) {
    context.push(AppRoutes.register);
  }

  @override
  void navigateToForgotPassword(BuildContext context) {
    context.push(AppRoutes.forgotPassword);
  }

  @override
  void navigateToLogin(BuildContext context) {
    context.go(AppRoutes.login);
  }

  @override
  void navigateBack(BuildContext context) {
    context.pop();
  }

  @override
  void navigateToHome(BuildContext context) {
    context.go(AppRoutes.todos);
  }
}
