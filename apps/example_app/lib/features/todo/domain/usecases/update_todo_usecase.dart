import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

/// Use case for updating a todo.
class UpdateTodoUseCase {
  const UpdateTodoUseCase(this._repository);

  final TodoRepository _repository;

  /// Update an existing todo
  Future<Todo> call(Todo todo) {
    return _repository.updateTodo(todo);
  }

  /// Toggle completion status
  Future<Todo> toggleCompletion(String id) {
    return _repository.toggleTodoCompletion(id);
  }
}
