import 'dart:async';
import 'package:flutter/services.dart';
import 'apple_id_credential.dart';
import 'apple_id_provider.dart';
import 'apple_id_request.dart';

class SignInWithApple {
  static const MethodChannel _channel = const MethodChannel('sign_in_with_apple');

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

  static Future<CredentialState> getCredentialState(String userId) async {
    final result = await _channel.invokeMethod("getCredentialState", { "userId" : userId });
    
    switch (result["credentialState"]) {
      case "revoked":
        return CredentialState.revoked;

      case "authorized":
        return CredentialState.authorized;

      case "notFound":
        return CredentialState.notFound;
    }

    return CredentialState.error;
  }


  static AuthorizationResult _makeAuthorizationResult(Map<String, dynamic> params) {
    switch (params["credentialType"]) {
      case "ASAuthorizationAppleIDCredential":
        final Map<String, dynamic> credential = params["credential"];

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

class AuthorizationResult {
  
  final AuthorizationStatus status;

  final AppleIdCredential credential;

  AuthorizationResult({this.status, this.credential});
}

enum AuthorizationStatus {
  authorized,
  error
}