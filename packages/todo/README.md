# Todo Package

A reusable todo management package with domain, data, and presentation layers following Clean Architecture principles.

## Features

- Complete CRUD operations (Create, Read, Update, Delete)
- Local persistence with Hive
- BLoC state management
- Pre-built UI components using the `widgets` package
- Clean Architecture with clear separation of concerns

## Installation

Add this package as a dependency in your `pubspec.yaml`:

```yaml
dependencies:
  todo:
    path: ../packages/todo
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Initialize Hive Storage

Before using the todo module, initialize Hive and open the todo box:

```dart
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Open the todo box
  final todoBox = await Hive.openBox<Map>('todos');

  runApp(MyApp(todoBox: todoBox));
}
```

### 2. Set Up TodoModule

Create the module with the Hive box:

```dart
import 'package:todo/todo.dart';

// Create datasource
final todoDataSource = TodoLocalDataSource(box: todoBox);

// Create module
final todoModule = TodoModule(dataSource: todoDataSource);

// Get the BLoC
final todoBloc = todoModule.createTodoBloc();
```

### 3. Provide BLoC to Widget Tree

```dart
BlocProvider<TodoBloc>(
  create: (_) => todoBloc..add(const LoadTodos()),
  child: MaterialApp(
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    home: const TodoPage(),
  ),
)
```

### 4. Use TodoPage

The package provides a pre-built `TodoPage` widget:

```dart
import 'package:todo/todo.dart';

// Basic usage
const TodoPage()

// With logout callback (for authenticated apps)
TodoPage(
  onLogout: () {
    // Handle logout
    context.read<AuthBloc>().add(const LogoutRequested());
  },
)
```

## Architecture

```
lib/
├── todo.dart                       # Barrel export
└── src/
    ├── todo_module.dart            # Dependency factory
    ├── domain/                     # Business logic
    │   ├── entities/
    │   │   └── todo.dart           # Todo entity
    │   ├── repositories/
    │   │   └── todo_repository.dart
    │   └── usecases/
    │       ├── get_todos_usecase.dart
    │       ├── add_todo_usecase.dart
    │       ├── update_todo_usecase.dart
    │       └── delete_todo_usecase.dart
    ├── data/                       # Data layer
    │   ├── datasources/
    │   │   └── todo_local_datasource.dart
    │   ├── models/
    │   │   └── todo_model.dart
    │   └── repositories/
    │       └── todo_repository_impl.dart
    └── presentation/               # UI layer
        ├── bloc/
        │   ├── todo_bloc.dart
        │   ├── todo_event.dart
        │   └── todo_state.dart
        └── pages/
            └── todo_page.dart
```

## Todo Entity

```dart
class Todo {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;
}
```

## BLoC Events

| Event | Description |
|-------|-------------|
| `LoadTodos()` | Fetches all todos from storage |
| `AddTodo(title, description?)` | Creates a new todo |
| `UpdateTodo(todo)` | Updates an existing todo |
| `DeleteTodo(id)` | Deletes a todo by ID |
| `ToggleTodoCompletion(id)` | Toggles the completion status |

## BLoC States

| State | Description |
|-------|-------------|
| `TodoInitial` | Initial state before loading |
| `TodoLoading` | Loading todos from storage |
| `TodoLoaded(todos)` | Todos loaded successfully |
| `TodoError(message)` | An error occurred |

## Usage Examples

### Adding a Todo

```dart
context.read<TodoBloc>().add(
  AddTodo(
    title: 'Buy groceries',
    description: 'Milk, eggs, bread',
  ),
);
```

### Toggling Completion

```dart
context.read<TodoBloc>().add(ToggleTodoCompletion(todo.id));
```

### Deleting a Todo

```dart
context.read<TodoBloc>().add(DeleteTodo(todo.id));
```

### Listening to State Changes

```dart
BlocListener<TodoBloc, TodoState>(
  listener: (context, state) {
    if (state is TodoError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: BlocBuilder<TodoBloc, TodoState>(
    builder: (context, state) {
      if (state is TodoLoading) {
        return const CircularProgressIndicator();
      }
      if (state is TodoLoaded) {
        return ListView.builder(
          itemCount: state.todos.length,
          itemBuilder: (context, index) {
            final todo = state.todos[index];
            return ListTile(
              title: Text(todo.title),
              trailing: Checkbox(
                value: todo.isCompleted,
                onChanged: (_) => context
                    .read<TodoBloc>()
                    .add(ToggleTodoCompletion(todo.id)),
              ),
            );
          },
        );
      }
      return const SizedBox.shrink();
    },
  ),
)
```

## Custom DataSource

You can implement a custom datasource (e.g., for remote API):

```dart
abstract class TodoDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> addTodo(TodoModel todo);
  Future<TodoModel> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
}

class RemoteTodoDataSource implements TodoDataSource {
  final ApiClient _client;

  RemoteTodoDataSource({required ApiClient client}) : _client = client;

  @override
  Future<List<TodoModel>> getTodos() async {
    final response = await _client.get('/todos');
    return (response.data as List)
        .map((json) => TodoModel.fromJson(json))
        .toList();
  }

  // ... implement other methods
}

// Use with TodoModule
final todoModule = TodoModule(dataSource: RemoteTodoDataSource(client: apiClient));
```

## Dependencies

This package depends on:

- `widgets` - For UI components and theming
- `bloc` / `flutter_bloc` - State management
- `hive` - Local persistence
- `equatable` - Value equality

## Integration with Auth

The `TodoPage` accepts an optional `onLogout` callback for integration with authentication:

```dart
TodoPage(
  onLogout: () {
    // Clear todo state if needed
    context.read<TodoBloc>().add(const ClearTodos());

    // Navigate to login
    context.go('/login');
  },
)
```
