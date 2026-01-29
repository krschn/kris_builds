import 'data/datasources/auth_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/forgot_password_usecase.dart';
import 'domain/usecases/get_current_user_usecase.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'domain/usecases/register_usecase.dart';
import 'presentation/bloc/auth_bloc.dart';

/// Factory for creating auth dependencies.
///
/// Provides a centralized way to create all auth-related objects
/// with proper dependency injection.
class AuthModule {
  AuthModule({required AuthDataSource dataSource}) : _dataSource = dataSource {
    _repository = AuthRepositoryImpl(_dataSource);
    _loginUseCase = LoginUseCase(_repository);
    _registerUseCase = RegisterUseCase(_repository);
    _forgotPasswordUseCase = ForgotPasswordUseCase(_repository);
    _logoutUseCase = LogoutUseCase(_repository);
    _getCurrentUserUseCase = GetCurrentUserUseCase(_repository);
  }

  final AuthDataSource _dataSource;
  late final AuthRepository _repository;
  late final LoginUseCase _loginUseCase;
  late final RegisterUseCase _registerUseCase;
  late final ForgotPasswordUseCase _forgotPasswordUseCase;
  late final LogoutUseCase _logoutUseCase;
  late final GetCurrentUserUseCase _getCurrentUserUseCase;

  /// The auth repository instance
  AuthRepository get repository => _repository;

  /// The login use case
  LoginUseCase get loginUseCase => _loginUseCase;

  /// The register use case
  RegisterUseCase get registerUseCase => _registerUseCase;

  /// The forgot password use case
  ForgotPasswordUseCase get forgotPasswordUseCase => _forgotPasswordUseCase;

  /// The logout use case
  LogoutUseCase get logoutUseCase => _logoutUseCase;

  /// The get current user use case
  GetCurrentUserUseCase get getCurrentUserUseCase => _getCurrentUserUseCase;

  /// Create a new AuthBloc instance
  AuthBloc createAuthBloc() => AuthBloc(
        loginUseCase: _loginUseCase,
        registerUseCase: _registerUseCase,
        forgotPasswordUseCase: _forgotPasswordUseCase,
        logoutUseCase: _logoutUseCase,
        authDataSource: _dataSource,
      );
}
