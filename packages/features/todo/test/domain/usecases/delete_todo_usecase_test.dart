import 'package:flutter_test/flutter_test.dart';
import 'package:todo/todo.dart';

void main() {
  group('DeleteTodoUseCase', () {
    late MockTodoRepository mockRepository;
    late DeleteTodoUseCase useCase;

    setUp(() {
      mockRepository = MockTodoRepository();
      useCase = DeleteTodoUseCase(mockRepository);
    });

    test('should call repository.deleteTodo with correct id', () async {
      await useCase('test-id');

      expect(mockRepository.deleteTodoCalled, true);
      expect(mockRepository.lastDeleteId, 'test-id');
    });

    test('should complete successfully when repository succeeds', () async {
      expect(() async => useCase('test-id'), returnsNormally);
    });

    test('should propagate exception from repository', () async {
      mockRepository.deleteTodoError = Exception('Failed to delete todo');

      expect(() => useCase('test-id'), throwsException);
    });
  });
}

class MockTodoRepository implements TodoRepository {
  Exception? deleteTodoError;
  String? lastDeleteId;
  bool deleteTodoCalled = false;

  @override
  Future<Todo> addTodo({required String title, String? description}) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTodo(String id) async {
    lastDeleteId = id;
    deleteTodoCalled = true;
    if (deleteTodoError != null) {
      throw deleteTodoError!;
    }
  }

  @override
  Future<List<Todo>> getTodos() {
    throw UnimplementedError();
  }

  @override
  Future<Todo> toggleTodoCompletion(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Todo> updateTodo(Todo todo) {
    throw UnimplementedError();
  }
}
