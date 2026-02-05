# Patrol Integration Test Examples

Real-world examples demonstrating Patrol integration tests with native automation.

## Example 1: Counter App - Integration Test

Testing a counter app with Patrol's concise finders.

### Basic Counter Test

```dart
// patrol_test/counter_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:my_app/main.dart';

void main() {
  patrolTest(
    'counter increments when button is tapped',
    ($) async {
      // Setup
      await $.pumpWidgetAndSettle(const MyApp());

      // Initial state
      expect($(#counterText).text, '0');

      // Action
      await $(FloatingActionButton).tap();

      // Assert
      expect($(#counterText).text, '1');
    },
  );

  patrolTest(
    'counter can increment multiple times',
    ($) async {
      await $.pumpWidgetAndSettle(const MyApp());

      await $(FloatingActionButton).tap();
      await $(FloatingActionButton).tap();
      await $(FloatingActionButton).tap();

      expect($(#counterText).text, '3');
    },
  );
}
```

**Run test:** `patrol test -t patrol_test/counter_test.dart`

### Testing App Persistence with Native Actions

```dart
patrolTest(
  'counter persists after navigating away and back',
  ($) async {
    await $.pumpWidgetAndSettle(const MyApp());

    // Increment counter
    await $(FloatingActionButton).tap();
    expect($(#counterText).text, '1');

    // Go to home
    await $.native.pressHome();

    // Return to app
    await $.native.pressDoubleRecentApps();

    // Counter should persist
    expect($(#counterText).text, '1');
  },
);
```

## Example 2: Login Flow - End-to-End Test

Testing complete login flow with form validation.

### Login Tests

```dart
// patrol_test/login_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:my_app/main.dart';

void main() {
  group('Login flow', () {
    patrolTest(
      'displays error when email is invalid',
      ($) async {
        await $.pumpWidgetAndSettle(const MyApp());

        // Enter invalid email
        await $(#emailField).enterText('invalid-email');
        await $(#passwordField).enterText('password123');
        await $(#loginButton).tap();

        // Should show error
        expect($('Invalid email'), findsOneWidget);
      },
    );

    patrolTest(
      'displays error when password is too short',
      ($) async {
        await $.pumpWidgetAndSettle(const MyApp());

        await $(#emailField).enterText('user@example.com');
        await $(#passwordField).enterText('short');
        await $(#loginButton).tap();

        expect($('Password must be at least 8 characters'), findsOneWidget);
      },
    );

    patrolTest(
      'navigates to home screen on successful login',
      ($) async {
        await $.pumpWidgetAndSettle(const MyApp());

        // Enter valid credentials
        await $(#emailField).enterText('user@example.com');
        await $(#passwordField).enterText('password123');
        await $(#loginButton).tap();

        // Wait for navigation
        await $.pumpAndSettle();

        // Should navigate to home
        expect($('Home Screen'), findsOneWidget);
        expect($('Welcome, user@example.com'), findsOneWidget);
      },
    );

    patrolTest(
      'can navigate back from home to login',
      ($) async {
        await $.pumpWidgetAndSettle(const MyApp());

        // Login
        await $(#emailField).enterText('user@example.com');
        await $(#passwordField).enterText('password123');
        await $(#loginButton).tap();
        await $.pumpAndSettle();

        // Verify on home
        expect($('Home Screen'), findsOneWidget);

        // Press back
        await $.native.pressBack();
        await $.pumpAndSettle();

        // Should be back at login
        expect($(#emailField), findsOneWidget);
      },
    );
  });
}
```

## Example 3: Permission Handling

Testing native permission dialogs with Patrol.

### Location Permission Tests

