//
//  NSErrorConverter.m
//  apple_sign_in
//
//  Created by Tom on 23/06/2019.
//

#import "NSErrorConverter.h"

@implementation NSErrorConverter

+ (NSDictionary *)dictionaryFromError:(NSError *)error {
    return
    @{
      @"code": @(error.code),
      @"domain": [self valueOrNSNull:error.domain],
      @"localizedDescription": [self valueOrNSNull:error.localizedDescription],
      @"localizedRecoverySuggestion": [self valueOrNSNull:error.localizedRecoverySuggestion],
      @"localizedFailureReason": [self valueOrNSNull:error.localizedFailureReason]
      };
}

+ (NSObject*)valueOrNSNull:(NSObject*)value {
    if (value == nil) {
        return [NSNull null];
    }
    
    return value;
}

@end
