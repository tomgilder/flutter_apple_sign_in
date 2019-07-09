import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sign_in_with_apple/open_id_operation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

void main() {
  group("performRequests", () {
    const MethodChannel channel = MethodChannel("dev.gilder.tom/sign_in_with_apple");

    Future<MethodCall> _getPerformRequestsMethodCall() {
      final completer = Completer<MethodCall>();

      channel.setMockMethodCallHandler((mc) async {
        if (mc.method == "performRequests") {
          completer.complete(mc);
          return {
            "status": "authorized",
            "credentialType": "ASAuthorizationAppleIDCredential",
            "credential": {
              "email": "email@email.com"
            }
          };
        }

        throw "Unexpected method: ${mc.method}";
      });

      return completer.future;
    }
    
    test('performRequests sends default request to channel', () async {
      final methodCall = _getPerformRequestsMethodCall();
      await SignInWithApple.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      expect((await methodCall).arguments["requests"], [{
        "requestType": "AppleIdRequest",
        "user": null,
        "requestedOperation": "login",
        "requestedScopes": ["email", "full_name"]
      }]);
    });

    test('AppleIdRequest maps operations', () async {
      Future expectOperation(OpenIdOperation operation, String expected) async {
        final methodCall = _getPerformRequestsMethodCall();
        await SignInWithApple.performRequests([AppleIdRequest(requestedOperation: operation)]);
        expect((await methodCall).arguments["requests"][0]["requestedOperation"], expected);
      }

      await expectOperation(OpenIdOperation.operationImplicit, "implicit");
      await expectOperation(OpenIdOperation.operationLogin, "login");
      await expectOperation(OpenIdOperation.operationLogout, "logout");
      await expectOperation(OpenIdOperation.operationRefresh, "refresh");
    });
  });
}
