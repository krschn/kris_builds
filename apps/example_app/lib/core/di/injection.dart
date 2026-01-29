import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/todo/data/datasources/todo_local_datasource.dart';
import '../../features/todo/data/repositories/todo_repository_impl.dart';
import '../../features/todo/domain/repositories/todo_repository.dart';
import '../../features/todo/domain/usecases/add_todo_usecase.dart';
import '../../features/todo/domain/usecases/delete_todo_usecase.dart';
import '../../features/todo/domain/usecases/get_todos_usecase.dart';
import '../../features/todo/domain/usecases/update_todo_usecase.dart';
import '../../features/todo/presentation/bloc/todo_bloc.dart';
import '../storage/hive_service.dart';

/// Simple dependency injection container.
///
/// Provides singleton instances of repositories, use cases, and blocs.
class Injection {
  Injection._();

  static Injection? _instance;

  // Auth module
  late final AuthModule _authModule;

  // Data sources - Todo
  late final TodoLocalDataSource _todoDataSource;

  // Repositories
  late final TodoRepository _todoRepository;

  // Use cases - Todo
  late final GetTodosUseCase _getTodosUseCase;
  late final AddTodoUseCase _addTodoUseCase;
  late final UpdateTodoUseCase _updateTodoUseCase;
  late final DeleteTodoUseCase _deleteTodoUseCase;

  /// Get the singleton instance
  static Injection get instance {
    _instance ??= Injection._()..init();
    return _instance!;
  }

  /// Initialize all dependencies
  void init() {
    // Auth module (handles all auth dependencies internally)
    final authDataSource = MockAuthDataSource(HiveService.authBox);
    _authModule = AuthModule(dataSource: authDataSource);

    // Todo data sources
    _todoDataSource = TodoLocalDataSource(HiveService.todoBox);

    // Repositories
    _todoRepository = TodoRepositoryImpl(_todoDataSource);

    // Todo use cases
    _getTodosUseCase = GetTodosUseCase(_todoRepository);
    _addTodoUseCase = AddTodoUseCase(_todoRepository);
    _updateTodoUseCase = UpdateTodoUseCase(_todoRepository);
    _deleteTodoUseCase = DeleteTodoUseCase(_todoRepository);
  }

  // Getters for repositories
  AuthRepository get authRepository => _authModule.repository;
  TodoRepository get todoRepository => _todoRepository;

  // Factory methods for blocs
  AuthBloc createAuthBloc() => _authModule.createAuthBloc();

  TodoBloc createTodoBloc() => TodoBloc(
        getTodosUseCase: _getTodosUseCase,
        addTodoUseCase: _addTodoUseCase,
        updateTodoUseCase: _updateTodoUseCase,
        deleteTodoUseCase: _deleteTodoUseCase,
      );

  /// Provides all necessary blocs for the app
  static List<BlocProvider> get providers => [
        BlocProvider<AuthBloc>(
          create: (_) => instance.createAuthBloc()..add(const CheckAuthStatus()),
        ),
        BlocProvider<TodoBloc>(
          create: (_) => instance.createTodoBloc(),
        ),
      ];
}
