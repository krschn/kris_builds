# Dart Performance Patterns Reference

This reference covers performance optimization patterns for Dart applications.

## Isolates for CPU-Intensive Work

### When to Use Isolates

Use isolates when:
- Parsing large JSON/XML files
- Image processing
- Cryptographic operations
- Complex calculations
- Data compression/decompression
- Any operation taking > 16ms (to maintain 60fps)

### Basic Isolate Usage

**Use `Isolate.run` for simple operations (Dart 2.19+):**
```dart
// Simple, one-shot computation
Future<List<User>> parseUsers(String jsonData) async {
  return await Isolate.run(() {
    final list = jsonDecode(jsonData) as List;
    return list.map((e) => User.fromJson(e)).toList();
  });
}
```

**Use `compute` in Flutter:**
```dart
// Flutter's compute helper
Future<List<User>> parseUsers(String jsonData) async {
  return await compute(_parseUsersSync, jsonData);
}

// Top-level or static function (required)
List<User> _parseUsersSync(String jsonData) {
  final list = jsonDecode(jsonData) as List;
  return list.map((e) => User.fromJson(e)).toList();
}
```

### Long-Running Isolates

**Use SendPort/ReceivePort for bidirectional communication:**
```dart
class IsolateWorker {
  late final Isolate _isolate;
  late final SendPort _sendPort;
  final _receivePort = ReceivePort();

  Future<void> start() async {
    _isolate = await Isolate.spawn(
      _isolateEntry,
      _receivePort.sendPort,
    );
    _sendPort = await _receivePort.first as SendPort;
  }

  Future<R> compute<T, R>(T message) async {
    final responsePort = ReceivePort();
    _sendPort.send((message, responsePort.sendPort));
    return await responsePort.first as R;
  }

  void dispose() {
    _isolate.kill();
    _receivePort.close();
  }

  static void _isolateEntry(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      final (data, replyPort) = message as (dynamic, SendPort);
      final result = _processData(data);
      replyPort.send(result);
    });
  }

  static dynamic _processData(dynamic data) {
    // Heavy computation here
    return data;
  }
}
```

### Isolate Pool

**Reuse isolates for repeated operations:**
```dart
class IsolatePool {
  final int size;
  final List<IsolateWorker> _workers = [];
  int _nextWorker = 0;

  IsolatePool({this.size = 4});

  Future<void> initialize() async {
    for (var i = 0; i < size; i++) {
      final worker = IsolateWorker();
      await worker.start();
      _workers.add(worker);
    }
  }

  Future<R> compute<T, R>(T data) async {
    final worker = _workers[_nextWorker];
    _nextWorker = (_nextWorker + 1) % size;
    return await worker.compute<T, R>(data);
  }

  void dispose() {
    for (final worker in _workers) {
      worker.dispose();
    }
  }
}
```

---

## Const and Compile-Time Constants

### Const Constructors

**Use const for immutable objects:**
```dart
class Point {
  final int x;
  final int y;

  const Point(this.x, this.y);

  static const origin = Point(0, 0);
}

// All these refer to the same instance
const p1 = Point(0, 0);
const p2 = Point.origin;
const p3 = Point(0, 0);
print(identical(p1, p2));  // true
print(identical(p2, p3));  // true
```

**Benefits:**
- Single instance in memory
- No runtime allocation
- Computed at compile time
- Enables widget const optimization in Flutter

### Const Collections

```dart
// Compile-time constant lists
const colors = ['red', 'green', 'blue'];
const numbers = [1, 2, 3];

// Compile-time constant maps
const config = {
  'apiUrl': 'https://api.example.com',
  'timeout': 30,
};

// Const set
const validStatus = {200, 201, 204};
```

### Static Const Members

```dart
class ApiEndpoints {
  static const baseUrl = 'https://api.example.com';
  static const users = '$baseUrl/users';
  static const products = '$baseUrl/products';

  // Compile-time constant expressions
  static const timeout = Duration(seconds: 30);
}
```

---

## Collection Efficiency

### Avoid Unnecessary Iterations

**Chain operations efficiently:**
```dart
// Bad - creates intermediate lists
final result = items
    .where((i) => i.isActive)
    .toList()
    .map((i) => i.name)
    .toList()
    .where((n) => n.isNotEmpty)
    .toList();

// Good - lazy evaluation
final result = items
    .where((i) => i.isActive)
    .map((i) => i.name)
    .where((n) => n.isNotEmpty)
    .toList();  // Single materialization at the end
```

