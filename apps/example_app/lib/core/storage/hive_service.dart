import 'package:hive_flutter/hive_flutter.dart';

/// Service for managing Hive local storage.
class HiveService {
  static const String _authBoxName = 'auth';
  static const String _todoBoxName = 'todos';

  static late Box<dynamic> _authBox;
  static late Box<dynamic> _todoBox;

  /// Initialize Hive and open required boxes
  static Future<void> init() async {
    await Hive.initFlutter();
    _authBox = await Hive.openBox(_authBoxName);
    _todoBox = await Hive.openBox(_todoBoxName);
  }

  /// Get the auth storage box
  static Box<dynamic> get authBox => _authBox;

  /// Get the todos storage box
  static Box<dynamic> get todoBox => _todoBox;

  /// Clear all stored data
  static Future<void> clearAll() async {
    await _authBox.clear();
    await _todoBox.clear();
  }

  /// Close all boxes
  static Future<void> close() async {
    await _authBox.close();
    await _todoBox.close();
  }
}
