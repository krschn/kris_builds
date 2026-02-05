# Modern Dart (3.x) Features Reference

This reference covers Dart 3.x features including patterns, records, sealed classes, and class modifiers.

## Patterns

Patterns are a powerful way to match and destructure data in Dart 3.0+.

### Pattern Types

**Literal Patterns:**
```dart
// Match exact values
switch (status) {
  case 200: return 'OK';
  case 404: return 'Not Found';
  case 500: return 'Server Error';
}
```

**Variable Patterns:**
```dart
// Bind to new variable
switch (value) {
  case int n: return n * 2;
  case String s: return s.length;
}
```

**Identifier Patterns (with final/var):**
```dart
// Destructure into variables
var (x, y) = getPoint();
final (name, age) = parseUser(json);
```

**Wildcard Patterns:**
```dart
// Ignore values
var (_, y) = point;  // Only need y
case [_, _, third]: return third;
```

**Type Patterns:**
```dart
// Match by type
case int(): return 'integer';
case String(): return 'string';
case List<int>(): return 'int list';
```

**List Patterns:**
```dart
switch (list) {
  case []: return 'empty';
  case [var only]: return 'one: $only';
  case [var first, var second]: return 'two: $first, $second';
  case [var first, ...]: return 'starts with: $first';
  case [..., var last]: return 'ends with: $last';
  case [var first, ..., var last]: return 'first: $first, last: $last';
}
```

**Map Patterns:**
```dart
switch (json) {
  case {'type': 'user', 'name': String name}:
    return User(name);
  case {'type': 'admin', 'name': String name, 'level': int level}:
    return Admin(name, level);
}
```

**Object Patterns:**
```dart
switch (shape) {
  case Circle(radius: var r): return 3.14 * r * r;
  case Rectangle(width: var w, height: var h): return w * h;
  case Square(side: var s): return s * s;
}
```

**Null-Check Patterns:**
```dart
// Match non-null and bind
switch (value) {
  case String? s?: print('Non-null string: $s');  // s is String
  case null: print('Null value');
}
```

**Null-Assert Patterns:**
```dart
// Assert non-null (throws if null)
var (name!, age!) = maybeNullTuple;
```

**Logical Patterns:**
```dart
// Combine with || and &&
switch (char) {
  case 'a' || 'e' || 'i' || 'o' || 'u': return 'vowel';
  case >= 'a' && <= 'z': return 'lowercase';
  case >= 'A' && <= 'Z': return 'uppercase';
}
```

**Relational Patterns:**
```dart
switch (number) {
  case < 0: return 'negative';
  case == 0: return 'zero';
  case > 0 && < 100: return 'small positive';
  case >= 100: return 'large positive';
}
```

### Pattern Contexts

**Variable Declaration:**
```dart
// Destructure into variables
var (lat, lng) = geolocate(address);
final (name, age) = parseRecord(data);
final Point(:x, :y) = point;  // Named field destructuring
```

**Assignment:**
```dart
// Swap values
(a, b) = (b, a);

// Destructure into existing variables
late String name;
late int age;
(name, age) = parseUser(json);
```

**Switch Statements/Expressions:**
```dart
// Statement
switch (value) {
  case Pattern1(): handlePattern1();
  case Pattern2(): handlePattern2();
}

// Expression
final result = switch (value) {
  Pattern1() => result1,
  Pattern2() => result2,
};
```

**If-Case:**
```dart
// Single pattern match
if (json case {'user': {'name': String name}}) {
  print('Found user: $name');
}

// With condition
if (number case int n when n > 0) {
  print('Positive: $n');
}
```

**For-In (with patterns):**
```dart
for (var MapEntry(:key, :value) in map.entries) {
  print('$key: $value');
}

for (var (index, item) in items.indexed) {
  print('$index: $item');
}
```

---

## Records

Records are anonymous, immutable aggregate types introduced in Dart 3.0.

### Record Syntax

**Positional Records:**
```dart
// Type annotation
(int, String) record;

// Creation
var point = (10, 20);
var user = (1, 'Alice', true);

// Access (positional fields are $1, $2, etc.)
print(point.$1);  // 10
print(user.$2);   // Alice
```

**Named Records:**
```dart
// Type annotation
({String name, int age}) person;

// Creation
var user = (name: 'Alice', age: 30);

// Access
print(user.name);  // Alice
print(user.age);   // 30
```

**Mixed Records:**
```dart
// Positional first, then named
(int, int, {String label}) labeled;

var point = (10, 20, label: 'origin');
print(point.$1);     // 10
print(point.$2);     // 20
print(point.label);  // origin
```

