import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/todo.dart';

void main() {
  group('TodoNotifier', () {
    late MockTodoRepository mockRepository;
    late ProviderContainer container;

    final DateTime testCreatedAt = DateTime(2024, 1, 15, 10, 30);

    final Todo testTodo = Todo(
      id: 'test-id',
      title: 'Test Todo',
      description: 'Test Description',
      createdAt: testCreatedAt,
    );

    setUp(() {
      mockRepository = MockTodoRepository();
      container = ProviderContainer(
        overrides: <Override>[
          todoRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is TodoInitial', () {
      final TodoState state = container.read(todoProvider);
      expect(state, isA<TodoInitial>());
    });

    group('loadTodos', () {
      test('emits TodoLoading then TodoLoaded when loading succeeds', () async {
        mockRepository.todos = <Todo>[testTodo];

        final List<TodoState> states = <TodoState>[];
        container.listen<TodoState>(
          todoProvider,
          (TodoState? previous, TodoState next) => states.add(next),
          fireImmediately: true,
        );

        await container.read(todoProvider.notifier).loadTodos();

        expect(states, <TypeMatcher<TodoState>>[
          isA<TodoInitial>(),
          isA<TodoLoading>(),
          isA<TodoLoaded>(),
        ]);

        final TodoState lastState = container.read(todoProvider);
        expect(lastState, isA<TodoLoaded>());
        expect((lastState as TodoLoaded).todos, <Todo>[testTodo]);
      });

      test('emits TodoLoading then TodoLoaded with empty list when no todos',
          () async {
        mockRepository.todos = <Todo>[];

        await container.read(todoProvider.notifier).loadTodos();

        final TodoState state = container.read(todoProvider);
        expect(state, isA<TodoLoaded>());
        expect((state as TodoLoaded).todos, isEmpty);
      });

      test('emits TodoLoading then TodoError when loading fails', () async {
        mockRepository.error = Exception('Failed to load');

        await container.read(todoProvider.notifier).loadTodos();

        final TodoState state = container.read(todoProvider);
        expect(state, isA<TodoError>());
      });
    });

    group('addTodo', () {
      test('emits TodoLoaded when adding succeeds', () async {
        mockRepository.todos = <Todo>[];

        await container.read(todoProvider.notifier).addTodo(
              title: 'Test Todo',
              description: 'Test Description',
            );

        final TodoState state = container.read(todoProvider);
        expect(state, isA<TodoLoaded>());
        expect((state as TodoLoaded).todos.length, 1);
      });

      test('emits TodoError when adding fails', () async {
        mockRepository.error = Exception('Failed to add');

        await container.read(todoProvider.notifier).addTodo(title: 'Test');

        final TodoState state = container.read(todoProvider);
        expect(state, isA<TodoError>());
      });
    });

    group('updateTodo', () {
      test('emits TodoLoaded when updating succeeds', () async {
        mockRepository.todos = <Todo>[testTodo];

        final Todo updatedTodo = testTodo.copyWith(title: 'Updated Title');
        await container.read(todoProvider.notifier).updateTodo(updatedTodo);

        final TodoState state = container.read(todoProvider);
        expect(state, isA<TodoLoaded>());
      });

      test('emits TodoError when updating fails', () async {
        mockRepository.error = Exception('Failed to update');

        await container.read(todoProvider.notifier).updateTodo(testTodo);

        final TodoState state = container.read(todoProvider);
        expect(state, isA<TodoError>());
      });
    });

    group('deleteTodo', () {
      test('emits TodoLoaded when deleting succeeds', () async {
        mockRepository.todos = <Todo>[testTodo];

        await container.read(todoProvider.notifier).deleteTodo('test-id');

        final TodoState state = container.read(todoProvider);
        expect(state, isA<TodoLoaded>());
        expect((state as TodoLoaded).todos, isEmpty);
      });

      test('emits TodoError when deleting fails', () async {
        mockRepository.error = Exception('Failed to delete');

        await container.read(todoProvider.notifier).deleteTodo('test-id');

        final TodoState state = container.read(todoProvider);
        expect(state, isA<TodoError>());
      });
    });

    group('toggleTodoCompletion', () {
      test('emits TodoLoaded when toggling succeeds', () async {
        mockRepository.todos = <Todo>[testTodo];

        await container
            .read(todoProvider.notifier)
            .toggleTodoCompletion('test-id');

        final TodoState state = container.read(todoProvider);
        expect(state, isA<TodoLoaded>());
        final TodoLoaded loadedState = state as TodoLoaded;
        expect(loadedState.todos.first.isCompleted, true);
      });

      test('emits TodoError when toggling fails', () async {
        mockRepository.error = Exception('Failed to toggle');

        await container
            .read(todoProvider.notifier)
            .toggleTodoCompletion('test-id');

        final TodoState state = container.read(todoProvider);
        expect(state, isA<TodoError>());
      });
    });
  });

  group('TodoState', () {
    group('TodoLoaded filtering', () {
      final DateTime now = DateTime.now();
      final List<Todo> todos = <Todo>[
        Todo(id: '1', title: 'Incomplete 1', createdAt: now),
        Todo(id: '2', title: 'Complete 1', isCompleted: true, createdAt: now),
        Todo(id: '3', title: 'Incomplete 2', createdAt: now),
        Todo(id: '4', title: 'Complete 2', isCompleted: true, createdAt: now),
      ];
      final TodoLoaded state = TodoLoaded(todos);

      test('completedTodos returns only completed todos', () {
        final List<Todo> completed = state.completedTodos;
        expect(completed.length, 2);
        expect(completed.every((Todo t) => t.isCompleted), true);
      });

      test('incompleteTodos returns only incomplete todos', () {
        final List<Todo> incomplete = state.incompleteTodos;
        expect(incomplete.length, 2);
        expect(incomplete.every((Todo t) => !t.isCompleted), true);
      });
    });
  });
}

class MockTodoRepository implements TodoRepository {
  List<Todo> todos = <Todo>[];
  Exception? error;

  @override
  Future<Todo> addTodo({required String title, String? description}) async {
    if (error != null) {
      throw error!;
    }
    final Todo todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    todos.add(todo);
    return todo;
  }

  @override
  Future<void> deleteTodo(String id) async {
    if (error != null) {
      throw error!;
    }
    todos.removeWhere((Todo t) => t.id == id);
  }

  @override
  Future<List<Todo>> getTodos() async {
    if (error != null) {
      throw error!;
    }
    return todos;
  }

  @override
  Future<Todo> toggleTodoCompletion(String id) async {
    if (error != null) {
      throw error!;
    }
    final int index = todos.indexWhere((Todo t) => t.id == id);
    if (index == -1) {
      throw Exception('Todo not found');
    }
    final Todo todo = todos[index];
    final Todo updated = todo.copyWith(
      isCompleted: !todo.isCompleted,
      completedAt: !todo.isCompleted ? DateTime.now() : null,
    );
    todos[index] = updated;
    return updated;
  }

  @override
  Future<Todo> updateTodo(Todo todo) async {
    if (error != null) {
      throw error!;
    }
    final int index = todos.indexWhere((Todo t) => t.id == todo.id);
    if (index == -1) {
      throw Exception('Todo not found');
    }
    todos[index] = todo;
    return todo;
  }
}
