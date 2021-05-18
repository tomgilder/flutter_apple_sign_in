import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

void main() {
  group('getCredentialState', () {
    const MethodChannel channel = MethodChannel('dev.gilder.tom/apple_sign_in');
    const String USER_ID = 'USER_ID';

    void _setUpReturn(Map map) {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'getCredentialState') {
          return map;
        }

        throw 'Unknown method: ${methodCall.method}';
      });
    }

    test('getCredentialState sends userId to channel', () async {
      late MethodCall methodCall;
      channel.setMockMethodCallHandler((mc) async {
        if (mc.method == 'getCredentialState') {
          methodCall = mc;
          return {'credentialState': 'authorized'};
        }

        throw 'Unexpected method: ${mc.method}';
      });

      await AppleSignIn.getCredentialState(USER_ID);
      expect(methodCall.arguments['userId'], USER_ID);
    });

    test('getCredentialState returns error', () async {
      _setUpReturn({
        'credentialState': 'error',
        'error': {
          'code': 42,
          'domain': 'domain',
          'localizedDescription': 'localizedDescription',
          'localizedRecoverySuggestion': 'localizedRecoverySuggestion',
          'localizedFailureReason': 'localizedFailureReason'
        }
      });

      final result = await AppleSignIn.getCredentialState(USER_ID);
      expect(result.status, CredentialStatus.error);
      expect(result.error!.code, 42);
      expect(result.error!.localizedDescription, 'localizedDescription');
      expect(result.error!.localizedRecoverySuggestion,
          'localizedRecoverySuggestion');
      expect(result.error!.localizedFailureReason, 'localizedFailureReason');
    });

    test('getCredentialState returns authorized', () async {
      _setUpReturn({'credentialState': 'authorized'});
      final result = await AppleSignIn.getCredentialState(USER_ID);
      expect(result.status, CredentialStatus.authorized);
    });

    test('getCredentialState returns revoked', () async {
      _setUpReturn({'credentialState': 'revoked'});
      final result = await AppleSignIn.getCredentialState(USER_ID);
      expect(result.status, CredentialStatus.revoked);
    });

    test('getCredentialState returns authorized', () async {
      _setUpReturn({'credentialState': 'notFound'});
      final result = await AppleSignIn.getCredentialState(USER_ID);
      expect(result.status, CredentialStatus.notFound);
    });

    test('getCredentialState returns transferred', () async {
      _setUpReturn({'credentialState': 'transferred'});
      final result = await AppleSignIn.getCredentialState(USER_ID);
      expect(result.status, CredentialStatus.transferred);
    });
  });
}
