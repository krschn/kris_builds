import 'dart:convert';

import 'package:hive/hive.dart';

import '../models/todo_model.dart';

/// Local data source for todo operations using Hive.
class TodoLocalDataSource {
  TodoLocalDataSource(this._box);

  final Box<dynamic> _box;

  static const String _todosKey = 'todos';

  /// Get all todos from local storage
  Future<List<TodoModel>> getTodos() async {
    final String? todosJson = _box.get(_todosKey) as String?;
    if (todosJson == null) return [];

    final List<dynamic> todosList = jsonDecode(todosJson) as List<dynamic>;
    return todosList
        .map((dynamic json) => TodoModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Save all todos to local storage
  Future<void> _saveTodos(List<TodoModel> todos) async {
    final String todosJson =
        jsonEncode(todos.map((TodoModel t) => t.toJson()).toList());
    await _box.put(_todosKey, todosJson);
  }

  /// Add a new todo
  Future<TodoModel> addTodo({
    required String title,
    String? description,
  }) async {
    final List<TodoModel> todos = await getTodos();

    final TodoModel newTodo = TodoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    todos.add(newTodo);
    await _saveTodos(todos);
    return newTodo;
  }

  /// Update an existing todo
  Future<TodoModel> updateTodo(TodoModel todo) async {
    final List<TodoModel> todos = await getTodos();

    final int index = todos.indexWhere((TodoModel t) => t.id == todo.id);
    if (index == -1) {
      throw Exception('Todo not found');
    }

    todos[index] = todo;
    await _saveTodos(todos);
    return todo;
  }

  /// Delete a todo by id
  Future<void> deleteTodo(String id) async {
    final List<TodoModel> todos = await getTodos();
    todos.removeWhere((TodoModel t) => t.id == id);
    await _saveTodos(todos);
  }

  /// Toggle todo completion status
  Future<TodoModel> toggleTodoCompletion(String id) async {
    final List<TodoModel> todos = await getTodos();

    final int index = todos.indexWhere((TodoModel t) => t.id == id);
    if (index == -1) {
      throw Exception('Todo not found');
    }

    final TodoModel todo = todos[index];
    final bool newCompletedStatus = !todo.isCompleted;
    final TodoModel updatedTodo = todo.copyWith(
      isCompleted: newCompletedStatus,
      completedAt: newCompletedStatus ? DateTime.now() : null,
    );

    todos[index] = updatedTodo;
    await _saveTodos(todos);
    return updatedTodo;
  }
}
