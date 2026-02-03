import 'package:flutter_test/flutter_test.dart';
import 'package:todo/todo.dart';

void main() {
  group('AddTodoUseCase', () {
    late MockTodoRepository mockRepository;
    late AddTodoUseCase useCase;

    final Todo testTodo = Todo(
      id: 'test-id',
      title: 'Test Todo',
      description: 'Test Description',
      createdAt: DateTime(2024, 1, 15),
    );

    setUp(() {
      mockRepository = MockTodoRepository();
      useCase = AddTodoUseCase(mockRepository);
    });

    test('should call repository.addTodo with correct parameters', () async {
      mockRepository.addTodoResult = testTodo;

      await useCase(title: 'Test Todo', description: 'Test Description');

      expect(mockRepository.lastAddTitle, 'Test Todo');
      expect(mockRepository.lastAddDescription, 'Test Description');
    });

    test('should call repository.addTodo with null description', () async {
      mockRepository.addTodoResult = testTodo;

      await useCase(title: 'Test Todo');

      expect(mockRepository.lastAddTitle, 'Test Todo');
      expect(mockRepository.lastAddDescription, isNull);
    });

    test('should return Todo from repository on success', () async {
      mockRepository.addTodoResult = testTodo;

      final Todo result = await useCase(title: 'Test Todo');

      expect(result, testTodo);
    });

    test('should propagate exception from repository', () async {
      mockRepository.addTodoError = Exception('Failed to add todo');

      expect(() => useCase(title: 'Test Todo'), throwsException);
    });
  });
}

class MockTodoRepository implements TodoRepository {
  Todo? addTodoResult;
  Exception? addTodoError;
  String? lastAddTitle;
  String? lastAddDescription;

  @override
  Future<Todo> addTodo({required String title, String? description}) async {
    lastAddTitle = title;
    lastAddDescription = description;
    if (addTodoError != null) {
      throw addTodoError!;
    }
    return addTodoResult!;
  }

  @override
  Future<void> deleteTodo(String id) {
    throw UnimplementedError();
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
