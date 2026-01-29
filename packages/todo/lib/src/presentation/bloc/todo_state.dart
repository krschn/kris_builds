part of 'todo_bloc.dart';

/// State when todo operation fails.
final class TodoError extends TodoState {
  const TodoError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

/// Initial todo state.
final class TodoInitial extends TodoState {
  const TodoInitial();
}

/// State when todos are successfully loaded.
final class TodoLoaded extends TodoState {
  const TodoLoaded(this.todos);

  final List<Todo> todos;

  /// Get completed todos
  List<Todo> get completedTodos => todos.where((Todo t) => t.isCompleted).toList();

  /// Get incomplete todos
  List<Todo> get incompleteTodos => todos.where((Todo t) => !t.isCompleted).toList();

  @override
  List<Object?> get props => <Object?>[todos];
}

/// State when todos are being loaded.
final class TodoLoading extends TodoState {
  const TodoLoading();
}

/// Base class for all todo states.
sealed class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => <Object?>[];
}
