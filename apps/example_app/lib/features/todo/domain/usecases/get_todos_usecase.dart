import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

/// Use case for getting all todos.
class GetTodosUseCase {
  const GetTodosUseCase(this._repository);

  final TodoRepository _repository;

  /// Get all todos
  Future<List<Todo>> call() {
    return _repository.getTodos();
  }
}
