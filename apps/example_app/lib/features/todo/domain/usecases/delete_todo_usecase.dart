import '../repositories/todo_repository.dart';

/// Use case for deleting a todo.
class DeleteTodoUseCase {
  const DeleteTodoUseCase(this._repository);

  final TodoRepository _repository;

  /// Delete a todo by id
  Future<void> call(String id) {
    return _repository.deleteTodo(id);
  }
}
