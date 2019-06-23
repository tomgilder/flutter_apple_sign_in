//
//  Utils.m
//  sign_in_with_apple
//
//  Created by Tom on 23/06/2019.
//

#import "Utils.h"

@implementation Utils

+ (NSObject*)valueOrNSNull:(NSObject*)object {
    return object ? object : [NSNull null];
}

@end
