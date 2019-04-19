//
//  SJFLAttributeUnit.h
//  Pods
//
//  Created by BlueDancer on 2019/4/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    SJFLAttributeNone,
    SJFLAttributeTop,
    SJFLAttributeLeft,
    SJFLAttributeBottom,
    SJFLAttributeRight,
    SJFLAttributeWidth,
    SJFLAttributeHeight,
    SJFLAttributeCenterX,
    SJFLAttributeCenterY
} SJFLAttribute;

@interface SJFLAttributeUnit : NSObject
- (instancetype)initWithView:(__weak UIView *)view attribute:(SJFLAttribute)attribute;
@property (nonatomic, readonly) SJFLAttribute attribute;
@property (nonatomic, weak, readonly, nullable) UIView *view;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END
