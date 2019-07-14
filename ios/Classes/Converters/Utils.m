//
//  Utils.m
//  apple_sign_in
//
//  Created by Tom on 23/06/2019.
//

#import "Utils.h"

@implementation Utils

+ (NSObject*)valueOrNSNull:(NSObject*)object {
    return object ? object : [NSNull null];
}

@end
