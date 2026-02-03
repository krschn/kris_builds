import 'dart:convert';

import 'package:hive/hive.dart';

import '../models/user_model.dart';
import 'auth_datasource.dart';

/// Mock authentication data source using Hive for persistence.
class MockAuthDataSource implements AuthDataSource {
  static const String _userKey = 'current_user';

  static const String _usersKey = 'registered_users';

  final Box<dynamic> _box;
  MockAuthDataSource(this._box);

  @override
  Future<void> forgotPassword({required String email}) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));
    // In a real app, this would send an email
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final String? userJson = _box.get(_userKey) as String?;
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
  }

  @override
  Future<bool> isAuthenticated() async {
    return _box.containsKey(_userKey);
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Check if user exists in registered users
    final String? usersJson = _box.get(_usersKey) as String?;
    if (usersJson != null) {
      final List<dynamic> users = jsonDecode(usersJson) as List<dynamic>;
      final Map<String, dynamic> existingUser = users
          .cast<Map<String, dynamic>>()
          .firstWhere(
            (Map<String, dynamic> u) => u['email'] == email,
            orElse: () => <String, dynamic>{},
          );

      if (existingUser.isNotEmpty) {
        // For mock purposes, we don't validate password
        final UserModel user = UserModel.fromJson(existingUser);
        await _box.put(_userKey, jsonEncode(user.toJson()));
        return user;
      }
    }

    // Create a mock user for demo purposes
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: email.split('@').first,
    );

    await _box.put(_userKey, jsonEncode(user.toJson()));
    return user;
  }

  @override
  Future<void> logout() async {
    await _box.delete(_userKey);
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
    );

    // Store in registered users
    final String? usersJson = _box.get(_usersKey) as String?;
    final List<dynamic> users = usersJson != null
        ? jsonDecode(usersJson) as List<dynamic>
        : <dynamic>[];
    users.add(user.toJson());
    await _box.put(_usersKey, jsonEncode(users));

    // Auto-login after registration
    await _box.put(_userKey, jsonEncode(user.toJson()));
    return user;
  }
}
