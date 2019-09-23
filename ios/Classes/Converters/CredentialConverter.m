#import <Flutter/Flutter.h>
#import "CredentialConverter.h"
#import "Utils.h"

@implementation CredentialConverter

+ (NSDictionary*)dictionaryFromAppleIDCredential:(ASAuthorizationAppleIDCredential*)credential API_AVAILABLE(ios(13.0)) {
    NSDictionary *dict = @{
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
              @"realUserStatus": @(credential.realUserStatus)
              }};
    
    NSLog(@"%@", dict); // TODO: Remove debug logging
    return dict;
}

+ (NSObject*)dictionaryFromPersonNameComponents:(NSPersonNameComponents*)components API_AVAILABLE(ios(9.0)) {
    if (!components) {
        return [NSNull null];
    }
    
    return
    @{
      @"namePrefix": [Utils valueOrNSNull:components.namePrefix],
      @"givenName": [Utils valueOrNSNull:components.givenName],
      @"middleName": [Utils valueOrNSNull:components.middleName],
      @"familyName": [Utils valueOrNSNull:components.familyName],
      @"nameSuffix": [Utils valueOrNSNull:components.nameSuffix],
      @"nickname": [Utils valueOrNSNull:components.nickname],
      };
}

+ (NSString*)stringForCredentialState:(ASAuthorizationAppleIDProviderCredentialState)credentialState API_AVAILABLE(ios(13.0)) {
    switch(credentialState) {
        case ASAuthorizationAppleIDProviderCredentialAuthorized:
            return @"authorized";
            
        case ASAuthorizationAppleIDProviderCredentialRevoked:
            return @"revoked";
            
        case ASAuthorizationAppleIDProviderCredentialTransferred:
            return @"transferred";
            
        default: // ASAuthorizationAppleIDProviderCredentialNotFound
            return @"notFound";
    }
}

@end
