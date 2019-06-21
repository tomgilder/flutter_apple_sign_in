#import <AuthenticationServices/AuthenticationServices.h>
#import "SignInWithApplePlugin.h"
#import "AppleIDButtonFactory.h"
#import "AuthorizationControllerDelegate.h"

@implementation SignInWithApplePlugin {
    NSMutableDictionary* controllersDict;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    AppleIDButtonFactory* appleIdButtonFactory = [[AppleIDButtonFactory alloc] initWithMessenger:registrar.messenger];
    
    [registrar registerViewFactory:appleIdButtonFactory
                            withId:@"dev.gilder.tom/apple_id_button"];
    
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"sign_in_with_apple"
                                     binaryMessenger:[registrar messenger]];
    SignInWithApplePlugin* instance = [[SignInWithApplePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"performRequests" isEqualToString:call.method]) {
        [self performRequests:call result:result];
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
    
    [controllersDict setObject:result
                        forKey:controller];
}

- (ASAuthorizationAppleIDRequest*)createAppleIDRequest:(NSDictionary*)args {
    ASAuthorizationAppleIDProvider* appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
    ASAuthorizationAppleIDRequest* request = [appleIDProvider createRequest];
    request.requestedScopes = args[@"requestedScopes"];
    return request;
}


@end