### Common Record Patterns

**Multiple Return Values:**
```dart
// Return multiple values without creating a class
(int, int) minMax(List<int> numbers) {
  var min = numbers.first;
  var max = numbers.first;
  for (var n in numbers) {
    if (n < min) min = n;
    if (n > max) max = n;
  }
  return (min, max);
}

// Usage
final (min, max) = minMax([3, 1, 4, 1, 5]);
```

**Named for Clarity:**
```dart
({double latitude, double longitude}) geolocate(String address) {
  // ...
  return (latitude: 37.7749, longitude: -122.4194);
}

// Destructure with names
final (:latitude, :longitude) = geolocate('San Francisco');
```

**Record Type Aliases:**
```dart
typedef Point = (int x, int y);
typedef UserInfo = ({String name, int age, String email});

Point origin = (0, 0);
UserInfo user = (name: 'Alice', age: 30, email: 'alice@test.com');
```

### Record Equality

Records have structural equality:
```dart
var a = (1, 2);
var b = (1, 2);
print(a == b);  // true

var x = (name: 'Alice', age: 30);
var y = (name: 'Alice', age: 30);
print(x == y);  // true
```

---

## Switch Expressions

Switch expressions return values and enable exhaustive matching.

### Basic Syntax

```dart
final result = switch (value) {
  pattern1 => result1,
  pattern2 => result2,
  pattern3 => result3,
  _ => defaultResult,  // Wildcard for default
};
```

### Exhaustiveness

**Enum exhaustiveness:**
```dart
enum Status { pending, approved, rejected }

// Must handle all cases (no default needed)
String describe(Status status) => switch (status) {
  Status.pending => 'Waiting...',
  Status.approved => 'Approved!',
  Status.rejected => 'Denied',
};
```

**Sealed class exhaustiveness:**
```dart
sealed class Shape {}
class Circle extends Shape { final double radius; Circle(this.radius); }
class Rectangle extends Shape { final double width, height; Rectangle(this.width, this.height); }

// Compiler ensures all subtypes are handled
double area(Shape shape) => switch (shape) {
  Circle(:var radius) => 3.14159 * radius * radius,
  Rectangle(:var width, :var height) => width * height,
};
```

### Guard Clauses

```dart
String describe(int n) => switch (n) {
  int x when x < 0 => 'negative',
  0 => 'zero',
  int x when x < 10 => 'small',
  int x when x < 100 => 'medium',
  _ => 'large',
};
```

### Complex Patterns

```dart
String process(Object value) => switch (value) {
  // Type + destructuring
  Point(:var x, :var y) when x == y => 'diagonal',
  Point(:var x, :var y) => '($x, $y)',

  // List patterns
  [] => 'empty list',
  [var only] => 'single: $only',
  [var first, ...var rest] => 'first: $first, rest: $rest',

  // Map patterns
  {'type': 'error', 'message': String msg} => 'Error: $msg',
  {'type': 'success'} => 'Success!',

  // Logical patterns
  int n when n >= 0 && n <= 100 => 'percentage: $n%',

  _ => 'unknown',
};
```

---

## Sealed Classes

Sealed classes restrict which classes can extend/implement them and enable exhaustive pattern matching.

### Basic Usage

```dart
// Only direct subtypes in this file can extend Shape
sealed class Shape {}

class Circle extends Shape {
  final double radius;
  Circle(this.radius);
}

class Rectangle extends Shape {
  final double width, height;
  Rectangle(this.width, this.height);
}

class Triangle extends Shape {
  final double a, b, c;
  Triangle(this.a, this.b, this.c);
}
```

### Exhaustive Matching

```dart
// Compiler ensures all cases are handled
double area(Shape shape) => switch (shape) {
  Circle(:var radius) => 3.14159 * radius * radius,
  Rectangle(:var width, :var height) => width * height,
  Triangle(:var a, :var b, :var c) => _heronArea(a, b, c),
};

// No default case needed - compiler knows all subtypes
```

### Algebraic Data Types

**Result type:**
```dart
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class Failure<T> extends Result<T> {
  final String message;
  final Object? error;
  const Failure(this.message, [this.error]);
}

// Usage
Result<User> fetchUser(String id) {
  try {
    final user = api.getUser(id);
    return Success(user);
  } catch (e) {
    return Failure('Failed to fetch user', e);
  }
}

// Pattern matching
void handleResult(Result<User> result) {
  switch (result) {
    case Success(:var value):
      showUser(value);
    case Failure(:var message):
      showError(message);
  }
}
```

