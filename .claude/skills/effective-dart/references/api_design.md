# Dart API Design Reference

This reference covers best practices for designing classes, interfaces, and APIs in Dart.

## Naming Conventions

### Consistent Terminology

**Use the same term for the same concept:**
```dart
// Good - consistent naming
class Document {
  int get pageCount => ...;
}

class Book {
  int get pageCount => ...;  // Same concept, same name
}

// Bad - inconsistent
class Document {
  int get pageCount => ...;
}

class Book {
  int get numPages => ...;  // Different name for same concept
}
```

### Avoid Abbreviations

**Use full words unless universally understood:**
```dart
// Good
class ButtonBuilder {}
int characterCount;
String userIdentifier;
Duration responseTimeout;

// Bad
class BtnBldr {}
int charCnt;
String usrId;
Duration respTO;

// OK - universal abbreviations
HttpClient client;
String uiLabel;
int maxValue;
String id;
```

### Boolean Naming

**Use positive, question-like names:**
```dart
// Good - reads like a question
bool isEmpty;       // Is it empty?
bool hasChildren;   // Does it have children?
bool canDelete;     // Can we delete it?
bool shouldUpdate;  // Should we update?
bool wasSuccessful; // Was it successful?

// Bad - ambiguous or negative
bool empty;         // Is this a verb or adjective?
bool notEmpty;      // Avoid negatives in names
bool deletable;     // canDelete is clearer
```

### Method Naming

**Use verbs for operations with side effects:**
```dart
// Good
void save();
void delete();
void send();
void process();
void reset();
Future<void> upload();
Future<void> fetchData();
```

**Use nouns/adjectives for computed values:**
```dart
// Good
int get length;
String get formattedDate;
bool get isValid;
User get currentUser;
List<Item> get filteredItems;
```

**Use imperative verbs for actions:**
```dart
// Good
void clearCache();
void refreshToken();
void cancelRequest();
void retryOperation();
```

### Conversion Method Names

**`to___()` returns a new independent object:**
```dart
// Creates new object
String toString();
List<E> toList();
Set<E> toSet();
Map<K, V> toMap();
DateTime toUtc();
User toEntity();
UserDto toDto();
```

**`as___()` returns a different view of same data:**
```dart
// Same underlying data, different interface
List<R> cast<R>();
Uint8List asUint8List();
Map<K, V> asMap();
Stream<T> asStream();
ByteData asByteData();
```

---

## Class Design

### Single Responsibility

**Each class should have one reason to change:**
```dart
// Bad - too many responsibilities
class User {
  String name;
  String email;

  void save() => ...;           // Persistence
  void sendEmail() => ...;      // Communication
  String toJson() => ...;       // Serialization
  bool validate() => ...;       // Validation
}

// Good - separated concerns
class User {
  final String name;
  final String email;

  const User({required this.name, required this.email});
}

class UserRepository {
  Future<void> save(User user) => ...;
}

class UserValidator {
  bool isValid(User user) => ...;
}
```

### Composition Over Inheritance

**Prefer composition for code reuse:**
```dart
// Bad - inheritance for code reuse
class LoggingService extends Logger {
  void process() {
    log('Processing...');  // Inherited
  }
}

// Good - composition
class LoggingService {
  final Logger _logger;

  LoggingService(this._logger);

  void process() {
    _logger.log('Processing...');
  }
}
```

### Immutability

**Prefer immutable classes:**
```dart
// Good - immutable
class User {
  final String id;
  final String name;
  final String email;

  const User({
    required this.id,
    required this.name,
    required this.email,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
```

**Use copyWith for modifications:**
```dart
final user = User(id: '1', name: 'Alice', email: 'alice@test.com');
final updated = user.copyWith(name: 'Alice Smith');
```

---

## Constructors

### Initializing Formals

**Always use `this.` for simple field assignment:**
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

  Point(int x, int y)
      : x = x,
        y = y;
}
```

### Named Constructors

**Use for alternative construction:**
```dart
class DateTime {
  DateTime(int year, int month, int day);
  DateTime.now();
  DateTime.utc(int year, int month, int day);
  DateTime.fromMillisecondsSinceEpoch(int ms);
}
```

**Use for semantic clarity:**
```dart
class User {
  final String id;
  final String name;
  final bool isGuest;

