import 'data/datasources/todo_local_datasource.dart';
import 'data/repositories/todo_repository_impl.dart';
import 'domain/repositories/todo_repository.dart';
import 'domain/usecases/add_todo_usecase.dart';
import 'domain/usecases/delete_todo_usecase.dart';
import 'domain/usecases/get_todos_usecase.dart';
import 'domain/usecases/update_todo_usecase.dart';
import 'presentation/bloc/todo_bloc.dart';

/// Factory for creating todo dependencies.
///
/// Provides a centralized way to create all todo-related objects
/// with proper dependency injection.
class TodoModule {
  TodoModule({required TodoLocalDataSource dataSource}) : _dataSource = dataSource {
    _repository = TodoRepositoryImpl(_dataSource);
    _getTodosUseCase = GetTodosUseCase(_repository);
    _addTodoUseCase = AddTodoUseCase(_repository);
    _updateTodoUseCase = UpdateTodoUseCase(_repository);
    _deleteTodoUseCase = DeleteTodoUseCase(_repository);
  }

  final TodoLocalDataSource _dataSource;
  late final TodoRepository _repository;
  late final GetTodosUseCase _getTodosUseCase;
  late final AddTodoUseCase _addTodoUseCase;
  late final UpdateTodoUseCase _updateTodoUseCase;
  late final DeleteTodoUseCase _deleteTodoUseCase;

  /// The todo repository instance
  TodoRepository get repository => _repository;

  /// The get todos use case
  GetTodosUseCase get getTodosUseCase => _getTodosUseCase;

  /// The add todo use case
  AddTodoUseCase get addTodoUseCase => _addTodoUseCase;

  /// The update todo use case
  UpdateTodoUseCase get updateTodoUseCase => _updateTodoUseCase;

  /// The delete todo use case
  DeleteTodoUseCase get deleteTodoUseCase => _deleteTodoUseCase;

  /// Create a new TodoBloc instance
  TodoBloc createTodoBloc() => TodoBloc(
        getTodosUseCase: _getTodosUseCase,
        addTodoUseCase: _addTodoUseCase,
        updateTodoUseCase: _updateTodoUseCase,
        deleteTodoUseCase: _deleteTodoUseCase,
      );
}
