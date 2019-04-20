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
    switch ( attr ) {
        case SJFLAttributeNone:
            break;
        case SJFLAttributeTop:
            return objc_getAssociatedObject(self, @selector(FL_Top));
        case SJFLAttributeLeft:
            return objc_getAssociatedObject(self, @selector(FL_Left));
        case SJFLAttributeBottom:
            return objc_getAssociatedObject(self, @selector(FL_Bottom));
        case SJFLAttributeRight:
            return objc_getAssociatedObject(self, @selector(FL_Right));
        case SJFLAttributeWidth:
            return objc_getAssociatedObject(self, @selector(FL_Width));
        case SJFLAttributeHeight:
            return objc_getAssociatedObject(self, @selector(FL_Height));
        case SJFLAttributeCenterX:
            return objc_getAssociatedObject(self, @selector(FL_CenterX));
        case SJFLAttributeCenterY:
            return objc_getAssociatedObject(self, @selector(FL_CenterY));
    }
    return nil;
}
@end
NS_ASSUME_NONNULL_END