  User({required this.id, required this.name, this.isGuest = false});

  User.guest()
      : id = 'guest',
        name = 'Guest User',
        isGuest = true;

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        isGuest = json['isGuest'] as bool? ?? false;
}
```

### Factory Constructors

**Use for caching:**
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

**Use for returning subtypes:**
```dart
abstract class Shape {
  factory Shape.fromJson(Map<String, dynamic> json) {
    return switch (json['type']) {
      'circle' => Circle.fromJson(json),
      'rectangle' => Rectangle.fromJson(json),
      _ => throw FormatException('Unknown shape: ${json['type']}'),
    };
  }
}
```

**Use for validation:**
```dart
class PositiveInt {
  final int value;

  PositiveInt._internal(this.value);

  factory PositiveInt(int value) {
    if (value <= 0) {
      throw ArgumentError.value(value, 'value', 'Must be positive');
    }
    return PositiveInt._internal(value);
  }
}
```

### Const Constructors

**Use for immutable, compile-time constant classes:**
```dart
class Color {
  final int r, g, b;

  const Color(this.r, this.g, this.b);

  static const red = Color(255, 0, 0);
  static const green = Color(0, 255, 0);
  static const blue = Color(0, 0, 255);
}

// Compile-time constant
const primaryColor = Color(0, 122, 255);
```

---

## Equality and Hashing

### Override Both or Neither

**Always override `hashCode` when overriding `==`:**
```dart
class Point {
  final int x;
  final int y;

  const Point(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}
```

### Use Equatable

**For less boilerplate:**
```dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;

  const User({
    required this.id,
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [id, name, email];
}
```

### Avoid Equality on Mutable Classes

**Mutable equality leads to bugs:**
```dart
// Bad - mutable fields affect equality
class MutableUser {
  String name;  // Mutable!

  @override
  bool operator ==(Object other) =>
      other is MutableUser && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

// Problem: object's hash changes after insertion
final set = <MutableUser>{MutableUser()..name = 'Alice'};
set.first.name = 'Bob';  // Now set contains 'Bob' but...
print(set.contains(MutableUser()..name = 'Bob'));  // false! Hash mismatch
```

---

## Type Annotations

### When to Annotate

**DO annotate public API signatures:**
```dart
// Good - clear contract
Future<User?> findUser(String id);
List<Widget> buildWidgets(BuildContext context);
Stream<Event> onEvent(String type);

// Bad - unclear
findUser(id);
buildWidgets(context);
onEvent(type);
```

**DON'T annotate local variables unnecessarily:**
```dart
// Good - inferred
var user = fetchUser();
var items = <String>[];
final count = list.length;

// Bad - redundant
User user = fetchUser();
List<String> items = <String>[];
int count = list.length;
```

**DO annotate when inference fails or is unclear:**
```dart
// Need annotation - empty collection
List<Widget> widgets = [];

// Need annotation - lambda parameter types
list.fold<int>(0, (sum, item) => sum + item.value);

// Need annotation - complex generic
final Map<String, List<User>> grouped = {};
```

### Avoid `dynamic`

**Use `Object?` for truly any type:**
```dart
// Bad - loses all type safety
void process(dynamic value) {}

// Good - explicit about accepting anything
void process(Object? value) {}
```

**Only use `dynamic` when necessary:**
```dart
// OK - JSON has dynamic structure
Map<String, dynamic> json = jsonDecode(response);

// OK - interop with untyped APIs
void jsCallback(dynamic result) {}
```

### Covariance

**Be careful with generic covariance:**
```dart
// List<Dog> is a subtype of List<Animal>
// But this is only safe for reading, not writing

void process(List<Animal> animals) {
  animals.add(Cat());  // Runtime error if passed List<Dog>!
}

// Solution: use extends for read-only generic parameters
void processReadOnly<T extends Animal>(List<T> animals) {
  for (var animal in animals) {
    print(animal.name);
  }
}
```

---

## Interface Design

### Minimal Interfaces

**Only expose what's necessary:**
```dart
// Bad - too much exposed
class UserService {
  final Database _db;
  final Cache _cache;

  Database get db => _db;      // Leaks implementation
  Cache get cache => _cache;   // Leaks implementation

  Future<User?> findUser(String id);
}

// Good - minimal interface
class UserService {
  final Database _db;
  final Cache _cache;

  Future<User?> findUser(String id);
  // Internal implementation details are hidden
}
```

### Dependency Inversion

**Depend on abstractions:**
```dart
// Good - depends on abstract interface
abstract class UserRepository {
  Future<User?> findById(String id);
  Future<void> save(User user);
}

class UserService {
  final UserRepository _repository;

  UserService(this._repository);

  Future<User?> getUser(String id) => _repository.findById(id);
}

// Implementations
class SqlUserRepository implements UserRepository { ... }
class MockUserRepository implements UserRepository { ... }
```

### Extension Methods

**Add functionality without modifying classes:**
```dart
extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }
}

// Usage
'hello'.capitalize();  // 'Hello'
'test@example.com'.isValidEmail;  // true
```

**Don't overuse extensions:**
```dart
// Bad - too much functionality added
extension UserExtensions on User {
  Future<void> save() => ...;
  Future<void> sendEmail() => ...;
  Widget toWidget() => ...;
}

// Good - keep focused
extension UserFormatting on User {
  String get displayName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}';
}
```

---

## Generics

### Type Parameters

**Use single uppercase letters for type parameters:**
```dart
class Box<T> {
  final T value;
  Box(this.value);
}

