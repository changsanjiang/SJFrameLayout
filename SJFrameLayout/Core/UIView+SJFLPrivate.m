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
    });
}

- (void)FL_layoutSubviews {
    [self FL_layoutSubviews];
    [self FL_refreshLayouts];
}

- (void)FL_refreshLayouts {
    for ( UIView *subview in self.subviews ) {
        for ( SJFLLayoutElement *ele in SJFLGetViewElementsContainerIfExists(subview) ) {
            if ( ele.tar_superview == self || ele.dep_view == self )
                [ele needRefreshLayout];
        }
    }
    
    if ( SJFLGetViewElementsContainerIfExists(self) != nil ) {
        SJFLViewLayoutFixInnerWidthIfNeeded(self);
        SJFLViewLayoutFixInnerHeightIfNeeded(self);
    }
}

- (void)FL_addElement:(SJFLLayoutElement *)element {
    if ( element )
        [SJFLGetViewElementsContainer(self) addObject:element];
}

- (void)FL_addElementsFromArray:(NSArray<SJFLLayoutElement *> *)elements {
    if ( elements.count != 0 )
        [SJFLGetViewElementsContainer(self) addObjectsFromArray:elements];
}

- (void)FL_replaceElementForAttribute:(SJFLAttribute)attribute withElement:(SJFLLayoutElement *)element {
    if ( element ) {
        NSMutableArray<SJFLLayoutElement *> *m = SJFLGetViewElementsContainer(self);
        BOOL replaced = NO;
        for ( int i = 0 ; i < m.count ; ++ i ) {
            SJFLLayoutElement *ele = m[i];
            if ( ele.tar_attr == attribute ) {
                [m replaceObjectAtIndex:i withObject:element];
                replaced = YES;
                break;
            }
        }
        
        if ( !replaced ) [m addObject:element];
    }
}

- (void)FL_removeAllElements {
    [SJFLGetViewElementsContainerIfExists(self) removeAllObjects];
}

- (SJFLLayoutElement *_Nullable)FL_elementForAttribute:(SJFLAttribute)attribute {
    NSArray<SJFLLayoutElement *> *eles = SJFLGetViewElementsContainerIfExists(self);
    for ( SJFLLayoutElement *ele in eles ) {
        if ( ele.tar_attr == attribute ) return ele;
    }
    return nil;
}

// -

UIKIT_STATIC_INLINE NSMutableArray<SJFLLayoutElement *> *SJFLGetViewElementsContainer(UIView *view) {
    NSMutableArray <SJFLLayoutElement *> *m = objc_getAssociatedObject(view, (__bridge void *)view);
    if ( !m ) {
        m = [NSMutableArray array];
        objc_setAssociatedObject(view, (__bridge void *)view, m, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return m;
}

UIKIT_STATIC_INLINE NSMutableArray<SJFLLayoutElement *> *SJFLGetViewElementsContainerIfExists(UIView *view) {
    return objc_getAssociatedObject(view, (__bridge void *)view);
}

UIKIT_STATIC_INLINE void SJFLViewLayoutFixInnerWidthIfNeeded(UIView *view) {
    // subview: left <===> right
    CGFloat maxX = 0;
    for ( UIView *sub in view.subviews ) {
        SJFLAttributeUnit *_Nullable right = [sub FL_elementForAttribute:SJFLAttributeRight].target;;
        CGFloat subMaxX = CGRectGetMaxX(sub.frame) - right.offset;
        if ( subMaxX > maxX ) maxX = subMaxX;
    }

    if ( maxX > 0 ) {
        CGRect frame = view.frame;
        if ( !SJFLFloatCompare(frame.size.width, maxX) ) {
#ifdef DEBUG
            NSLog(@"view: %p, maxX: %lf", view, maxX);
#endif
            SJFLAttributeUnit *newUnit = [[SJFLAttributeUnit alloc] initWithView:view attribute:SJFLAttributeWidth];
            SJFLLayoutElement *newEle = [[SJFLLayoutElement alloc] initWithTarget:newUnit];
            newUnit->offset.value = maxX;
            newUnit->offset_t = FL_CGFloatValue;
            [view FL_replaceElementForAttribute:SJFLAttributeWidth withElement:newEle];
            
            frame.size.width = maxX;
            view.frame = frame;
            [view.superview FL_refreshLayouts];
        }
    }
}

UIKIT_STATIC_INLINE void SJFLViewLayoutFixInnerHeightIfNeeded(UIView *view) {
    // subview: top <===> bottom
    CGFloat maxY = 0;
    for ( UIView *sub in view.subviews ) {
        SJFLAttributeUnit *_Nullable bottom = [sub FL_elementForAttribute:SJFLAttributeBottom].target;
        CGFloat subMaxY = CGRectGetMaxY(sub.frame) - bottom.offset;
        if ( subMaxY > maxY ) maxY = subMaxY;
    }
    
    if ( maxY > 0 ) {
        CGRect frame = view.frame;
        if ( !SJFLFloatCompare(frame.size.height, maxY) ) {
#ifdef DEBUG
            NSLog(@"view: %p, maxY: %lf", view, maxY);
#endif
            SJFLAttributeUnit *newUnit = [[SJFLAttributeUnit alloc] initWithView:view attribute:SJFLAttributeHeight];
            SJFLLayoutElement *newEle = [[SJFLLayoutElement alloc] initWithTarget:newUnit];
            newUnit->offset.value = maxY;
            newUnit->offset_t = FL_CGFloatValue;
            [view FL_replaceElementForAttribute:SJFLAttributeHeight withElement:newEle];
            
            frame.size.height = maxY;
            view.frame = frame;
            [view.superview FL_refreshLayouts];
        }
    }
}

UIKIT_STATIC_INLINE BOOL SJFLFloatCompare(CGFloat value1, CGFloat value2) {
    return floor(value1 + 0.5) == floor(value2 + 0.5);
}
@end
NS_ASSUME_NONNULL_END
