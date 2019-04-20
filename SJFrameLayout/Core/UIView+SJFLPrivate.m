//
//  UIView+SJFLPrivate.m
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "UIView+SJFLPrivate.h"
#import "SJFLLayoutElement.h"
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN
@implementation UIView (SJFLPrivate)
- (void)FL_layoutSubviews {
    [self FL_layoutSubviews];
    for ( UIView *subview in self.subviews ) {
        for ( SJFLLayoutElement *ele in subview.FL_elements ) {
            UIView *dep = ele.dependencyView;
            if ( dep == self)
                [ele dependencyViewsDidLayoutSubViews];
        }
    }
}

- (void)setFL_elements:(NSArray<SJFLLayoutElement *> *_Nullable)FL_elements {
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
    objc_setAssociatedObject(self, @selector(FL_elements), FL_elements, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSArray<SJFLLayoutElement *> *_Nullable)FL_elements {
    return objc_getAssociatedObject(self, _cmd);
}
@end
NS_ASSUME_NONNULL_END
