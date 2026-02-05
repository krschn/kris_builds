---
name: effective-dart
description: Senior Dart developer best practices. Auto-triggers for all Dart and Flutter development. Covers Effective Dart guidelines, modern Dart 3.x features (patterns, records, sealed classes), API design, performance optimization, testable code patterns, and Flutter-specific practices. Use this skill whenever writing, reviewing, or refactoring Dart code.
---

# Effective Dart Skill

This skill ensures Claude writes proper, idiomatic Dart code following official Effective Dart guidelines and modern best practices. Apply these guidelines to ALL Dart and Flutter code.

## Guideline Terminology

- **DO**: Always follow this guideline
- **DON'T**: Never do this
- **PREFER**: Follow unless you have a good reason not to
- **AVOID**: Don't do this unless you have a good reason
- **CONSIDER**: Use your judgment based on context

---

## 1. Style Guidelines

### Naming Conventions

**DO use UpperCamelCase for types:**
```dart
// Good
class HttpRequest {}
typedef Predicate<T> = bool Function(T);
extension StringExtensions on String {}
mixin Comparable<T> {}
enum Status { pending, approved, rejected }
```

**DO use lowerCamelCase for members and variables:**
```dart
// Good
var itemCount = 3;
void calculateTotal() {}
final String firstName;
const defaultTimeout = Duration(seconds: 30);
```

**DO use lowercase_with_underscores for packages and files:**
```dart
// Good
import 'package:my_package/src/http_client.dart';
import 'string_utils.dart';
```

**DON'T use prefix letters (Hungarian notation):**
```dart
// Bad
String kDefaultName = 'Guest';
String sUserName = 'John';

// Good
String defaultName = 'Guest';
String userName = 'John';
```

**DO use noun phrases for non-boolean properties:**
```dart
// Good
final String name;
final List<Item> items;
final double totalAmount;
```

**DO use isX, hasX, canX for boolean properties:**
```dart
// Good
bool isEmpty;
bool hasChildren;
bool canDelete;
bool shouldUpdate;
```

### Import Ordering

**DO order imports in sections:**
```dart
// 1. dart: imports
import 'dart:async';
import 'dart:io';

// 2. package: imports
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

// 3. Relative imports
import '../models/user.dart';
import 'utils.dart';
```

**PREFER relative imports within your own package:**
```dart
// In lib/src/feature/page.dart

// Good
import '../models/user.dart';
import 'widgets/header.dart';

// Avoid
import 'package:my_app/src/models/user.dart';
```

### Formatting

**DO use `dart format`** - Never manually format. Let the tool handle it.

**DO use curly braces for all flow control:**
```dart
// Good
if (isValid) {
  process();
}

// Bad
if (isValid) process();
```

**PREFER single quotes for strings:**
```dart
// Good
var greeting = 'Hello, World!';

// Bad
var greeting = "Hello, World!";
```

---

## 2. Documentation

**DO use `///` doc comments for public APIs:**
```dart
/// Returns the user with the given [id].
///
/// Throws [UserNotFoundException] if no user exists with that ID.
/// Returns `null` if the user is archived.
Future<User?> findUser(String id);
```

**DO start with a single-sentence summary:**
```dart
/// Deletes the file at [path].
///
/// Additional details can follow in subsequent paragraphs.
void deleteFile(String path);
```

**DO use square brackets for references:**
```dart
/// Throws a [StateError] if the widget is not mounted.
/// Similar to [RenderObject.owner] but for widgets.
/// See also [dispose], which releases resources.
```

**DON'T use block comments for documentation:**
```dart
// Bad
/**
 * Counts the items.
 */

// Good
/// Counts the items.
```

**CONSIDER documenting private members when complex:**
```dart
/// Cache of computed values, keyed by input hash.
/// Entries older than [_cacheTimeout] are evicted on next access.
final Map<int, Result> _cache = {};
```

---

## 3. Null Safety

**DON'T explicitly initialize to null:**
```dart
// Bad
String? name = null;

// Good
String? name;
```

**DON'T use `late` unless necessary:**
```dart
// Bad - late for something easily initialized
late String title = 'Default';

// Good
String title = 'Default';

// Good use of late - expensive computation deferred
late final Config config = _loadConfig();
```

**DO use `!` only when you've verified non-null:**
```dart
// Good - we just checked
if (user != null) {
  print(user.name); // No need for ! after null check
}

// Good - documented invariant
final item = _items[id]!; // We know map is pre-populated
```

**PREFER null-aware operators:**
```dart
// Good
final name = user?.name ?? 'Guest';
list?.add(item);
callback?.call();
```

