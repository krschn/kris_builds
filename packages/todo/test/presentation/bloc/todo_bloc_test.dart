import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/todo.dart';

void main() {
  group('TodoBloc', () {
    late MockTodoRepository mockRepository;
    late MockGetTodosUseCase mockGetTodosUseCase;
    late MockAddTodoUseCase mockAddTodoUseCase;
    late MockUpdateTodoUseCase mockUpdateTodoUseCase;
    late MockDeleteTodoUseCase mockDeleteTodoUseCase;

    final DateTime testCreatedAt = DateTime(2024, 1, 15, 10, 30);

    final Todo testTodo = Todo(
      id: 'test-id',
      title: 'Test Todo',
      description: 'Test Description',
      createdAt: testCreatedAt,
    );

    setUp(() {
      mockRepository = MockTodoRepository();
      mockGetTodosUseCase = MockGetTodosUseCase(mockRepository);
      mockAddTodoUseCase = MockAddTodoUseCase(mockRepository);
      mockUpdateTodoUseCase = MockUpdateTodoUseCase(mockRepository);
      mockDeleteTodoUseCase = MockDeleteTodoUseCase(mockRepository);
    });

    TodoBloc createBloc() => TodoBloc(
      getTodosUseCase: mockGetTodosUseCase,
      addTodoUseCase: mockAddTodoUseCase,
      updateTodoUseCase: mockUpdateTodoUseCase,
      deleteTodoUseCase: mockDeleteTodoUseCase,
    );

    test('initial state is TodoInitial', () {
      expect(createBloc().state, const TodoInitial());
    });

    group('LoadTodos', () {
      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoading, TodoLoaded] when loading succeeds',
        build: () {
          mockGetTodosUseCase.result = <Todo>[testTodo];
          return createBloc();
        },
        act: (TodoBloc bloc) => bloc.add(const LoadTodos()),
        expect: () => <TodoState>[
          const TodoLoading(),
          TodoLoaded(<Todo>[testTodo]),
        ],
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoading, TodoLoaded] with empty list when no todos',
        build: () {
          mockGetTodosUseCase.result = <Todo>[];
          return createBloc();
        },
        act: (TodoBloc bloc) => bloc.add(const LoadTodos()),
        expect: () => <TodoState>[const TodoLoading(), const TodoLoaded(<Todo>[])],
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoading, TodoError] when loading fails',
        build: () {
          mockGetTodosUseCase.error = Exception('Failed to load');
          return createBloc();
        },
        act: (TodoBloc bloc) => bloc.add(const LoadTodos()),
        expect: () => <Object>[const TodoLoading(), isA<TodoError>()],
      );
    });

    group('AddTodo', () {
      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoaded] when adding succeeds',
        build: () {
          mockAddTodoUseCase.result = testTodo;
          mockGetTodosUseCase.result = <Todo>[testTodo];
          return createBloc();
        },
        act: (TodoBloc bloc) =>
            bloc.add(const AddTodo(title: 'Test Todo', description: 'Test Description')),
        expect: () => <TodoLoaded>[
          TodoLoaded(<Todo>[testTodo]),
        ],
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoError] when adding fails',
        build: () {
          mockAddTodoUseCase.error = Exception('Failed to add');
          return createBloc();
        },
        act: (TodoBloc bloc) => bloc.add(const AddTodo(title: 'Test')),
        expect: () => <TypeMatcher<TodoError>>[isA<TodoError>()],
      );
    });

    group('UpdateTodo', () {
      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoaded] when updating succeeds',
        build: () {
          final Todo updatedTodo = testTodo.copyWith(title: 'Updated Title');
          mockUpdateTodoUseCase.result = updatedTodo;
          mockGetTodosUseCase.result = <Todo>[updatedTodo];
          return createBloc();
        },
        act: (TodoBloc bloc) => bloc.add(UpdateTodo(testTodo)),
        expect: () => <TypeMatcher<TodoLoaded>>[isA<TodoLoaded>()],
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoError] when updating fails',
        build: () {
          mockUpdateTodoUseCase.error = Exception('Failed to update');
          return createBloc();
        },
        act: (TodoBloc bloc) => bloc.add(UpdateTodo(testTodo)),
        expect: () => <TypeMatcher<TodoError>>[isA<TodoError>()],
      );
    });

    group('DeleteTodo', () {
      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoaded] when deleting succeeds',
        build: () {
          mockGetTodosUseCase.result = <Todo>[];
          return createBloc();
        },
        act: (TodoBloc bloc) => bloc.add(const DeleteTodo('test-id')),
        expect: () => <TodoLoaded>[const TodoLoaded(<Todo>[])],
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoError] when deleting fails',
        build: () {
          mockDeleteTodoUseCase.error = Exception('Failed to delete');
          return createBloc();
        },
        act: (TodoBloc bloc) => bloc.add(const DeleteTodo('test-id')),
        expect: () => <TypeMatcher<TodoError>>[isA<TodoError>()],
      );
    });

    group('ToggleTodoCompletion', () {
      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoaded] when toggling succeeds',
        build: () {
          final Todo toggledTodo = testTodo.copyWith(isCompleted: true);
          mockUpdateTodoUseCase.toggleResult = toggledTodo;
          mockGetTodosUseCase.result = <Todo>[toggledTodo];
          return createBloc();
        },
        act: (TodoBloc bloc) => bloc.add(const ToggleTodoCompletion('test-id')),
        expect: () => <TypeMatcher<TodoLoaded>>[isA<TodoLoaded>()],
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoError] when toggling fails',
        build: () {
          mockUpdateTodoUseCase.error = Exception('Failed to toggle');
          return createBloc();
        },
        act: (TodoBloc bloc) => bloc.add(const ToggleTodoCompletion('test-id')),
        expect: () => <TypeMatcher<TodoError>>[isA<TodoError>()],
      );
    });
  });

  group('TodoEvent', () {
    test('LoadTodos props are empty', () {
      expect(const LoadTodos().props, isEmpty);
    });

    test('AddTodo props contain title and description', () {
      const AddTodo event = AddTodo(title: 'Test', description: 'Description');
      expect(event.props, <String>['Test', 'Description']);
    });

    test('UpdateTodo props contain todo', () {
      final Todo todo = Todo(id: 'id', title: 'Title', createdAt: DateTime.now());
      final UpdateTodo event = UpdateTodo(todo);
      expect(event.props, <Todo>[todo]);
    });

    test('DeleteTodo props contain id', () {
      const DeleteTodo event = DeleteTodo('test-id');
      expect(event.props, <String>['test-id']);
    });

    test('ToggleTodoCompletion props contain id', () {
      const ToggleTodoCompletion event = ToggleTodoCompletion('test-id');
      expect(event.props, <String>['test-id']);
    });
  });

  group('TodoState', () {
    test('TodoInitial props are empty', () {
      expect(const TodoInitial().props, isEmpty);
    });

    test('TodoLoading props are empty', () {
      expect(const TodoLoading().props, isEmpty);
    });

    test('TodoLoaded props contain todos', () {
      final List<Todo> todos = <Todo>[Todo(id: '1', title: 'Todo 1', createdAt: DateTime.now())];
      expect(TodoLoaded(todos).props, <List<Todo>>[todos]);
    });

    test('TodoError props contain message', () {
      const TodoError error = TodoError('Error message');
      expect(error.props, <String>['Error message']);
    });

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

class MockAddTodoUseCase extends AddTodoUseCase {
  MockAddTodoUseCase(MockTodoRepository super.repository);

  Todo? result;
  Exception? error;

  @override
  Future<Todo> call({required String title, String? description}) async {
    if (error != null) {
      throw error!;
    }
    return result!;
  }
}

class MockDeleteTodoUseCase extends DeleteTodoUseCase {
  MockDeleteTodoUseCase(MockTodoRepository super.repository);

  Exception? error;

  @override
  Future<void> call(String id) async {
    if (error != null) {
      throw error!;
    }
  }
}

class MockGetTodosUseCase extends GetTodosUseCase {
  MockGetTodosUseCase(MockTodoRepository super.repository);

  List<Todo>? result;
  Exception? error;

  @override
  Future<List<Todo>> call() async {
    if (error != null) {
      throw error!;
    }
    return result ?? <Todo>[];
  }
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
    if (index == -1) throw Exception('Todo not found');
    todos[index] = todo;
    return todo;
  }
}

class MockUpdateTodoUseCase extends UpdateTodoUseCase {
  MockUpdateTodoUseCase(MockTodoRepository super.repository);

  Todo? result;
  Todo? toggleResult;
  Exception? error;

  @override
  Future<Todo> call(Todo todo) async {
    if (error != null) throw error!;
    return result ?? todo;
  }

  @override
  Future<Todo> toggleCompletion(String id) async {
    if (error != null) throw error!;
    return toggleResult!;
  }
}
