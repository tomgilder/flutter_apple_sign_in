#import "AuthorizationControllerDelegate.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "Converters/NSErrorConverter.h"
#import "Converters/CredentialConverter.h"

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
   didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)) {
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        _completion([CredentialConverter dictionaryFromAppleIDCredential:authorization.credential]);
        return;
    }
    
    _completion(@{@"status": @"error"});
}

- (void)authorizationController:(ASAuthorizationController *)controller
           didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    _completion(@
                {@"status": @"error",
                    @"error": [NSErrorConverter dictionaryFromError:error]
                }
                );
}

@end
