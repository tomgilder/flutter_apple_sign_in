#import <AuthenticationServices/AuthenticationServices.h>
#import "AppleSignInPlugin.h"
#import "AppleIDButtonFactory.h"
#import "AuthorizationControllerDelegate.h"
#import "Converters/NSErrorConverter.h"
#import "Converters/CredentialConverter.h"

@implementation AppleSignInPlugin
{
    FlutterEventSink _eventSink;
}

typedef void(^CredentialStateCompletionBlock)(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) API_AVAILABLE(ios(13.0));

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    AppleIDButtonFactory* appleIdButtonFactory = [[AppleIDButtonFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:appleIdButtonFactory
                            withId:@"dev.gilder.tom/apple_id_button"];
    
    if (@available(iOS 13.0, *)) {
        FlutterMethodChannel* methodChannel = [FlutterMethodChannel methodChannelWithName:@"dev.gilder.tom/apple_sign_in"
                                                                          binaryMessenger:[registrar messenger]];
        
        FlutterEventChannel* eventChannel = [FlutterEventChannel eventChannelWithName:@"dev.gilder.tom/apple_sign_in_events"
                                                                      binaryMessenger:[registrar messenger]];
        
        AppleSignInPlugin* plugin = [[AppleSignInPlugin alloc] init];
        [registrar addMethodCallDelegate:plugin channel:methodChannel];
        [eventChannel setStreamHandler:plugin];
    }
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if (@available(iOS 13.0, *)) {
        if ([call.method isEqualToString:@"performRequests"]) {
            [self performRequests:call result:result];
        } else if ([call.method isEqualToString:@"getCredentialState"]) {
            [self getCredentialState:call result:result];
        } else {
            result(FlutterMethodNotImplemented);
        }
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)performRequests:(FlutterMethodCall*)call result:(FlutterResult)result API_AVAILABLE(ios(13.0)) {
    NSArray* requestsInput = call.arguments[@"requests"];
    NSMutableArray<ASAuthorizationRequest*>* requests = [[NSMutableArray alloc] initWithCapacity:[requestsInput count]];
    
    for (NSDictionary* request in requestsInput) {
        if ([request[@"requestType"] isEqualToString:@"AppleIdRequest"]) {
            [requests addObject:[self createAppleIDRequest:request]];
        }
    }
    
    __block AuthorizationControllerDelegate* delegate;
    delegate = [[AuthorizationControllerDelegate alloc] initWithCompletion:^(NSDictionary *delegateResult) {
        result(delegateResult);
        delegate = nil;
    }];
    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:requests];
    controller.delegate = (id<ASAuthorizationControllerDelegate>)delegate;
    [controller performRequests];
}

- (ASAuthorizationAppleIDRequest*)createAppleIDRequest:(NSDictionary*)args API_AVAILABLE(ios(13.0)) {
    ASAuthorizationAppleIDProvider* appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
    ASAuthorizationAppleIDRequest* request = [appleIDProvider createRequest];
    request.requestedScopes = args[@"requestedScopes"];
    return request;
}

- (void)getCredentialState:(FlutterMethodCall*)call result:(FlutterResult)result API_AVAILABLE(ios(13.0)) {
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


#pragma mark Credentials revoked FlutterStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments
                             eventSink:(FlutterEventSink)eventSink API_AVAILABLE(ios(13.0)) {
    _eventSink = eventSink;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onCredentialRevokedNotification:)
                                                 name:ASAuthorizationAppleIDProviderCredentialRevokedNotification
                                               object:nil];
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _eventSink = nil;
    return nil;
}

- (void)onCredentialRevokedNotification:(NSNotification *)notification API_AVAILABLE(ios(13.0)) {
    if (_eventSink != nil) {
        _eventSink(ASAuthorizationAppleIDProviderCredentialRevokedNotification);
    }
}

@end
