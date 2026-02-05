# Dart Usage Patterns Reference

This reference covers common idioms and patterns for effective Dart code.

## Collection Patterns

### Collection Literals

**Always use literals over constructors:**
```dart
// Good
var list = <int>[];
var map = <String, int>{};
var set = <String>{};

// Bad
var list = List<int>();
var map = Map<String, int>();
var set = Set<String>();
```

**Use type inference when possible:**
```dart
// Good - type is inferred
var numbers = [1, 2, 3];
var ages = {'Alice': 30, 'Bob': 25};

// Good - explicit when needed
var items = <Widget>[];
Map<String, dynamic> json = {};
```

### Collection Operations

**Use `.isEmpty` / `.isNotEmpty`:**
```dart
// Good
if (items.isEmpty) return;
if (items.isNotEmpty) process(items);

// Bad
if (items.length == 0) return;
if (items.length > 0) process(items);
```

**Use `.first` / `.last` / `.single`:**
```dart
// Good
final first = items.first;
final last = items.last;
final only = items.single;  // Throws if not exactly one

// Bad
final first = items[0];
final last = items[items.length - 1];
```

**Use `whereType<T>()` for type filtering:**
```dart
// Good
final strings = objects.whereType<String>();
final widgets = items.whereType<Widget>().toList();

// Bad
final strings = objects.where((e) => e is String).cast<String>();
```

**Use `.firstWhere()` with `orElse`:**
```dart
// Good
final admin = users.firstWhere(
  (u) => u.isAdmin,
  orElse: () => User.guest(),
);

// With null instead
final admin = users.cast<User?>().firstWhere(
  (u) => u?.isAdmin ?? false,
  orElse: () => null,
);
```

### Spread Operator

**Use spread for combining collections:**
```dart
// Good
var combined = [...list1, ...list2];
var withExtra = [...items, newItem];

// Bad
var combined = List<int>.from(list1)..addAll(list2);
var withExtra = List<Item>.from(items)..add(newItem);
```

**Use null-aware spread:**
```dart
// Good
var all = [...required, ...?optional];

// Bad
var all = [...required];
if (optional != null) {
  all.addAll(optional);
}
```

### Collection If/For

**Use collection if for conditional items:**
```dart
// Good
var widgets = [
  Header(),
  if (showNavigation) Navigation(),
  Body(),
  if (showFooter) Footer(),
];

// Bad
var widgets = [Header(), Body()];
if (showNavigation) {
  widgets.insert(1, Navigation());
}
if (showFooter) {
  widgets.add(Footer());
}
```

**Use collection for for transformations:**
```dart
// Good
var names = [
  for (var user in users) user.name,
];

var indexed = [
  for (var i = 0; i < items.length; i++)
    '${i + 1}. ${items[i]}',
];

// Bad
var names = users.map((u) => u.name).toList();
```

**Combine if and for:**
```dart
// Good
var activeNames = [
  for (var user in users)
    if (user.isActive) user.name,
];
```

### Map Patterns

**Use `.entries` for iteration:**
```dart
// Good
for (var MapEntry(:key, :value) in map.entries) {
  print('$key: $value');
}

// Also good
for (var entry in map.entries) {
  print('${entry.key}: ${entry.value}');
}

// Bad
for (var key in map.keys) {
  print('$key: ${map[key]}');
}
```

**Use `putIfAbsent` for lazy initialization:**
```dart
// Good
cache.putIfAbsent(key, () => computeExpensiveValue());

// Bad
if (!cache.containsKey(key)) {
  cache[key] = computeExpensiveValue();
}
```

**Use `update` for conditional updates:**
```dart
// Good
counts.update(key, (value) => value + 1, ifAbsent: () => 1);

// Bad
if (counts.containsKey(key)) {
  counts[key] = counts[key]! + 1;
} else {
  counts[key] = 1;
}
```

---

## Null Safety Patterns

### Null Checks

**Don't initialize nullable to null:**
```dart
// Good
String? name;

// Bad
String? name = null;
```

**Use null-aware operators:**
```dart
// Null-aware access
final length = text?.length;

// Null-aware method calls
callback?.call();

// Null coalescing
final name = user?.name ?? 'Guest';

// Null-aware assignment
cache ??= loadFromDisk();

// Null-aware cascade
user?..name = 'New'..save();

// Null-aware index
final first = list?[0];
```

**Prefer local variable for multiple checks:**
```dart
// Good
final user = _user;
if (user != null) {
  print(user.name);  // user is promoted to non-null
  print(user.email);
}

// Bad - field might change between checks
if (_user != null) {
  print(_user!.name);  // Need ! each time
  print(_user!.email);
}
```

### Late Variables

**Use `late` for definitely-assigned variables:**
```dart
// Good - assigned before use
late String name;

void init(String value) {
  name = value;
}

void display() {
  print(name);  // Will be assigned
}
```

**Use `late final` for lazy computation:**
```dart
// Good - computed once on first access
late final Config config = _loadConfig();
late final Database db = Database.connect();
```

