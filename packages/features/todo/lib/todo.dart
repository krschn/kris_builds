/// This package provides a complete todo management solution that can be
/// plugged into any Flutter app. It uses clean architecture principles.
library;

// Data - Data Sources
export 'src/data/datasources/todo_local_datasource.dart';
// Data - Models
export 'src/data/models/todo_model.dart';
// Data - Repositories
export 'src/data/repositories/todo_repository_impl.dart';
// Domain - Entities
export 'src/domain/entities/todo.dart';
// Domain - Repositories
export 'src/domain/repositories/todo_repository.dart';
// Domain - Use Cases
export 'src/domain/usecases/add_todo_usecase.dart';
export 'src/domain/usecases/delete_todo_usecase.dart';
export 'src/domain/usecases/get_todos_usecase.dart';
export 'src/domain/usecases/update_todo_usecase.dart';
// Presentation - Pages
export 'src/presentation/pages/todo_page.dart';
// Providers (Riverpod)
export 'src/providers/todo_providers.dart'
    show
        TodoConfig,
        todoBoxProvider,
        todoConfigProvider,
        todoProvider,
        todoRepositoryProvider;
export 'src/providers/todo_state.dart';
