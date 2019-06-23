//
//  NSErrorConverter.m
//  sign_in_with_apple
//
//  Created by Tom on 23/06/2019.
//

#import "NSErrorConverter.h"

@implementation NSErrorConverter

static id valueOrNSNull(id value) {
    return value ? value : [NSNull null];
}

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
