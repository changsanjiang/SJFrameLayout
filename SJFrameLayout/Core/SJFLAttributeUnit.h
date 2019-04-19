//
//  SJFLAttributeUnit.h
//  Pods
//
//  Created by BlueDancer on 2019/4/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    SJFLAttributeNone = 1 << 0,
    SJFLAttributeTop = 1 << 1,
    SJFLAttributeLeft = 1 << 2,
    SJFLAttributeBottom = 1 << 3,
    SJFLAttributeRight = 1 << 4,
    SJFLAttributeWidth = 1 << 5,
    SJFLAttributeHeight = 1 << 6,
    SJFLAttributeCenterX = 1 << 7,
    SJFLAttributeCenterY = 1 << 8
} SJFLAttribute;

@interface SJFLAttributeUnit : NSObject
- (instancetype)initWithView:(__weak UIView *)view attribute:(SJFLAttribute)attribute;
@property (nonatomic, readonly) SJFLAttribute attribute;
@property (nonatomic, weak, readonly, nullable) UIView *view;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END
