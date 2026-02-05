# Patrol API Reference

Comprehensive reference for Patrol testing framework API.

## PatrolIntegrationTester ($)

The main testing interface, commonly aliased as `$`.

### Widget Pump Methods

```dart
// Pump widget and wait for all animations/frames to settle
await $.pumpWidgetAndSettle(widget);

// Pump widget without waiting
await $.pumpWidget(widget);

// Pump and settle after interactions
await $.pumpAndSettle();

// Pump with duration
await $.pump(Duration(seconds: 1));
```

### Custom Finders

Patrol's custom finder system is concise and powerful:

```dart
// Find by text
$(text: 'Login')
$('Login')  // Shorthand

// Find by type
$(FloatingActionButton)
$(TextField)

// Find by ValueKey
$(#loginButton)  // Key('loginButton')
$(#emailField)

// Find by regex pattern
$(RegExp(r'Hello.*'))

// Find with index (when multiple matches)
$('Item').at(0)  // First match
$('Item').at(1)  // Second match

// Find descendants
$(Scaffold).$(AppBar).$(Text)
```

### Widget Interactions

```dart
// Tap on widget
await $(#submitButton).tap();

// Enter text
await $(#emailInput).enterText('user@example.com');

// Scroll to make widget visible
await $(#targetWidget).scrollTo.visible();

// Long press
await $(#item).longPress();

// Drag
await $(#slider).drag(Offset(100, 0));

// Wait for widget to appear
await $(#loadingIndicator).waitUntilVisible();
await $(#errorMessage).waitUntilExists();
```

### Assertions

```dart
// Check if widget exists
expect($('Login'), findsOneWidget);
expect($('Error'), findsNothing);
expect($('Item'), findsNWidgets(3));

// Check text content
expect($(#resultText).text, 'Success');
expect($(#counterText).text, equals('5'));

// Check widget properties
expect($(#submitButton).enabled, true);
expect($(#checkbox).visible, true);
```

## Native Automation

### Common Native Actions

```dart
// Device buttons
await $.native.pressHome();          // Go to home screen
await $.native.pressBack();          // Press back button
await $.native.pressRecentApps();    // Open recent apps
await $.native.pressDoubleRecentApps(); // Switch between two recent apps

// Notifications
await $.native.openNotifications();  // Open notification drawer
await $.native.closeNotifications(); // Close notification drawer
await $.native.closeHeadsUpNotification(); // Dismiss heads-up notification

// Interact with notification
await $.native.tap(Selector(text: 'Notification Title'));
await $.native.tapOnNotificationByIndex(0);
await $.native.tapOnNotificationBySelector(
  Selector(textStartsWith: 'New Message')
);

// Quick settings (Android)
await $.native.openQuickSettings();
await $.native.closeQuickSettings();
```

### Permissions

```dart
// Location permissions
await $.native.selectFineLocation();
await $.native.selectCoarseLocation();
await $.native.grantPermissionWhenInUse();
await $.native.grantPermissionOnlyThisTime();
await $.native.denyPermission();

// Other permissions (Android)
await $.native.selectExactAlarm();
```

### Device Settings

```dart
// Network
await $.native.enableWifi();
await $.native.disableWifi();
await $.native.enableCellular();
await $.native.disableCellular();
await $.native.enableBluetooth();
await $.native.disableBluetooth();
await $.native.enableAirplaneMode();
await $.native.disableAirplaneMode();

// Display
await $.native.enableDarkMode();
await $.native.disableDarkMode();

// Location
await $.native.enableLocation();
await $.native.disableLocation();
```

### App Management

```dart
// Open app
await $.native.openApp();

// Open URL
await $.native.openUrl('https://example.com');

// Get native UI hierarchy (debugging)
await $.native.getNativeViews();
```

### Native Selectors

Find and interact with native UI elements:

```dart
// By text
Selector(text: 'OK')
Selector(textStartsWith: 'Hello')
Selector(textContains: 'world')
Selector(textMatches: RegExp(r'Hello.*'))

// By resource ID (Android)
Selector(resourceId: 'com.example.app:id/button')

// By class name
Selector(className: 'android.widget.Button')

// By package (Android)
Selector(pkg: 'com.example.app')

// By instance (when multiple matches)
Selector(text: 'OK', instance: 0)

// Combined selectors
Selector(
  text: 'Submit',
  className: 'android.widget.Button',
  enabled: true
)
```

### Native Interactions

