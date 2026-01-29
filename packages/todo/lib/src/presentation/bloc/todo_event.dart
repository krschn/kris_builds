part of 'todo_bloc.dart';

/// Event to add a new todo.
final class AddTodo extends TodoEvent {
  const AddTodo({required this.title, this.description});

  final String title;
  final String? description;

  @override
  List<Object?> get props => <Object?>[title, description];
}

/// Event to delete a todo.
final class DeleteTodo extends TodoEvent {
  const DeleteTodo(this.id);

  final String id;

  @override
  List<Object?> get props => <Object?>[id];
}

/// Event to load all todos.
final class LoadTodos extends TodoEvent {
  const LoadTodos();
}

/// Base class for all todo events.
sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Event to toggle todo completion.
final class ToggleTodoCompletion extends TodoEvent {
  const ToggleTodoCompletion(this.id);

  final String id;

  @override
  List<Object?> get props => <Object?>[id];
}

/// Event to update an existing todo.
final class UpdateTodo extends TodoEvent {
  const UpdateTodo(this.todo);

  final Todo todo;

  @override
  List<Object?> get props => <Object?>[todo];
}
