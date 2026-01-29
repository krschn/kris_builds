import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

/// Implementation of AuthRepository using abstract data source.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final AuthDataSource _dataSource;

  @override
  Future<User> login({
    required String email,
    required String password,
  }) {
    return _dataSource.login(email: email, password: password);
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String name,
  }) {
    return _dataSource.register(
      email: email,
      password: password,
      name: name,
    );
  }

  @override
  Future<void> forgotPassword({required String email}) {
    return _dataSource.forgotPassword(email: email);
  }

  @override
  Future<void> logout() {
    return _dataSource.logout();
  }

  @override
  Future<User?> getCurrentUser() {
    return _dataSource.getCurrentUser();
  }

  @override
  Future<bool> isAuthenticated() {
    return _dataSource.isAuthenticated();
  }
}
