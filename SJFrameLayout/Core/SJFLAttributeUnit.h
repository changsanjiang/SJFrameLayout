//
//  SJFLAttributeUnit.h
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
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

typedef enum : NSUInteger {
    SJFLAttributeMaskNone = 1 << SJFLAttributeNone,
    SJFLAttributeMaskTop = 1 << SJFLAttributeTop,
    SJFLAttributeMaskLeft = 1 << SJFLAttributeLeft,
    SJFLAttributeMaskBottom = 1 << SJFLAttributeBottom,
    SJFLAttributeMaskRight = 1 << SJFLAttributeRight,
    SJFLAttributeMaskWidth = 1 << SJFLAttributeWidth,
    SJFLAttributeMaskHeight = 1 << SJFLAttributeHeight,
    SJFLAttributeMaskCenterX = 1 << SJFLAttributeCenterX,
    SJFLAttributeMaskCenterY = 1 << SJFLAttributeCenterY,
    SJFLAttributeMaskEdges = SJFLAttributeMaskTop | SJFLAttributeMaskLeft | SJFLAttributeMaskBottom | SJFLAttributeMaskRight,
    SJFLAttributeMaskCenter = SJFLAttributeMaskCenterX | SJFLAttributeMaskCenterY,
    SJFLAttributeMaskSize = SJFLAttributeMaskWidth | SJFLAttributeMaskHeight,
    SJFLAttributeMaskAll = SJFLAttributeMaskNone | SJFLAttributeMaskEdges | SJFLAttributeMaskSize | SJFLAttributeMaskCenter
} SJFLAttributeMask;

@interface SJFLAttributeUnit : NSObject {
    @public
    union {
        CGFloat value;
        CGPoint point;
        CGSize size;
        UIEdgeInsets edges;
    } offset;
    
    enum :char {
        SJFLCGFloatValue,
        SJFLCGPointValue,
        SJFLCGSizeValue,
        SJFLUIEdgeInsetsValue
    } offset_t;
    
    CGFloat multiplier; // default value is 1.0
    
    enum :char {
        SJFLPriorityRequired,
        SJFLPriorityFittingSize
    } priority;
}
- (instancetype)initWithView:(__weak UIView *)view attribute:(SJFLAttribute)attribute;
@property (nonatomic, readonly) SJFLAttribute attribute;
@property (nonatomic, weak, readonly, nullable) UIView *view;
@property (nonatomic, strong, readonly, nullable) SJFLAttributeUnit *equalToUnit;
- (void)equalTo:(__weak UIView *)view attribute:(SJFLAttribute)attribute;
- (void)equalTo:(SJFLAttributeUnit *)unit;
- (CGFloat)offset;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
+ (NSString *)debug_attributeToString:(SJFLAttribute)attribute;
@end
NS_ASSUME_NONNULL_END
