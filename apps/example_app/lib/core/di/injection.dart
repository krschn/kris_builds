import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/todo.dart';

import '../storage/hive_service.dart';

/// Simple dependency injection container.
///
/// Provides singleton instances of repositories, use cases, and blocs.
class Injection {
  static Injection? _instance;

  /// Get the singleton instance
  static Injection get instance {
    _instance ??= Injection._()..init();
    return _instance!;
  }

  /// Provides all necessary blocs for the app
  static List<BlocProvider<dynamic>> get providers => <BlocProvider<dynamic>>[
    BlocProvider<AuthBloc>(
      create: (_) => instance.createAuthBloc()..add(const CheckAuthStatus()),
    ),
    BlocProvider<TodoBloc>(create: (_) => instance.createTodoBloc()),
  ];

  // Auth module
  late final AuthModule _authModule;

  // Todo module
  late final TodoModule _todoModule;

  Injection._();

  // Getters for repositories
  AuthRepository get authRepository => _authModule.repository;
  TodoRepository get todoRepository => _todoModule.repository;

  // Factory methods for blocs
  AuthBloc createAuthBloc() => _authModule.createAuthBloc();

  TodoBloc createTodoBloc() => _todoModule.createTodoBloc();

  /// Initialize all dependencies
  void init() {
    // Auth module (handles all auth dependencies internally)
    final MockAuthDataSource authDataSource = MockAuthDataSource(
      HiveService.authBox,
    );
    _authModule = AuthModule(dataSource: authDataSource);

    // Todo module (handles all todo dependencies internally)
    final TodoLocalDataSource todoDataSource = TodoLocalDataSource(
      HiveService.todoBox,
    );
    _todoModule = TodoModule(dataSource: todoDataSource);
  }
}
