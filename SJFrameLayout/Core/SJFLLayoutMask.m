//
//  SJFLLayoutMask.m
//  Pods
//
//  Created by 畅三江 on 2019/4/19.
//

#import "SJFLLayoutMask.h"
#import "UIView+SJFLLayoutAttributeUnits.h"
#import "UIView+SJFLViewFrameAttributes.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SJFLLayoutMask {
    SJFLAttributeMask _attrs;
    __weak UIView *_view;
}

- (instancetype)initWithView:(UIView *)view attributes:(SJFLAttributeMask)attrs {
    self = [super init];
    if ( !self ) return nil;
    _view = view;
    _attrs = attrs;
    return self;
}
- (instancetype)initWithView:(UIView *)view attribute:(SJFLAttribute)attr {
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
        if      ( [box isKindOfClass:SJFLViewFrameAttribute.class] ) {
            SJFLViewFrameAttribute *attribute = box;
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeTop) ) [view.FL_topUnit equalTo:attribute];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeLeft) ) [view.FL_leftUnit equalTo:attribute];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeBottom) ) [view.FL_bottomUnit equalTo:attribute];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeRight) ) [view.FL_rightUnit equalTo:attribute];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeWidth) ) [view.FL_widthUnit equalTo:attribute];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeHeight) ) [view.FL_heightUnit equalTo:attribute];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeCenterX) ) [view.FL_centerXUnit equalTo:attribute];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeCenterY) ) [view.FL_centerYUnit equalTo:attribute];
        }
        else if ( [box isKindOfClass:UIView.class] ) {
            UIView *dep_view = box;
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeTop) ) [view.FL_topUnit equalTo:dep_view.FL_top];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeLeft) ) [view.FL_leftUnit equalTo:dep_view.FL_left];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeBottom) ) [view.FL_bottomUnit equalTo:dep_view.FL_bottom];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeRight) ) [view.FL_rightUnit equalTo:dep_view.FL_right];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeWidth) ) [view.FL_widthUnit equalTo:dep_view.FL_width];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeHeight) ) [view.FL_heightUnit equalTo:dep_view.FL_height];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeCenterX) ) [view.FL_centerXUnit equalTo:dep_view.FL_centerX];
            if ( SJFLLayoutContainsAttribute(attributes, SJFLAttributeCenterY) ) [view.FL_centerYUnit equalTo:dep_view.FL_centerY];
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
    __unit__->offset_t = SJFLCGFloatValue; \
}
        SET_FL_UNIT_OFFSET(SJFLAttributeTop, view.FL_topUnit);
        SET_FL_UNIT_OFFSET(SJFLAttributeLeft, view.FL_leftUnit);
        SET_FL_UNIT_OFFSET(SJFLAttributeBottom, view.FL_bottomUnit);
        SET_FL_UNIT_OFFSET(SJFLAttributeRight, view.FL_rightUnit);
        SET_FL_UNIT_OFFSET(SJFLAttributeWidth, view.FL_widthUnit);
        SET_FL_UNIT_OFFSET(SJFLAttributeHeight, view.FL_heightUnit);
        SET_FL_UNIT_OFFSET(SJFLAttributeCenterX, view.FL_centerXUnit);
        SET_FL_UNIT_OFFSET(SJFLAttributeCenterY, view.FL_centerYUnit);
    };
}

