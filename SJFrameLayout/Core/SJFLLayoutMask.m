//
//  SJFLLayoutMask.m
//  Pods
//
//  Created by 畅三江 on 2019/4/19.
//

#import "SJFLLayoutMask.h"
#import "UIView+SJFLLayoutAttributeUnits.h"
#import "UIView+SJFLFrameAttributeUnits.h"
#import "SJFLAttributesDefines.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SJFLLayoutMask {
    SJFLLayoutAttributeMask _attrs;
    __weak UIView *_Nullable _view;
}

static Class SJFLFrameAttributeUnitClass;
static Class SJFLArrayClass;
static Class SJFLViewClass;

+ (void)initialize {
    SJFLFrameAttributeUnitClass = SJFLFrameAttributeUnit.class;
    SJFLArrayClass = NSArray.class;
    SJFLViewClass = UIView.class;
}

- (instancetype)initWithView:(UIView *)view attributes:(SJFLLayoutAttributeMask)attrs {
    self = [super init];
    if ( !self ) return nil;
    _view = view;
    _attrs = attrs;
    return self;
}
- (instancetype)initWithView:(UIView *)view attribute:(SJFLLayoutAttribute)attr {
    return [self initWithView:view attributes:1 << attr];
}

- (SJFLLayoutMask *)top {
    _attrs |= SJFLLayoutAttributeMaskTop;
    return self;
}

- (SJFLLayoutMask *)left {
    _attrs |= SJFLLayoutAttributeMaskLeft;
    return self;
}

- (SJFLLayoutMask *)bottom {
    _attrs |= SJFLLayoutAttributeMaskBottom;
    return self;
}

- (SJFLLayoutMask *)right {
    _attrs |= SJFLLayoutAttributeMaskRight;
    return self;
}

- (SJFLLayoutMask *)edges {
    _attrs |= SJFLLayoutAttributeMaskEdges;
    return self;
}

- (SJFLLayoutMask *)width {
    _attrs |= SJFLLayoutAttributeMaskWidth;
    return self;
}

- (SJFLLayoutMask *)height {
    _attrs |= SJFLLayoutAttributeMaskHeight;
    return self;
}

- (SJFLLayoutMask *)size {
    _attrs |= SJFLLayoutAttributeMaskSize;
    return self;
}

- (SJFLLayoutMask *)centerX {
    _attrs |= SJFLLayoutAttributeMaskCenterX;
    return self;
}

- (SJFLLayoutMask *)centerY {
    _attrs |= SJFLLayoutAttributeMaskCenterY;
    return self;
}

- (SJFLLayoutMask *)center {
    _attrs |= SJFLLayoutAttributeMaskCenter;
    return self;
}