**Use `firstWhere` instead of `where(...).first`:**
```dart
// Good - stops at first match
final admin = users.firstWhere((u) => u.isAdmin);

// Bad - evaluates all elements first
final admin = users.where((u) => u.isAdmin).first;
```

**Use `any` / `every` for existence checks:**
```dart
// Good - short-circuits
if (users.any((u) => u.isAdmin)) { ... }
if (users.every((u) => u.isActive)) { ... }

// Bad - evaluates all elements
if (users.where((u) => u.isAdmin).isNotEmpty) { ... }
```

### Pre-Size Collections

**Specify initial capacity when known:**
```dart
// Good - pre-sized
final List<int> numbers = List.filled(1000, 0);
final List<String> names = List.generate(users.length, (i) => users[i].name);

// Less efficient - grows dynamically
final numbers = <int>[];
for (var i = 0; i < 1000; i++) {
  numbers.add(i);
}
```

### Use Appropriate Collection Types

```dart
// Use Set for unique values and O(1) lookup
final uniqueIds = <String>{};
if (uniqueIds.contains(id)) { ... }  // O(1)

// Use Map for key-value lookup
final usersById = <String, User>{};
final user = usersById[id];  // O(1)

// Use List only when order matters and duplicates allowed
final history = <Event>[];
```

### Avoid Repeated Property Access

```dart
// Bad - repeated length access
for (var i = 0; i < list.length; i++) {
  // ...
}

// Good - cache length
final length = list.length;
for (var i = 0; i < length; i++) {
  // ...
}

// Best - use for-in when possible
for (final item in list) {
  // ...
}
```

---

## String Performance

### Use StringBuffer for Concatenation

```dart
// Bad - creates many intermediate strings
String buildCsv(List<List<String>> rows) {
  var result = '';
  for (final row in rows) {
    result += row.join(',') + '\n';
  }
  return result;
}

// Good - single allocation
String buildCsv(List<List<String>> rows) {
  final buffer = StringBuffer();
  for (final row in rows) {
    buffer.writeln(row.join(','));
  }
  return buffer.toString();
}
```

### Adjacent String Literals

```dart
// Good - compiled to single string
const message = 'This is a very long message '
    'that spans multiple lines '
    'in the source code.';

// Bad - runtime concatenation
const message = 'This is a very long message ' +
    'that spans multiple lines ' +
    'in the source code.';
```

### Interpolation vs Concatenation

```dart
// Good - interpolation is optimized
final greeting = 'Hello, $name!';

// Avoid - explicit concatenation
final greeting = 'Hello, ' + name + '!';
```

---

## Lazy Initialization

### Late Final for Expensive Computation

```dart
class ExpensiveService {
  // Only computed when first accessed
  late final Config config = _loadConfig();
  late final Database db = _connectDatabase();

  Config _loadConfig() {
    // Expensive operation
    return Config.fromFile('config.yaml');
  }

  Database _connectDatabase() {
    // Expensive operation
    return Database.connect(config.connectionString);
  }
}
```

### Lazy Getters

```dart
class User {
  final String firstName;
  final String lastName;

  User(this.firstName, this.lastName);

  // Computed once, cached
  late final String fullName = '$firstName $lastName';

  // Or compute every time if cheap
  String get initials => '${firstName[0]}${lastName[0]}';
}
```

### Null-Aware Assignment

```dart
class Cache {
  Map<String, dynamic>? _data;

  Map<String, dynamic> get data => _data ??= _loadData();

  Map<String, dynamic> _loadData() {
    // Expensive operation
    return {};
  }
}
```

---

## Memory Management

### Avoid Unnecessary Object Creation

```dart
// Bad - creates new DateTime each call
bool isExpired(DateTime created) {
  return DateTime.now().difference(created) > Duration(hours: 24);
}

// Good - reuse constant Duration
static const _expirationDuration = Duration(hours: 24);

bool isExpired(DateTime created) {
  return DateTime.now().difference(created) > _expirationDuration;
}
```

### Use Records for Lightweight Data

