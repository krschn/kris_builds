import 'package:flutter/widgets.dart';

import 'auth_navigation.dart';

/// InheritedWidget that provides AuthNavigationDelegate to the widget tree.
class AuthNavigationProvider extends InheritedWidget {
  const AuthNavigationProvider({
    super.key,
    required this.delegate,
    required super.child,
  });

  /// The navigation delegate implementation
  final AuthNavigationDelegate delegate;

  /// Get the AuthNavigationDelegate from the widget tree.
  ///
  /// Throws if no AuthNavigationProvider is found.
  static AuthNavigationDelegate of(BuildContext context) {
    final AuthNavigationProvider? provider =
        context.dependOnInheritedWidgetOfExactType<AuthNavigationProvider>();
    assert(
      provider != null,
      'No AuthNavigationProvider found in context. '
      'Wrap your app with AuthNavigationProvider.',
    );
    return provider!.delegate;
  }

  /// Try to get the AuthNavigationDelegate from the widget tree.
  ///
  /// Returns null if no AuthNavigationProvider is found.
  static AuthNavigationDelegate? maybeOf(BuildContext context) {
    final AuthNavigationProvider? provider =
        context.dependOnInheritedWidgetOfExactType<AuthNavigationProvider>();
    return provider?.delegate;
  }

  @override
  bool updateShouldNotify(AuthNavigationProvider oldWidget) {
    return delegate != oldWidget.delegate;
  }
}