class Map<K, V> {
  V? operator [](K key);
}

// Common conventions:
// T - Type (general)
// E - Element (collections)
// K - Key (maps)
// V - Value (maps)
// R - Return type
// S, U - Additional types
```

### Bounds

**Use `extends` for type constraints:**
```dart
// Only accept Comparable types
T max<T extends Comparable<T>>(T a, T b) {
  return a.compareTo(b) > 0 ? a : b;
}

// Only accept Widget subtypes
class WidgetList<T extends Widget> {
  final List<T> _widgets = [];
  void add(T widget) => _widgets.add(widget);
}
```

### Generic Methods

**Use generic methods for flexibility:**
```dart
T firstOrDefault<T>(List<T> items, T defaultValue) {
  return items.isEmpty ? defaultValue : items.first;
}

R fold<T, R>(List<T> items, R initial, R Function(R, T) combine) {
  var result = initial;
  for (var item in items) {
    result = combine(result, item);
  }
  return result;
}
```

---

## Anti-Patterns

### Don't Create Single-Method Abstract Classes

```dart
// Bad
abstract class Validator {
  bool validate(String input);
}

// Good - use a typedef
typedef Validator = bool Function(String input);
```

### Don't Create Utility Classes

```dart
// Bad
class StringUtils {
  StringUtils._();  // Private constructor

  static String capitalize(String s) => ...;
  static bool isEmpty(String s) => ...;
}

// Good - use top-level functions
String capitalize(String s) => ...;

// Or extension methods
extension StringExtensions on String {
  String capitalize() => ...;
}
```

### Don't Use Positional Boolean Parameters

```dart
// Bad - what does true mean?
connect('host.com', true, false);

// Good - named parameters are self-documenting
connect('host.com', useSSL: true, autoReconnect: false);
```

### Don't Expose Internal State

```dart
// Bad - exposes mutable internal list
class TodoList {
  final List<Todo> items = [];
}

// Good - return unmodifiable view
class TodoList {
  final List<Todo> _items = [];

  List<Todo> get items => List.unmodifiable(_items);
  // Or: UnmodifiableListView(_items)

  void add(Todo item) => _items.add(item);
}
```

### Don't Use Inheritance for Code Reuse

```dart
// Bad
class LoggingButton extends Button {
  @override
  void onPressed() {
    log('Button pressed');
    super.onPressed();
  }
}

// Good - use composition
class LoggingButton {
  final Button _button;
  final Logger _logger;

  void onPressed() {
    _logger.log('Button pressed');
    _button.onPressed();
  }
}

// Or use mixins for cross-cutting concerns
mixin Logging {
  void log(String message) => print(message);
}

class LoggingButton with Logging {
  void onPressed() {
    log('Button pressed');
    // ...
  }
}
```
