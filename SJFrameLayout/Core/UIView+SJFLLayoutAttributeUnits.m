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
    RETURN_FL_ATTR_UNIT(SJFLAttributeTop);
}
- (SJFLLayoutAttributeUnit *)FL_leftUnit {
    RETURN_FL_ATTR_UNIT(SJFLAttributeLeft);
}
- (SJFLLayoutAttributeUnit *)FL_bottomUnit {
    RETURN_FL_ATTR_UNIT(SJFLAttributeBottom);
}
- (SJFLLayoutAttributeUnit *)FL_rightUnit {
    RETURN_FL_ATTR_UNIT(SJFLAttributeRight);
}
- (SJFLLayoutAttributeUnit *)FL_widthUnit {
    RETURN_FL_ATTR_UNIT(SJFLAttributeWidth);
}
- (SJFLLayoutAttributeUnit *)FL_heightUnit {
    RETURN_FL_ATTR_UNIT(SJFLAttributeHeight);
}
- (SJFLLayoutAttributeUnit *)FL_centerXUnit {
    RETURN_FL_ATTR_UNIT(SJFLAttributeCenterX);
}
- (SJFLLayoutAttributeUnit *)FL_centerYUnit {
    RETURN_FL_ATTR_UNIT(SJFLAttributeCenterY);
}
- (SJFLLayoutAttributeUnit *_Nullable)FL_attributeUnitForAttribute:(SJFLAttribute)attr {
    FL_selectorsInit();
    switch ( attr ) {
        case SJFLAttributeNone:
            break;
        case SJFLAttributeTop:
            return objc_getAssociatedObject(self, FL_topUnit);
        case SJFLAttributeLeft:
            return objc_getAssociatedObject(self, FL_leftUnit);
        case SJFLAttributeBottom:
            return objc_getAssociatedObject(self, FL_bottomUnit);
        case SJFLAttributeRight:
            return objc_getAssociatedObject(self, FL_rightUnit);
        case SJFLAttributeWidth:
            return objc_getAssociatedObject(self, FL_widthUnit);
        case SJFLAttributeHeight:
            return objc_getAssociatedObject(self, FL_heightUnit);
        case SJFLAttributeCenterX:
            return objc_getAssociatedObject(self, FL_centerXUnit);
        case SJFLAttributeCenterY:
            return objc_getAssociatedObject(self, FL_centerYUnit);
    }
    return nil;
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
