import 'dart:async';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'apple_id_credential.dart';
import 'apple_id_request.dart';

export 'authorization_scope.dart';
export 'apple_id_request.dart';

class SignInWithApple {
  static const MethodChannel _channel = const MethodChannel('dev.gilder.tom/sign_in_with_apple');

  static Future<AuthorizationResult> performRequests(List<AuthorizationRequest> requests) async {
    final result = await _channel.invokeMethod("performRequests", {
      "requests": requests.map((request) => request.toMap()).toList()
    });

    switch (result["status"]) {
      case "authorized":
        return _makeAuthorizationResult(result);
        break;

      case "error":
        return AuthorizationResult(status: AuthorizationStatus.error);
        break;
    }

    throw "Unknown status";
  }

  /// Returns the credential state for the given user.
  static Future<CredentialState> getCredentialState(String userId) async {
    assert(userId != null, "Must provide userId");

    final result = await _channel.invokeMethod("getCredentialState", { "userId": userId });
    
    switch (result["credentialState"]) {
      case "error":
        return CredentialState(status: CredentialStatus.error, error: CredentialError());

      case "revoked":
        return CredentialState(status: CredentialStatus.revoked);
      
      case "authorized":
        return CredentialState(status: CredentialStatus.authorized);

      case "notFound":
        return CredentialState(status: CredentialStatus.notFound);
    }

    throw "Unknown credentialState";
  }


  static AuthorizationResult _makeAuthorizationResult(Map params) {
    switch (params["credentialType"]) {
      case "ASAuthorizationAppleIDCredential":
        final Map credential = params["credential"];
        assert(credential != null);

        return AuthorizationResult(
          status: AuthorizationStatus.authorized,
          credential: AppleIdCredential(
            email: credential["email"]
          )
        );

        break;

      default:

        throw "Unknown credentials type";
    }
  }

}

@immutable
class CredentialState {
  final CredentialStatus status;

  final CredentialError error;

  const CredentialState({@required this.status, this.error});
}

class CredentialError {

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
 
class AuthorizationResult {
  final AuthorizationStatus status;

  final AppleIdCredential credential;

  AuthorizationResult({this.status, this.credential});
}

enum AuthorizationStatus {
  authorized,
  error
}