**State management:**
```dart
sealed class AuthState {}

class Initial extends AuthState {}

class Loading extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthState {
  final String? message;
  Unauthenticated([this.message]);
}

// In BLoC/Provider
Widget build(BuildContext context) {
  return switch (state) {
    Initial() || Loading() => CircularProgressIndicator(),
    Authenticated(:var user) => HomePage(user: user),
    Unauthenticated(:var message) => LoginPage(error: message),
  };
}
```

---

## Class Modifiers

Dart 3.0 introduced new class modifiers for API control.

### abstract

Cannot be instantiated directly:
```dart
abstract class Shape {
  double get area;
}

// Can be extended
class Circle extends Shape {
  final double radius;
  Circle(this.radius);
  @override
  double get area => 3.14159 * radius * radius;
}
```

### base

Must be extended, not implemented. Subclasses must also be base, final, or sealed:
```dart
base class Animal {
  void breathe() => print('Breathing...');
}

// Good - extends
base class Dog extends Animal {
  void bark() => print('Woof!');
}

// Error - cannot implement
class Cat implements Animal {}  // ❌
```

### interface

Can only be implemented, not extended:
```dart
interface class Repository {
  Future<User?> findById(String id);
  Future<void> save(User user);
}

// Good - implements
class SqlRepository implements Repository {
  @override
  Future<User?> findById(String id) => ...;
  @override
  Future<void> save(User user) => ...;
}

// Error - cannot extend
class SqlRepository extends Repository {}  // ❌
```

### final

Cannot be extended or implemented outside its library:
```dart
final class ImmutablePoint {
  final int x, y;
  const ImmutablePoint(this.x, this.y);
}

// In same library: OK
class Origin extends ImmutablePoint {
  Origin() : super(0, 0);
}

// In different library: Error
class MyPoint extends ImmutablePoint {}  // ❌
class MyPoint implements ImmutablePoint {}  // ❌
```

### sealed

Abstract + final. Subtypes must be in same library:
```dart
sealed class Event {}

class ClickEvent extends Event {
  final int x, y;
  ClickEvent(this.x, this.y);
}

class KeyEvent extends Event {
  final String key;
  KeyEvent(this.key);
}
```

### mixin

Can be mixed in but not extended:
```dart
mixin Logging {
  void log(String message) => print('[LOG] $message');
}

class Service with Logging {
  void process() {
    log('Processing...');
  }
}
```

### Combining Modifiers

```dart
// Abstract interface - can only be implemented
abstract interface class Serializable {
  Map<String, dynamic> toJson();
}

// Abstract base - must be extended, can have implementation
abstract base class Entity {
  final String id;
  Entity(this.id);
}

// Base mixin - can be mixed in, but subtypes must be base/final/sealed
base mixin Disposable {
  bool _disposed = false;
  void dispose() => _disposed = true;
}
```

---

## Dot Shorthands (Dart 3.10+)

When the type is inferrable from context, use `.` instead of the full type name.

### Enum Shorthands

```dart
enum Status { pending, approved, rejected }

// When type is known from context
Status status = .pending;  // Same as Status.pending

// In parameters
void setStatus(Status s) {}
setStatus(.approved);

// In switch
String label = switch (status) {
  .pending => 'Waiting',
  .approved => 'Done',
  .rejected => 'Failed',
};
```

### Static Member Shorthands

```dart
class Color {
  static const red = Color._(255, 0, 0);
  static const green = Color._(0, 255, 0);
  static const blue = Color._(0, 0, 255);

  final int r, g, b;
  const Color._(this.r, this.g, this.b);
}

// Usage
Color primary = .red;  // Same as Color.red
```

### Flutter Examples

```dart
Container(
  alignment: .center,  // Alignment.center
  padding: .all(8),    // EdgeInsets.all(8)
  child: Text(
    'Hello',
    style: .headlineMedium,  // Theme.of(context).textTheme.headlineMedium
  ),
);

// In animations
AnimatedContainer(
  curve: .easeInOut,  // Curves.easeInOut
  duration: .milliseconds(300),  // Duration(milliseconds: 300)
);
```

### Limitations

Dot shorthands only work when:
1. The expected type is known at compile time
2. The member exists as a static/const member on that type
3. The context provides unambiguous type information

```dart
// Works - type known from declaration
Status s = .pending;

// Works - type known from parameter
void handle(Status s) {}
handle(.approved);

// Doesn't work - type not inferrable
var s = .pending;  // ❌ What type is .pending?
```
