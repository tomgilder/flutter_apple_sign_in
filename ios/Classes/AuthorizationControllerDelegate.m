#import "AuthorizationControllerDelegate.h"
#import <AuthenticationServices/AuthenticationServices.h>

@implementation AuthorizationControllerDelegate {
    CompletionBlock _completion;
}

- (instancetype)initWithCompletion:(CompletionBlock)completion {
    self = [super init];
    if (self) {
        _completion = completion;
    }
    return self;
}

- (void)authorizationController:(ASAuthorizationController *)controller
   didCompleteWithAuthorization:(ASAuthorization *)authorization {
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        _completion([self dictionaryFromAppleIDCredential:authorization.credential]);
    }
    
    _completion(@{@"result": @"error"});
}

- (void)authorizationController:(ASAuthorizationController *)controller
           didCompleteWithError:(NSError *)error {
    _completion(@{@"result": @"error"});
}

- (NSDictionary*)dictionaryFromAppleIDCredential:(ASAuthorizationAppleIDCredential*)credential {
    return
    @{
      @"result": @"authorized",
      @"credentialType": @"ASAuthorizationAppleIDCredential",
      @"credential": @{
      @"user": credential.user,
      @"state": credential.state,
      @"authorizedScopes": credential.authorizedScopes,
      // @"authorizationCode": credential.authorizationCode, // TODO: Data
      // @"identityToken": credential.identityToken, // TODO: Token
      @"email": credential.email
//      @"fullName": credential.fullName, // TODO:PersonNameComponents
      //@"realUserStatus": credential.realUserStatus // TODO: ASUserDetectionStatus (int)
      }};
}

@end
