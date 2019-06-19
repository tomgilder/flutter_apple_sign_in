import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sign_in_with_apple/apple_id_provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

void main() {
  const MethodChannel channel = MethodChannel('dev.gilder.tom/sign_in_with_apple');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.arguments["userId"])
      {
        case "revokedUserId":
          return "revoked";
        case "authorizedUserId":
          return "authorized";
        case "notFoundUserId":
          return "notFound";
      }
      
      throw "Unknown user ID";
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getCredentialState returns revoked', () async {
    final result = await AppleIdProvider.getCredentialState("revokedUserId");
    expect(result, CredentialState.revoked);
  });

  test('getCredentialState returns authorized', () async {
    final result = await AppleIdProvider.getCredentialState("authorizedUserId");
    expect(result, CredentialState.authorized);
  });

  test('getCredentialState returns notFound', () async {
    final result = await AppleIdProvider.getCredentialState("notFoundUserId");
    expect(result, CredentialState.notFound);
  });
}