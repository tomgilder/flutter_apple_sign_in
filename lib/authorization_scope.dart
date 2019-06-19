
import 'package:meta/meta.dart';

/// The kinds of contact information that can be requested from the user.
@immutable
class AuthorizationScope {
  /// A scope that includes the user’s email address.
  static AuthorizationScope email = const AuthorizationScope.rawValue("email");

  /// A scope that includes the user’s full name.
  static AuthorizationScope fullName = const AuthorizationScope.rawValue("full_name");

  /// Value of the authorization scope
  final String value;

  /// Creates a scope from the given string.
  /// Typically you use one of the predefined scopes, like email, instead of initializing one from a string.
  const AuthorizationScope.rawValue(this.value);
}