**Don't use late unnecessarily:**
```dart
// Bad
late String name = 'Default';

// Good
String name = 'Default';
```

### Non-Null Assertions

**Use `!` sparingly and document why:**
```dart
// Good - documented invariant
class Page {
  // _title is always set in initState before build
  String? _title;

  @override
  Widget build(BuildContext context) {
    // Safe: initState guarantees _title is set
    return Text(_title!);
  }
}

// Good - immediately after null check
final value = map[key];
if (value == null) throw StateError('Missing key: $key');
return value;  // No need for ! after null check
```

---

## Function Patterns

### Function Declarations

**Use named declarations at top level:**
```dart
// Good
void processUser(User user) {
  // ...
}

// Bad - lambda assignment for top-level
var processUser = (User user) {
  // ...
};
```

### Tear-offs

**Prefer tear-offs over lambdas:**
```dart
// Good
names.forEach(print);
items.map(buildWidget);
button.onPressed = handleTap;
users.where(isActive);

// Bad
names.forEach((name) => print(name));
items.map((item) => buildWidget(item));
button.onPressed = () => handleTap();
users.where((user) => isActive(user));
```

**Tear-offs work with instance methods:**
```dart
class UserService {
  bool isValid(User user) => user.name.isNotEmpty;

  List<User> filterValid(List<User> users) {
    return users.where(isValid).toList();  // Tear-off
  }
}
```

### Parameters

**Use named parameters for clarity:**
```dart
// Good
void createUser({
  required String name,
  required String email,
  bool isAdmin = false,
});

createUser(name: 'Alice', email: 'alice@test.com');

// Bad - positional booleans
void createUser(String name, String email, bool isAdmin);
createUser('Alice', 'alice@test.com', false);  // What's false?
```

**Use required for non-nullable named parameters:**
```dart
// Good
void sendEmail({
  required String to,
  required String subject,
  String? body,
});

// Bad - default empty string
void sendEmail({
  String to = '',
  String subject = '',
  String? body,
});
```

**Default values should be const:**
```dart
// Good
void process(List<int> items = const []);

// Bad
void process(List<int>? items) {
  items ??= [];  // Creates new list each call
}
```

### Expression Bodies

**Use `=>` for simple returns:**
```dart
// Good
bool get isEmpty => _items.length == 0;
int add(int a, int b) => a + b;
String greet(String name) => 'Hello, $name!';

// Bad - expression body with complex logic
String format(User u) => u.name.isNotEmpty
    ? '${u.name} (${u.email})'
    : u.email;

// Good - use block body for complex logic
String format(User u) {
  if (u.name.isNotEmpty) {
    return '${u.name} (${u.email})';
  }
  return u.email;
}
```

---

## Constructor Patterns

### Initializing Formals

**Use `this.` for parameter-to-field:**
```dart
// Good
class User {
  final String name;
  final String email;

  User(this.name, this.email);
}

// Bad
class User {
  final String name;
  final String email;

  User(String name, String email)
      : name = name,
        email = email;
}
```

**Combine with named parameters:**
```dart
class User {
  final String name;
  final String email;
  final bool isAdmin;

  User({
    required this.name,
    required this.email,
    this.isAdmin = false,
  });
}
```

### Empty Bodies

**Use `;` for empty constructor bodies:**
```dart
// Good
class Point {
  final int x, y;
  Point(this.x, this.y);
}

// Bad
class Point {
  final int x, y;
  Point(this.x, this.y) {}
}
```

### Factory Constructors

**Use factory for caching/returning subtypes:**
```dart
class Logger {
  static final Map<String, Logger> _cache = {};
  final String name;

  Logger._internal(this.name);

  factory Logger(String name) {
    return _cache.putIfAbsent(name, () => Logger._internal(name));
  }
}
```

**Use factory for validation:**
```dart
class Email {
  final String value;

  Email._internal(this.value);

  factory Email(String value) {
    if (!value.contains('@')) {
      throw FormatException('Invalid email: $value');
    }
    return Email._internal(value);
  }
}
```

### Named Constructors

**Use named constructors for clarity:**
```dart
class Point {
  final double x, y;

  Point(this.x, this.y);

  Point.origin() : x = 0, y = 0;

  Point.fromJson(Map<String, dynamic> json)
      : x = json['x'] as double,
        y = json['y'] as double;
}
```

### Const Constructors

**Use const for immutable classes:**
```dart
class Color {
  final int red, green, blue;

  const Color(this.red, this.green, this.blue);

  static const white = Color(255, 255, 255);
  static const black = Color(0, 0, 0);
}

// Usage
const primaryColor = Color(0, 122, 255);
```

---

## Error Handling Patterns

### Catching Exceptions