```dart
// Good - records are lightweight
(int, int) getMinMax(List<int> numbers) {
  return (numbers.reduce(min), numbers.reduce(max));
}

// Heavier - class allocation
class MinMax {
  final int min, max;
  MinMax(this.min, this.max);
}
```

### Clear References

```dart
class ImageCache {
  final Map<String, Image> _cache = {};

  void clear() {
    _cache.clear();  // Allow GC to collect images
  }

  void remove(String key) {
    _cache.remove(key);
  }
}
```

### Dispose Patterns

```dart
class ResourceHolder {
  StreamSubscription? _subscription;
  Timer? _timer;

  void start() {
    _subscription = stream.listen(_handleEvent);
    _timer = Timer.periodic(Duration(seconds: 1), _tick);
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _timer?.cancel();
    _timer = null;
  }
}
```

---

## Async Performance

### Avoid Unnecessary Async

```dart
// Bad - unnecessary async overhead
Future<int> getValue() async {
  return 42;
}

// Good - synchronous when possible
int getValue() {
  return 42;
}

// Good - return Future directly
Future<int> getCachedValue() {
  if (_cache != null) {
    return Future.value(_cache);
  }
  return _fetchValue();
}
```

### Parallel Operations

```dart
// Good - parallel execution
Future<void> loadData() async {
  final results = await Future.wait([
    fetchUsers(),
    fetchProducts(),
    fetchOrders(),
  ]);
  // All completed
}

// Bad - sequential when not needed
Future<void> loadData() async {
  await fetchUsers();
  await fetchProducts();
  await fetchOrders();
}
```

### Stream Efficiency

```dart
// Good - transform without buffering
Stream<String> processLines(Stream<String> input) {
  return input
      .where((line) => line.isNotEmpty)
      .map((line) => line.trim());
}

// Bad - collects all before processing
Future<List<String>> processLines(Stream<String> input) async {
  final lines = await input.toList();
  return lines
      .where((line) => line.isNotEmpty)
      .map((line) => line.trim())
      .toList();
}
```

### Cancel Long Operations

```dart
class DataLoader {
  CancelableOperation<List<Data>>? _currentOperation;

  Future<List<Data>> loadData() async {
    // Cancel previous operation
    _currentOperation?.cancel();

    _currentOperation = CancelableOperation.fromFuture(
      _fetchData(),
      onCancel: () => print('Cancelled'),
    );

    return _currentOperation!.value;
  }

  void dispose() {
    _currentOperation?.cancel();
  }
}
```

---

## Profiling Tips

### Use DevTools

```dart
// Add timeline events for profiling
import 'dart:developer';

Future<void> processData() async {
  Timeline.startSync('processData');
  try {
    // ... processing
  } finally {
    Timeline.finishSync();
  }
}
```

### Benchmark Code

```dart
void benchmark() {
  final stopwatch = Stopwatch()..start();

  // Code to measure
  for (var i = 0; i < 100000; i++) {
    expensiveOperation();
  }

  stopwatch.stop();
  print('Elapsed: ${stopwatch.elapsedMilliseconds}ms');
}
```

### Memory Profiling

```dart
// Track object allocations
import 'dart:developer';

void trackAllocation() {
  // Take heap snapshot in DevTools
  debugger();  // Pause for snapshot
}
```

---

## Common Performance Mistakes

### Don't Create Objects in Loops

```dart
// Bad
for (var item in items) {
  final formatter = DateFormat('yyyy-MM-dd');  // Created each iteration
  print(formatter.format(item.date));
}

// Good
final formatter = DateFormat('yyyy-MM-dd');
for (var item in items) {
  print(formatter.format(item.date));
}
```

### Don't Parse Repeatedly

```dart
// Bad
bool isValid(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}

// Good
final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

bool isValid(String email) {
  return _emailRegex.hasMatch(email);
}
```

### Don't Block the Event Loop

```dart
// Bad - blocks UI
void processAllData(List<Data> data) {
  for (var item in data) {
    heavyComputation(item);  // Blocks
  }
}

// Good - use isolate
Future<void> processAllData(List<Data> data) async {
  await Isolate.run(() {
    for (var item in data) {
      heavyComputation(item);
    }
  });
}

// Or break up work
Future<void> processAllData(List<Data> data) async {
  for (var item in data) {
    heavyComputation(item);
    await Future.delayed(Duration.zero);  // Yield to event loop
  }
}
```
