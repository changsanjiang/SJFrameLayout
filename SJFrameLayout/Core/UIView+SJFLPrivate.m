//
//  UIView+SJFLPrivate.m
//  Pods
//
//  Created by BlueDancer on 2019/4/18.
//

#import "UIView+SJFLPrivate.h"
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN
@implementation UIView (SJFLPrivate)
+ (void)FL_layoutElementWantReceiveNotificationForLayoutSubviews {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class nav = [self class];
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzledSelector = @selector(FL_layoutSubviews);
        Method originalMethod = class_getInstanceMethod(nav, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(nav, swizzledSelector);
        BOOL added = class_addMethod([self class], originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if ( added ) {
            class_replaceMethod([self class], swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }
        else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)FL_layoutSubviews {
    [self FL_layoutSubviews];
    [NSNotificationCenter.defaultCenter postNotificationName:SJFLViewLayoutSubviewsNotification object:self];
}

- (void)setFL_elements:(NSArray<SJFLLayoutElement *> *_Nullable)FL_elements {
    objc_setAssociatedObject(self, @selector(FL_elements), FL_elements, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSArray<SJFLLayoutElement *> *_Nullable)FL_elements {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)FL_replaceElement:(SJFLAttribute)attribute withElement:(SJFLLayoutElement *)element {
    
}
@end

NSNotificationName const SJFLViewLayoutSubviewsNotification = @"SJFLViewLayoutSubviewsNotification";
NS_ASSUME_NONNULL_END
