//
//  UIView+SJFLViewFrameAttributes.m
//  Pods
//
//  Created by 畅三江 on 2019/4/23.
//

#import "UIView+SJFLViewFrameAttributes.h"
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN
@implementation UIView (SJFLViewFrameAttributes)
#define RETURN_FL_VIEW_ATTR_LAYOUT(__attr__) \
    SJFLViewFrameAttribute *_Nullable attr = objc_getAssociatedObject(self, _cmd); \
    if ( !attr ) { \
        attr = [[SJFLViewFrameAttribute alloc] initWithView:self attribute:__attr__]; \
        objc_setAssociatedObject(self, _cmd, attr, OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
    } \
    return attr; \

- (SJFLViewFrameAttribute *)FL_top {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLAttributeTop);
}
- (SJFLViewFrameAttribute *)FL_left {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLAttributeLeft);
}
- (SJFLViewFrameAttribute *)FL_bottom {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLAttributeBottom);
}
- (SJFLViewFrameAttribute *)FL_right {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLAttributeRight);
}
- (SJFLViewFrameAttribute *)FL_width {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLAttributeWidth);
}
- (SJFLViewFrameAttribute *)FL_height {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLAttributeHeight);
}
- (SJFLViewFrameAttribute *)FL_centerX {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLAttributeCenterX);
}
- (SJFLViewFrameAttribute *)FL_centerY {
    RETURN_FL_VIEW_ATTR_LAYOUT(SJFLAttributeCenterY);
}
- (SJFLViewFrameAttribute *)viewLayoutForAttribute:(SJFLAttribute)attribtue {
    switch ( attribtue ) {
        case SJFLAttributeNone:
            return [[SJFLViewFrameAttribute alloc] initWithView:self attribute:SJFLAttributeNone];
        case SJFLAttributeTop:
            return self.FL_top;
        case SJFLAttributeLeft:
            return self.FL_left;
        case SJFLAttributeBottom:
            return self.FL_bottom;
        case SJFLAttributeRight:
            return self.FL_right;
        case SJFLAttributeWidth:
            return self.FL_width;
        case SJFLAttributeHeight:
            return self.FL_height;
        case SJFLAttributeCenterX:
            return self.FL_centerX;
        case SJFLAttributeCenterY:
            return self.FL_centerY;
    }
}
@end
NS_ASSUME_NONNULL_END