- (SJFLBoxOffsetHandler)box_offset {
    return ^(NSValue *box) {
        if ( [box isKindOfClass:NSValue.class] ) {
            CGFloat floatValue = 0.0;
            CGPoint pointValue = CGPointZero;
            CGSize sizeValue = CGSizeZero;
            UIEdgeInsets insetsValue = UIEdgeInsetsZero;
            char t = SJFLCGFloatValue;
            if      ( [box isKindOfClass:NSNumber.class] ) {
                t = SJFLCGFloatValue;
                if (@available(iOS 11.0, *)) {
                    [box getValue:&floatValue size:sizeof(CGFloat)];
                } else {
                    [box getValue:&floatValue];
                }
            }
            else if (strcmp(box.objCType, @encode(CGPoint)) == 0) {
                t = SJFLCGPointValue;
                if (@available(iOS 11.0, *)) {
                    [box getValue:&pointValue size:sizeof(CGPoint)];
                } else {
                    [box getValue:&pointValue];
                }
            }
            else if (strcmp(box.objCType, @encode(CGSize)) == 0) {
                t = SJFLCGSizeValue;
                if (@available(iOS 11.0, *)) {
                    [box getValue:&sizeValue size:sizeof(CGSize)];
                } else {
                    [box getValue:&sizeValue];
                }
            }
            else if (strcmp(box.objCType, @encode(UIEdgeInsets)) == 0) {
                t = SJFLUIEdgeInsetsValue;
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
                SJFLLayoutAttributeUnit *unit = __unit__; \
                unit->offset_t = t; \
                switch ( unit->offset_t ) {  \
                    case SJFLCGFloatValue: \
                        unit->offset.value = floatValue; \
                        break;  \
                    case SJFLCGPointValue: \
                        unit->offset.point = pointValue; \
                        break; \
                    case SJFLCGSizeValue: \
                        unit->offset.size = sizeValue; \
                        break; \
                    case SJFLUIEdgeInsetsValue: \
                        unit->offset.edges = insetsValue; \
                        break;  \
                }   \
            }
            
            SET_FL_UNIT_BOX_OFFSET(SJFLAttributeTop, view.FL_topUnit);
            SET_FL_UNIT_BOX_OFFSET(SJFLAttributeLeft, view.FL_leftUnit);
            SET_FL_UNIT_BOX_OFFSET(SJFLAttributeBottom, view.FL_bottomUnit);
            SET_FL_UNIT_BOX_OFFSET(SJFLAttributeRight, view.FL_rightUnit);
            SET_FL_UNIT_BOX_OFFSET(SJFLAttributeWidth, view.FL_widthUnit);
            SET_FL_UNIT_BOX_OFFSET(SJFLAttributeHeight, view.FL_heightUnit);
            SET_FL_UNIT_BOX_OFFSET(SJFLAttributeCenterX, view.FL_centerXUnit);
            SET_FL_UNIT_BOX_OFFSET(SJFLAttributeCenterY, view.FL_centerYUnit);
        }
    };
}

- (SJFLMultiplierHandler)multipliedBy {
    return ^SJFLLayoutMask *(CGFloat multiplier) {
        SJFLAttributeMask attributes = self->_attrs;
        UIView *view = self->_view;
#define SET_FL_UNIT_MULTIPLIER(__attr__, __unit__) \
if ( SJFLLayoutContainsAttribute(attributes, __attr__) ) { \
    __unit__->multiplier = multiplier; \
}
        SET_FL_UNIT_MULTIPLIER(SJFLAttributeTop, view.FL_topUnit);
        SET_FL_UNIT_MULTIPLIER(SJFLAttributeLeft, view.FL_leftUnit);
        SET_FL_UNIT_MULTIPLIER(SJFLAttributeBottom, view.FL_bottomUnit);
        SET_FL_UNIT_MULTIPLIER(SJFLAttributeRight, view.FL_rightUnit);
        SET_FL_UNIT_MULTIPLIER(SJFLAttributeWidth, view.FL_widthUnit);
        SET_FL_UNIT_MULTIPLIER(SJFLAttributeHeight, view.FL_heightUnit);
        SET_FL_UNIT_MULTIPLIER(SJFLAttributeCenterX, view.FL_centerXUnit);
        SET_FL_UNIT_MULTIPLIER(SJFLAttributeCenterY, view.FL_centerYUnit);
        
        return self;
    };
}

UIKIT_STATIC_INLINE BOOL SJFLLayoutContainsAttribute(SJFLAttributeMask attrs, SJFLAttribute attr) {
    return attrs & (1 << attr);
}
@end
NS_ASSUME_NONNULL_END
