import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User', () {
    const String testId = 'test-id';
    const String testEmail = 'test@example.com';
    const String testName = 'Test User';

    test('should create User with required properties', () {
      const User user = User(
        id: testId,
        email: testEmail,
        name: testName,
      );

      expect(user.id, testId);
      expect(user.email, testEmail);
      expect(user.name, testName);
    });

    test('should support value equality', () {
      const User user1 = User(
        id: testId,
        email: testEmail,
        name: testName,
      );
      const User user2 = User(
        id: testId,
        email: testEmail,
        name: testName,
      );

      expect(user1, equals(user2));
      expect(user1.hashCode, equals(user2.hashCode));
    });

    test('should not be equal when id differs', () {
      const User user1 = User(
        id: 'id-1',
        email: testEmail,
        name: testName,
      );
      const User user2 = User(
        id: 'id-2',
        email: testEmail,
        name: testName,
      );

      expect(user1, isNot(equals(user2)));
    });

    test('should not be equal when email differs', () {
      const User user1 = User(
        id: testId,
        email: 'email1@example.com',
        name: testName,
      );
      const User user2 = User(
        id: testId,
        email: 'email2@example.com',
        name: testName,
      );

      expect(user1, isNot(equals(user2)));
    });

    test('should not be equal when name differs', () {
      const User user1 = User(
        id: testId,
        email: testEmail,
        name: 'Name 1',
      );
      const User user2 = User(
        id: testId,
        email: testEmail,
        name: 'Name 2',
      );

      expect(user1, isNot(equals(user2)));
    });

    test('props should contain id, email, and name', () {
      const User user = User(
        id: testId,
        email: testEmail,
        name: testName,
      );

      expect(user.props, [testId, testEmail, testName]);
    });
  });
}