**DO use `??=` for lazy initialization:**
```dart
// Good
_cache ??= _computeExpensiveValue();
```

---

## 4. Collections

**DO use collection literals:**
```dart
// Good
var items = <String>[];
var map = <String, int>{};
var set = <int>{};

// Bad
var items = List<String>();
var map = Map<String, int>();
```

**DO use `.isEmpty` and `.isNotEmpty`:**
```dart
// Good
if (items.isEmpty) {}
if (items.isNotEmpty) {}

// Bad
if (items.length == 0) {}
if (items.length > 0) {}
```

**DO use `whereType<T>()` for type filtering:**
```dart
// Good
var strings = objects.whereType<String>();

// Bad
var strings = objects.where((e) => e is String).cast<String>();
```

**DO use spread operators:**
```dart
// Good
var combined = [...list1, ...list2];
var withOptional = [...required, ...?optional];

// Bad
var combined = List<int>.from(list1)..addAll(list2);
```

**DO use collection if/for:**
```dart
// Good
var widgets = [
  Header(),
  if (showBody) Body(),
  for (var item in items) ItemWidget(item),
  Footer(),
];
```

---

## 5. Functions

**DO use named function declarations at top level:**
```dart
// Good
void processItem(Item item) {}

// Bad
var processItem = (Item item) {};
```

**DO use tear-offs instead of lambdas:**
```dart
// Good
items.forEach(print);
names.map(buildGreeting);
button.onPressed = handleSubmit;

// Bad
items.forEach((item) => print(item));
names.map((name) => buildGreeting(name));
button.onPressed = () => handleSubmit();
```

**DO use `=` for single-expression functions:**
```dart
// Good
String get fullName => '$firstName $lastName';
bool isValid(String s) => s.isNotEmpty;

// Bad (for single expression)
String get fullName {
  return '$firstName $lastName';
}
```

**PREFER named parameters for multiple booleans:**
```dart
// Good
void resize({required bool animate, required bool fill});

// Bad
void resize(bool animate, bool fill);
```

**DO use required for non-nullable named parameters:**
```dart
// Good
void createUser({required String name, required String email});

// Bad
void createUser({String name = '', String email = ''});
```

---

## 6. Constructors

**DO use initializing formals:**
```dart
// Good
class Point {
  final int x;
  final int y;
  Point(this.x, this.y);
}

// Bad
class Point {
  final int x;
  final int y;
  Point(int x, int y) : x = x, y = y;
}
```

**DO use `;` for empty constructor bodies:**
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

**DON'T use `new`:**
```dart
// Good
var point = Point(1, 2);
var list = <int>[];

// Bad
var point = new Point(1, 2);
var list = new List<int>();
```

**DO use `const` for compile-time constants:**
```dart
// Good
const defaultPoint = Point(0, 0);
const emptyList = <String>[];

// In Flutter
const Text('Hello');
```

**DO make immutable classes with const constructors:**
```dart
// Good
class Point {
  final int x;
  final int y;
  const Point(this.x, this.y);
}
```

---

## 7. Modern Dart 3.x Features

### Patterns and Destructuring

**DO use patterns for multiple returns:**
```dart
// Good
(String, int) parseEntry(String line) {
  final parts = line.split(':');
  return (parts[0], int.parse(parts[1]));
}

final (name, value) = parseEntry('count:42');
```

**DO use pattern matching in switch:**
```dart
// Good
String describe(Object obj) => switch (obj) {
  int n when n < 0 => 'negative',
  int n => 'integer: $n',
  String s when s.isEmpty => 'empty string',
  String s => 'string: $s',
  [var first, ...] => 'list starting with $first',
  {'name': var name} => 'map with name: $name',
  _ => 'unknown',
};
```

**DO use if-case for single pattern checks:**
```dart
// Good
if (json case {'user': {'name': String name}}) {
  print('Found user: $name');
}

// Instead of
if (json is Map && json['user'] is Map && json['user']['name'] is String) {
  final name = json['user']['name'] as String;
  print('Found user: $name');
}
```

### Records

**DO use records for multiple return values:**
```dart
// Good
(double, double) geoLocate(String address) => (37.7749, -122.4194);
final (lat, lng) = geoLocate('San Francisco');

// Named fields for clarity
({String name, int age}) parseUser(Map json) =>
    (name: json['name'] as String, age: json['age'] as int);

final (:name, :age) = parseUser({'name': 'Alice', 'age': 30});
```

### Sealed Classes

