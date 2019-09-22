import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apple_sign_in/open_id_operation.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

void main() {
  group('performRequests', () {
    const MethodChannel channel = MethodChannel('dev.gilder.tom/apple_sign_in');

    Future<MethodCall> _getPerformRequestsMethodCall() {
      final completer = Completer<MethodCall>();

      channel.setMockMethodCallHandler((mc) async {
        if (mc.method == 'performRequests') {
          completer.complete(mc);
          return {
            'status': 'authorized',
            'credentialType': 'ASAuthorizationAppleIDCredential',
            'credential': {'email': 'email@email.com'}
          };
        }

        throw 'Unexpected method: ${mc.method}';
      });

      return completer.future;
    }

    test('performRequests sends getCredentialState request to channel',
        () async {
      final methodCall = _getPerformRequestsMethodCall();
      await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      expect((await methodCall).arguments['requests'], [
        {
          'requestType': 'AppleIdRequest',
          'user': null,
          'requestedOperation': 'login',
          'requestedScopes': ['email', 'full_name']
        }
      ]);
    });

    test('AppleIdRequest maps operations', () async {
      Future expectOperation(OpenIdOperation operation, String expected) async {
        final methodCall = _getPerformRequestsMethodCall();
        await AppleSignIn.performRequests(
            [AppleIdRequest(requestedOperation: operation)]);
        expect(
            (await methodCall).arguments['requests'][0]['requestedOperation'],
            expected);
      }

      await expectOperation(OpenIdOperation.operationImplicit, 'implicit');
      await expectOperation(OpenIdOperation.operationLogin, 'login');
      await expectOperation(OpenIdOperation.operationLogout, 'logout');
      await expectOperation(OpenIdOperation.operationRefresh, 'refresh');
    });
  });
}
