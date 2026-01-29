import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/storage/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive storage
  await HiveService.init();

  // Run the app with dependency injection
  runApp(
    MultiBlocProvider(
      providers: Injection.providers,
      child: const App(),
    ),
  );
}
