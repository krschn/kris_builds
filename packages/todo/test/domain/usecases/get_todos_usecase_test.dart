import 'package:flutter_test/flutter_test.dart';
import 'package:todo/todo.dart';

void main() {
  group('GetTodosUseCase', () {
    late MockTodoRepository mockRepository;
    late GetTodosUseCase useCase;

    final DateTime testCreatedAt = DateTime(2024, 1, 15);

    final List<Todo> testTodos = <Todo>[
      Todo(id: '1', title: 'Todo 1', createdAt: testCreatedAt),
      Todo(id: '2', title: 'Todo 2', createdAt: testCreatedAt),
    ];

    setUp(() {
      mockRepository = MockTodoRepository();
      useCase = GetTodosUseCase(mockRepository);
    });

    test('should call repository.getTodos', () async {
      mockRepository.getTodosResult = testTodos;

      await useCase();

      expect(mockRepository.getTodosCalled, true);
    });

    test('should return list of todos from repository', () async {
      mockRepository.getTodosResult = testTodos;

      final List<Todo> result = await useCase();

      expect(result, testTodos);
      expect(result.length, 2);
    });

    test('should return empty list when no todos', () async {
      mockRepository.getTodosResult = <Todo>[];

      final List<Todo> result = await useCase();

      expect(result, isEmpty);
    });

    test('should propagate exception from repository', () async {
      mockRepository.getTodosError = Exception('Failed to load todos');

      expect(() => useCase(), throwsException);
    });
  });
}

class MockTodoRepository implements TodoRepository {
  List<Todo>? getTodosResult;
  Exception? getTodosError;
  bool getTodosCalled = false;

  @override
  Future<Todo> addTodo({required String title, String? description}) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTodo(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Todo>> getTodos() async {
    getTodosCalled = true;
    if (getTodosError != null) {
      throw getTodosError!;
    }
    return getTodosResult ?? <Todo>[];
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