- (SJFLEqualToHandler)equalTo {
    return ^SJFLLayoutMask *(id box) {
        SJFLLayoutAttributeMask attributes = self->_attrs;
        UIView *view = self->_view;
        if      ( [box isKindOfClass:SJFLFrameAttributeUnitClass] ) {
            SJFLFrameAttributeUnit *unit = box;
            if ( SJFLLayoutContainsAttribute(attributes, SJFLLayoutAttributeTop) ) view.FL_topUnit->equalToViewAttribute = unit;
            if ( SJFLLayoutContainsAttribute(attributes, SJFLLayoutAttributeLeft) ) view.FL_leftUnit->equalToViewAttribute = unit;
            if ( SJFLLayoutContainsAttribute(attributes, SJFLLayoutAttributeBottom) ) view.FL_bottomUnit->equalToViewAttribute = unit;
            if ( SJFLLayoutContainsAttribute(attributes, SJFLLayoutAttributeRight) ) view.FL_rightUnit->equalToViewAttribute = unit;
            if ( SJFLLayoutContainsAttribute(attributes, SJFLLayoutAttributeWidth) ) view.FL_widthUnit->equalToViewAttribute = unit;
            if ( SJFLLayoutContainsAttribute(attributes, SJFLLayoutAttributeHeight) ) view.FL_heightUnit->equalToViewAttribute = unit;
            if ( SJFLLayoutContainsAttribute(attributes, SJFLLayoutAttributeCenterX) ) view.FL_centerXUnit->equalToViewAttribute = unit;
            if ( SJFLLayoutContainsAttribute(attributes, SJFLLayoutAttributeCenterY) ) view.FL_centerYUnit->equalToViewAttribute = unit;
        }
        else if ( [box isKindOfClass:SJFLViewClass] ) {
            UIView *dep_view = box;
            if ( SJFLLayoutContainsAttribute(attributes, SJFLLayoutAttributeTop) ) view.FL_topUnit->equalToViewAttribute = dep_view.FL_top;
            if ( SJFLLayoutContainsAttribute(attributes, SJFLLayoutAttributeLeft) ) view.FL_leftUnit->equalToViewAttribute = dep_view.FL_left;
            if ( SJFLLayoutContainsAttribute(attributes, SJFLLayoutAttributeBottom) ) view.FL_bottomUnit->equalToViewAttribute = dep_view.FL_bottom;
            if ( SJFLLayoutContainsAttribute(attributes, SJFLLayoutAttributeRight) ) view.FL_rightUnit->equalToViewAttribute = dep_view.FL_right;
            if ( SJFLLayoutContainsAttribute(attributes, SJFLLayoutAttributeWidth) ) view.FL_widthUnit->equalToViewAttribute = dep_view.FL_width;
            if ( SJFLLayoutContainsAttribute(attributes, SJFLLayoutAttributeHeight) ) view.FL_heightUnit->equalToViewAttribute = dep_view.FL_height;
            if ( SJFLLayoutContainsAttribute(attributes, SJFLLayoutAttributeCenterX) ) view.FL_centerXUnit->equalToViewAttribute = dep_view.FL_centerX;
            if ( SJFLLayoutContainsAttribute(attributes, SJFLLayoutAttributeCenterY) ) view.FL_centerYUnit->equalToViewAttribute = dep_view.FL_centerY;
        }
        else if ( [box isKindOfClass:SJFLArrayClass] ) {
            for ( SJFLFrameAttributeUnit *unit in (NSArray *)box ) {
                SJFLLayoutAttribute layoutAttribute = SJFLLayoutAttributeForFrameAttribute(unit.attribute);
                SJFLLayoutAttributeUnit *layoutUnit = [view FL_requestAttributeUnitForAttribute:layoutAttribute];
                if ( layoutUnit != nil )  layoutUnit->equalToViewAttribute = unit;
            }
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
        SJFLLayoutAttributeMask attributes = self->_attrs;
        UIView *view = self->_view;
#define SET_FL_UNIT_OFFSET(__attr__, __unit__) \
if ( SJFLLayoutContainsAttribute(attributes, __attr__) ) { \
    __unit__->offset.value = offset; \
    __unit__->offset_t = SJFLCGFloatValue; \
}
        SET_FL_UNIT_OFFSET(SJFLLayoutAttributeTop, view.FL_topUnit);
        SET_FL_UNIT_OFFSET(SJFLLayoutAttributeLeft, view.FL_leftUnit);
        SET_FL_UNIT_OFFSET(SJFLLayoutAttributeBottom, view.FL_bottomUnit);
        SET_FL_UNIT_OFFSET(SJFLLayoutAttributeRight, view.FL_rightUnit);
        SET_FL_UNIT_OFFSET(SJFLLayoutAttributeWidth, view.FL_widthUnit);
        SET_FL_UNIT_OFFSET(SJFLLayoutAttributeHeight, view.FL_heightUnit);
        SET_FL_UNIT_OFFSET(SJFLLayoutAttributeCenterX, view.FL_centerXUnit);
        SET_FL_UNIT_OFFSET(SJFLLayoutAttributeCenterY, view.FL_centerYUnit);
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

            SJFLLayoutAttributeMask attributes = self->_attrs;
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
            
            SET_FL_UNIT_BOX_OFFSET(SJFLLayoutAttributeTop, view.FL_topUnit);
            SET_FL_UNIT_BOX_OFFSET(SJFLLayoutAttributeLeft, view.FL_leftUnit);
            SET_FL_UNIT_BOX_OFFSET(SJFLLayoutAttributeBottom, view.FL_bottomUnit);
            SET_FL_UNIT_BOX_OFFSET(SJFLLayoutAttributeRight, view.FL_rightUnit);
            SET_FL_UNIT_BOX_OFFSET(SJFLLayoutAttributeWidth, view.FL_widthUnit);
            SET_FL_UNIT_BOX_OFFSET(SJFLLayoutAttributeHeight, view.FL_heightUnit);
            SET_FL_UNIT_BOX_OFFSET(SJFLLayoutAttributeCenterX, view.FL_centerXUnit);
            SET_FL_UNIT_BOX_OFFSET(SJFLLayoutAttributeCenterY, view.FL_centerYUnit);
        }
    };
}

- (SJFLMultiplierHandler)multipliedBy {
    return ^SJFLLayoutMask *(CGFloat multiplier) {
        SJFLLayoutAttributeMask attributes = self->_attrs;
        UIView *view = self->_view;
#define SET_FL_UNIT_MULTIPLIER(__attr__, __unit__) \
if ( SJFLLayoutContainsAttribute(attributes, __attr__) ) { \
    __unit__->multiplier = multiplier; \
}
        SET_FL_UNIT_MULTIPLIER(SJFLLayoutAttributeTop, view.FL_topUnit);
        SET_FL_UNIT_MULTIPLIER(SJFLLayoutAttributeLeft, view.FL_leftUnit);
        SET_FL_UNIT_MULTIPLIER(SJFLLayoutAttributeBottom, view.FL_bottomUnit);
        SET_FL_UNIT_MULTIPLIER(SJFLLayoutAttributeRight, view.FL_rightUnit);
        SET_FL_UNIT_MULTIPLIER(SJFLLayoutAttributeWidth, view.FL_widthUnit);
        SET_FL_UNIT_MULTIPLIER(SJFLLayoutAttributeHeight, view.FL_heightUnit);
        SET_FL_UNIT_MULTIPLIER(SJFLLayoutAttributeCenterX, view.FL_centerXUnit);
        SET_FL_UNIT_MULTIPLIER(SJFLLayoutAttributeCenterY, view.FL_centerYUnit);
        
        return self;
    };
}

UIKIT_STATIC_INLINE BOOL SJFLLayoutContainsAttribute(SJFLLayoutAttributeMask attrs, SJFLLayoutAttribute attr) {
    return attrs & (1 << attr);
}
@end
NS_ASSUME_NONNULL_END
