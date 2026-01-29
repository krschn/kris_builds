import 'package:flutter_test/flutter_test.dart';
import 'package:todo/todo.dart';

void main() {
  group('TodoModel', () {
    final DateTime testCreatedAt = DateTime(2024, 1, 15, 10, 30);
    final DateTime testCompletedAt = DateTime(2024, 1, 16, 14);

    final TodoModel testTodoModel = TodoModel(
      id: 'test-id',
      title: 'Test Todo',
      description: 'Test Description',
      isCompleted: true,
      createdAt: testCreatedAt,
      completedAt: testCompletedAt,
    );

    final Map<String, dynamic> testJson = <String, dynamic>{
      'id': 'test-id',
      'title': 'Test Todo',
      'description': 'Test Description',
      'isCompleted': true,
      'createdAt': testCreatedAt.toIso8601String(),
      'completedAt': testCompletedAt.toIso8601String(),
    };

    group('constructor', () {
      test('should create TodoModel with required properties', () {
        final TodoModel model = TodoModel(
          id: 'test-id',
          title: 'Test Todo',
          createdAt: testCreatedAt,
        );

        expect(model.id, 'test-id');
        expect(model.title, 'Test Todo');
        expect(model.description, isNull);
        expect(model.isCompleted, false);
        expect(model.createdAt, testCreatedAt);
        expect(model.completedAt, isNull);
      });

      test('should extend Todo', () {
        expect(testTodoModel, isA<Todo>());
      });
    });

    group('fromJson', () {
      test('should create TodoModel from valid JSON', () {
        final TodoModel result = TodoModel.fromJson(testJson);

        expect(result.id, 'test-id');
        expect(result.title, 'Test Todo');
        expect(result.description, 'Test Description');
        expect(result.isCompleted, true);
        expect(result.createdAt, testCreatedAt);
        expect(result.completedAt, testCompletedAt);
      });

      test('should handle null description', () {
        final Map<String, dynamic> json = <String, dynamic>{
          'id': 'test-id',
          'title': 'Test Todo',
          'description': null,
          'isCompleted': false,
          'createdAt': testCreatedAt.toIso8601String(),
          'completedAt': null,
        };

        final TodoModel result = TodoModel.fromJson(json);

        expect(result.description, isNull);
        expect(result.completedAt, isNull);
      });

      test('should handle missing isCompleted (default to false)', () {
        final Map<String, dynamic> json = <String, dynamic>{
          'id': 'test-id',
          'title': 'Test Todo',
          'createdAt': testCreatedAt.toIso8601String(),
        };

        final TodoModel result = TodoModel.fromJson(json);

        expect(result.isCompleted, false);
      });
    });

    group('toJson', () {
      test('should convert TodoModel to JSON', () {
        final Map<String, dynamic> result = testTodoModel.toJson();

        expect(result['id'], 'test-id');
        expect(result['title'], 'Test Todo');
        expect(result['description'], 'Test Description');
        expect(result['isCompleted'], true);
        expect(result['createdAt'], testCreatedAt.toIso8601String());
        expect(result['completedAt'], testCompletedAt.toIso8601String());
      });

      test('should handle null completedAt', () {
        final TodoModel model = TodoModel(
          id: 'test-id',
          title: 'Test Todo',
          createdAt: testCreatedAt,
        );

        final Map<String, dynamic> result = model.toJson();

        expect(result['completedAt'], isNull);
      });

      test('should produce valid JSON that can be used with fromJson', () {
        final Map<String, dynamic> json = testTodoModel.toJson();
        final TodoModel recreated = TodoModel.fromJson(json);

        expect(recreated.id, testTodoModel.id);
        expect(recreated.title, testTodoModel.title);
        expect(recreated.description, testTodoModel.description);
        expect(recreated.isCompleted, testTodoModel.isCompleted);
        expect(recreated.createdAt, testTodoModel.createdAt);
        expect(recreated.completedAt, testTodoModel.completedAt);
      });
    });

    group('fromEntity', () {
      test('should create TodoModel from Todo entity', () {
        final Todo todo = Todo(
          id: 'test-id',
          title: 'Test Todo',
          description: 'Test Description',
          isCompleted: true,
          createdAt: testCreatedAt,
          completedAt: testCompletedAt,
        );

        final TodoModel result = TodoModel.fromEntity(todo);

        expect(result.id, todo.id);
        expect(result.title, todo.title);
        expect(result.description, todo.description);
        expect(result.isCompleted, todo.isCompleted);
        expect(result.createdAt, todo.createdAt);
        expect(result.completedAt, todo.completedAt);
      });

      test('should handle nullable fields', () {
        final Todo todo = Todo(id: 'test-id', title: 'Test Todo', createdAt: testCreatedAt);

        final TodoModel result = TodoModel.fromEntity(todo);

        expect(result.description, isNull);
        expect(result.completedAt, isNull);
      });
    });

    group('copyWith', () {
      test('should return identical model when no parameters changed', () {
        final TodoModel copy = testTodoModel.copyWith();

        expect(copy, equals(testTodoModel));
      });

      test('should update title', () {
        final TodoModel copy = testTodoModel.copyWith(title: 'New Title');

        expect(copy.title, 'New Title');
        expect(copy.id, testTodoModel.id);
        expect(copy, isA<TodoModel>());
      });

      test('should update isCompleted', () {
        final TodoModel original = TodoModel(
          id: 'test-id',
          title: 'Test Todo',
          createdAt: testCreatedAt,
        );

        final TodoModel copy = original.copyWith(isCompleted: true);

        expect(copy.isCompleted, true);
        expect(copy, isA<TodoModel>());
      });
    });
  });
}