**DO use sealed classes for exhaustive matching:**
```dart
// Good
sealed class Result<T> {}

class Success<T> extends Result<T> {
  final T value;
  Success(this.value);
}

class Failure<T> extends Result<T> {
  final String message;
  Failure(this.message);
}

// Compiler ensures exhaustiveness
String describe<T>(Result<T> result) => switch (result) {
  Success(:final value) => 'Success: $value',
  Failure(:final message) => 'Failed: $message',
};
```

### Switch Expressions

**DO use switch expressions for value mapping:**
```dart
// Good
final label = switch (status) {
  Status.pending => 'Waiting...',
  Status.approved => 'Approved!',
  Status.rejected => 'Denied',
};

// Bad
String label;
switch (status) {
  case Status.pending:
    label = 'Waiting...';
    break;
  case Status.approved:
    label = 'Approved!';
    break;
  case Status.rejected:
    label = 'Denied';
    break;
}
```

### Class Modifiers

**DO use `final` to prevent subclassing outside package:**
```dart
// Good - prevent unexpected inheritance
final class Config {
  final String apiUrl;
  const Config(this.apiUrl);
}
```

**DO use `interface` for implementation contracts:**
```dart
// Good - can only be implemented, not extended
interface class Repository {
  Future<User> findUser(String id);
}
```

**DO use `base` when subclasses must call super:**
```dart
// Good - ensures proper initialization
base class Disposable {
  bool _disposed = false;
  void dispose() => _disposed = true;
}
```

### Dot Shorthands (Dart 3.10+)

**CONSIDER using dot shorthands for concise enum/static access:**
```dart
// Good - when type is inferrable
Color color = .red;  // Same as Color.red
Alignment align = .center;

// In Flutter widgets
Container(
  alignment: .center,  // Alignment.center
  color: .blue,  // Colors.blue
);

// In switch
String label = switch (status) {
  .pending => 'Waiting',
  .approved => 'Done',
  .rejected => 'Failed',
};
```

---

## 8. API Design

### Naming

**DO use consistent terminology:**
```dart
// Good - consistent naming
pageCount, itemCount, elementCount

// Bad - inconsistent
pageCount, numItems, nElements
```

**AVOID abbreviations unless universally known:**
```dart
// Good
buttonBuilder, characterCount, userIdentifier

// Bad (unclear abbreviations)
btnBldr, charCnt, usrId

// OK (universal abbreviations)
httpClient, uiController, maxId, minValue
```

**DO name methods for what they do:**
```dart
// For side effects, use verbs
void save();
void delete();
Future<void> uploadFile();

// For computed values, use nouns/adjectives
int get length;
bool get isEmpty;
String formattedDate();
```

**DO use `to___()` for copies and `as___()` for views:**
```dart
// to___ creates a new object
List<E> toList();
String toString();
DateTime toUtc();

// as___ returns a different view of same data
List<R> cast<R>();
Map<K, V> asMap();
```

### Equality

**DO override `hashCode` if you override `==`:**
```dart
// Good
class Point {
  final int x, y;
  const Point(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      other is Point && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}
```

**AVOID defining `==` on mutable classes:**
```dart
// Bad - equality based on mutable state
class User {
  String name;  // Mutable!
  @override
  bool operator ==(Object other) => other is User && other.name == name;
}

// Good - use Equatable for immutable value objects
class User extends Equatable {
  final String name;
  const User(this.name);
  @override
  List<Object?> get props => [name];
}
```

### Types

**PREFER type inference for local variables:**
```dart
// Good
var items = <String>[];
var user = User('Alice');
final total = items.fold(0, (sum, item) => sum + item.price);

// Bad (redundant)
List<String> items = <String>[];
User user = User('Alice');
```

**DO annotate public APIs:**
```dart
// Good
Future<User> findUser(String id) async { ... }

// Bad
findUser(id) async { ... }
```

**AVOID `dynamic` unless intentional:**
```dart
// Bad
dynamic parse(String input) { ... }

// Good - be explicit about what's returned
Object? parse(String input) { ... }
Map<String, dynamic> parseJson(String input) { ... }  // OK for JSON
```

---

## 9. Error Handling

**DO use `on` to catch specific exceptions:**
```dart
// Good
try {
  await file.readAsString();
} on FileSystemException catch (e) {
  log('File error: $e');
} on FormatException catch (e) {
  log('Format error: $e');
}
```

**DON'T discard errors silently:**
```dart
// Bad
try {
  process();
} catch (e) {
  // Silently swallowed
}

// Good
try {
  process();
} catch (e, stack) {
  log.error('Process failed', e, stack);
  rethrow;
}
```

