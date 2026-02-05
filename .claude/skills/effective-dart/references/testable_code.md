# Testable Dart Code Reference

This reference covers patterns for writing testable Dart code.

## Dependency Injection

### Constructor Injection

**Inject dependencies through constructors:**
```dart
// Good - dependencies injected
class UserService {
  final UserRepository _repository;
  final Logger _logger;

  UserService({
    required UserRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  Future<User?> findUser(String id) async {
    _logger.log('Finding user: $id');
    return _repository.findById(id);
  }
}

// Test
void main() {
  test('findUser logs and delegates to repository', () async {
    final mockRepo = MockUserRepository();
    final mockLogger = MockLogger();
    final service = UserService(
      repository: mockRepo,
      logger: mockLogger,
    );

    when(() => mockRepo.findById('123')).thenAnswer((_) async => testUser);

    await service.findUser('123');

    verify(() => mockLogger.log('Finding user: 123')).called(1);
    verify(() => mockRepo.findById('123')).called(1);
  });
}
```

### Factory Pattern for Complex Dependencies

```dart
// Module that creates properly wired dependencies
class AuthModule {
  final AuthDataSource _dataSource;

  AuthModule({required AuthDataSource dataSource})
      : _dataSource = dataSource;

  AuthRepository createRepository() {
    return AuthRepositoryImpl(dataSource: _dataSource);
  }

  LoginUseCase createLoginUseCase() {
    return LoginUseCase(repository: createRepository());
  }

  AuthBloc createAuthBloc() {
    return AuthBloc(loginUseCase: createLoginUseCase());
  }
}

// Production
final authModule = AuthModule(
  dataSource: ApiAuthDataSource(client: httpClient),
);

// Test
final authModule = AuthModule(
  dataSource: MockAuthDataSource(),
);
```

### Avoid Service Locators in Business Logic

```dart
// Bad - hidden dependency
class UserService {
  Future<User?> findUser(String id) async {
    final repo = GetIt.instance<UserRepository>();  // Hidden!
    return repo.findById(id);
  }
}

// Good - explicit dependency
class UserService {
  final UserRepository _repository;

  UserService({required UserRepository repository})
      : _repository = repository;

  Future<User?> findUser(String id) async {
    return _repository.findById(id);
  }
}
```

---

## Abstraction Patterns

### Repository Pattern

**Abstract data access behind interfaces:**
```dart
// Interface
abstract class UserRepository {
  Future<User?> findById(String id);
  Future<List<User>> findAll();
  Future<void> save(User user);
  Future<void> delete(String id);
}

// Production implementation
class ApiUserRepository implements UserRepository {
  final HttpClient _client;

  ApiUserRepository({required HttpClient client}) : _client = client;

  @override
  Future<User?> findById(String id) async {
    final response = await _client.get('/users/$id');
    if (response.statusCode == 404) return null;
    return User.fromJson(response.body);
  }

  // ... other methods
}

// Test implementation
class FakeUserRepository implements UserRepository {
  final Map<String, User> _users = {};

  @override
  Future<User?> findById(String id) async => _users[id];

  @override
  Future<void> save(User user) async => _users[user.id] = user;

  // ... other methods
}
```

### Service Abstraction

**Abstract external services:**
```dart
// Interface
abstract class EmailService {
  Future<void> send({
    required String to,
    required String subject,
    required String body,
  });
}

// Production
class SmtpEmailService implements EmailService {
  @override
  Future<void> send({
    required String to,
    required String subject,
    required String body,
  }) async {
    // Real SMTP implementation
  }
}

// Test
class FakeEmailService implements EmailService {
  final List<({String to, String subject, String body})> sentEmails = [];

  @override
  Future<void> send({
    required String to,
    required String subject,
    required String body,
  }) async {
    sentEmails.add((to: to, subject: subject, body: body));
  }
}
```

### Time Abstraction

**Abstract time for deterministic tests:**
```dart
// Interface
abstract class Clock {
  DateTime now();
}

// Production
class SystemClock implements Clock {
  @override
  DateTime now() => DateTime.now();
}

// Test
class FakeClock implements Clock {
  DateTime _now;

  FakeClock(this._now);

  @override
  DateTime now() => _now;

  void advance(Duration duration) {
    _now = _now.add(duration);
  }
}

// Usage
class TokenService {
  final Clock _clock;

  TokenService({required Clock clock}) : _clock = clock;

  bool isExpired(Token token) {
    return _clock.now().isAfter(token.expiresAt);
  }
}

// Test
void main() {
  test('isExpired returns true for past expiration', () {
    final clock = FakeClock(DateTime(2024, 1, 1, 12, 0));
    final service = TokenService(clock: clock);
    final token = Token(expiresAt: DateTime(2024, 1, 1, 11, 0));

    expect(service.isExpired(token), isTrue);
  });
}
```

---

## Pure Functions

### Prefer Pure Functions

