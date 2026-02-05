# Dart Style Guide Reference

This reference provides detailed style guidelines for Dart code.

## Naming Conventions

### Identifiers

**UpperCamelCase** (PascalCase):
- Classes: `HttpRequest`, `UserRepository`
- Enums: `Status`, `ConnectionState`
- Typedefs: `Predicate`, `JsonDecoder`
- Type parameters: `T`, `E`, `K`, `V`, `R`
- Extensions: `StringExtensions`, `ListUtils`
- Mixins: `ChangeNotifier`, `Comparable`

**lowerCamelCase**:
- Variables: `itemCount`, `currentUser`
- Parameters: `userId`, `isEnabled`
- Functions: `calculateTotal`, `fetchUser`
- Methods: `getName`, `setPassword`
- Named constants: `maxRetries`, `defaultTimeout`
- Enum values: `Status.pending`, `Color.darkBlue`

**lowercase_with_underscores**:
- Libraries: `library my_library;`
- Packages: `package:my_package`
- Directories: `src/`, `my_feature/`
- Files: `http_client.dart`, `user_repository.dart`

### Naming Best Practices

**Be descriptive but concise:**
```dart
// Good
int itemCount;
String userName;
bool isVisible;

// Too short
int n;
String s;
bool b;

// Too verbose
int numberOfItemsInTheShoppingCart;
String theUserNameOfTheCurrentLoggedInUser;
```

**Use standard prefixes for booleans:**
```dart
// Good
bool isEnabled;
bool hasPermission;
bool canDelete;
bool shouldRefresh;
bool wasSuccessful;

// Bad
bool enabled;     // Sounds like an action
bool permission;  // Not clearly boolean
bool delete;      // Sounds like a verb
```

**Private members start with underscore:**
```dart
class User {
  final String _id;        // Private field
  String? _cachedName;     // Private nullable field

  void _validate() {}      // Private method
  int get _internalId => 0;  // Private getter
}
```

**Avoid Hungarian notation:**
```dart
// Bad
String strName;
int intCount;
List<String> lstItems;
bool bIsValid;

// Good
String name;
int count;
List<String> items;
bool isValid;
```

**Use consistent terminology:**
```dart
// Good - pick one and stick with it
pageCount, elementCount, itemCount

// Bad - mixing different conventions
pageCount, numElements, nItems
```

### Method Naming

**Actions (side effects) use verbs:**
```dart
void save();
void delete();
void fetchData();
void updateUser();
void sendEmail();
void processPayment();
```

**Computations (no side effects) use nouns:**
```dart
int get length;
String get formattedDate;
double calculateTotal();
User buildUser();
List<Item> filteredItems();
```

**Conversion methods:**
```dart
// to___ - returns a new object
List<E> toList();
Map<K, V> toMap();
String toString();
DateTime toUtc();
User toUser();

// as___ - returns a view/cast of same data
List<R> cast<R>();
Map<K, V> asMap();
Stream<T> asStream();
```

**Query methods:**
```dart
// Use verbs for queries
bool contains(T element);
bool startsWith(String prefix);
bool hasChild(String name);

// Or use is/has/can for getters
bool get isEmpty;
bool get hasChildren;
bool get canPop;
```

### Class Naming

**Suffixes for common patterns:**
```dart
// Repositories
class UserRepository {}
class ProductRepository {}

// Services
class AuthService {}
class NotificationService {}

// Controllers/BLoCs
class LoginController {}
class CartBloc {}

// Widgets
class UserCard {}
class PriceLabel {}

// Exceptions
class NetworkException {}
class ValidationException {}

// Interfaces (no prefix!)
abstract class Serializable {}  // Not: ISerializable
abstract class Disposable {}    // Not: IDisposable
```

---

## Import Organization

### Order of Imports

Imports should be organized in the following order:

1. `dart:` imports
2. `package:` imports
3. Relative imports

```dart
// 1. Dart SDK imports
import 'dart:async';
import 'dart:convert';
import 'dart:io';

// 2. Package imports (sorted alphabetically)
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 3. Relative imports
import '../models/user.dart';
import '../utils/validators.dart';
import 'widgets/header.dart';
```

### Import Conventions

**Alphabetize within sections:**
```dart
// Good
import 'dart:async';
import 'dart:convert';
import 'dart:io';

// Bad
import 'dart:io';
import 'dart:async';
import 'dart:convert';
```

**Use relative imports within your package:**
```dart
// In lib/src/features/auth/login_page.dart

// Good (relative)
import '../models/user.dart';
import '../../core/utils.dart';

// Avoid (package import for own package)
import 'package:my_app/src/models/user.dart';
```

**Use named prefixes to avoid conflicts:**
```dart
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import '../models/path.dart' as model;

final random = math.Random();
final response = await http.get(uri);
final path = model.Path('/home');
```

**Show/hide for specific exports:**
```dart
// Only import specific items
import 'package:flutter/material.dart' show Widget, BuildContext;

// Import everything except specific items
import 'dart:io' hide File;
```

