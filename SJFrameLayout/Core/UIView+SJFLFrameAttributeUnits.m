//
//  UIView+SJFLFrameAttributes.m
//  Pods
//
//  Created by 畅三江 on 2019/4/23.
//

#import "UIView+SJFLFrameAttributeUnits.h"
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN
@implementation UIView (SJFLFrameAttributeUnits)
#define RETURN_FL_VIEW_ATTR_LAYOUT(__attr__) \
    SJFLFrameAttributeUnit *_Nullable attr = objc_getAssociatedObject(self, _cmd); \
    if ( !attr ) { \
        attr = [[SJFLFrameAttributeUnit alloc] initWithView:self attribute:__attr__]; \
        objc_setAssociatedObject(self, _cmd, attr, OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
    } \
    return attr; \

- (SJFLFrameAttributeUnit *)FL_none {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLFrameAttributeNone);
}
- (SJFLFrameAttributeUnit *)FL_top {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLFrameAttributeTop);
}
- (SJFLFrameAttributeUnit *)FL_left {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLFrameAttributeLeft);
}
- (SJFLFrameAttributeUnit *)FL_bottom {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLFrameAttributeBottom);
}
- (SJFLFrameAttributeUnit *)FL_right {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLFrameAttributeRight);
}
- (SJFLFrameAttributeUnit *)FL_width {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLFrameAttributeWidth);
}
- (SJFLFrameAttributeUnit *)FL_height {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLFrameAttributeHeight);
}
- (SJFLFrameAttributeUnit *)FL_centerX {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLFrameAttributeCenterX);
}
- (SJFLFrameAttributeUnit *)FL_centerY {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLFrameAttributeCenterY);
}
- (SJFLFrameAttributeUnit *)FL_safeTop {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLFrameAttributeSafeTop);
}
- (SJFLFrameAttributeUnit *)FL_safeLeft {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLFrameAttributeSafeLeft);
}
- (SJFLFrameAttributeUnit *)FL_safeBottom {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLFrameAttributeSafeBottom);
}
- (SJFLFrameAttributeUnit *)FL_safeRight {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLFrameAttributeSafeRight);
}
- (NSArray<SJFLFrameAttributeUnit *> *)FL_safeArea {
    NSArray<SJFLFrameAttributeUnit *> *_Nullable safeArea = objc_getAssociatedObject(self, _cmd);
    if ( !safeArea ) {
        safeArea = @[self.FL_safeTop, self.FL_safeLeft, self.FL_safeBottom, self.FL_safeRight];
        objc_setAssociatedObject(self, _cmd, safeArea, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return safeArea;
}
@end

UIKIT_EXTERN SJFLFrameAttributeUnit *
SJFLFrameAtrributeUnitForAttribute(UIView *self, SJFLFrameAttribute attribute) {
    switch ( attribute ) {
        case SJFLFrameAttributeNone:
            return self.FL_none;
        case SJFLFrameAttributeTop:
            return self.FL_top;
        case SJFLFrameAttributeLeft:
            return self.FL_left;
        case SJFLFrameAttributeBottom:
            return self.FL_bottom;
        case SJFLFrameAttributeRight:
            return self.FL_right;
        case SJFLFrameAttributeWidth:
            return self.FL_width;
        case SJFLFrameAttributeHeight:
            return self.FL_height;
        case SJFLFrameAttributeCenterX:
            return self.FL_centerX;
        case SJFLFrameAttributeCenterY:
            return self.FL_centerY;
        case SJFLFrameAttributeSafeTop:
            return self.FL_safeTop;
        case SJFLFrameAttributeSafeLeft:
            return self.FL_safeLeft;
        case SJFLFrameAttributeSafeBottom:
            return self.FL_safeBottom;
        case SJFLFrameAttributeSafeRight:
            return self.FL_safeRight;
    }
}
NS_ASSUME_NONNULL_END
