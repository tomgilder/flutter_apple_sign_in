import 'package:flutter/services.dart';
import 'apple_id_request.dart';

class AppleIdProvider {
  static const MethodChannel _channel = const MethodChannel('dev.gilder.tom/sign_in_with_apple');

  /// Creates a new Apple ID authorization request.
  static AppleIdRequest createRequest() {
    return AppleIdRequest();
  }

  /// Returns the credential state for the given user.
  static Future<CredentialState> getCredentialState(String userId) async {
    final result = await _channel.invokeMethod("getCredentialState", { "userId": userId });
    
    switch (result) {
      case "revoked":
        return CredentialState.revoked;
      
      case "authorized":
        return CredentialState.authorized;

      case "notFound":
        return CredentialState.notFound;
    }

    throw "Unknown Sign In with Apple user state: '$result'";
  }
}

// Possible values for the credential state of a user.
enum CredentialState {
  // Authorization for the given user has been revoked.
  revoked,

  /// The user is authorized.
  authorized,

  /// The user can’t be found.
  notFound
 }