**Avoid overly long show lists:**
```dart
// Bad - too many items
import 'package:flutter/material.dart'
    show Widget, BuildContext, State, StatefulWidget, ...20 more;

// Good - just import the whole library
import 'package:flutter/material.dart';
```

---

## Formatting

### Use `dart format`

Never manually format Dart code. Always use `dart format`:

```bash
# Format a file
dart format lib/main.dart

# Format entire project
dart format .

# Check formatting without changing files
dart format --output=none --set-exit-if-changed .
```

### Line Length

The default line length is 80 characters. This can be configured but stick with the default for consistency.

### Curly Braces

**Always use curly braces for control flow:**
```dart
// Good
if (isValid) {
  process();
}

for (final item in items) {
  process(item);
}

while (hasMore) {
  process();
}

// Bad
if (isValid) process();
for (final item in items) process(item);
while (hasMore) process();
```

**Exception: Single-line if for simple guards:**
```dart
// Acceptable for simple early returns
if (items.isEmpty) return;
if (user == null) throw ArgumentError.notNull('user');
```

### Expression Bodies

**Use `=>` for single expressions:**
```dart
// Good
String get fullName => '$firstName $lastName';
bool isValid(String s) => s.isNotEmpty && s.length < 100;
int add(int a, int b) => a + b;

// Bad (use block body for complex logic)
String get fullName => _firstName != null && _lastName != null
    ? '$_firstName $_lastName'
    : _firstName ?? _lastName ?? 'Unknown';
```

### Trailing Commas

**Use trailing commas for better formatting:**
```dart
// Good - trailing comma triggers multi-line formatting
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(8),
    color: Colors.blue,
    child: Text('Hello'),
  );
}

// Without trailing comma - stays on one line
var point = Point(x: 1, y: 2);
```

### Blank Lines

**One blank line between top-level declarations:**
```dart
import 'dart:async';

const maxRetries = 3;

class User {
  // ...
}

class Admin extends User {
  // ...
}
```

**No blank lines at start/end of blocks:**
```dart
// Good
class User {
  final String name;

  User(this.name);
}

// Bad
class User {

  final String name;

  User(this.name);

}
```

---

## String Conventions

### Quote Style

**Prefer single quotes:**
```dart
// Good
var message = 'Hello, World!';
var path = '/home/user';

// Bad
var message = "Hello, World!";
var path = "/home/user";
```

**Use double quotes when string contains single quotes:**
```dart
// Good
var message = "It's a beautiful day";

// Acceptable (escape)
var message = 'It\'s a beautiful day';
```

### String Interpolation

**Use interpolation instead of concatenation:**
```dart
// Good
var greeting = 'Hello, $name!';
var path = '${directory}/${filename}';

// Bad
var greeting = 'Hello, ' + name + '!';
var path = directory + '/' + filename;
```

**Omit braces for simple identifiers:**
```dart
// Good
'Hello, $name!';
'Item count: $count';

// Bad (unnecessary braces)
'Hello, ${name}!';
'Item count: ${count}';
```

**Use braces for expressions:**
```dart
// Good
'Total: ${items.length}';
'Name: ${user.firstName} ${user.lastName}';
'Result: ${a + b}';
```

### Multi-line Strings

**Use adjacent literals for readability:**
```dart
// Good
var message = 'This is a very long message that '
    'spans multiple lines in the source code '
    'but renders as a single line.';

// Also good (with newlines)
var message = '''
This message contains
actual line breaks
in the output.
''';
```

---

## Comment Conventions

### Types of Comments

**Single-line comments for implementation:**
```dart
// Calculate the total including tax.
var total = subtotal * (1 + taxRate);
```

**Doc comments for public APIs:**
```dart
/// Returns the user with the given [id].
///
/// Returns `null` if no user exists.
User? getUser(String id);
```

**TODO comments for future work:**
```dart
// TODO(username): Implement caching.
// TODO: Add error handling.
```

### What to Comment

**DO comment non-obvious code:**
```dart
// Binary search requires a sorted list.
final index = _binarySearch(sortedList, target);

// Offset by 1 because API uses 1-based indexing.
final page = index + 1;
```

**DON'T comment obvious code:**
```dart
// Bad - obvious from the code
// Loop through all users
for (final user in users) {
  // Print the user's name
  print(user.name);
}

// Good - let code speak for itself
for (final user in users) {
  print(user.name);
}
```

### Doc Comment Structure

```dart
/// A brief one-line description.
///
/// A longer description that provides more detail.
/// Can span multiple paragraphs.
///
/// Use [brackets] to reference other elements:
/// - [User] - reference to a class
/// - [User.name] - reference to a member
/// - [fetchUser] - reference to a function
///
/// Example:
/// ```dart
/// final user = getUser('123');
/// print(user?.name);
/// ```
///
/// See also:
/// - [createUser] for creating users
/// - [deleteUser] for removing users
User? getUser(String id);
```
