import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'apple_id_credential.dart';
import 'apple_id_request.dart';
export 'authorization_scope.dart';
export 'apple_id_request.dart';
export 'apple_id_credential.dart';
export 'open_id_operation.dart';
export 'apple_sign_in_button.dart';

class AppleSignIn {
  static const MethodChannel _methodChannel =
      const MethodChannel('dev.gilder.tom/apple_sign_in');
  static const EventChannel _eventChannel =
      const EventChannel('dev.gilder.tom/apple_sign_in_events');

  static Stream<void> _onCredentialsRevoked;
  static Stream<void> get onCredentialRevoked {
    if (_onCredentialsRevoked == null) {
      _onCredentialsRevoked = _eventChannel.receiveBroadcastStream();
    }

    return _onCredentialsRevoked;
  }

  static Future<AuthorizationResult> performRequests(
      List<AuthorizationRequest> requests) async {
    final result = await _methodChannel.invokeMethod(
      'performRequests',
      {'requests': requests.map((request) => request.toMap()).toList()},
    );
    final status = result['status'];

    switch (status) {
      case 'authorized':
        return _makeAuthorizationResult(result);
        break;

      case 'error':
        return AuthorizationResult(
            status: AuthorizationStatus.error,
            error: NsError.fromMap(result['error']));
        break;
    }

    throw "performRequests: Unknown status returned: '$status'";
  }

  /// Returns the credential state for the given user.
  static Future<CredentialState> getCredentialState(String userId) async {
    assert(userId != null, 'Must provide userId');

    final result = await _methodChannel
        .invokeMethod('getCredentialState', {'userId': userId});
    final credentialState = result['credentialState'];

    switch (credentialState) {
      case 'error':
        return CredentialState(
            status: CredentialStatus.error,
            error: NsError.fromMap(result['error']));

      case 'revoked':
        return CredentialState(status: CredentialStatus.revoked);

      case 'authorized':
        return CredentialState(status: CredentialStatus.authorized);

      case 'notFound':
        return CredentialState(status: CredentialStatus.notFound);
    }

    throw "Unknown credentialState: '$credentialState'";
  }

  static Future<bool> isAvailable() async {
    if (!Platform.isIOS) {
      return false;
    }

    final result = await _methodChannel.invokeMethod('isAvailable');
    final isAvailable = result['isAvailable'] == 1;
    assert(isAvailable != null);
    return isAvailable;
  }

  static AuthorizationResult _makeAuthorizationResult(Map params) {
    switch (params['credentialType']) {
      case 'ASAuthorizationAppleIDCredential':
        final Map credential = params['credential'];
        assert(credential != null);

        return AuthorizationResult(
            status: AuthorizationStatus.authorized,
            credential: AppleIdCredential.fromMap(credential));

        break;

      default:
        throw 'Unknown credentials type';
    }
  }
}

@immutable
class CredentialState {
  final CredentialStatus status;

  final NsError error;

  const CredentialState({@required this.status, this.error});
}

@immutable
class NsError {
  final int code;

  final String domain;

  final String localizedDescription;

  final String localizedRecoverySuggestion;

  final String localizedFailureReason;

  @override
  String toString() => localizedDescription;

  const NsError(
      {this.code,
      this.domain,
      this.localizedDescription,
      this.localizedRecoverySuggestion,
      this.localizedFailureReason});

  factory NsError.fromMap(Map map) {
    assert(map != null);

    return NsError(
      code: map['code'],
      domain: map['domain'],
      localizedDescription: map['localizedDescription'],
      localizedRecoverySuggestion: map['localizedRecoverySuggestion'],
      localizedFailureReason: map['localizedFailureReason'],
    );
  }
}

// Possible values for the credential state of a user.
enum CredentialStatus {
  // Authorization for the given user has been revoked.
  revoked,

  /// The user is authorized.
  authorized,

  /// The user can’t be found.
  notFound,

  error
}

@immutable
class AuthorizationResult {
  final AuthorizationStatus status;

  final AppleIdCredential credential;

  final NsError error;

  const AuthorizationResult({
    @required this.status,
    this.credential,
    this.error,
  });
}

enum AuthorizationStatus { authorized, error }
