import 'package:meta/meta.dart';
import 'dart:typed_data';
import 'authorization_scope.dart';

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

  factory AppleIdCredential.fromMap(Map map) {
    return AppleIdCredential(
        identityToken: map["identityToken"],
        authorizationCode: map["authorizationCode"],
        state: map["state"],
        user: map["user"],
        authorizedScopes: _scopesFromList(map["authorizedScopes"]),
        email: map["email"],
        realUserStatus: map.containsKey("realUserStatus")
            ? UserDetectionStatus.values[map["realUserStatus"]]
            : UserDetectionStatus.unsupported,
        fullName: PersonNameComponents.fromMap(map["fullName"]));
  }

  static List<Scope> _scopesFromList(List list) {
    if (list == null) {
      return List();
    }

    return list.map((scope) => Scope.rawValue(scope)).toList();
  }
}

/// Possible values for the real user indicator.
enum UserDetectionStatus {
  /// The system can’t determine this user’s status as a real person.
  unsupported,

  /// The system hasn’t determined whether the user might be a real person.
  unknown,

  /// The user appears to be a real person.
  likelyReal
}

/// The separate parts of a person's name, allowing locale-aware formatting.
@immutable
class PersonNameComponents {
  /// Pre-nominal letters denoting title, salutation, or honorific, e.g. Dr., Mr. Can be null.
  final String namePrefix;

  /// Name bestowed upon an individual by one's parents, e.g. Johnathan. Can be null.
  final String givenName;

  /// Secondary given name chosen to differentiate those with the same first name, e.g. Maple. Can be null.
  final String middleName;

  /// Name passed from one generation to another to indicate lineage, e.g. Appleseed. Can be null.
  final String familyName;

  /// Post-nominal letters denoting degree, accreditation, or other honor, e.g. Esq., Jr., Ph.D. Can be null.
  final String nameSuffix;

  /// Name substituted for the purposes of familiarity, e.g. "Johnny". Can be null.
  final String nickname;

  PersonNameComponents(
      {this.namePrefix,
      this.givenName,
      this.middleName,
      this.familyName,
      this.nameSuffix,
      this.nickname});

  factory PersonNameComponents.fromMap(Map map) {
    if (map == null) {
      return PersonNameComponents();
    }

    return PersonNameComponents(
        namePrefix: map["namePrefix"],
        givenName: map["givenName"],
        middleName: map["middleName"],
        familyName: map["familyName"],
        nameSuffix: map["nameSuffix"],
        nickname: map["nickname"]);
  }
}
