//
//  UIView+SJFLAdditions.m
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "UIView+SJFLAdditions.h"
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN
@implementation UIView (SJFLAdditions)
static SEL FL_Top;
static SEL FL_Left;
static SEL FL_Bottom;
static SEL FL_Right;
static SEL FL_Width;
static SEL FL_Height;
static SEL FL_CenterX;
static SEL FL_CenterY;
UIKIT_STATIC_INLINE void FL_selectorsInit(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FL_Top = @selector(FL_Top);
        FL_Left = @selector(FL_Left);
        FL_Bottom = @selector(FL_Bottom);
        FL_Right = @selector(FL_Right);
        FL_Width = @selector(FL_Width);
        FL_Height = @selector(FL_Height);
        FL_CenterX = @selector(FL_CenterX);
        FL_CenterY = @selector(FL_CenterY);
    });
}
#define RETURN_FL_ATTR_UNIT(__attr__) \
SJFLAttributeUnit *_Nullable unit = objc_getAssociatedObject(self, _cmd); \
if ( !unit ) { \
    unit = [[SJFLAttributeUnit alloc] initWithView:self attribute:__attr__]; \
    objc_setAssociatedObject(self, _cmd, unit, OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
} \
return unit;
- (SJFLAttributeUnit *)FL_Top {
    RETURN_FL_ATTR_UNIT(SJFLAttributeTop);
}
- (SJFLAttributeUnit *)FL_Left {
    RETURN_FL_ATTR_UNIT(SJFLAttributeLeft);
}
- (SJFLAttributeUnit *)FL_Bottom {
    RETURN_FL_ATTR_UNIT(SJFLAttributeBottom);
}
- (SJFLAttributeUnit *)FL_Right {
    RETURN_FL_ATTR_UNIT(SJFLAttributeRight);
}
- (SJFLAttributeUnit *)FL_Width {
    RETURN_FL_ATTR_UNIT(SJFLAttributeWidth);
}
- (SJFLAttributeUnit *)FL_Height {
    RETURN_FL_ATTR_UNIT(SJFLAttributeHeight);
}
- (SJFLAttributeUnit *)FL_CenterX {
    RETURN_FL_ATTR_UNIT(SJFLAttributeCenterX);
}
- (SJFLAttributeUnit *)FL_CenterY {
    RETURN_FL_ATTR_UNIT(SJFLAttributeCenterY);
}
- (SJFLAttributeUnit *_Nullable)FL_attributeUnitForAttribute:(SJFLAttribute)attr {
    FL_selectorsInit();
    switch ( attr ) {
        case SJFLAttributeNone:
            break;
        case SJFLAttributeTop:
            return objc_getAssociatedObject(self, FL_Top);
        case SJFLAttributeLeft:
            return objc_getAssociatedObject(self, FL_Left);
        case SJFLAttributeBottom:
            return objc_getAssociatedObject(self, FL_Bottom);
        case SJFLAttributeRight:
            return objc_getAssociatedObject(self, FL_Right);
        case SJFLAttributeWidth:
            return objc_getAssociatedObject(self, FL_Width);
        case SJFLAttributeHeight:
            return objc_getAssociatedObject(self, FL_Height);
        case SJFLAttributeCenterX:
            return objc_getAssociatedObject(self, FL_CenterX);
        case SJFLAttributeCenterY:
            return objc_getAssociatedObject(self, FL_CenterY);
    }
    return nil;
}
- (void)FL_reset {
    FL_selectorsInit();
    objc_setAssociatedObject(self, FL_Top, nil, 0);
    objc_setAssociatedObject(self, FL_Left, nil, 0);
    objc_setAssociatedObject(self, FL_Bottom, nil, 0);
    objc_setAssociatedObject(self, FL_Right, nil, 0);
    objc_setAssociatedObject(self, FL_Width, nil, 0);
    objc_setAssociatedObject(self, FL_Height, nil, 0);
    objc_setAssociatedObject(self, FL_CenterX, nil, 0);
    objc_setAssociatedObject(self, FL_CenterY, nil, 0);
}
@end
NS_ASSUME_NONNULL_END