```dart
// patrol_test/location_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:my_app/main.dart';

void main() {
  group('Location permissions', () {
    patrolTest(
      'displays location when permission is granted',
      ($) async {
        await $.pumpWidgetAndSettle(const MyApp());

        // Navigate to location screen
        await $(#locationTab).tap();

        // Tap button to request location
        await $(#getLocationButton).tap();

        // Grant permission in native dialog
        await $.native.grantPermissionWhenInUse();

        // Wait for location fetch
        await $.pumpAndSettle();

        // Should display location coordinates
        expect($(#locationText), findsOneWidget);
        expect($(#locationText).text, isNot('No location'));
        expect($(#locationText).text, contains(','));
      },
    );

    patrolTest(
      'displays error when permission is denied',
      ($) async {
        await $.pumpWidgetAndSettle(const MyApp());

        await $(#locationTab).tap();
        await $(#getLocationButton).tap();

        // Deny permission
        await $.native.denyPermission();
        await $.pumpAndSettle();

        // Should show error
        expect($('Location permission denied'), findsOneWidget);
      },
    );

    patrolTest(
      'allows granting permission only once',
      ($) async {
        await $.pumpWidgetAndSettle(const MyApp());

        await $(#locationTab).tap();
        await $(#getLocationButton).tap();

        // Grant one-time permission
        await $.native.grantPermissionOnlyThisTime();
        await $.pumpAndSettle();

        // Should display location
        expect($(#locationText).text, isNot('No location'));
      },
    );
  });
}
```

### Camera Permission Test

```dart
patrolTest(
  'opens camera when permission is granted',
  ($) async {
    await $.pumpWidgetAndSettle(const MyApp());

    await $(#cameraButton).tap();

    // Handle permission dialog
    await $.native.tap(Selector(text: 'Allow'));
    await $.pumpAndSettle();

    // Camera preview should be visible
    expect($(#cameraPreview), findsOneWidget);
  },
);
```

## Example 4: Notification Testing

Testing push notification handling with native automation.

### Notification Tests

```dart
// patrol_test/notification_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:my_app/main.dart';

void main() {
  group('Notifications', () {
    patrolTest(
      'can send and tap on notification',
      ($) async {
        await $.pumpWidgetAndSettle(const MyApp());

        // Trigger notification from app
        await $(#sendNotificationButton).tap();

        // Wait for notification to appear
        await Future.delayed(const Duration(seconds: 2));

        // Open notification drawer
        await $.native.openNotifications();

        // Tap on the notification
        await $.native.tap(Selector(text: 'Test Notification'));

        // App should show notification was handled
        expect($(#notificationMessage).text, 'Notification tapped!');
      },
    );

    patrolTest(
      'can dismiss notification',
      ($) async {
        await $.pumpWidgetAndSettle(const MyApp());

        await $(#sendNotificationButton).tap();
        await Future.delayed(const Duration(seconds: 2));

        // Dismiss heads-up notification
        await $.native.closeHeadsUpNotification();

        // App should still be visible
        expect($(#sendNotificationButton), findsOneWidget);
      },
    );

    patrolTest(
      'tapping notification navigates to detail screen',
      ($) async {
        await $.pumpWidgetAndSettle(const MyApp());

        // Send notification with deep link
        await $(#sendDeepLinkNotification).tap();
        await Future.delayed(const Duration(seconds: 2));

        await $.native.openNotifications();
        await $.native.tapOnNotificationBySelector(
          Selector(textContains: 'View Details'),
        );

        // Should navigate to detail screen
        expect($('Detail Screen'), findsOneWidget);
      },
    );
  });
}
```

## Example 5: Device Settings

Testing app behavior with device setting changes.

### Dark Mode Tests

```dart
// patrol_test/theme_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:my_app/main.dart';

void main() {
  group('Theme handling', () {
    patrolTest(
      'app responds to system dark mode',
      ($) async {
        await $.pumpWidgetAndSettle(const MyApp());

        // Enable dark mode
        await $.native.enableDarkMode();
        await $.pumpAndSettle();

        // App should be in dark mode
        // (Verify by checking background color or theme-dependent widget)
        expect($(#themeIndicator).text, 'Dark');

        // Disable dark mode
        await $.native.disableDarkMode();
        await $.pumpAndSettle();

        expect($(#themeIndicator).text, 'Light');
      },
    );
  });
}
```

### Network Connectivity Tests

```dart
patrolTest(
  'shows offline message when wifi is disabled',
  ($) async {
    await $.pumpWidgetAndSettle(const MyApp());

    // Disable wifi
    await $.native.disableWifi();
    await $.pumpAndSettle();

    // Trigger network request
    await $(#refreshButton).tap();
    await $.pumpAndSettle();

    // Should show offline message
    expect($('No internet connection'), findsOneWidget);

    // Re-enable wifi
    await $.native.enableWifi();
  },
);
```

