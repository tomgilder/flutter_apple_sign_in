import 'package:meta/meta.dart';
import 'dart:typed_data';
import 'authorization_scope.dart';

/// Possible values for the real user indicator.
enum UserDetectionStatus {
  /// The user appears to be a real person.
  likelyReal,

  /// The system hasn’t determined whether the user might be a real person.
  unknown,

  /// The system can’t determine this user’s status as a real person.
  unsupported
}

@immutable
class AppleIdCredential {
  /// A JSON Web Token (JWT) that securely communicates information about the user to your app. Can be null.
  final Uint8List identityToken;

  /// A short-lived token used by your app for proof of authorization when interacting with the app’s server counterpart. Can be null.
  final Uint8List authorizationCode;

  /// An arbitrary string that your app provided to the request that generated the credential.
  final String state;

  /// An identifier associated with the authenticated user. Can be null.
  final String user;

  /// The contact information the user authorized your app to access.
  final List<Scope> authorizedScopes;

  /// The user’s name. Can be null.
  final PersonNameComponents fullName;

  /// The user’s email address. Can be null.
  final String email;

  /// A value that indicates whether the user appears to be a real person.
  final UserDetectionStatus realUserStatus;

  const AppleIdCredential(
      {this.identityToken,
      this.authorizationCode,
      this.state,
      this.user,
      this.authorizedScopes,
      this.fullName,
      this.email,
      this.realUserStatus});
}

/// The separate parts of a person's name, allowing locale-aware formatting.
@immutable
class PersonNameComponents {
  final List<Scope> authorizedScopes;

  /// The user’s email address. Can be null.
  final String email;

  PersonNameComponents({this.authorizedScopes, this.email});
}