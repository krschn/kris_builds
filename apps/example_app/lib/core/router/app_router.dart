import 'package:auth/auth.dart';
import 'package:calculator/calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/todo.dart';
import 'package:treat_decider/treat_decider.dart';

/// Application router configuration using go_router.
class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  AppRouter._();

  static GoRouter router(AuthBloc authBloc) => GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    refreshListenable: _GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final bool isAuthenticated =
          context.read<AuthBloc>().state is AuthAuthenticated;
      final bool isAuthRoute =
          state.matchedLocation == AppRoutes.login ||
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
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.todos,
        name: 'todos',
        builder: (context, state) => Scaffold(
          body: TodoPage(
            onLogout: () {
              context.read<AuthBloc>().add(const LogoutRequested());
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            onTap: (index) {
              if (index == 1) {
                context.go(AppRoutes.treatDecider);
              } else if (index == 2) {
                context.go(AppRoutes.calculator);
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline),
                label: 'Todos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.celebration),
                label: 'Treat Decider',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calculate),
                label: 'Calculator',
              ),
            ],
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.treatDecider,
        name: 'treatDecider',
        builder: (context, state) => Scaffold(
          body: TreatDeciderPage(
            onNavigateToHistory: () => context.push(AppRoutes.treatDeciderHistory),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 1,
            onTap: (index) {
              if (index == 0) {
                context.go(AppRoutes.todos);
              } else if (index == 2) {
                context.go(AppRoutes.calculator);
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline),
                label: 'Todos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.celebration),
                label: 'Treat Decider',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calculate),
                label: 'Calculator',
              ),
            ],
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.treatDeciderHistory,
        name: 'treatDeciderHistory',
        builder: (context, state) {
          context.read<TreatDeciderBloc>().add(const LoadHistory());
          return const TreatHistoryPage();
        },
      ),
      GoRoute(
        path: AppRoutes.calculator,
        name: 'calculator',
        builder: (context, state) => Scaffold(
          body: const CalculatorPage(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 2,
            onTap: (index) {
              if (index == 0) {
                context.go(AppRoutes.todos);
              } else if (index == 1) {
                context.go(AppRoutes.treatDecider);
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline),
                label: 'Todos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.celebration),
                label: 'Treat Decider',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calculate),
                label: 'Calculator',
              ),
            ],
          ),
        ),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}

/// Application route paths
class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String todos = '/todos';
  static const String treatDecider = '/treat-decider';
  static const String treatDeciderHistory = '/treat-decider/history';
  static const String calculator = '/calculator';
  AppRoutes._();
}

/// Converts a Stream into a Listenable for GoRouter refresh
class _GoRouterRefreshStream extends ChangeNotifier {
  late final dynamic _subscription;

  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
