import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/todo.dart';
import '../../domain/usecases/add_todo_usecase.dart';
import '../../domain/usecases/delete_todo_usecase.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../../domain/usecases/update_todo_usecase.dart';

part 'todo_event.dart';
part 'todo_state.dart';

/// BLoC for managing todo state.
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc({
    required GetTodosUseCase getTodosUseCase,
    required AddTodoUseCase addTodoUseCase,
    required UpdateTodoUseCase updateTodoUseCase,
    required DeleteTodoUseCase deleteTodoUseCase,
  })  : _getTodosUseCase = getTodosUseCase,
        _addTodoUseCase = addTodoUseCase,
        _updateTodoUseCase = updateTodoUseCase,
        _deleteTodoUseCase = deleteTodoUseCase,
        super(const TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ToggleTodoCompletion>(_onToggleTodoCompletion);
  }

  final GetTodosUseCase _getTodosUseCase;
  final AddTodoUseCase _addTodoUseCase;
  final UpdateTodoUseCase _updateTodoUseCase;
  final DeleteTodoUseCase _deleteTodoUseCase;

  Future<void> _onLoadTodos(
    LoadTodos event,
    Emitter<TodoState> emit,
  ) async {
    emit(const TodoLoading());
    try {
      final List<Todo> todos = await _getTodosUseCase();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onAddTodo(
    AddTodo event,
    Emitter<TodoState> emit,
  ) async {
    final TodoState currentState = state;
    try {
      await _addTodoUseCase(
        title: event.title,
        description: event.description,
      );
      // Reload todos after adding
      final List<Todo> todos = await _getTodosUseCase();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
      if (currentState is TodoLoaded) {
        emit(currentState);
      }
    }
  }

  Future<void> _onUpdateTodo(
    UpdateTodo event,
    Emitter<TodoState> emit,
  ) async {
    final TodoState currentState = state;
    try {
      await _updateTodoUseCase(event.todo);
      // Reload todos after updating
      final List<Todo> todos = await _getTodosUseCase();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
      if (currentState is TodoLoaded) {
        emit(currentState);
      }
    }
  }

  Future<void> _onDeleteTodo(
    DeleteTodo event,
    Emitter<TodoState> emit,
  ) async {
    final TodoState currentState = state;
    try {
      await _deleteTodoUseCase(event.id);
      // Reload todos after deleting
      final List<Todo> todos = await _getTodosUseCase();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
      if (currentState is TodoLoaded) {
        emit(currentState);
      }
    }
  }

  Future<void> _onToggleTodoCompletion(
    ToggleTodoCompletion event,
    Emitter<TodoState> emit,
  ) async {
    final TodoState currentState = state;
    try {
      await _updateTodoUseCase.toggleCompletion(event.id);
      // Reload todos after toggling
      final List<Todo> todos = await _getTodosUseCase();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
      if (currentState is TodoLoaded) {
        emit(currentState);
      }
    }
  }
}
