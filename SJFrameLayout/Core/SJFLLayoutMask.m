//
//  SJFLLayoutMask.m
//  Pods
//
//  Created by 畅三江 on 2019/4/19.
//

#import "SJFLLayoutMask.h"
#import "UIView+SJFLAttributeUnits.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SJFLLayoutMask {
    SJFLAttributeMask _attrs;
    __weak UIView *_view;
}

- (instancetype)initWithView:(__weak UIView *)view attributes:(SJFLAttributeMask)attrs {
    self = [super init];
    if ( !self ) return nil;
    _view = view;
    _attrs = attrs;
    return self;
}
- (instancetype)initWithView:(__weak UIView *)view attribute:(SJFLAttribute)attr {
    return [self initWithView:view attributes:1 << attr];
}

- (SJFLLayoutMask *)top {
    _attrs |= SJFLAttributeMaskTop;
    return self;
}

- (SJFLLayoutMask *)left {
    _attrs |= SJFLAttributeMaskLeft;
    return self;
}

- (SJFLLayoutMask *)bottom {
    _attrs |= SJFLAttributeMaskBottom;
    return self;
}

- (SJFLLayoutMask *)right {
    _attrs |= SJFLAttributeMaskRight;
    return self;
}

- (SJFLLayoutMask *)edges {
    _attrs |= SJFLAttributeMaskEdges;
    return self;
}

- (SJFLLayoutMask *)width {
    _attrs |= SJFLAttributeMaskWidth;
    return self;
}

- (SJFLLayoutMask *)height {
    _attrs |= SJFLAttributeMaskHeight;
    return self;
}

- (SJFLLayoutMask *)size {
    _attrs |= SJFLAttributeMaskSize;
    return self;
}

- (SJFLLayoutMask *)centerX {
    _attrs |= SJFLAttributeMaskCenterX;
    return self;
}

- (SJFLLayoutMask *)centerY {
    _attrs |= SJFLAttributeMaskCenterY;
    return self;
}

- (SJFLLayoutMask *)center {
    _attrs |= SJFLAttributeMaskCenter;
    return self;
}

- (SJFLEqualToHandler)equalTo {
    return ^SJFLLayoutMask *(id box) {
        SJFLAttributeMask attributes = self->_attrs;
        UIView *view = self->_view;
        if      ( [box isKindOfClass:SJFLAttributeUnit.class] ) {
            SJFLAttributeUnit *unit = box;
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeTop) ) [view.FL_Top equalTo:unit];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeLeft) ) [view.FL_Left equalTo:unit];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeBottom) ) [view.FL_Bottom equalTo:unit];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeRight) ) [view.FL_Right equalTo:unit];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeWidth) ) [view.FL_Width equalTo:unit];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeHeight) ) [view.FL_Height equalTo:unit];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeCenterX) ) [view.FL_CenterX equalTo:unit];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeCenterY) ) [view.FL_CenterY equalTo:unit];
        }
        else if ( [box isKindOfClass:UIView.class] ) {
            UIView *dep_view = box;
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeTop) ) [view.FL_Top equalTo:dep_view.FL_Top];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeLeft) ) [view.FL_Left equalTo:dep_view.FL_Left];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeBottom) ) [view.FL_Bottom equalTo:dep_view.FL_Bottom];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeRight) ) [view.FL_Right equalTo:dep_view.FL_Right];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeWidth) ) [view.FL_Width equalTo:dep_view.FL_Width];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeHeight) ) [view.FL_Height equalTo:dep_view.FL_Height];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeCenterX) ) [view.FL_CenterX equalTo:dep_view.FL_CenterX];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeCenterY) ) [view.FL_CenterY equalTo:dep_view.FL_CenterY];
        }
        else {
            self.box_offset(box);
        }
        return self;
    };
}

- (SJFLEqualToHandler)box_equalTo {
    return self.equalTo;
}

