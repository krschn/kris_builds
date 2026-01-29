import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

/// Use case for adding a new todo.
class AddTodoUseCase {
  const AddTodoUseCase(this._repository);

  final TodoRepository _repository;

  /// Add a new todo
  Future<Todo> call({
    required String title,
    String? description,
  }) {
    return _repository.addTodo(title: title, description: description);
  }
}
