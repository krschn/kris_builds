# Flutter-Specific Patterns Reference

This reference covers Flutter-specific best practices for widget design, state management, and performance.

## Widget Design

### Composition Over Inheritance

**Build complex widgets from simple ones:**
```dart
// Good - composition
class UserCard extends StatelessWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Avatar(imageUrl: user.avatarUrl),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserName(name: user.name),
                  UserEmail(email: user.email),
                ],
              ),
            ),
            FavoriteButton(userId: user.id),
          ],
        ),
      ),
    );
  }
}

// Bad - inheritance
class UserCard extends Card {
  // Don't extend framework widgets
}
```

### Small, Focused Widgets

**Extract widgets for readability and reusability:**
```dart
// Good - small, focused widgets
class TodoList extends StatelessWidget {
  final List<Todo> todos;

  const TodoList({super.key, required this.todos});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) => TodoItem(todo: todos[index]),
    );
  }
}

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: TodoCheckbox(isCompleted: todo.isCompleted),
      title: TodoTitle(text: todo.title),
      trailing: TodoDeleteButton(todoId: todo.id),
    );
  }
}
```

### Widget Parameters

**Use required for non-nullable parameters:**
```dart
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool showPrice;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.showPrice = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          children: [
            ProductImage(url: product.imageUrl),
            ProductTitle(text: product.name),
            if (showPrice) ProductPrice(amount: product.price),
          ],
        ),
      ),
    );
  }
}
```

---

## Const Widgets

### Use Const Constructors

**Mark widgets as const when possible:**
```dart
// Good - const widget
class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const FlutterLogo(size: 48);
  }
}

// Usage - const invocation
@override
Widget build(BuildContext context) {
  return Column(
    children: const [
      AppLogo(),           // Const - no rebuild needed
      SizedBox(height: 16),
      Text('Welcome'),
    ],
  );
}
```

### Extract Const Subtrees

**Move static parts to const widgets:**
```dart
// Good - const extracted
class ProductPage extends StatelessWidget {
  final Product product;

  const ProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _ProductAppBar(),  // Const - never rebuilds
      body: Column(
        children: [
          ProductImage(url: product.imageUrl),  // Dynamic
          const _Divider(),                      // Const
          ProductDetails(product: product),      // Dynamic
          const _ActionButtons(),                // Const
        ],
      ),
    );
  }
}

class _ProductAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ProductAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(title: const Text('Product'));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Divider(),
    );
  }
}
```

---

## State Management with BLoC

### BLoC Structure

**Separate events, states, and bloc:**
```dart
// Events
sealed class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class LogoutRequested extends AuthEvent {}

// States
sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);
}

class Unauthenticated extends AuthState {
  final String? message;

  Unauthenticated([this.message]);
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _loginUseCase.execute(event.email, event.password);
      emit(Authenticated(user));
    } catch (e) {
      emit(Unauthenticated(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logoutUseCase.execute();
    emit(Unauthenticated());
  }
}
```

### Using BLoC in Widgets

**Use BlocBuilder for UI updates:**
```dart
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return switch (state) {
          AuthInitial() || AuthLoading() => const LoadingIndicator(),
          Authenticated(:final user) => HomePage(user: user),
          Unauthenticated(:final message) => LoginPage(error: message),
        };
      },
    );
  }
}
```

**Use BlocListener for side effects:**
```dart
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state case Unauthenticated(message: final msg?) when msg.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg)),
          );
        }
      },
      child: const LoginForm(),
    );
  }
}
```

**Use BlocConsumer for both:**
```dart
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state case ProfileSaved()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile saved!')),
          );
        }
      },
      builder: (context, state) {
        return switch (state) {
          ProfileLoading() => const LoadingIndicator(),
          ProfileLoaded(:final profile) => ProfileForm(profile: profile),
          ProfileError(:final message) => ErrorDisplay(message: message),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}
```

### Selective Rebuilds

**Use buildWhen to limit rebuilds:**
```dart
BlocBuilder<CartBloc, CartState>(
  buildWhen: (previous, current) {
    // Only rebuild when item count changes
    return previous.itemCount != current.itemCount;
  },
  builder: (context, state) {
    return Badge(
      label: Text('${state.itemCount}'),
      child: const Icon(Icons.shopping_cart),
    );
  },
)
```

---

## Keys

### When to Use Keys

**Use keys for stateful widgets in lists:**
```dart
// Good - key for stateful widget identity
ListView.builder(
  itemCount: todos.length,
  itemBuilder: (context, index) {
    return TodoItem(
      key: ValueKey(todos[index].id),  // Preserves state when reordered
      todo: todos[index],
    );
  },
)
```

**Use keys for widget replacement:**
```dart
// Force rebuild when user changes
ProfilePage(
  key: ValueKey(currentUser.id),  // New widget when user changes
  user: currentUser,
)
```

### Key Types

```dart
// ValueKey - for value-based identity
ValueKey(item.id)
ValueKey('unique_string')

// ObjectKey - for object identity
ObjectKey(item)  // Same instance = same key

// UniqueKey - always unique
UniqueKey()  // Forces new widget

// GlobalKey - access state from outside
final formKey = GlobalKey<FormState>();
Form(key: formKey, ...)
formKey.currentState?.validate()
```

---

## BuildContext Usage

### Context Limitations

