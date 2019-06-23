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
   didCompleteWithAuthorization:(ASAuthorization *)authorization {
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        _completion([CredentialConverter dictionaryFromAppleIDCredential:authorization.credential]);
    }
    
    _completion(@{@"result": @"error"});
}

- (void)authorizationController:(ASAuthorizationController *)controller
           didCompleteWithError:(NSError *)error {
    _completion(@
                {@"result": @"error",
                    @"error": [NSErrorConverter dictionaryFromError:error]
                }
                );
}

@end
