//
//  SJFLAttributeUnit.m
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "SJFLAttributeUnit.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SJFLAttributeUnit
+ (NSString *)debug_attributeToString:(SJFLAttribute)attribute {
    switch ( attribute ) {
        case SJFLAttributeNone:
            return @"SJFLAttributeNone";
        case SJFLAttributeTop:
            return @"SJFLAttributeTop";
        case SJFLAttributeLeft:
            return @"SJFLAttributeLeft";
        case SJFLAttributeBottom:
            return @"SJFLAttributeBottom";
        case SJFLAttributeRight:
            return @"SJFLAttributeRight";
        case SJFLAttributeWidth:
            return @"SJFLAttributeWidth";
        case SJFLAttributeHeight:
            return @"SJFLAttributeHeight";
        case SJFLAttributeCenterX:
            return @"SJFLAttributeCenterX";
        case SJFLAttributeCenterY:
            return @"SJFLAttributeCenterY";
    }
}

- (instancetype)initWithView:(__weak UIView *)view attribute:(SJFLAttribute)attribute {
    self = [super init];
    if ( !self ) return nil;
    _attribute = attribute;
    _view = view;
    return self;
}

- (void)equalTo:(__weak UIView *)view attribute:(SJFLAttribute)attribute {
    _equalToUnit = [[SJFLAttributeUnit alloc] initWithView:view attribute:attribute];
}
- (void)equalTo:(SJFLAttributeUnit *)unit {
    _equalToUnit = unit;
}
- (CGFloat)offset {
    if ( offset_t == FL_CGFloatValue ) {
        return offset.value;
    }
    
    SJFLAttribute attr = _equalToUnit.attribute;
    CGFloat value = 0;
    switch ( attr ) {
        case SJFLAttributeNone: {
            value = offset.value;
        }
            break;
        case SJFLAttributeTop: {
            value = offset.value;
        }
            break;
        case SJFLAttributeLeft: {
            switch ( offset_t ) {
                case FL_CGFloatValue:
                case FL_CGPointValue:
                case FL_CGSizeValue: {
                    value = offset.value;
                }
                    break;
                case FL_UIEdgeInsetsValue: {
                    value = offset.edges.left;
                }
                    break;
            }
        }
            break;
        case SJFLAttributeBottom: {
            switch ( offset_t ) {
                case FL_CGFloatValue:
                case FL_CGPointValue:
                case FL_CGSizeValue: {
                    value = offset.value;
                }
                    break;
                case FL_UIEdgeInsetsValue: {
                    value = offset.edges.bottom;
                }
                    break;
            }
        }
            break;
        case SJFLAttributeRight: {
            switch ( offset_t ) {
                case FL_CGFloatValue:
                case FL_CGPointValue:
                case FL_CGSizeValue: {
                    value = offset.value;
                }
                    break;
                case FL_UIEdgeInsetsValue: {
                    value = offset.edges.right;
                }
                    break;
            }
        }
            break;
        case SJFLAttributeWidth: {
            switch ( offset_t ) {
                case FL_CGFloatValue:
                case FL_CGPointValue:
                case FL_UIEdgeInsetsValue: {
                    value = offset.value;
                }
                    break;
                case FL_CGSizeValue: {
                    value = offset.size.width;
                }
                    break;
            }
        }
            break;
        case SJFLAttributeHeight: {
            switch ( offset_t ) {
                case FL_CGFloatValue:
                case FL_CGPointValue:
                case FL_UIEdgeInsetsValue: {
                    value = offset.value;
                }
                    break;
                case FL_CGSizeValue: {
                    value = offset.size.height;
                }
                    break;
            }
        }
            break;
        case SJFLAttributeCenterX: {
            switch ( offset_t ) {
                case FL_CGFloatValue:
                case FL_CGSizeValue:
                case FL_UIEdgeInsetsValue: {
                    value = offset.value;
                }
                    break;
                case FL_CGPointValue: {
                    value = offset.point.x;
                }
                    break;
            }
        }
            break;
        case SJFLAttributeCenterY: {
            switch ( offset_t ) {
                case FL_CGFloatValue:
                case FL_CGSizeValue:
                case FL_UIEdgeInsetsValue: {
                    value = offset.value;
                }
                    break;
                case FL_CGPointValue: {
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
