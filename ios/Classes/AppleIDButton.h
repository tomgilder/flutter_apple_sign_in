#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(13.0))
@interface AppleIDButton : NSObject <FlutterPlatformView>

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger ;

- (UIView*)view;
@end

NS_ASSUME_NONNULL_END
