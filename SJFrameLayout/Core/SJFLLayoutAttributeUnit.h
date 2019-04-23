//
//  SJFLLayoutAttributeUnit.h
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import <UIKit/UIKit.h>
#import "SJFLViewFrameAttribute.h"

NS_ASSUME_NONNULL_BEGIN
typedef NSString *SJFLAttributeKey;
static SJFLAttributeKey const SJFLAttributeKeyNone = @"N";
static SJFLAttributeKey const SJFLAttributeKeyTop = @"T";
static SJFLAttributeKey const SJFLAttributeKeyLeft = @"L";
static SJFLAttributeKey const SJFLAttributeKeyBottom = @"B";
static SJFLAttributeKey const SJFLAttributeKeyRight = @"R";
static SJFLAttributeKey const SJFLAttributeKeyWidth = @"W";
static SJFLAttributeKey const SJFLAttributeKeyHeight = @"H";
static SJFLAttributeKey const SJFLAttributeKeyCenterX = @"CX";
static SJFLAttributeKey const SJFLAttributeKeyCenterY = @"CY";

UIKIT_STATIC_INLINE
//SJFLAttributeKey SJFLAttributeKeyForAttribute(SJFLAttribute attribtue) {
//    switch ( attribtue ) {
//        case SJFLAttributeNone:
//            return SJFLAttributeKeyNone;
//        case SJFLAttributeTop:
//            return SJFLAttributeKeyTop;
//        case SJFLAttributeLeft:
//            return SJFLAttributeKeyLeft;
//        case SJFLAttributeBottom:
//            return SJFLAttributeKeyBottom;
//        case SJFLAttributeRight:
//            return SJFLAttributeKeyRight;
//        case SJFLAttributeWidth:
//            return SJFLAttributeKeyWidth;
//        case SJFLAttributeHeight:
//            return SJFLAttributeKeyHeight;
//        case SJFLAttributeCenterX:
//            return SJFLAttributeKeyCenterX;
//        case SJFLAttributeCenterY:
//            return SJFLAttributeKeyCenterY;
//    }
//}

//UIKIT_STATIC_INLINE
//SJFLAttribute SJFLAttributeForAttributeKey(SJFLAttributeKey key) {
//    if ( key == SJFLAttributeKeyNone ) return SJFLAttributeNone;
//    if ( key == SJFLAttributeKeyTop ) return SJFLAttributeTop;
//    if ( key == SJFLAttributeKeyLeft ) return SJFLAttributeLeft;
//    if ( key == SJFLAttributeKeyBottom ) return SJFLAttributeBottom;
//    if ( key == SJFLAttributeKeyRight ) return SJFLAttributeRight;
//    if ( key == SJFLAttributeKeyWidth ) return SJFLAttributeWidth;
//    if ( key == SJFLAttributeKeyHeight ) return SJFLAttributeHeight;
//    if ( key == SJFLAttributeKeyCenterX ) return SJFLAttributeCenterX;
//    if ( key == SJFLAttributeKeyCenterY ) return SJFLAttributeCenterY;
//    return 0;
//}

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
