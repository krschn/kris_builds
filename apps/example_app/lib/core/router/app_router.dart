import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/todo.dart';

/// Application route paths
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String todos = '/todos';
}

/// Provider for the GoRouter configuration.
///
/// This provider creates a router that listens to auth state changes.
final Provider<GoRouter> routerProvider = Provider<GoRouter>((Ref ref) {
  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    refreshListenable: _AuthRefreshNotifier(ref),
    redirect: (BuildContext context, GoRouterState state) {
      final AuthState authState = ref.read(authProvider);
      final bool isAuthenticated = authState is AuthAuthenticated;
      final bool isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register ||
          state.matchedLocation == AppRoutes.forgotPassword;

      // Redirect to todos if authenticated and on auth route
      if (isAuthenticated && isAuthRoute) {
        return AppRoutes.todos;
      }

      // Redirect to login if not authenticated and not on auth route
      if (!isAuthenticated && !isAuthRoute) {
        return AppRoutes.login;
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (BuildContext context, GoRouterState state) =>
            const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (BuildContext context, GoRouterState state) =>
            const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.todos,
        name: 'todos',
        builder: (BuildContext context, GoRouterState state) => Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return TodoPage(
              onLogout: () {
                ref.read(authProvider.notifier).logout();
              },
            );
          },
        ),
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
});

/// Notifier that listens to auth state changes and refreshes the router.
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(this._ref) {
    // Initial notification
    notifyListeners();

    // Listen to auth state changes
    _ref.listen<AuthState>(authProvider, (AuthState? previous, AuthState next) {
      notifyListeners();
    });
  }

  final Ref _ref;
}
