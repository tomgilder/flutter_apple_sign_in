
import 'package:meta/meta.dart';
import 'open_id_operation.dart';

@immutable
class AppleIdRequest {
  /// An identifier associated with the user’s Apple ID.
  ///
  /// Typically you leave this property set to nil the first time you authenticate a user. Otherwise, if you previously received an authorization containing an ASAuthorizationAppleIDCredential instance, set this property to the value from the credential’s user property.
  ///
  /// The value is an arbitrary string that’s portable among apps from a single developer, but not between apps from different developers.
  final String user;

  final OpenIdOperation requestedOperation;

  const AppleIdRequest({
    this.user,
    this.requestedOperation
  });
}