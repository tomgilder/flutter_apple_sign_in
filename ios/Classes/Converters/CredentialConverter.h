#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>

NS_ASSUME_NONNULL_BEGIN

@interface CredentialConverter : NSObject

+ (NSDictionary*)dictionaryFromAppleIDCredential:(ASAuthorizationAppleIDCredential*)credential API_AVAILABLE(ios(13.0));
+ (NSString*)stringForCredentialState:(ASAuthorizationAppleIDProviderCredentialState)credentialState API_AVAILABLE(ios(13.0));

@end

NS_ASSUME_NONNULL_END
