#import <AuthenticationServices/AuthenticationServices.h>
#import "SignInWithApplePlugin.h"
#import "AppleIDButtonFactory.h"
#import "AuthorizationControllerDelegate.h"
#import "Converters/NSErrorConverter.h"
#import "Converters/CredentialConverter.h"

@implementation SignInWithApplePlugin

typedef void(^CredentialStateCompletionBlock)(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error);

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    AppleIDButtonFactory* appleIdButtonFactory = [[AppleIDButtonFactory alloc] initWithMessenger:registrar.messenger];
    
    [registrar registerViewFactory:appleIdButtonFactory
                            withId:@"dev.gilder.tom/apple_id_button"];
    
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"dev.gilder.tom/sign_in_with_apple"
                                                                binaryMessenger:[registrar messenger]];
    SignInWithApplePlugin* instance = [[SignInWithApplePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"performRequests"]) {
        [self performRequests:call result:result];
    } else if ([call.method isEqualToString:@"getCredentialState"]) {
        [self getCredentialState:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)performRequests:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSArray* requestsInput = call.arguments[@"requests"];
    NSMutableArray<ASAuthorizationRequest*>* requests = [[NSMutableArray alloc] initWithCapacity:[requestsInput count]];
    
    for (NSDictionary* request in requestsInput) {
        if ([request[@"requestType"] isEqualToString:@"AppleIdRequest"]) {
            [requests addObject:[self createAppleIDRequest:request]];
        }
    }
    
    __block AuthorizationControllerDelegate* delegate;
    delegate = [[AuthorizationControllerDelegate alloc] initWithCompletion:^(NSDictionary *delegateResult) {
        NSLog(@"Complete");
        result(delegateResult);
        delegate = nil;
    }];
    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:requests];
    controller.delegate = delegate;
    [controller performRequests];
}

- (ASAuthorizationAppleIDRequest*)createAppleIDRequest:(NSDictionary*)args {
    ASAuthorizationAppleIDProvider* appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
    ASAuthorizationAppleIDRequest* request = [appleIDProvider createRequest];
    request.requestedScopes = args[@"requestedScopes"];
    return request;
}

- (void)getCredentialState:(FlutterMethodCall*)call result:(FlutterResult)result {
    CredentialStateCompletionBlock completion = ^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
        if (error != nil) {
            result(@{
                     @"credentialState": @"error",
                     @"error": [NSErrorConverter dictionaryFromError:error]
                     });
        } else {
            result(@{@"credentialState": [CredentialConverter stringForCredentialState:credentialState]});
        }
    };
    
    ASAuthorizationAppleIDProvider* provider = [[ASAuthorizationAppleIDProvider alloc] init];
    [provider getCredentialStateForUserID:call.arguments[@"userId"]
                               completion:completion];
}

@end
