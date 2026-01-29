import 'package:flutter_test/flutter_test.dart';
import 'package:todo/todo.dart';

void main() {
  group('UpdateTodoUseCase', () {
    late MockTodoRepository mockRepository;
    late UpdateTodoUseCase useCase;

    final DateTime testCreatedAt = DateTime(2024, 1, 15);

    final Todo testTodo = Todo(
      id: 'test-id',
      title: 'Test Todo',
      description: 'Test Description',
      createdAt: testCreatedAt,
    );

    setUp(() {
      mockRepository = MockTodoRepository();
      useCase = UpdateTodoUseCase(mockRepository);
    });

    group('call', () {
      test('should call repository.updateTodo with correct todo', () async {
        mockRepository.updateTodoResult = testTodo;

        await useCase(testTodo);

        expect(mockRepository.lastUpdateTodo, testTodo);
      });

      test('should return updated Todo from repository', () async {
        final Todo updatedTodo = testTodo.copyWith(title: 'Updated Title');
        mockRepository.updateTodoResult = updatedTodo;

        final Todo result = await useCase(testTodo);

        expect(result, updatedTodo);
      });

      test('should propagate exception from repository', () async {
        mockRepository.error = Exception('Failed to update todo');

        expect(() => useCase(testTodo), throwsException);
      });
    });

    group('toggleCompletion', () {
      test('should call repository.toggleTodoCompletion with correct id', () async {
        final Todo toggledTodo = testTodo.copyWith(isCompleted: true);
        mockRepository.toggleCompletionResult = toggledTodo;

        await useCase.toggleCompletion('test-id');

        expect(mockRepository.lastToggleId, 'test-id');
      });

      test('should return toggled Todo from repository', () async {
        final Todo toggledTodo = testTodo.copyWith(isCompleted: true);
        mockRepository.toggleCompletionResult = toggledTodo;

        final Todo result = await useCase.toggleCompletion('test-id');

        expect(result.isCompleted, true);
      });

      test('should propagate exception from repository', () async {
        mockRepository.error = Exception('Failed to toggle todo');

        expect(() => useCase.toggleCompletion('test-id'), throwsException);
      });
    });
  });
}

class MockTodoRepository implements TodoRepository {
  Todo? updateTodoResult;
  Todo? toggleCompletionResult;
  Exception? error;
  Todo? lastUpdateTodo;
  String? lastToggleId;

  @override
  Future<Todo> addTodo({required String title, String? description}) {
    throw UnimplementedError();
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
  Future<Todo> toggleTodoCompletion(String id) async {
    lastToggleId = id;
    if (error != null) {
      throw error!;
    }
    return toggleCompletionResult!;
  }

  @override
  Future<Todo> updateTodo(Todo todo) async {
    lastUpdateTodo = todo;
    if (error != null) {
      throw error!;
    }
    return updateTodoResult ?? todo;
  }
}