**Functions without side effects are easy to test:**
```dart
// Good - pure function
int calculateTotal(List<Item> items, double taxRate) {
  final subtotal = items.fold(0.0, (sum, item) => sum + item.price);
  return (subtotal * (1 + taxRate)).round();
}

// Test
void main() {
  test('calculateTotal includes tax', () {
    final items = [Item(price: 100), Item(price: 50)];
    expect(calculateTotal(items, 0.1), equals(165));
  });
}
```

**Extract pure logic from impure operations:**
```dart
// Bad - mixed concerns
class OrderService {
  Future<void> processOrder(String orderId) async {
    final order = await _repository.findById(orderId);

    // Business logic mixed with I/O
    if (order.items.isEmpty) throw EmptyOrderException();
    final total = order.items.fold(0, (sum, i) => sum + i.price);
    if (total > order.customer.creditLimit) throw CreditLimitException();

    await _repository.save(order.copyWith(status: OrderStatus.processed));
  }
}

// Good - separated concerns
class OrderService {
  Future<void> processOrder(String orderId) async {
    final order = await _repository.findById(orderId);

    // Pure validation
    validateOrder(order);

    await _repository.save(order.copyWith(status: OrderStatus.processed));
  }
}

// Pure function - easy to test
void validateOrder(Order order) {
  if (order.items.isEmpty) throw EmptyOrderException();
  final total = order.items.fold(0, (sum, i) => sum + i.price);
  if (total > order.customer.creditLimit) throw CreditLimitException();
}

// Test
void main() {
  test('validateOrder throws for empty order', () {
    final order = Order(items: [], customer: testCustomer);
    expect(() => validateOrder(order), throwsA(isA<EmptyOrderException>()));
  });
}
```

---

## Mocking Patterns

### Using Mocktail

```dart
import 'package:mocktail/mocktail.dart';

// Create mock
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockRepository;
  late UserService service;

  setUp(() {
    mockRepository = MockUserRepository();
    service = UserService(repository: mockRepository);
  });

  test('findUser returns user from repository', () async {
    // Arrange
    final expectedUser = User(id: '123', name: 'Alice');
    when(() => mockRepository.findById('123'))
        .thenAnswer((_) async => expectedUser);

    // Act
    final result = await service.findUser('123');

    // Assert
    expect(result, equals(expectedUser));
    verify(() => mockRepository.findById('123')).called(1);
  });

  test('findUser returns null when not found', () async {
    when(() => mockRepository.findById(any()))
        .thenAnswer((_) async => null);

    final result = await service.findUser('unknown');

    expect(result, isNull);
  });
}
```

### Fakes vs Mocks

**Use fakes for complex behavior:**
```dart
// Fake - maintains state
class FakeUserRepository implements UserRepository {
  final Map<String, User> _users = {};
  int saveCallCount = 0;

  @override
  Future<User?> findById(String id) async => _users[id];

  @override
  Future<void> save(User user) async {
    _users[user.id] = user;
    saveCallCount++;
  }

  void addUser(User user) => _users[user.id] = user;
}

// Test with fake
void main() {
  test('registration creates user', () async {
    final fakeRepo = FakeUserRepository();
    final service = RegistrationService(repository: fakeRepo);

    await service.register(name: 'Alice', email: 'alice@test.com');

    final user = await fakeRepo.findById('alice@test.com');
    expect(user?.name, equals('Alice'));
    expect(fakeRepo.saveCallCount, equals(1));
  });
}
```

**Use mocks for verification:**
```dart
// Mock - verifies interactions
void main() {
  test('registration sends welcome email', () async {
    final mockEmail = MockEmailService();
    final service = RegistrationService(emailService: mockEmail);

    when(() => mockEmail.send(
      to: any(named: 'to'),
      subject: any(named: 'subject'),
      body: any(named: 'body'),
    )).thenAnswer((_) async {});

    await service.register(name: 'Alice', email: 'alice@test.com');

    verify(() => mockEmail.send(
      to: 'alice@test.com',
      subject: 'Welcome!',
      body: any(named: 'body'),
    )).called(1);
  });
}
```

---

## BLoC Testing

### Using bloc_test

```dart
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('AuthBloc', () {
    late MockLoginUseCase mockLoginUseCase;

    setUp(() {
      mockLoginUseCase = MockLoginUseCase();
    });

    blocTest<AuthBloc, AuthState>(
      'emits [loading, authenticated] when login succeeds',
      build: () {
        when(() => mockLoginUseCase.execute(any(), any()))
            .thenAnswer((_) async => testUser);
        return AuthBloc(loginUseCase: mockLoginUseCase);
      },
      act: (bloc) => bloc.add(LoginRequested('test@test.com', 'password')),
      expect: () => [
        AuthLoading(),
        Authenticated(testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [loading, error] when login fails',
      build: () {
        when(() => mockLoginUseCase.execute(any(), any()))
            .thenThrow(AuthException('Invalid credentials'));
        return AuthBloc(loginUseCase: mockLoginUseCase);
      },
      act: (bloc) => bloc.add(LoginRequested('test@test.com', 'wrong')),
      expect: () => [
        AuthLoading(),
        AuthError('Invalid credentials'),
      ],
    );
  });
}
```

