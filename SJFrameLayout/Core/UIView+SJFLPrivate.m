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

NS_ASSUME_NONNULL_BEGIN
#if 1
#ifdef DEBUG
#undef DEBUG
#endif
#endif

@implementation UIView (SJFLPrivate)
static SEL FL_elements;

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
    
    if ( self.FL_elements != nil ) {
        SJFLViewLayoutFixInnerWidthIfNeeded(self);
        SJFLViewLayoutFixInnerHeightIfNeeded(self);
    }
}

- (void)setFL_elements:(NSArray<SJFLLayoutElement *> *_Nullable)elements {
    objc_setAssociatedObject(self, FL_elements, elements, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray<SJFLLayoutElement *> *_Nullable)FL_elements {
    return objc_getAssociatedObject(self, _cmd);
}

UIKIT_STATIC_INLINE void SJFLViewLayoutFixInnerWidthIfNeeded(UIView *view) {
    // subview: left <===> right
    CGFloat maxX = 0;
    for ( UIView *sub in view.subviews ) {
        SJFLAttributeUnit *_Nullable right = [sub FL_attributeUnitForAttribute:SJFLAttributeRight];
        CGFloat subMaxX = CGRectGetMaxX(sub.frame) - right.offset;
        if ( subMaxX > maxX ) maxX = subMaxX;
    }

    if ( maxX > 0 ) {
        CGRect frame = view.frame;
        if ( !SJFLFloatCompare(frame.size.width, maxX) ) {
#ifdef DEBUG
            NSLog(@"view: %p, maxX: %lf", view, maxX);
#endif

            SJFLAttributeUnit *_Nullable width = [view FL_attributeUnitForAttribute:SJFLAttributeWidth];
            if ( width == nil ) {
                width = view.FL_Width;
                NSMutableArray<SJFLLayoutElement *> *m = view.FL_elements.mutableCopy;
                [m addObject:[[SJFLLayoutElement alloc] initWithTarget:width]];
                view.FL_elements = m;
            }
            
            width->offset.value = maxX;
            width->offset_t = FL_CGFloatValue;
            
            frame.size.width = maxX;
            view.frame = frame;
            [view.superview layoutSubviews];
        }
    }
}

UIKIT_STATIC_INLINE void SJFLViewLayoutFixInnerHeightIfNeeded(UIView *view) {
    // subview: top <===> bottom
    CGFloat maxY = 0;
    for ( UIView *sub in view.subviews ) {
        SJFLAttributeUnit *_Nullable bottom = [sub FL_attributeUnitForAttribute:SJFLAttributeBottom];
        CGFloat subMaxY = CGRectGetMaxY(sub.frame) - bottom.offset;
        if ( subMaxY > maxY ) maxY = subMaxY;
    }
    
    if ( maxY > 0 ) {
        CGRect frame = view.frame;
        if ( !SJFLFloatCompare(frame.size.height, maxY) ) {
#ifdef DEBUG
            NSLog(@"view: %p, maxY: %lf", view, maxY);
#endif

            SJFLAttributeUnit *_Nullable height = [view FL_attributeUnitForAttribute:SJFLAttributeHeight];
            if ( height == nil ) {
                height = view.FL_Height;
                NSMutableArray<SJFLLayoutElement *> *m = view.FL_elements.mutableCopy;
                [m addObject:[[SJFLLayoutElement alloc] initWithTarget:height]];
                view.FL_elements = m;
            }

            height->offset.value = maxY;
            height->offset_t = FL_CGFloatValue;
            
            frame.size.height = maxY;
            view.frame = frame;
            [view.superview layoutSubviews];
        }
    }
}

UIKIT_STATIC_INLINE BOOL SJFLFloatCompare(CGFloat value1, CGFloat value2) {
    return floor(value1 + 0.5) == floor(value2 + 0.5);
}
@end
NS_ASSUME_NONNULL_END
