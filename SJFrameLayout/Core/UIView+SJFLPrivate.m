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
static Class FL_UILabelClass;
static Class FL_UIButtonClass;
static SEL FL_layout;

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
        
        FL_UILabelClass = UILabel.class;
        FL_UIButtonClass = UIButton.class;
        FL_layout = @selector(FL_layout);
    });
}

- (void)setFL_layout:(BOOL)layout {
    objc_setAssociatedObject(self, FL_layout, @(layout), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)FL_layout {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)FL_layoutSubviews {
    [self FL_layoutSubviews];
    [self FL_refreshLayouts];
}

- (void)FL_refreshLayouts {
    if ( self.superview == nil )
        return;
    
    for ( UIView *subview in self.subviews ) {
        for ( SJFLLayoutElement *ele in SJFLGetElementsContainerIfExists(subview) ) {
            if ( ele.tar_superview == self || ele.dep_view == self )
                [ele needRefreshLayout];
        }
    }
    
    SJFLViewLayoutFixInnerSizeIfNeeded(self);
}

- (SJFLLayoutElement *_Nullable)FL_elementForAttribute:(SJFLAttribute)attribute {
    return [self FL_elementForAttribute:attribute priority:SJFLPriorityRequired];
}

- (SJFLLayoutElement *_Nullable)FL_elementForAttribute:(SJFLAttribute)attribute priority:(char)priority {
    NSArray<SJFLLayoutElement *> *eles = SJFLGetElementsContainerIfExists(self);
    return SJFLGetElement(eles, attribute, priority);
}

- (void)FL_addElement:(SJFLLayoutElement *)element {
    if ( element )
        [SJFLGetElementsContainer(self) addObject:element];
}

- (void)FL_addElementsFromArray:(NSArray<SJFLLayoutElement *> *)elements {
    if ( elements.count != 0 )
        [SJFLGetElementsContainer(self) addObjectsFromArray:elements];
}

- (void)FL_replaceElementForAttribute:(SJFLAttribute)attribute withElement:(SJFLLayoutElement *)element {
    [self _FL_replaceElementForAttribute:attribute priority:SJFLPriorityRequired withElement:element];
}

- (void)FL_removeElementForAttribute:(SJFLAttribute)attribute {
    NSMutableArray<SJFLLayoutElement *> *m = SJFLGetElementsContainerIfExists(self);
    NSInteger index = SJFLGetIndex(m, attribute, SJFLPriorityRequired);
    if ( index != NSNotFound ) [m removeObjectAtIndex:index];
}

- (void)FL_removeElement:(SJFLLayoutElement *)element {
    if ( element )
        [SJFLGetElementsContainerIfExists(self) removeObject:element];
}

- (void)FL_removeAllElements {
    [SJFLGetElementsContainerIfExists(self) removeAllObjects];
}


- (NSArray<SJFLLayoutElement *> *_Nullable)FL_elements {
    return SJFLGetElementsContainerIfExists(self);
}

// private methods

- (void)_FL_replaceElementForAttribute:(SJFLAttribute)attribute priority:(char)priority withElement:(SJFLLayoutElement *)element {
    if ( element ) {
        NSMutableArray<SJFLLayoutElement *> *m = SJFLGetElementsContainer(self);
        BOOL needAdd = YES;
        NSInteger index = SJFLGetIndex(m, attribute, priority);
        if ( index != NSNotFound ) {
            needAdd = NO;
            [m replaceObjectAtIndex:index withObject:element];
        }

        if ( !needAdd )
            [m addObject:element];
    }
}

//

SJFLLayoutElement *_Nullable SJFLGetElement(NSArray<SJFLLayoutElement *> *eles, SJFLAttribute attribute, char priority) {
    NSInteger index = SJFLGetIndex(eles, attribute, priority);
    if ( index != NSNotFound )
        return eles[index];
    return nil;
}

NSInteger SJFLGetIndex(NSArray<SJFLLayoutElement *> *m, SJFLAttribute attribute, char priority) {
    for ( int i = 0 ; i < m.count ; ++ i ) {
        SJFLLayoutElement *ele = m[i];
        SJFLAttributeUnit *unit = ele.target;
        if ( unit.attribute == attribute && unit->priority == priority  )
            return i;
    }
    return NSNotFound;
}

UIKIT_STATIC_INLINE NSMutableArray<SJFLLayoutElement *> *SJFLGetElementsContainer(UIView *view) {
    NSMutableArray <SJFLLayoutElement *> *m = objc_getAssociatedObject(view, (__bridge void *)view);
    if ( !m ) {
        m = [NSMutableArray array];
        objc_setAssociatedObject(view, (__bridge void *)view, m, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return m;
}

UIKIT_STATIC_INLINE NSMutableArray<SJFLLayoutElement *> *_Nullable SJFLGetElementsContainerIfExists(UIView *view) {
    return objc_getAssociatedObject(view, (__bridge void *)view);
}


// fix inner size

UIKIT_STATIC_INLINE void SJFLViewLayoutFixInnerSizeIfNeeded(UIView *view) {
    NSMutableArray<SJFLLayoutElement *> *m = SJFLGetElementsContainer(view);
    if ( m.count < 1 )
        return;
    // - fitting size -
    SJFLAttributeUnit *_Nullable fit_width = SJFLGetElement(m, SJFLAttributeWidth, SJFLPriorityFittingSize).target;
    SJFLAttributeUnit *_Nullable fit_height = SJFLGetElement(m, SJFLAttributeHeight, SJFLPriorityFittingSize).target;
    if ( fit_width != nil || fit_height != nil ) {
        if ( [view isKindOfClass:FL_UILabelClass] ) {
            SJFLLabelAdjustBoxIfNeeded((id)view, m);
            SJFLLabelLayoutFixInnerSize((id)view, fit_width, fit_height);
        }
        else {
            SJFLViewLayoutFixInnerSize(view, fit_width, fit_height);
        }
    }
}

UIKIT_STATIC_INLINE void SJFLLabelAdjustBoxIfNeeded(UILabel *label, NSMutableArray<SJFLLayoutElement *> *m) {
    CGFloat preferredMaxLayoutWidth = label.preferredMaxLayoutWidth;
    if ( !SJFLFloatCompare(0, preferredMaxLayoutWidth) ) {
        SJFLAttributeUnit *_Nullable widthUnit = SJFLGetElement(m, SJFLAttributeWidth, SJFLPriorityRequired).target;
        if ( !widthUnit ) {
            widthUnit = [[SJFLAttributeUnit alloc] initWithView:label attribute:SJFLAttributeWidth];
            [label FL_addElement:[[SJFLLayoutElement alloc] initWithTarget:widthUnit]];
            // remove fitting element
            NSInteger index = SJFLGetIndex(m, SJFLAttributeWidth, SJFLPriorityFittingSize);
            if ( index != NSNotFound ) {
                [m removeObjectAtIndex:index];
            }
        }
        widthUnit->offset_t = SJFLCGFloatValue;
        widthUnit->offset.value = preferredMaxLayoutWidth;
    }
}

UIKIT_STATIC_INLINE void SJFLLabelLayoutFixInnerSize(UILabel *label, SJFLAttributeUnit *_Nullable fit_width, SJFLAttributeUnit *_Nullable fit_height) {
    CGRect frame = label.frame;
    CGSize container = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    
    // 具有宽度约束
    if ( fit_width == nil ) {
        container.width = CGRectGetWidth(frame);
    }
    // 具有高度约束
    else if ( fit_height == nil ) {
        container.height = CGRectGetHeight(frame);
    }
    CGSize fit = [label textRectForBounds:CGRectMake(0, 0, container.width, container.height) limitedToNumberOfLines:label.numberOfLines].size;
    
    if ( !CGSizeEqualToSize(fit, frame.size) ) {
        if ( fit_width ) fit_width->offset.value = ceil(fit.width);
        if ( fit_height ) fit_height->offset.value = ceil(fit.height);
        [label.superview layoutSubviews];
    }
}

UIKIT_STATIC_INLINE void SJFLViewLayoutFixInnerSize(UIView *view, SJFLAttributeUnit *_Nullable fit_width, SJFLAttributeUnit *_Nullable fit_height) {
    
    CGFloat maxX = 0;
    for ( UIView *sub in view.subviews ) {
        SJFLAttributeUnit *_Nullable right = [sub FL_elementForAttribute:SJFLAttributeRight].target;;
        CGFloat subMaxX = CGRectGetMaxX(sub.frame) - right.offset;
        if ( subMaxX > maxX ) maxX = subMaxX;
    }

    CGFloat maxY = 0;
    for ( UIView *sub in view.subviews ) {
        SJFLAttributeUnit *_Nullable bottom = [sub FL_elementForAttribute:SJFLAttributeBottom].target;
        CGFloat subMaxY = CGRectGetMaxY(sub.frame) - bottom.offset;
        if ( subMaxY > maxY ) maxY = subMaxY;
    }
    
    BOOL needRefresh = NO;
    if ( !SJFLFloatCompare(maxX, fit_width->offset.value) ) {
        fit_width->offset.value = maxX;
        needRefresh = YES;
    }
    
    if ( !SJFLFloatCompare(maxY, fit_height->offset.value) ) {
        fit_height->offset.value = maxY;
        needRefresh = YES;
    }
    
    if ( needRefresh ) {
        [view.superview layoutSubviews];
    }
    
//    NSLog(@"maxX: %lf, maxY: %lf", maxX, maxY);
}

UIKIT_STATIC_INLINE BOOL SJFLFloatCompare(CGFloat value1, CGFloat value2) {
    return floor(value1 + 0.5) == floor(value2 + 0.5);
}
@end
NS_ASSUME_NONNULL_END
