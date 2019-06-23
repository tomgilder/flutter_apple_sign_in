#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>

NS_ASSUME_NONNULL_BEGIN

@interface CredentialConverter : NSObject

+ (NSDictionary*)dictionaryFromAppleIDCredential:(ASAuthorizationAppleIDCredential*)credential;
+ (NSString*)stringForCredentialState:(ASAuthorizationAppleIDProviderCredentialState)credentialState;

@end

NS_ASSUME_NONNULL_END
