import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:apple_sign_in/apple_id_credential.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

void main() {
  group('AppleIdCredential', () {
    test('Creates from map', () async {
      final map = {
        'identityToken': Uint8List.fromList([4, 8, 15, 16, 23, 42]),
        'authorizationCode': Uint8List.fromList([1, 2, 3]),
        'state': 'state',
        'authorizedScopes': ['email', 'full_name'],
        'user': 'user',
        'email': 'email',
        'realUserStatus': 2,
        'fullName': {
          'familyName': 'family',
          'givenName': 'given',
          'middleName': 'middle',
          'namePrefix': 'prefix',
          'nameSuffix': 'suffix',
          'nickname': 'nick'
        }
      };

      final result = AppleIdCredential.fromMap(map);

      expect(result.identityToken!.toList(), [4, 8, 15, 16, 23, 42]);
      expect(result.authorizationCode!.toList(), [1, 2, 3]);
      expect(result.state, 'state');
      expect(result.authorizedScopes, [Scope.email, Scope.fullName]);
      expect(result.user, 'user');
      expect(result.email, 'email');
      expect(result.realUserStatus, UserDetectionStatus.likelyReal);

      expect(result.fullName!.familyName, 'family');
      expect(result.fullName!.givenName, 'given');
      expect(result.fullName!.middleName, 'middle');
      expect(result.fullName!.namePrefix, 'prefix');
      expect(result.fullName!.nameSuffix, 'suffix');
      expect(result.fullName!.nickname, 'nick');
    });
  });
}
