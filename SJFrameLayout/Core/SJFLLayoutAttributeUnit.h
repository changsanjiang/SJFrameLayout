//
//  SJFLLayoutAttributeUnit.h
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import <UIKit/UIKit.h>
#import "SJFLViewFrameAttribute.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLLayoutAttributeUnit : NSObject {
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
- (instancetype)initWithView:(UIView *)view attribute:(SJFLAttribute)attribute;
@property (nonatomic, readonly) SJFLAttribute attribute;
@property (nonatomic, weak, readonly, nullable) UIView *view;
@property (nonatomic, strong, readonly, nullable) SJFLViewFrameAttribute *equalToViewAttribute;
- (void)equalTo:(SJFLViewFrameAttribute *)viewAttribute;
- (CGFloat)offset;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
+ (NSString *)debug_attributeToString:(SJFLAttribute)attribute;
@end
NS_ASSUME_NONNULL_END
