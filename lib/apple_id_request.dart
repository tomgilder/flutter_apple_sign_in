import 'package:meta/meta.dart';
import 'authorization_scope.dart';
import 'open_id_operation.dart';

@immutable
abstract class AuthorizationRequest {
  final OpenIdOperation requestedOperation;

  final List<Scope> requestedScopes;

  Map<String, dynamic> toMap();

  const AuthorizationRequest({this.requestedOperation, this.requestedScopes});
}

@immutable
class AppleIdRequest extends AuthorizationRequest {
  /// An identifier associated with the user’s Apple ID.
  ///
  /// Typically you leave this property set to nil the first time you authenticate a user. Otherwise, if you previously received an authorization containing an ASAuthorizationAppleIDCredential instance, set this property to the value from the credential’s user property.
  ///
  /// The value is an arbitrary string that’s portable among apps from a single developer, but not between apps from different developers.
  final String user;

  // TODO should default OpenIdOperation be login?
  const AppleIdRequest(
      {this.user,
      OpenIdOperation requestedOperation = OpenIdOperation.operationLogin,
      List<Scope> requestedScopes})
      : super(
            requestedOperation: requestedOperation,
            requestedScopes: requestedScopes);

  Map<String, dynamic> toMap() {
    return {
      "requestType": "AppleIdRequest",
      "user": user,
      "requestedOperation": requestedOperation.value,
      "requestedScopes":
          requestedScopes?.map((scope) => scope.value)?.toList() ?? []
    };
  }
}
