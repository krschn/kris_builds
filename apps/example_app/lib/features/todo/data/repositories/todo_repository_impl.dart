import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';
import '../models/todo_model.dart';

/// Implementation of TodoRepository using local data source.
class TodoRepositoryImpl implements TodoRepository {
  const TodoRepositoryImpl(this._dataSource);

  final TodoLocalDataSource _dataSource;

  @override
  Future<List<Todo>> getTodos() {
    return _dataSource.getTodos();
  }

  @override
  Future<Todo> addTodo({
    required String title,
    String? description,
  }) {
    return _dataSource.addTodo(title: title, description: description);
  }

  @override
  Future<Todo> updateTodo(Todo todo) {
    return _dataSource.updateTodo(TodoModel.fromEntity(todo));
  }

  @override
  Future<void> deleteTodo(String id) {
    return _dataSource.deleteTodo(id);
  }

  @override
  Future<Todo> toggleTodoCompletion(String id) {
    return _dataSource.toggleTodoCompletion(id);
  }
}
