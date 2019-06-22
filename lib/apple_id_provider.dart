import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'apple_id_request.dart';
import 'authorization_scope.dart';

class AppleIdProvider {
  static const MethodChannel _channel = const MethodChannel('dev.gilder.tom/sign_in_with_apple');

  /// Creates a new Apple ID authorization request.
  static AppleIdRequest createRequest() {
    return AppleIdRequest();
  }

  static Future performRequests({List<Scope> scopes}) async {
    final request = AppleIdRequest(requestedScopes: scopes);
    final result = await _channel.invokeMethod("request",
    {
      "requestedScopes": scopes
    });
  }

  /// Returns the credential state for the given user.
  static Future<CredentialState> getCredentialState(String userId) async {
    final result = await _channel.invokeMethod("getCredentialState", { "userId": userId });
    
    switch (result["credentialState"]) {
      case "error":
        return CredentialState(status: CredentialStatus.error);

      case "revoked":
        return CredentialState(status: CredentialStatus.revoked);
      
      case "authorized":
        return CredentialState(status: CredentialStatus.authorized);

      case "notFound":
        return CredentialState(status: CredentialStatus.notFound);
    }

    throw "Unknown credentialState";
  }
}

@immutable
class CredentialState {
  final CredentialStatus status;

  const CredentialState({@required this.status});
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