//
//  NSErrorConverter.h
//  apple_sign_in
//
//  Created by Tom on 23/06/2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSErrorConverter : NSObject

+ (NSDictionary *)dictionaryFromError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
