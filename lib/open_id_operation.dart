import 'package:meta/meta.dart';

/// The kinds of operations that you can perform with OpenID authentication.
@immutable
class OpenIdOperation {
  /// An operation that depends on the particular kind of credential provider.
  static const operationImplicit = OpenIdOperation.rawValue("implicit");

  /// An operation used to authenticate a user.
  static const operationLogin = OpenIdOperation.rawValue("login");

  /// An operation that ends an authenticated session.
  static const operationLogout = OpenIdOperation.rawValue("logout");

  /// An operation that refreshes the logged-in user’s credentials.
  static const operationRefresh = OpenIdOperation.rawValue("refresh");

  /// The value of the operation
  final String value;

  /// Creates an operation from the given string.
  const OpenIdOperation.rawValue(this.value);
}