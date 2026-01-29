import 'package:flutter_test/flutter_test.dart';
import 'package:todo/todo.dart';

void main() {
  group('Todo', () {
    final DateTime testCreatedAt = DateTime(2024, 1, 15, 10, 30);
    final DateTime testCompletedAt = DateTime(2024, 1, 16, 14);

    test('should create Todo with required properties', () {
      final Todo todo = Todo(id: 'test-id', title: 'Test Todo', createdAt: testCreatedAt);

      expect(todo.id, 'test-id');
      expect(todo.title, 'Test Todo');
      expect(todo.description, isNull);
      expect(todo.isCompleted, false);
      expect(todo.createdAt, testCreatedAt);
      expect(todo.completedAt, isNull);
    });

    test('should create Todo with all properties', () {
      final Todo todo = Todo(
        id: 'test-id',
        title: 'Test Todo',
        description: 'Test Description',
        isCompleted: true,
        createdAt: testCreatedAt,
        completedAt: testCompletedAt,
      );

      expect(todo.id, 'test-id');
      expect(todo.title, 'Test Todo');
      expect(todo.description, 'Test Description');
      expect(todo.isCompleted, true);
      expect(todo.createdAt, testCreatedAt);
      expect(todo.completedAt, testCompletedAt);
    });

    test('should support value equality', () {
      final Todo todo1 = Todo(id: 'test-id', title: 'Test Todo', createdAt: testCreatedAt);
      final Todo todo2 = Todo(id: 'test-id', title: 'Test Todo', createdAt: testCreatedAt);

      expect(todo1, equals(todo2));
      expect(todo1.hashCode, equals(todo2.hashCode));
    });

    test('should not be equal when id differs', () {
      final Todo todo1 = Todo(id: 'id-1', title: 'Test Todo', createdAt: testCreatedAt);
      final Todo todo2 = Todo(id: 'id-2', title: 'Test Todo', createdAt: testCreatedAt);

      expect(todo1, isNot(equals(todo2)));
    });

    test('should not be equal when title differs', () {
      final Todo todo1 = Todo(id: 'test-id', title: 'Title 1', createdAt: testCreatedAt);
      final Todo todo2 = Todo(id: 'test-id', title: 'Title 2', createdAt: testCreatedAt);

      expect(todo1, isNot(equals(todo2)));
    });

    test('props should contain all fields', () {
      final Todo todo = Todo(
        id: 'test-id',
        title: 'Test Todo',
        description: 'Description',
        isCompleted: true,
        createdAt: testCreatedAt,
        completedAt: testCompletedAt,
      );

      expect(todo.props, <Object>[
        'test-id',
        'Test Todo',
        'Description',
        true,
        testCreatedAt,
        testCompletedAt,
      ]);
    });

    group('copyWith', () {
      test('should return identical todo when no parameters changed', () {
        final Todo original = Todo(
          id: 'test-id',
          title: 'Test Todo',
          description: 'Description',
          createdAt: testCreatedAt,
        );

        final Todo copy = original.copyWith();

        expect(copy, equals(original));
      });

      test('should update id', () {
        final Todo original = Todo(id: 'old-id', title: 'Test Todo', createdAt: testCreatedAt);

        final Todo copy = original.copyWith(id: 'new-id');

        expect(copy.id, 'new-id');
        expect(copy.title, original.title);
      });

      test('should update title', () {
        final Todo original = Todo(id: 'test-id', title: 'Old Title', createdAt: testCreatedAt);

        final Todo copy = original.copyWith(title: 'New Title');

        expect(copy.title, 'New Title');
        expect(copy.id, original.id);
      });

      test('should update description', () {
        final Todo original = Todo(
          id: 'test-id',
          title: 'Test Todo',
          description: 'Old Description',
          createdAt: testCreatedAt,
        );

        final Todo copy = original.copyWith(description: 'New Description');

        expect(copy.description, 'New Description');
      });

      test('should update isCompleted', () {
        final Todo original = Todo(id: 'test-id', title: 'Test Todo', createdAt: testCreatedAt);

        final Todo copy = original.copyWith(isCompleted: true);

        expect(copy.isCompleted, true);
      });

      test('should update completedAt', () {
        final Todo original = Todo(id: 'test-id', title: 'Test Todo', createdAt: testCreatedAt);

        final Todo copy = original.copyWith(completedAt: testCompletedAt);

        expect(copy.completedAt, testCompletedAt);
      });

      test('should update multiple fields at once', () {
        final Todo original = Todo(id: 'test-id', title: 'Old Title', createdAt: testCreatedAt);

        final Todo copy = original.copyWith(
          title: 'New Title',
          isCompleted: true,
          completedAt: testCompletedAt,
        );

        expect(copy.title, 'New Title');
        expect(copy.isCompleted, true);
        expect(copy.completedAt, testCompletedAt);
        expect(copy.id, original.id);
      });
    });
  });
}
