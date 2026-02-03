import '../domain/entities/todo.dart';

/// Base class for all todo states.
sealed class TodoState {
  const TodoState();
}

/// Initial todo state.
final class TodoInitial extends TodoState {
  const TodoInitial();
}

/// State when todos are being loaded.
final class TodoLoading extends TodoState {
  const TodoLoading();
}

/// State when todos are successfully loaded.
final class TodoLoaded extends TodoState {
  const TodoLoaded(this.todos);

  final List<Todo> todos;

  /// Get completed todos
  List<Todo> get completedTodos =>
      todos.where((Todo t) => t.isCompleted).toList();

  /// Get incomplete todos
  List<Todo> get incompleteTodos =>
      todos.where((Todo t) => !t.isCompleted).toList();
}

/// State when todo operation fails.
final class TodoError extends TodoState {
  const TodoError(this.message);

  final String message;
}