## Example 6: Multi-Step User Flow

Testing a complete user journey through the app.

### Onboarding Flow Test

```dart
// patrol_test/onboarding_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:my_app/main.dart';

void main() {
  patrolTest(
    'complete onboarding flow',
    ($) async {
      await $.pumpWidgetAndSettle(const MyApp());

      // Step 1: Welcome screen
      expect($('Welcome to MyApp'), findsOneWidget);
      await $(#nextButton).tap();

      // Step 2: Notification permission
      expect($('Enable Notifications'), findsOneWidget);
      await $(#enableNotificationsButton).tap();
      await $.native.tap(Selector(text: 'Allow'));
      await $.pumpAndSettle();

      // Step 3: Location permission
      expect($('Enable Location'), findsOneWidget);
      await $(#enableLocationButton).tap();
      await $.native.grantPermissionWhenInUse();
      await $.pumpAndSettle();

      // Step 4: Profile setup
      expect($('Set Up Profile'), findsOneWidget);
      await $(#nameField).enterText('John Doe');
      await $(#continueButton).tap();

      // Should be on home screen
      expect($('Home'), findsOneWidget);
      expect($('Welcome, John Doe'), findsOneWidget);
    },
  );
}
```

### Shopping Cart Flow

```dart
patrolTest(
  'complete purchase flow',
  ($) async {
    await $.pumpWidgetAndSettle(const MyApp());

    // Browse products
    await $(#productsTab).tap();
    await $('Product A').tap();

    // Add to cart
    await $(#addToCartButton).tap();
    expect($('Added to cart'), findsOneWidget);

    // Go to cart
    await $(#cartTab).tap();
    expect($('Product A'), findsOneWidget);
    expect($(#totalPrice).text, '\$29.99');

    // Checkout
    await $(#checkoutButton).tap();

    // Fill payment info
    await $(#cardNumber).enterText('4242424242424242');
    await $(#expiryDate).enterText('12/25');
    await $(#cvv).enterText('123');
    await $(#payButton).tap();

    // Wait for payment processing
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    // Should show success
    expect($('Order Confirmed'), findsOneWidget);
  },
);
```

## Example 7: Form with Native Keyboard

Testing form interactions with native keyboard.

```dart
patrolTest(
  'can fill form using native keyboard actions',
  ($) async {
    await $.pumpWidgetAndSettle(const MyApp());

    // Enter text in first field
    await $(#firstNameField).enterText('John');

    // Use native keyboard to go to next field (if applicable)
    // On some platforms, you might need to tap the next field
    await $(#lastNameField).tap();
    await $(#lastNameField).enterText('Doe');

    await $(#emailField).tap();
    await $(#emailField).enterText('john.doe@example.com');

    // Submit form
    await $(#submitButton).tap();
    await $.pumpAndSettle();

    expect($('Form submitted successfully'), findsOneWidget);
  },
);
```

## Key Takeaways for Patrol Tests

1. **Use ValueKeys** - `$(#key)` is more reliable than text finders
2. **Wait for animations** - Always use `pumpAndSettle()` after interactions
3. **Handle native dialogs** - Use `$.native.*` methods for permissions, notifications
4. **Test real user flows** - Integration tests should verify complete scenarios
5. **Keep tests independent** - Each test starts with fresh app state
6. **Use develop mode** - `patrol develop` for rapid iteration during development

## Common Patterns

### Wait for Loading

```dart
await $.pumpWidgetAndSettle(MyApp());
await $.waitUntilGone($(#loadingIndicator));
expect($(#content), findsOneWidget);
```

### Scroll to Widget

```dart
await $(#targetWidget).scrollTo.visible();
await $(#targetWidget).tap();
```

### Handle Multiple Matches

```dart
// Tap the second item in a list
await $('List Item').at(1).tap();
```

### Conditional Platform Logic

```dart
if (Platform.isAndroid) {
  await $.native.pressBack();
} else {
  await $(#backButton).tap();
}
```
