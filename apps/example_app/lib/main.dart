import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/todo.dart';

import 'app.dart';
import 'core/storage/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive storage
  await HiveService.init();

  // Run the app with Riverpod
  runApp(
    ProviderScope(
      overrides: <Override>[
        // Provide the Hive boxes to the providers
        authBoxProvider.overrideWithValue(HiveService.authBox),
        todoBoxProvider.overrideWithValue(HiveService.todoBox),
      ],
      child: const App(),
    ),
  );
}
