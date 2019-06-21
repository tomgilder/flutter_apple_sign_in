
import 'package:meta/meta.dart';

/// The kinds of contact information that can be requested from the user.
@immutable
class Scope {
  /// A scope that includes the user’s email address.
  static Scope email = const Scope.rawValue("email");

  /// A scope that includes the user’s full name.
  static Scope fullName = const Scope.rawValue("full_name");

  /// Value of the authorization scope
  final String value;

  /// Creates a scope from the given string.
  /// Typically you use one of the predefined scopes, like email, instead of initializing one from a string.
  const Scope.rawValue(this.value);
}