//
//  SJFLLayoutAttributeUnit.h
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import <UIKit/UIKit.h>
#import "SJFLFrameAttributeUnit.h"
#import "SJFLLayoutAttributesDefines.h"

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
- (instancetype)initWithView:(UIView *)view attribute:(SJFLLayoutAttribute)attribute;
@property (nonatomic, readonly) SJFLLayoutAttribute attribute;
@property (nonatomic, weak, readonly, nullable) UIView *view;
@property (nonatomic, strong, readonly, nullable) SJFLFrameAttributeUnit *equalToViewAttribute;
- (void)equalTo:(SJFLFrameAttributeUnit *)viewAttribute;
- (CGFloat)offset;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
+ (NSString *)debug_attributeToString:(SJFLLayoutAttribute)attribute;
@end
NS_ASSUME_NONNULL_END