### Testing State Changes

```dart
blocTest<CounterBloc, int>(
  'increments state by 1',
  build: () => CounterBloc(),
  act: (bloc) => bloc.add(Increment()),
  expect: () => [1],
);

blocTest<CounterBloc, int>(
  'decrements state by 1',
  build: () => CounterBloc(),
  seed: () => 10,  // Start with initial state
  act: (bloc) => bloc.add(Decrement()),
  expect: () => [9],
);

blocTest<CounterBloc, int>(
  'handles multiple events',
  build: () => CounterBloc(),
  act: (bloc) {
    bloc.add(Increment());
    bloc.add(Increment());
    bloc.add(Decrement());
  },
  expect: () => [1, 2, 1],
);
```

---

## Widget Testing

### Testing with Dependencies

```dart
void main() {
  testWidgets('LoginPage shows error on invalid credentials', (tester) async {
    final mockAuthBloc = MockAuthBloc();

    // Set up bloc states
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    whenListen(
      mockAuthBloc,
      Stream.fromIterable([
        AuthLoading(),
        AuthError('Invalid credentials'),
      ]),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: LoginPage(),
        ),
      ),
    );

    // Trigger login
    await tester.enterText(find.byKey(Key('emailField')), 'test@test.com');
    await tester.enterText(find.byKey(Key('passwordField')), 'wrong');
    await tester.tap(find.byKey(Key('loginButton')));

    // Wait for state changes
    await tester.pump();

    // Verify error shown
    expect(find.text('Invalid credentials'), findsOneWidget);
  });
}
```

### Widget Test Helpers

```dart
extension WidgetTesterExtensions on WidgetTester {
  Future<void> pumpApp(Widget widget) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(body: widget),
      ),
    );
  }

  Future<void> pumpAppWithBloc<B extends Bloc<dynamic, dynamic>>(
    Widget widget,
    B bloc,
  ) async {
    await pumpWidget(
      MaterialApp(
        home: BlocProvider<B>.value(
          value: bloc,
          child: Scaffold(body: widget),
        ),
      ),
    );
  }
}

// Usage
void main() {
  testWidgets('Counter displays value', (tester) async {
    await tester.pumpApp(Counter(value: 42));
    expect(find.text('42'), findsOneWidget);
  });
}
```

---

## Test Organization

### Arrange-Act-Assert

```dart
void main() {
  test('calculateDiscount applies percentage correctly', () {
    // Arrange
    final calculator = DiscountCalculator();
    const price = 100.0;
    const discountPercent = 20;

    // Act
    final result = calculator.apply(price, discountPercent);

    // Assert
    expect(result, equals(80.0));
  });
}
```

### Group Related Tests

```dart
void main() {
  group('UserRepository', () {
    group('findById', () {
      test('returns user when exists', () async { ... });
      test('returns null when not found', () async { ... });
      test('throws on network error', () async { ... });
    });

    group('save', () {
      test('creates new user', () async { ... });
      test('updates existing user', () async { ... });
      test('throws on validation error', () async { ... });
    });
  });
}
```

### setUp and tearDown

```dart
void main() {
  late UserService service;
  late MockUserRepository mockRepo;

  setUp(() {
    mockRepo = MockUserRepository();
    service = UserService(repository: mockRepo);
  });

  tearDown(() {
    // Clean up if needed
  });

  setUpAll(() {
    // Run once before all tests
    registerFallbackValue(User(id: '', name: ''));
  });

  tearDownAll(() {
    // Run once after all tests
  });

  test('...', () { ... });
}
```

---

## Test Data

### Test Fixtures

```dart
// test/fixtures/users.dart
class UserFixtures {
  static const validUser = User(
    id: 'user-123',
    name: 'Test User',
    email: 'test@example.com',
  );

  static const adminUser = User(
    id: 'admin-456',
    name: 'Admin User',
    email: 'admin@example.com',
    isAdmin: true,
  );

  static User withName(String name) => validUser.copyWith(name: name);
  static User withEmail(String email) => validUser.copyWith(email: email);
}

// Usage
void main() {
  test('displays user name', () {
    final user = UserFixtures.withName('Alice');
    expect(formatUser(user), contains('Alice'));
  });
}
```

### Builder Pattern for Test Data

```dart
class UserBuilder {
  String _id = 'default-id';
  String _name = 'Default Name';
  String _email = 'default@test.com';
  bool _isAdmin = false;

  UserBuilder withId(String id) {
    _id = id;
    return this;
  }

  UserBuilder withName(String name) {
    _name = name;
    return this;
  }

  UserBuilder withEmail(String email) {
    _email = email;
    return this;
  }

  UserBuilder asAdmin() {
    _isAdmin = true;
    return this;
  }

  User build() => User(
    id: _id,
    name: _name,
    email: _email,
    isAdmin: _isAdmin,
  );
}

// Usage
void main() {
  test('admin users can delete', () {
    final admin = UserBuilder().asAdmin().withName('Admin').build();
    expect(canDelete(admin), isTrue);
  });
}
```
