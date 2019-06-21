#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompletionBlock)(NSDictionary*);

@interface AuthorizationControllerDelegate<ASAuthorizationControllerDelegate> : NSObject
- (instancetype)initWithCompletion:(CompletionBlock)completition;
@end

NS_ASSUME_NONNULL_END
