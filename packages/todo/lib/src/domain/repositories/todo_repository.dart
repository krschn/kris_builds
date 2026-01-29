import '../entities/todo.dart';

/// Repository interface for todo operations.
abstract class TodoRepository {
  /// Get all todos
  Future<List<Todo>> getTodos();

  /// Add a new todo
  Future<Todo> addTodo({
    required String title,
    String? description,
  });

  /// Update an existing todo
  Future<Todo> updateTodo(Todo todo);

  /// Delete a todo by id
  Future<void> deleteTodo(String id);

  /// Toggle todo completion status
  Future<Todo> toggleTodoCompletion(String id);
}
