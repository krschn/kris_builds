import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../data/datasources/auth_datasource.dart';
import '../data/datasources/mock_auth_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/entities/user.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

// ============================================================================
// Configuration
// ============================================================================

/// Configuration for the auth feature.
///
/// Apps can override this to provide custom data sources.
class AuthConfig {
  const AuthConfig({
    this.customDataSource,
  });

  /// Custom data source to use instead of the default.
  final AuthDataSource? customDataSource;
}

/// Provider for auth configuration.
///
/// Override this in your app to customize the auth feature.
final Provider<AuthConfig> authConfigProvider = Provider<AuthConfig>(
  (Ref ref) {
    return const AuthConfig();
  },
);

// ============================================================================
// Data Layer Providers
// ============================================================================

/// Provider for the Hive box used by auth feature.
///
/// This MUST be overridden in the host app with the actual Hive box.
final Provider<Box<dynamic>> authBoxProvider = Provider<Box<dynamic>>(
  (Ref ref) {
    throw UnimplementedError(
      'authBoxProvider must be overridden with a Hive box. '
      'Add this to your ProviderScope overrides: '
      'authBoxProvider.overrideWithValue(yourHiveBox)',
    );
  },
);

/// Provider for the auth data source.
final Provider<AuthDataSource> authDataSourceProvider =
    Provider<AuthDataSource>(
  (Ref ref) {
    final AuthConfig config = ref.watch(authConfigProvider);

    // Use custom data source if provided
    if (config.customDataSource != null) {
      return config.customDataSource!;
    }

    // Use default mock data source with the provided box
    final Box<dynamic> box = ref.watch(authBoxProvider);
    return MockAuthDataSource(box);
  },
);

/// Provider for the auth repository.
final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>(
  (Ref ref) {
    final AuthDataSource dataSource = ref.watch(authDataSourceProvider);
    return AuthRepositoryImpl(dataSource);
  },
);

// ============================================================================
// State Management
// ============================================================================

/// Main provider for auth feature.
///
/// Provides access to auth state and operations.
final NotifierProvider<AuthNotifier, AuthState> authProvider =
    NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

/// Notifier for managing auth state.
class AuthNotifier extends Notifier<AuthState> {
  late AuthRepository _repository;
  late AuthDataSource _dataSource;

  @override
  AuthState build() {
    _repository = ref.watch(authRepositoryProvider);
    _dataSource = ref.watch(authDataSourceProvider);
    return const AuthInitial();
  }

  /// Check current authentication status.
  Future<void> checkAuthStatus() async {
    state = const AuthLoading();
    try {
      final User? user = await _dataSource.getCurrentUser();
      if (user != null) {
        state = AuthAuthenticated(user);
      } else {
        state = const AuthUnauthenticated();
      }
    } catch (e) {
      state = const AuthUnauthenticated();
    }
  }

  /// Login with email and password.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      final User user = await _repository.login(
        email: email,
        password: password,
      );
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  /// Register a new user.
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AuthLoading();
    try {
      final User user = await _repository.register(
        email: email,
        password: password,
        name: name,
      );
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  /// Request password reset.
  Future<void> forgotPassword({required String email}) async {
    state = const AuthLoading();
    try {
      await _repository.forgotPassword(email: email);
      state = const AuthPasswordResetSent();
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  /// Logout the current user.
  Future<void> logout() async {
    state = const AuthLoading();
    try {
      await _repository.logout();
      state = const AuthUnauthenticated();
    } catch (e) {
      state = AuthError(e.toString());
    }
  }
}
