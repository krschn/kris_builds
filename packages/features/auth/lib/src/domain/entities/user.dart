import 'package:flutter/foundation.dart';

/// User entity representing an authenticated user.
@immutable
class User {
  const User({
    required this.id,
    required this.email,
    required this.name,
  });

  final String id;
  final String email;
  final String name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.name == name;
  }

  @override
  int get hashCode => Object.hash(id, email, name);
}