**DO use `rethrow` to preserve stack trace:**
```dart
// Good
try {
  await riskyOperation();
} catch (e) {
  logError(e);
  rethrow;  // Preserves original stack trace
}

// Bad
try {
  await riskyOperation();
} catch (e) {
  logError(e);
  throw e;  // Loses original stack trace
}
```

**DO distinguish `Error` from `Exception`:**
```dart
// Error = programming bug (should not be caught in production)
throw StateError('Invalid state');
throw ArgumentError.notNull('id');

// Exception = runtime failure (should be handled)
throw HttpException('Connection failed');
throw FormatException('Invalid JSON');
```

---

## 10. Async Best Practices

**PREFER async/await over raw Futures:**
```dart
// Good
Future<User> fetchUser(String id) async {
  final response = await http.get('/users/$id');
  return User.fromJson(response.body);
}

// Bad
Future<User> fetchUser(String id) {
  return http.get('/users/$id').then((response) {
    return User.fromJson(response.body);
  });
}
```

**DO use `Future<void>` for no-return async:**
```dart
// Good
Future<void> saveUser(User user) async {
  await _storage.write(user);
}

// Bad
Future saveUser(User user) async {
  await _storage.write(user);
}
```

**DO use higher-order stream methods:**
```dart
// Good
final names = users.map((u) => u.name);
final adults = users.where((u) => u.age >= 18);
final total = orders.fold(0.0, (sum, o) => sum + o.total);

// Bad
final names = <String>[];
for (final u in users) {
  names.add(u.name);
}
```

**DO use isolates for CPU-intensive work:**
```dart
// Good - offload heavy computation
final result = await Isolate.run(() => parseHugeFile(data));

// Bad - blocks the event loop
final result = parseHugeFile(data);
```

---

## 11. Anti-Patterns to Avoid

**DON'T create single-member abstract classes:**
```dart
// Bad
abstract class Logger {
  void log(String message);
}

// Good - just use a function type
typedef Logger = void Function(String message);
```

**DON'T create classes with only static members:**
```dart
// Bad
class StringUtils {
  static String capitalize(String s) => ...;
  static String truncate(String s, int length) => ...;
}

// Good - use top-level functions
String capitalize(String s) => ...;
String truncate(String s, int length) => ...;
```

**DON'T use positional boolean parameters:**
```dart
// Bad
void connect(String host, bool useHttps, bool retry);
connect('api.com', true, false);  // What do true/false mean?

// Good
void connect(String host, {bool useHttps = true, bool retry = true});
connect('api.com', useHttps: true, retry: false);
```

**DON'T extend classes not designed for inheritance:**
```dart
// Bad
class MyList extends ListBase<int> { ... }  // Complex inheritance

// Good - composition
class MyList {
  final List<int> _inner = [];
  void add(int item) => _inner.add(item);
}
```

---

## 12. Reference Files

For more detailed coverage, see:

- **[style_guide.md](references/style_guide.md)** - Complete naming, formatting, and import rules
- **[usage_patterns.md](references/usage_patterns.md)** - Common idioms and patterns
- **[modern_dart.md](references/modern_dart.md)** - Dart 3.x patterns, records, sealed classes
- **[api_design.md](references/api_design.md)** - Class and API design principles
- **[performance.md](references/performance.md)** - Isolates, efficient patterns, allocations
- **[testable_code.md](references/testable_code.md)** - DI, abstractions, mocking patterns
- **[flutter_patterns.md](references/flutter_patterns.md)** - Widget design, state management

---

## Quick Reference

### Naming Cheatsheet
| Element | Style | Example |
|---------|-------|---------|
| Classes, enums, typedefs | UpperCamelCase | `HttpClient` |
| Variables, parameters | lowerCamelCase | `itemCount` |
| Constants | lowerCamelCase | `maxItems` |
| Libraries, packages | lowercase_with_underscores | `my_package` |
| Files | lowercase_with_underscores | `http_client.dart` |

### Operator Precedence (key ones)
```dart
// Cascade (..) applies last
sb.write('hello')..write('world');

// Null-aware (?., ??) short-circuit
user?.address?.city ?? 'Unknown';

// Spread (...) in collections
[...list1, ...list2]
```

### Quick Patterns
```dart
// Multiple return values
(int, String) fetch() => (200, 'OK');
final (code, message) = fetch();

// Exhaustive switch
sealed class Event {}
class Click extends Event {}
class Scroll extends Event {}

handle(Event e) => switch (e) {
  Click() => 'clicked',
  Scroll() => 'scrolled',
};

// If-case extraction
if (json case {'data': List items}) {
  process(items);
}
```

---

**Always apply these guidelines when writing Dart code. When in doubt, refer to the detailed reference files or the official Effective Dart documentation.**