```dart
// Tap native element
await $.native.tap(Selector(text: 'Allow'));

// Enter text into native input
await $.native.enterTextByIndex('password123', index: 0);
await $.native.enterTextBySelector(
  'user@example.com',
  selector: Selector(resourceId: 'email_field')
);

// Handle native dialogs
await $.native.tap(Selector(text: 'OK'));
await $.native.tap(Selector(text: 'Cancel'));
await $.native.tap(Selector(text: 'Allow'));
await $.native.tap(Selector(text: 'Don\'t Allow'));
```

## Platform-Specific Features

### Android-Specific

```dart
// Interact with Android system UI
await $.native.openQuickSettings();

// Handle Android permissions
await $.native.selectExactAlarm();

// Android back button
await $.native.pressBack();
```

### iOS-Specific

```dart
// iOS permissions have slightly different flow
await $.native.grantPermissionWhenInUse();  // "Allow While Using App"
await $.native.grantPermissionOnlyThisTime(); // "Allow Once"
await $.native.denyPermission();  // "Don't Allow"
```

## Configuration

### Test Configuration

```dart
patrolTest(
  'test name',
  nativeAutomatorConfig: NativeAutomatorConfig(
    // Package name for Android
    packageName: 'com.example.app',
    // Bundle ID for iOS
    bundleId: 'com.example.app',
  ),
  // Custom timeout
  timeout: Timeout(Duration(minutes: 5)),
  // Skip test
  skip: false,
  ($) async {
    // Test code
  },
);
```

### Test Groups

```dart
void main() {
  group('Login tests', () {
    setUp(() async {
      // Setup before each test
    });

    tearDown(() async {
      // Cleanup after each test
    });

    patrolTest('successful login', ($) async {
      // Test code
    });

    patrolTest('failed login', ($) async {
      // Test code
    });
  });
}
```

## Common Patterns

### Wait for Conditions

```dart
// Wait for widget to appear
await $.waitUntilVisible(Text('Loading complete'));

// Wait for widget to disappear
await $.waitUntilGone(CircularProgressIndicator);

// Custom wait condition
await Future.delayed(Duration(seconds: 2));
await $.pumpAndSettle();
```

### Handle Loading States

```dart
// Wait for loading to complete
await $.pumpWidgetAndSettle(MyApp());
await $.waitUntilGone($(#loadingIndicator));
expect($(#content), findsOneWidget);
```

### Multi-Step Flows

```dart
// Login flow
await $(#emailField).enterText('user@example.com');
await $(#passwordField).enterText('password123');
await $(#loginButton).tap();

// Handle permission dialog
await $.native.grantPermissionWhenInUse();

// Verify success
expect($(#welcomeMessage), findsOneWidget);
```

### Testing Forms

```dart
// Fill form
await $(#nameField).enterText('John Doe');
await $(#emailField).enterText('john@example.com');
await $(#phoneField).enterText('1234567890');

// Select dropdown
await $(#countryDropdown).tap();
await $('United States').tap();

// Check checkbox
await $(#agreeCheckbox).tap();

// Submit
await $(#submitButton).tap();

// Verify
expect($(#successMessage), findsOneWidget);
```

## Debugging

### Print Native Views

```dart
// Get current native UI hierarchy
final views = await $.native.getNativeViews();
print(views);
```

### Add Delays for Visual Debugging

```dart
// Add delay to see what's happening (remove in production)
await Future.delayed(Duration(seconds: 2));
```

### Take Screenshots

```dart
// Patrol automatically takes screenshots on failure
// You can also manually take them
await $.takeScreenshot('login-screen');
```

## Best Practices

1. **Use ValueKeys for reliable finders**
   ```dart
   // Good
   await $(#submitButton).tap();
   
   // Avoid (text can change with localization)
   await $('Submit').tap();
   ```

2. **Wait for animations**
   ```dart
   // Always use pumpAndSettle after interactions
   await $(#button).tap();
   await $.pumpAndSettle();
   ```

3. **Keep tests independent**
   ```dart
   // Each test should start from clean state
   patrolTest('test 1', ($) async {
     await $.pumpWidgetAndSettle(MyApp());
     // Test code
   });
   ```

4. **Test happy path in integration tests**
   ```dart
   // Integration tests should test main user flows
   // Save edge cases for unit tests
   ```

5. **Use descriptive test names**
   ```dart
   patrolTest(
     'user can login with valid credentials and see home screen',
     ($) async {
       // Test code
     },
   );
   ```

## Additional Resources

- Official Patrol Documentation: https://patrol.leancode.co/documentation
- Patrol GitHub: https://github.com/leancodepl/patrol
- Patrol API Reference: https://pub.dev/documentation/patrol/latest/