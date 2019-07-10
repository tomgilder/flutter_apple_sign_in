#import <Flutter/Flutter.h>
#import "CredentialConverter.h"
#import "Utils.h"

@implementation CredentialConverter

+ (NSDictionary*)dictionaryFromAppleIDCredential:(ASAuthorizationAppleIDCredential*)credential {
    return
    @{
      @"status": @"authorized",
      @"credentialType": @"ASAuthorizationAppleIDCredential",
      @"credential": @{
              @"user": [Utils valueOrNSNull:credential.user],
              @"state": [Utils valueOrNSNull:credential.state],
              @"authorizedScopes": [Utils valueOrNSNull:credential.authorizedScopes],
              @"authorizationCode": credential.authorizationCode ? [FlutterStandardTypedData typedDataWithBytes:credential.authorizationCode] : [NSNull null],
              @"identityToken": credential.identityToken ? [FlutterStandardTypedData typedDataWithBytes:credential.identityToken] : [NSNull null],
              @"email": [Utils valueOrNSNull:credential.email],
              @"fullName": [CredentialConverter dictionaryFromPersonNameComponents:credential.fullName],
              //@"realUserStatus": credential.realUserStatus // TODO: ASUserDetectionStatus (int)
              }};
}

+ (NSObject*)dictionaryFromPersonNameComponents:(NSPersonNameComponents*)components {
    if (!components) {
        return [NSNull null];
    }
    
    return
    @{
      @"namePrefix": [Utils valueOrNSNull:components.namePrefix],
      @"namePrefix": [Utils valueOrNSNull:components.givenName],
      @"namePrefix": [Utils valueOrNSNull:components.middleName],
      @"familyName": [Utils valueOrNSNull:components.familyName],
      @"nameSuffix": [Utils valueOrNSNull:components.nameSuffix],
      @"nickname": [Utils valueOrNSNull:components.nickname],
      };
}

+ (NSString*)stringForCredentialState:(ASAuthorizationAppleIDProviderCredentialState)credentialState {
    switch(credentialState) {
        case ASAuthorizationAppleIDProviderCredentialAuthorized:
            return @"authorized";
            
        case ASAuthorizationAppleIDProviderCredentialRevoked:
            return @"revoked";
            
        default: // ASAuthorizationAppleIDProviderCredentialNotFound
            return @"notFound";
    }
}

@end
