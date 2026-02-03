import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../data/datasources/todo_local_datasource.dart';
import '../data/repositories/todo_repository_impl.dart';
import '../domain/entities/todo.dart';
import '../domain/repositories/todo_repository.dart';
import 'todo_state.dart';

// ============================================================================
// Configuration
// ============================================================================

/// Configuration for the todo feature.
///
/// Apps can override this to provide custom data sources.
class TodoConfig {
  const TodoConfig({
    this.customDataSource,
  });

  /// Custom data source to use instead of the default.
  final TodoLocalDataSource? customDataSource;
}

/// Provider for todo configuration.
///
/// Override this in your app to customize the todo feature.
final Provider<TodoConfig> todoConfigProvider = Provider<TodoConfig>(
  (Ref ref) {
    return const TodoConfig();
  },
);

// ============================================================================
// Data Layer Providers
// ============================================================================

/// Provider for the Hive box used by todo feature.
///
/// This MUST be overridden in the host app with the actual Hive box.
final Provider<Box<dynamic>> todoBoxProvider = Provider<Box<dynamic>>(
  (Ref ref) {
    throw UnimplementedError(
      'todoBoxProvider must be overridden with a Hive box. '
      'Add this to your ProviderScope overrides: '
      'todoBoxProvider.overrideWithValue(yourHiveBox)',
    );
  },
);

/// Provider for the todo data source.
final Provider<TodoLocalDataSource> todoDataSourceProvider =
    Provider<TodoLocalDataSource>(
  (Ref ref) {
    final TodoConfig config = ref.watch(todoConfigProvider);

    // Use custom data source if provided
    if (config.customDataSource != null) {
      return config.customDataSource!;
    }

    // Use default data source with the provided box
    final Box<dynamic> box = ref.watch(todoBoxProvider);
    return TodoLocalDataSource(box);
  },
);

/// Provider for the todo repository.
final Provider<TodoRepository> todoRepositoryProvider =
    Provider<TodoRepository>(
  (Ref ref) {
    final TodoLocalDataSource dataSource = ref.watch(todoDataSourceProvider);
    return TodoRepositoryImpl(dataSource);
  },
);

// ============================================================================
// State Management
// ============================================================================

/// Main provider for todo feature.
///
/// Provides access to todo state and operations.
final NotifierProvider<TodoNotifier, TodoState> todoProvider =
    NotifierProvider<TodoNotifier, TodoState>(
  TodoNotifier.new,
);

/// Notifier for managing todo state.
class TodoNotifier extends Notifier<TodoState> {
  late TodoRepository _repository;

  @override
  TodoState build() {
    _repository = ref.watch(todoRepositoryProvider);
    return const TodoInitial();
  }

  /// Load all todos.
  Future<void> loadTodos() async {
    state = const TodoLoading();
    try {
      final List<Todo> todos = await _repository.getTodos();
      state = TodoLoaded(todos);
    } catch (e) {
      state = TodoError(e.toString());
    }
  }

  /// Add a new todo.
  Future<void> addTodo({
    required String title,
    String? description,
  }) async {
    final TodoState currentState = state;
    try {
      await _repository.addTodo(title: title, description: description);
      final List<Todo> todos = await _repository.getTodos();
      state = TodoLoaded(todos);
    } catch (e) {
      state = TodoError(e.toString());
      if (currentState is TodoLoaded) {
        state = currentState;
      }
    }
  }

  /// Update an existing todo.
  Future<void> updateTodo(Todo todo) async {
    final TodoState currentState = state;
    try {
      await _repository.updateTodo(todo);
      final List<Todo> todos = await _repository.getTodos();
      state = TodoLoaded(todos);
    } catch (e) {
      state = TodoError(e.toString());
      if (currentState is TodoLoaded) {
        state = currentState;
      }
    }
  }

  /// Delete a todo by id.
  Future<void> deleteTodo(String id) async {
    final TodoState currentState = state;
    try {
      await _repository.deleteTodo(id);
      final List<Todo> todos = await _repository.getTodos();
      state = TodoLoaded(todos);
    } catch (e) {
      state = TodoError(e.toString());
      if (currentState is TodoLoaded) {
        state = currentState;
      }
    }
  }

  /// Toggle todo completion status.
  Future<void> toggleTodoCompletion(String id) async {
    final TodoState currentState = state;
    try {
      await _repository.toggleTodoCompletion(id);
      final List<Todo> todos = await _repository.getTodos();
      state = TodoLoaded(todos);
    } catch (e) {
      state = TodoError(e.toString());
      if (currentState is TodoLoaded) {
        state = currentState;
      }
    }
  }
}
