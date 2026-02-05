---
name: patrol
description: Patrol integration testing framework for Flutter with native automation. Use when creating Patrol tests, testing native features (permissions, notifications, device settings), writing e2e integration tests, or setting up Patrol in a project. Triggers include "patrol", "integration test", "native automation", "e2e test", "patrol develop", "permissions test", "notifications test".
---

# Patrol Integration Testing

Complete guide for using Patrol framework for end-to-end integration testing with native automation capabilities.

## Overview

Patrol is a powerful testing framework that extends Flutter's testing capabilities with native automation. It allows you to test native features like permissions, notifications, device settings, and system dialogs that are inaccessible to standard Flutter tests.

## Patrol Test Structure

### Basic Patrol Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'descriptive test name explaining what is being tested',
    ($) async {
      // Setup: Initialize app
      await $.pumpWidgetAndSettle(const MyApp());

      // Action: Perform user interactions
      await $(#widgetKey).tap();

      // Assert: Verify expected behavior
      expect($(#resultText).text, 'Expected Result');
    },
  );
}
```

## App Initialization Rules

Critical rules when initializing app in Patrol tests:

1. **DO NOT** call `WidgetsFlutterBinding.ensureInitialized()`
2. **DO NOT** use `runApp()` - Instead use `$.pumpWidget()` or `$.pumpWidgetAndSettle()`
3. **DO NOT** modify `FlutterError.onError` (breaks test error handling)

Extract common initialization logic into a helper function:

```dart
Future<void> initializeApp(PatrolIntegrationTester $) async {
  // Add necessary setup here
  await $.pumpWidgetAndSettle(const MyApp());
}
```

## Patrol Finders

Patrol's custom finder system is concise and powerful:

### Finding Widgets

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

## Running Patrol Tests

### Patrol Commands

**Run single test:**
```bash
patrol test -t patrol_test/feature_test.dart
```

**Run all tests:**
```bash
patrol test
```

**Hot restart during development:**
```bash
patrol develop -t patrol_test/feature_test.dart
# Press 'r' to restart test
```

**Run on specific device:**
```bash
patrol test -d <device-id>
```

**Run with flavor:**
```bash
patrol test --flavor development
```

**Check Patrol setup:**
```bash
patrol doctor
```

## Test Organization

### Directory Structure
```
patrol_test/           # Integration tests with Patrol
  auth/
    auth_login_test.dart
    auth_signup_test.dart
  home/
    home_navigation_test.dart
```

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

### Testing User Input
```dart
await $(#emailField).enterText('user@example.com');
await $(#passwordField).enterText('password123');
await $(#loginButton).tap();
expect($(#welcomeMessage).text, 'Welcome!');
```

### Testing Navigation
```dart
await $(#settingsButton).tap();
expect($('Settings'), findsOneWidget);
await $.native.pressBack();
expect($('Home'), findsOneWidget);
```

### Testing Permissions
```dart
await $(#locationButton).tap();
await $.native.grantPermissionWhenInUse();
expect($(#locationText), findsOneWidget);
```

### Testing Notifications
```dart
await $(#notifyButton).tap();
await $.native.openNotifications();
await $.native.tap(Selector(text: 'Test Notification'));
expect($(#notificationTapped).text, 'true');
```

### Handle Loading States
```dart
// Wait for loading to complete
await $.pumpWidgetAndSettle(MyApp());
await $.waitUntilGone($(#loadingIndicator));
expect($(#content), findsOneWidget);
```

## Best Practices

### Patrol Practices
- Use ValueKeys (#key) for finding widgets reliably
- Prefer `pumpWidgetAndSettle()` for initialization
- Add delays only for debugging/visibility, not production tests
- Test happy path in integration tests
- Test edge cases in unit tests
- Use native automation for platform-specific features

### Widget Keys
```dart
// Good - reliable finder
await $(#submitButton).tap();

// Avoid - text can change with localization
await $('Submit').tap();
```

### Wait for Animations
```dart
// Always use pumpAndSettle after interactions
await $(#button).tap();
await $.pumpAndSettle();
```

### Keep Tests Independent
```dart
// Each test should start from clean state
patrolTest('test 1', ($) async {
  await $.pumpWidgetAndSettle(MyApp());
  // Test code
});
```

## Troubleshooting

### Common Issues

**App Initialization Errors:**
- Don't call `WidgetsFlutterBinding.ensureInitialized()` in tests
- Use `$.pumpWidget()` instead of `runApp()`
- Don't modify `FlutterError.onError` in test initialization

**Finders Not Working:**
- Ensure widgets have ValueKeys
- Use `$.pumpAndSettle()` after interactions to wait for animations
- Check widget is actually in the widget tree

**Native Automation Failing:**
- Verify Patrol CLI is properly installed: `patrol doctor`
- Check native setup is complete for target platform
- Ensure app bundle ID and package name are correct in `pubspec.yaml`

**Tests Timing Out:**
- Increase timeout in `patrolTest` configuration
- Check for infinite animations or missing `pumpAndSettle()`
- Verify app is actually loading on device

### Debugging

```dart
// Get current native UI hierarchy
final views = await $.native.getNativeViews();
print(views);

// Add delay to see what's happening (remove in production)
await Future.delayed(Duration(seconds: 2));

// Take screenshot
await $.takeScreenshot('login-screen');
```

## Resources

### Bundled Resources

**references/patrol_api.md** - Comprehensive Patrol API reference with all methods and examples

**references/patrol_examples.md** - Complete integration test examples with native automation scenarios

**scripts/setup_patrol.py** - Script to help initialize Patrol in new projects

**scripts/run_patrol.sh** - Automated script for running Patrol tests with common configurations

### External Resources
- Official Patrol Documentation: https://patrol.leancode.co/documentation
- Patrol GitHub: https://github.com/leancodepl/patrol
- Patrol API Reference: https://pub.dev/documentation/patrol/latest/
