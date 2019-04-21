//
//  UIView+SJFLPrivate.m
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "UIView+SJFLPrivate.h"
#import "SJFLLayoutElement.h"
#import "UIView+SJFLAttributeUnits.h"
#import <objc/message.h>

#ifdef DEBUG
#import "SJFLViewTreePlaceholder.h"
#endif


NS_ASSUME_NONNULL_BEGIN
@implementation UIView (SJFLPrivate)
static SEL FL_elements;
static SEL FL_needWidthToFit;
static SEL FL_needHeightToFit;

+ (void)load {
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
        
        FL_elements = @selector(FL_elements);
        FL_needWidthToFit = @selector(FL_needWidthToFit);
        FL_needHeightToFit = @selector(FL_needHeightToFit);
    });
}

- (void)FL_layoutSubviews {
    [self FL_layoutSubviews];
    
    for ( UIView *subview in self.subviews ) {
        for ( SJFLLayoutElement *ele in subview.FL_elements ) {
            if ( ele.tar_superview == self || ele.dep_view == self )
                [ele needRefreshLayout];
        }
    }
    
    if ( self.FL_needWidthToFit ) {
        SJFLViewLayoutFixInnerWidthIfNeeded(self);
    }
    
    if ( self.FL_needHeightToFit ) {
        SJFLViewLayoutFixInnerHeightIfNeeded(self);
    }
}

- (void)setFL_elements:(NSArray<SJFLLayoutElement *> *_Nullable)elements {
    objc_setAssociatedObject(self, FL_elements, elements, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray<SJFLLayoutElement *> *_Nullable)FL_elements {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFL_needWidthToFit:(BOOL)needWidthToFit {
    objc_setAssociatedObject(self, FL_needWidthToFit, @(needWidthToFit), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)FL_needWidthToFit {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setFL_needHeightToFit:(BOOL)needHeightToFit {
    objc_setAssociatedObject(self, FL_needHeightToFit, @(needHeightToFit), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)FL_needHeightToFit {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}


/**
 如果父视图需要子视图来撑满
 
 父视图的size.width  = CGRectGetMaxX's
 父视图的size.height = CGRectGetMaxY's
 
 给父视图一个很大的size, 当所有子视图布局完成后, 修改它的size
 
 子视图布局就是因为他没有size, 才导致如法布局的
 
 */
UIKIT_STATIC_INLINE void SJFLViewLayoutFixInnerWidthIfNeeded(UIView *view) {
    // subview: left <===> right
    CGFloat maxX = 0;
    for ( UIView *sub in view.subviews ) {
        CGFloat subMaxX = CGRectGetMaxX(sub.frame);
        if ( subMaxX > maxX ) maxX = subMaxX;
    }

    NSLog(@"maxX: %lf", maxX);
}

UIKIT_STATIC_INLINE void SJFLViewLayoutFixInnerHeightIfNeeded(UIView *view) {
    // subview: top <===> bottom
    CGFloat maxY = 0;
    for ( UIView *sub in view.subviews ) {
        CGFloat subMaxY = CGRectGetMaxY(sub.frame);
        if ( subMaxY > maxY ) maxY = subMaxY;
    }

    NSLog(@"maxY: %lf", maxY);
}
@end
NS_ASSUME_NONNULL_END
