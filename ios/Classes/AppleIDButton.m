//
//  AppleIdButton.m
//  apple_sign_in
//
//  Created by Tom on 21/06/2019.
//

#import "AppleIDButton.h"
#import <AuthenticationServices/AuthenticationServices.h>

@implementation AppleIDButton {
    ASAuthorizationAppleIDButton* _button;
    int64_t _viewId;
    FlutterMethodChannel* _channel;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    
    if ([super init]) {
        NSString* channelName = [NSString stringWithFormat:@"dev.gilder.tom/apple_sign_in_button_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        
        _viewId = viewId;
        
        ASAuthorizationAppleIDButtonType buttonType = [self buttonTypeFromString:args[@"buttonType"]];
        ASAuthorizationAppleIDButtonStyle buttonStyle = [self buttonStyleFromString:args[@"buttonStyle"]];
        _button = [ASAuthorizationAppleIDButton buttonWithType:buttonType
                                                         style:buttonStyle];
        
        _button.frame = frame;
        _button.enabled = [args[@"enabled"] boolValue];
        _button.cornerRadius = [args[@"cornerRadius"] floatValue];
        
        [_button addTarget:self
                    action:@selector(onTapped)
          forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (UIView*)view {
    return _button;
}

- (void)onTapped {
    [_channel invokeMethod:@"onTapped" arguments:nil];
}

- (ASAuthorizationAppleIDButtonType)buttonTypeFromString:(NSString*)buttonType {
    if ([buttonType isEqualToString:@"ButtonType.continueButton"]) {
        return ASAuthorizationAppleIDButtonTypeContinue;
    }
    
    if ([buttonType isEqualToString:@"ButtonType.signUp"]) {
        return ASAuthorizationAppleIDButtonTypeSignUp;
    }
    
    // "ButtonType.defaultType"
    return ASAuthorizationAppleIDButtonTypeDefault;
}


- (ASAuthorizationAppleIDButtonStyle)buttonStyleFromString:(NSString*)buttonStyle {
    if ([buttonStyle isEqualToString:@"ButtonStyle.white"]) {
        return ASAuthorizationAppleIDButtonStyleWhite;
    }
    
    if ([buttonStyle isEqualToString:@"ButtonStyle.whiteOutline"]) {
        return ASAuthorizationAppleIDButtonStyleWhiteOutline;
    }
    
    // "ButtonStyle.black"
    return ASAuthorizationAppleIDButtonStyleBlack;
}

@end
