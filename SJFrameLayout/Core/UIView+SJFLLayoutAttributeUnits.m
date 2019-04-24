//
//  UIView+SJFLLayoutAttributeUnits.m
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "UIView+SJFLLayoutAttributeUnits.h"
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN
@implementation UIView (SJFLLayoutAttributeUnits)
static SEL FL_topUnit;
static SEL FL_leftUnit;
static SEL FL_bottomUnit;
static SEL FL_rightUnit;
static SEL FL_widthUnit;
static SEL FL_heightUnit;
static SEL FL_centerXUnit;
static SEL FL_centerYUnit;
UIKIT_STATIC_INLINE void FL_selectorsInit(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FL_topUnit = @selector(FL_topUnit);
        FL_leftUnit = @selector(FL_leftUnit);
        FL_bottomUnit = @selector(FL_bottomUnit);
        FL_rightUnit = @selector(FL_rightUnit);
        FL_widthUnit = @selector(FL_widthUnit);
        FL_heightUnit = @selector(FL_heightUnit);
        FL_centerXUnit = @selector(FL_centerXUnit);
        FL_centerYUnit = @selector(FL_centerYUnit);
    });
}
#define RETURN_FL_ATTR_UNIT(__attr__) \
SJFLLayoutAttributeUnit *_Nullable unit = objc_getAssociatedObject(self, _cmd); \
if ( !unit ) { \
    unit = [[SJFLLayoutAttributeUnit alloc] initWithView:self attribute:__attr__]; \
    objc_setAssociatedObject(self, _cmd, unit, OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
} \
return unit;
- (SJFLLayoutAttributeUnit *)FL_topUnit {
    RETURN_FL_ATTR_UNIT(SJFLLayoutAttributeTop);
}
- (SJFLLayoutAttributeUnit *)FL_leftUnit {
    RETURN_FL_ATTR_UNIT(SJFLLayoutAttributeLeft);
}
- (SJFLLayoutAttributeUnit *)FL_bottomUnit {
    RETURN_FL_ATTR_UNIT(SJFLLayoutAttributeBottom);
}
- (SJFLLayoutAttributeUnit *)FL_rightUnit {
    RETURN_FL_ATTR_UNIT(SJFLLayoutAttributeRight);
}
- (SJFLLayoutAttributeUnit *)FL_widthUnit {
    RETURN_FL_ATTR_UNIT(SJFLLayoutAttributeWidth);
}
- (SJFLLayoutAttributeUnit *)FL_heightUnit {
    RETURN_FL_ATTR_UNIT(SJFLLayoutAttributeHeight);
}
- (SJFLLayoutAttributeUnit *)FL_centerXUnit {
    RETURN_FL_ATTR_UNIT(SJFLLayoutAttributeCenterX);
}
- (SJFLLayoutAttributeUnit *)FL_centerYUnit {
    RETURN_FL_ATTR_UNIT(SJFLLayoutAttributeCenterY);
}
- (SJFLLayoutAttributeUnit *_Nullable)FL_attributeUnitForAttribute:(SJFLLayoutAttribute)attr {
    FL_selectorsInit();
    switch ( attr ) {
        case SJFLLayoutAttributeNone:
            break;
        case SJFLLayoutAttributeTop:
            return objc_getAssociatedObject(self, FL_topUnit);
        case SJFLLayoutAttributeLeft:
            return objc_getAssociatedObject(self, FL_leftUnit);
        case SJFLLayoutAttributeBottom:
            return objc_getAssociatedObject(self, FL_bottomUnit);
        case SJFLLayoutAttributeRight:
            return objc_getAssociatedObject(self, FL_rightUnit);
        case SJFLLayoutAttributeWidth:
            return objc_getAssociatedObject(self, FL_widthUnit);
        case SJFLLayoutAttributeHeight:
            return objc_getAssociatedObject(self, FL_heightUnit);
        case SJFLLayoutAttributeCenterX:
            return objc_getAssociatedObject(self, FL_centerXUnit);
        case SJFLLayoutAttributeCenterY:
            return objc_getAssociatedObject(self, FL_centerYUnit);
    }
    return nil;
}
- (SJFLLayoutAttributeUnit *)FL_requestAttributeUnitForAttribute:(SJFLLayoutAttribute)attr {
    switch ( attr ) {
        case SJFLLayoutAttributeNone:
            return [[SJFLLayoutAttributeUnit alloc] initWithView:self attribute:SJFLLayoutAttributeNone];
        case SJFLLayoutAttributeTop:
            return self.FL_topUnit;
        case SJFLLayoutAttributeLeft:
            return self.FL_leftUnit;
        case SJFLLayoutAttributeBottom:
            return self.FL_bottomUnit;
        case SJFLLayoutAttributeRight:
            return self.FL_rightUnit;
        case SJFLLayoutAttributeWidth:
            return self.FL_widthUnit;
        case SJFLLayoutAttributeHeight:
            return self.FL_heightUnit;
        case SJFLLayoutAttributeCenterX:
            return self.FL_centerXUnit;
        case SJFLLayoutAttributeCenterY:
            return self.FL_centerYUnit;
    }
}
- (void)FL_resetAttributeUnits {
    FL_selectorsInit();
    objc_setAssociatedObject(self, FL_topUnit, nil, 0);
    objc_setAssociatedObject(self, FL_leftUnit, nil, 0);
    objc_setAssociatedObject(self, FL_bottomUnit, nil, 0);
    objc_setAssociatedObject(self, FL_rightUnit, nil, 0);
    objc_setAssociatedObject(self, FL_widthUnit, nil, 0);
    objc_setAssociatedObject(self, FL_heightUnit, nil, 0);
    objc_setAssociatedObject(self, FL_centerXUnit, nil, 0);
    objc_setAssociatedObject(self, FL_centerYUnit, nil, 0);
}
@end
NS_ASSUME_NONNULL_END
