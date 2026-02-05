import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/todo.dart';
import 'package:treat_decider/treat_decider.dart';

import '../storage/hive_service.dart';

/// Simple dependency injection container.
///
/// Provides singleton instances of repositories, use cases, and blocs.
class Injection {
  static Injection? _instance;

  /// Get the singleton instance
  static Injection get instance {
    _instance ??= Injection._()..init();
    return _instance!;
  }

  /// Provides all necessary blocs for the app
  static List<BlocProvider<dynamic>> get providers => <BlocProvider<dynamic>>[
    BlocProvider<AuthBloc>(
      create: (_) => instance.createAuthBloc()..add(const CheckAuthStatus()),
    ),
    BlocProvider<TodoBloc>(create: (_) => instance.createTodoBloc()),
    BlocProvider<TreatDeciderBloc>(create: (_) => instance.createTreatDeciderBloc()),
  ];

  // Auth module
  late final AuthModule _authModule;

  // Todo module
  late final TodoModule _todoModule;

  // Treat Decider module
  late final TreatDeciderModule _treatDeciderModule;

  Injection._();

  // Getters for repositories
  AuthRepository get authRepository => _authModule.repository;
  TodoRepository get todoRepository => _todoModule.repository;
  TreatDeciderRepository get treatDeciderRepository => _treatDeciderModule.repository;

  // Factory methods for blocs
  AuthBloc createAuthBloc() => _authModule.createAuthBloc();

  TodoBloc createTodoBloc() => _todoModule.createTodoBloc();

  TreatDeciderBloc createTreatDeciderBloc() => _treatDeciderModule.createTreatDeciderBloc();

  /// Initialize all dependencies
  void init() {
    // Auth module (handles all auth dependencies internally)
    final MockAuthDataSource authDataSource = MockAuthDataSource(
      HiveService.authBox,
    );
    _authModule = AuthModule(dataSource: authDataSource);

    // Todo module (handles all todo dependencies internally)
    final TodoLocalDataSource todoDataSource = TodoLocalDataSource(
      HiveService.todoBox,
    );
    _todoModule = TodoModule(dataSource: todoDataSource);

    // Treat Decider module
    final HiveTreatDeciderDataSource treatDeciderDataSource = HiveTreatDeciderDataSource(
      HiveService.treatDeciderBox,
    );
    _treatDeciderModule = TreatDeciderModule(dataSource: treatDeciderDataSource);
  }
}