**Be specific with on clauses:**
```dart
// Good
try {
  await file.readAsString();
} on FileSystemException catch (e) {
  log.warning('File not found: ${e.path}');
  return defaultContent;
} on FormatException catch (e) {
  log.error('Invalid file format: $e');
  rethrow;
}

// Bad - catches everything
try {
  await file.readAsString();
} catch (e) {
  log.error(e);
}
```

**Capture stack traces:**
```dart
try {
  await processData();
} catch (e, stackTrace) {
  log.error('Processing failed', e, stackTrace);
  rethrow;
}
```

### Error vs Exception

**Use Error for programming bugs:**
```dart
// Caller passed invalid argument
throw ArgumentError.value(value, 'value', 'must be positive');

// Object in invalid state
throw StateError('Cannot call read() after close()');

// Not implemented
throw UnimplementedError('Subclass must override this method');
```

**Use Exception for recoverable failures:**
```dart
// Network issues
throw HttpException('Connection timeout');

// Business rule violations
throw InsufficientFundsException(balance, amount);

// Parsing failures
throw FormatException('Invalid JSON at position $position');
```

### Custom Exceptions

```dart
class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class NotFoundException extends ApiException {
  NotFoundException(String resource)
      : super(404, '$resource not found');
}
```

### Rethrow

**Use `rethrow` to preserve stack traces:**
```dart
// Good
try {
  await riskyOperation();
} catch (e) {
  logError(e);
  rethrow;  // Original stack trace preserved
}

// Bad
try {
  await riskyOperation();
} catch (e) {
  logError(e);
  throw e;  // Stack trace lost!
}
```

---

## Async Patterns

### async/await

**Prefer async/await over raw Futures:**
```dart
// Good
Future<User> fetchUser(String id) async {
  final response = await http.get('/users/$id');
  final json = jsonDecode(response.body);
  return User.fromJson(json);
}

// Bad
Future<User> fetchUser(String id) {
  return http.get('/users/$id').then((response) {
    final json = jsonDecode(response.body);
    return User.fromJson(json);
  });
}
```

**Use Future.wait for parallel operations:**
```dart
// Good - parallel
final results = await Future.wait([
  fetchUser(id),
  fetchOrders(id),
  fetchPreferences(id),
]);

// Bad - sequential (unnecessary)
final user = await fetchUser(id);
final orders = await fetchOrders(id);
final prefs = await fetchPreferences(id);
```

### Stream Patterns

**Use higher-order stream methods:**
```dart
// Good
stream
    .where((event) => event.isValid)
    .map((event) => event.data)
    .distinct()
    .listen(process);

// Bad
stream.listen((event) {
  if (event.isValid) {
    final data = event.data;
    if (data != lastData) {
      lastData = data;
      process(data);
    }
  }
});
```

**Use `async*` for generators:**
```dart
Stream<int> countDown(int from) async* {
  for (var i = from; i >= 0; i--) {
    yield i;
    await Future.delayed(Duration(seconds: 1));
  }
}
```

### Completing Futures

**Use Future.value for immediate values:**
```dart
// Good
Future<int> cachedCount() {
  if (_cache != null) return Future.value(_cache);
  return _fetchCount();
}

// Also good with async
Future<int> cachedCount() async {
  if (_cache != null) return _cache;
  return _fetchCount();
}
```

**Use Completer for callback APIs:**
```dart
Future<String> readFile(String path) {
  final completer = Completer<String>();

  legacyReadFile(path,
    onSuccess: (content) => completer.complete(content),
    onError: (error) => completer.completeError(error),
  );

  return completer.future;
}
```

---

## Type Patterns

### Type Inference

**Let inference work for locals:**
```dart
// Good
var items = <String>[];
var user = fetchUser();
final count = items.length;

// Bad (redundant)
List<String> items = <String>[];
Future<User> user = fetchUser();
int count = items.length;
```

**Annotate when inference fails:**
```dart
// Need annotation - type not inferrable
List<Widget> widgets = [];

// Need annotation - complex generic
Map<String, List<int>> grouped = {};
```

### Casts

**Prefer pattern matching over casts:**
```dart
// Good
if (value case int number) {
  return number * 2;
}

// Good - switch
return switch (value) {
  int n => n * 2,
  String s => int.parse(s) * 2,
  _ => 0,
};

// Less good - explicit cast
if (value is int) {
  return (value as int) * 2;  // Redundant after is check
}

// Better with is
if (value is int) {
  return value * 2;  // Promoted, no cast needed
}
```

### Generics

**Use type parameters for flexibility:**
```dart
T firstOrDefault<T>(List<T> items, T defaultValue) {
  return items.isEmpty ? defaultValue : items.first;
}

// With bounds
T max<T extends Comparable<T>>(T a, T b) {
  return a.compareTo(b) > 0 ? a : b;
}
```

**Don't use dynamic when you mean Object:**
```dart
// Bad - allows anything, no type safety
void process(dynamic value) {}

// Good - explicit about accepting any type
void process(Object? value) {}

// Good - for truly dynamic JSON
Map<String, dynamic> parseJson(String input) => ...;
```