- (SJFLOffsetHandler)offset {
    return ^(CGFloat offset) {
        SJFLAttributeMask attributes = self->_attrs;
        UIView *view = self->_view;
#define SET_FL_UNIT_OFFSET(__attr__, __unit__) \
if ( SJFLLayoutContainsAttribute(attributes, __attr__) ) { \
    __unit__->offset.value = offset; \
    __unit__->offset_t = FL_CGFloatValue; \
}
        SET_FL_UNIT_OFFSET(SJFLAttributeTop, view.FL_Top);
        SET_FL_UNIT_OFFSET(SJFLAttributeLeft, view.FL_Left);
        SET_FL_UNIT_OFFSET(SJFLAttributeBottom, view.FL_Bottom);
        SET_FL_UNIT_OFFSET(SJFLAttributeRight, view.FL_Right);
        SET_FL_UNIT_OFFSET(SJFLAttributeWidth, view.FL_Width);
        SET_FL_UNIT_OFFSET(SJFLAttributeHeight, view.FL_Height);
        SET_FL_UNIT_OFFSET(SJFLAttributeCenterX, view.FL_CenterX);
        SET_FL_UNIT_OFFSET(SJFLAttributeCenterY, view.FL_CenterY);
    };
}

- (SJFLBoxOffsetHandler)box_offset {
    return ^(NSValue *box) {
        if ( [box isKindOfClass:NSValue.class] ) {
            CGFloat floatValue = 0.0;
            CGPoint pointValue = CGPointZero;
            CGSize sizeValue = CGSizeZero;
            UIEdgeInsets insetsValue = UIEdgeInsetsZero;
            char t = FL_CGFloatValue;
            if      ( [box isKindOfClass:NSNumber.class] ) {
                t = FL_CGFloatValue;
                if (@available(iOS 11.0, *)) {
                    [box getValue:&floatValue size:sizeof(CGFloat)];
                } else {
                    [box getValue:&floatValue];
                }
            }
            else if (strcmp(box.objCType, @encode(CGPoint)) == 0) {
                t = FL_CGPointValue;
                if (@available(iOS 11.0, *)) {
                    [box getValue:&pointValue size:sizeof(CGPoint)];
                } else {
                    [box getValue:&pointValue];
                }
            }
            else if (strcmp(box.objCType, @encode(CGSize)) == 0) {
                t = FL_CGSizeValue;
                if (@available(iOS 11.0, *)) {
                    [box getValue:&sizeValue size:sizeof(CGSize)];
                } else {
                    [box getValue:&sizeValue];
                }
            }
            else if (strcmp(box.objCType, @encode(UIEdgeInsets)) == 0) {
                t = FL_UIEdgeInsetsValue;
                if (@available(iOS 11.0, *)) {
                    [box getValue:&insetsValue size:sizeof(UIEdgeInsets)];
                } else {
                    [box getValue:&insetsValue];
                }
            }

            SJFLAttributeMask attributes = self->_attrs;
            UIView *view = self->_view;

#define SET_FL_UNIT_BOX_OFFSET(__attr__, __unit__) \
            if ( SJFLLayoutContainsAttribute(attributes, __attr__) ) { \
                SJFLAttributeUnit *unit = __unit__; \
                unit->offset_t = t; \
                switch ( unit->offset_t ) {  \
                    case FL_CGFloatValue: \
                        unit->offset.value = floatValue; \
                        break;  \
                    case FL_CGPointValue: \
                        unit->offset.point = pointValue; \
                        break; \
                    case FL_CGSizeValue: \
                        unit->offset.size = sizeValue; \
                        break; \
                    case FL_UIEdgeInsetsValue: \
                        unit->offset.edges = insetsValue; \
                        break;  \
                }   \
            }
            
            SET_FL_UNIT_BOX_OFFSET(SJFLAttributeTop, view.FL_Top);
            SET_FL_UNIT_BOX_OFFSET(SJFLAttributeLeft, view.FL_Left);
            SET_FL_UNIT_BOX_OFFSET(SJFLAttributeBottom, view.FL_Bottom);
            SET_FL_UNIT_BOX_OFFSET(SJFLAttributeRight, view.FL_Right);
            SET_FL_UNIT_BOX_OFFSET(SJFLAttributeWidth, view.FL_Width);
            SET_FL_UNIT_BOX_OFFSET(SJFLAttributeHeight, view.FL_Height);
            SET_FL_UNIT_BOX_OFFSET(SJFLAttributeCenterX, view.FL_CenterX);
            SET_FL_UNIT_BOX_OFFSET(SJFLAttributeCenterY, view.FL_CenterY);
        }
    };
}

UIKIT_STATIC_INLINE BOOL SJFLLayoutContainsAttribute(SJFLAttributeMask attrs, SJFLAttribute attr) {
    return attrs & (1 << attr);
}
@end
NS_ASSUME_NONNULL_END
