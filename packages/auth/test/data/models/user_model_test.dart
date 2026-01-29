import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel', () {
    const String testId = 'test-id';
    const String testEmail = 'test@example.com';
    const String testName = 'Test User';

    const UserModel testUserModel = UserModel(
      id: testId,
      email: testEmail,
      name: testName,
    );

    final Map<String, dynamic> testJson = {
      'id': testId,
      'email': testEmail,
      'name': testName,
    };

    group('constructor', () {
      test('should create UserModel with required properties', () {
        expect(testUserModel.id, testId);
        expect(testUserModel.email, testEmail);
        expect(testUserModel.name, testName);
      });

      test('should extend User', () {
        expect(testUserModel, isA<User>());
      });
    });

    group('fromJson', () {
      test('should create UserModel from valid JSON', () {
        final UserModel result = UserModel.fromJson(testJson);

        expect(result.id, testId);
        expect(result.email, testEmail);
        expect(result.name, testName);
      });

      test('should handle JSON with additional fields', () {
        final Map<String, dynamic> jsonWithExtra = {
          ...testJson,
          'extraField': 'extra value',
        };

        final UserModel result = UserModel.fromJson(jsonWithExtra);

        expect(result.id, testId);
        expect(result.email, testEmail);
        expect(result.name, testName);
      });
    });

    group('toJson', () {
      test('should convert UserModel to JSON', () {
        final Map<String, dynamic> result = testUserModel.toJson();

        expect(result, testJson);
      });

      test('should produce valid JSON that can be used with fromJson', () {
        final Map<String, dynamic> json = testUserModel.toJson();
        final UserModel recreated = UserModel.fromJson(json);

        expect(recreated.id, testUserModel.id);
        expect(recreated.email, testUserModel.email);
        expect(recreated.name, testUserModel.name);
      });
    });

    group('fromEntity', () {
      test('should create UserModel from User entity', () {
        const User user = User(
          id: testId,
          email: testEmail,
          name: testName,
        );

        final UserModel result = UserModel.fromEntity(user);

        expect(result.id, user.id);
        expect(result.email, user.email);
        expect(result.name, user.name);
      });

      test('should create UserModel from UserModel entity', () {
        final UserModel result = UserModel.fromEntity(testUserModel);

        expect(result.id, testUserModel.id);
        expect(result.email, testUserModel.email);
        expect(result.name, testUserModel.name);
      });
    });

    group('equality', () {
      test('UserModel should have same props as User with same properties', () {
        const User user = User(
          id: testId,
          email: testEmail,
          name: testName,
        );

        expect(testUserModel.props, equals(user.props));
      });

      test('should be equal to another UserModel with same properties', () {
        const UserModel other = UserModel(
          id: testId,
          email: testEmail,
          name: testName,
        );

        expect(testUserModel, equals(other));
      });
    });
  });
}