**Don't use context after async gaps:**
```dart
// Bad - context might be invalid after await
Future<void> submit() async {
  await api.submit();
  Navigator.of(context).pop();  // context might be unmounted!
}

// Good - check if mounted
Future<void> submit() async {
  await api.submit();
  if (mounted) {
    Navigator.of(context).pop();
  }
}

// Better - use StatelessWidget with callback
class SubmitButton extends StatelessWidget {
  final VoidCallback onSubmitted;

  const SubmitButton({super.key, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await api.submit();
        onSubmitted();  // Parent handles navigation
      },
      child: const Text('Submit'),
    );
  }
}
```

### Context in Callbacks

**Store context references before async operations:**
```dart
// Good - capture navigator before async
void _handleTap() async {
  final navigator = Navigator.of(context);
  final messenger = ScaffoldMessenger.of(context);

  try {
    await doAsyncWork();
    navigator.pop(true);
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
  }
}
```

---

## Performance Optimization

### Avoid Rebuilds

**Use const where possible:**
```dart
// Good
const SizedBox(height: 16)
const EdgeInsets.all(8)
const Text('Static text')

// Bad - creates new instance each build
SizedBox(height: 16)
EdgeInsets.all(8)
Text('Static text')
```

**Split widgets to minimize rebuild scope:**
```dart
// Bad - entire widget rebuilds
class CounterPage extends StatefulWidget {
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),  // Rebuilds
      body: Center(
        child: Text('Count: $_count'),  // Rebuilds (needed)
      ),
      floatingActionButton: FloatingActionButton(  // Rebuilds
        onPressed: () => setState(() => _count++),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Good - only counter rebuilds
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: const Center(child: CounterDisplay()),
      floatingActionButton: const CounterButton(),
    );
  }
}
```

### ListView Optimization

**Use ListView.builder for long lists:**
```dart
// Good - lazy building
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(item: items[index]),
)

// Bad - builds all items upfront
ListView(
  children: items.map((item) => ItemWidget(item: item)).toList(),
)
```

**Use cacheExtent for smooth scrolling:**
```dart
ListView.builder(
  cacheExtent: 500,  // Pre-build widgets 500 pixels off-screen
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(item: items[index]),
)
```

### Image Optimization

**Use cacheWidth/cacheHeight for memory efficiency:**
```dart
// Good - resized in memory
Image.network(
  url,
  cacheWidth: 200,  // Decode to this size
  cacheHeight: 200,
)

// Bad - full resolution in memory
Image.network(url)
```

**Use FadeInImage for better UX:**
```dart
FadeInImage.memoryNetwork(
  placeholder: kTransparentImage,
  image: imageUrl,
  fadeInDuration: const Duration(milliseconds: 300),
)
```

---

## Navigation Patterns

### Using GoRouter

**Define routes declaratively:**
```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'user/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return UserPage(userId: id);
          },
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
  ],
);
```

**Navigation with type safety:**
```dart
// Define route constants
class AppRoutes {
  static const home = '/';
  static String user(String id) => '/user/$id';
  static const settings = '/settings';
}

// Navigate
context.go(AppRoutes.home);
context.go(AppRoutes.user('123'));
context.push(AppRoutes.settings);
```

### Passing Data

**Use route parameters for IDs:**
```dart
// Route definition
GoRoute(
  path: 'product/:id',
  builder: (context, state) {
    return ProductPage(productId: state.pathParameters['id']!);
  },
)

// Navigate
context.go('/product/123');
```

**Use extra for complex data:**
```dart
// Pass object
context.go('/checkout', extra: cart);

// Receive
GoRoute(
  path: '/checkout',
  builder: (context, state) {
    final cart = state.extra as Cart;
    return CheckoutPage(cart: cart);
  },
)
```

---

## Form Patterns

### Form Validation

```dart
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        LoginRequested(
          _emailController.text,
          _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!value.contains('@')) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

### Reusable Form Fields

```dart
class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      validator: _validate,
    );
  }

  String? _validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }
}
```

---

## Responsive Design

### Using LayoutBuilder

```dart
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobile;
        } else if (constraints.maxWidth < 1200) {
          return tablet;
        } else {
          return desktop;
        }
      },
    );
  }
}
```

### Using MediaQuery

```dart
class AdaptiveGrid extends StatelessWidget {
  final List<Widget> children;

  const AdaptiveGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = switch (width) {
      < 600 => 2,
      < 900 => 3,
      < 1200 => 4,
      _ => 6,
    };

    return GridView.count(
      crossAxisCount: crossAxisCount,
      children: children,
    );
  }
}
```

---

## Theme Usage

### Accessing Theme

```dart
// Good - use Theme.of
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final textTheme = theme.textTheme;

  return Container(
    color: colorScheme.surface,
    child: Text(
      'Title',
      style: textTheme.headlineMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
    ),
  );
}
```

### Custom Theme Extensions

```dart
// Define extension
class AppSpacing extends ThemeExtension<AppSpacing> {
  final double small;
  final double medium;
  final double large;

  const AppSpacing({
    required this.small,
    required this.medium,
    required this.large,
  });

  @override
  AppSpacing copyWith({double? small, double? medium, double? large}) {
    return AppSpacing(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
    );
  }

  @override
  AppSpacing lerp(AppSpacing? other, double t) {
    if (other == null) return this;
    return AppSpacing(
      small: lerpDouble(small, other.small, t)!,
      medium: lerpDouble(medium, other.medium, t)!,
      large: lerpDouble(large, other.large, t)!,
    );
  }
}

// Register in theme
ThemeData(
  extensions: [
    const AppSpacing(small: 8, medium: 16, large: 24),
  ],
)

// Use in widget
final spacing = Theme.of(context).extension<AppSpacing>()!;
Padding(padding: EdgeInsets.all(spacing.medium))
```
