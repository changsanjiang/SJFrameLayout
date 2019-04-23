//
//  SJFLLayoutAttributeUnit.m
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "SJFLLayoutAttributeUnit.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SJFLLayoutAttributeUnit
+ (NSString *)debug_attributeToString:(SJFLLayoutAttribute)attribute {
    switch ( attribute ) {
        case SJFLLayoutAttributeNone:
            return @"SJFLLayoutAttributeNone";
        case SJFLLayoutAttributeTop:
            return @"SJFLLayoutAttributeTop";
        case SJFLLayoutAttributeLeft:
            return @"SJFLLayoutAttributeLeft";
        case SJFLLayoutAttributeBottom:
            return @"SJFLLayoutAttributeBottom";
        case SJFLLayoutAttributeRight:
            return @"SJFLLayoutAttributeRight";
        case SJFLLayoutAttributeWidth:
            return @"SJFLLayoutAttributeWidth";
        case SJFLLayoutAttributeHeight:
            return @"SJFLLayoutAttributeHeight";
        case SJFLLayoutAttributeCenterX:
            return @"SJFLLayoutAttributeCenterX";
        case SJFLLayoutAttributeCenterY:
            return @"SJFLLayoutAttributeCenterY";
    }
}

- (instancetype)initWithView:(UIView *)view attribute:(SJFLLayoutAttribute)attribute {
    self = [super init];
    if ( !self ) return nil;
    _attribute = attribute;
    _view = view;
    self->multiplier = 1.0;
    return self;
}
- (void)equalTo:(SJFLFrameAttributeUnit *)viewAttribute {
    _equalToViewAttribute = viewAttribute;
}
- (CGFloat)offset {
    if ( offset_t == SJFLCGFloatValue ) {
        return offset.value;
    }
    
    SJFLFrameAttribute attr = _equalToViewAttribute.attribute;
    CGFloat value = 0;
    switch ( attr ) {
        case SJFLFrameAttributeNone: {
            value = offset.value;
        }
            break;
        case SJFLFrameAttributeSafeTop:
        case SJFLFrameAttributeTop: {
            value = offset.value;
        }
            break;
        case SJFLFrameAttributeSafeLeft:
        case SJFLFrameAttributeLeft: {
            switch ( offset_t ) {
                case SJFLCGFloatValue:
                case SJFLCGPointValue:
                case SJFLCGSizeValue: {
                    value = offset.value;
                }
                    break;
                case SJFLUIEdgeInsetsValue: {
                    value = offset.edges.left;
                }
                    break;
            }
        }
            break;
        case SJFLFrameAttributeSafeBottom:
        case SJFLFrameAttributeBottom: {
            switch ( offset_t ) {
                case SJFLCGFloatValue:
                case SJFLCGPointValue:
                case SJFLCGSizeValue: {
                    value = offset.value;
                }
                    break;
                case SJFLUIEdgeInsetsValue: {
                    value = -offset.edges.bottom;
                }
                    break;
            }
        }
            break;
        case SJFLFrameAttributeSafeRight:
        case SJFLFrameAttributeRight: {
            switch ( offset_t ) {
                case SJFLCGFloatValue:
                case SJFLCGPointValue:
                case SJFLCGSizeValue: {
                    value = offset.value;
                }
                    break;
                case SJFLUIEdgeInsetsValue: {
                    value = -offset.edges.right;
                }
                    break;
            }
        }
            break;
        case SJFLFrameAttributeWidth: {
            switch ( offset_t ) {
                case SJFLCGFloatValue:
                case SJFLCGPointValue:
                case SJFLUIEdgeInsetsValue: {
                    value = offset.value;
                }
                    break;
                case SJFLCGSizeValue: {
                    value = offset.size.width;
                }
                    break;
            }
        }
            break;
        case SJFLFrameAttributeHeight: {
            switch ( offset_t ) {
                case SJFLCGFloatValue:
                case SJFLCGPointValue:
                case SJFLUIEdgeInsetsValue: {
                    value = offset.value;
                }
                    break;
                case SJFLCGSizeValue: {
                    value = offset.size.height;
                }
                    break;
            }
        }
            break;
        case SJFLFrameAttributeCenterX: {
            switch ( offset_t ) {
                case SJFLCGFloatValue:
                case SJFLCGSizeValue:
                case SJFLUIEdgeInsetsValue: {
                    value = offset.value;
                }
                    break;
                case SJFLCGPointValue: {
                    value = offset.point.x;
                }
                    break;
            }
        }
            break;
        case SJFLFrameAttributeCenterY: {
            switch ( offset_t ) {
                case SJFLCGFloatValue:
                case SJFLCGSizeValue:
                case SJFLUIEdgeInsetsValue: {
                    value = offset.value;
                }
                    break;
                case SJFLCGPointValue: {
                    value = offset.point.y;
                }
                    break;
            }
        }
            break;
    }
    
    return value;
}
@end
NS_ASSUME_NONNULL_END
