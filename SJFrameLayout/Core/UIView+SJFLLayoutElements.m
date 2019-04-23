//
//  UIView+SJFLLayoutElements.m
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "UIView+SJFLLayoutElements.h"
#import "SJFLLayoutElement.h"
#import "UIView+SJFLLayoutAttributeUnits.h"
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN
#if 1
#ifdef DEBUG
#undef DEBUG
#endif
#endif
@implementation UIView (SJFLLayoutElements)
- (void)FL_dependencyViewDidLayoutSubviews:(UIView *)view {
    if ( view != self ) {
        for ( SJFLLayoutElement *ele in SJFLGetElementsContainerIfExists(self) ) {
            [ele refreshLayoutIfNeeded];
        }
    }
    
    SJFLViewLayoutFixInnerSizeIfNeeded(self);
    SJFLViewLayoutFixInnerSizeIfNeeded(self.superview);
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
        SJFLLayoutAttributeUnit *unit = ele.target;
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
    
//    NSLog(@"%@", view);
    
    // - fitting size -
    SJFLLayoutAttributeUnit *_Nullable fit_width = SJFLGetElement(m, SJFLAttributeWidth, SJFLPriorityFittingSize).target;
    SJFLLayoutAttributeUnit *_Nullable fit_height = SJFLGetElement(m, SJFLAttributeHeight, SJFLPriorityFittingSize).target;
    
    static Class FL_UILabelClass;
    static Class FL_UIButtonClass;
    static Class FL_UIImageViewClass;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FL_UILabelClass = [UILabel class];
        FL_UIButtonClass = [UIButton class];
        FL_UIImageViewClass = [UIImageView class];
    });
    
    if ( fit_width != nil || fit_height != nil ) {
        if ( [view isKindOfClass:FL_UILabelClass] ) {
            SJFLLabelAdjustBoxIfNeeded((id)view, m);
            SJFLLabelLayoutFixInnerSize((id)view, fit_width, fit_height);
        }
        else if ( [view isKindOfClass:FL_UIButtonClass] ) {
            SJFLButtonLayoutFixInnerSize((id)view, fit_width, fit_height);
        }
        else if ( [view isKindOfClass:FL_UIImageViewClass] ) {
            SJFLImageViewLayoutFixInnerSize((id)view, fit_width, fit_height);
        }
        else {
            SJFLViewLayoutFixInnerSize(view, fit_width, fit_height);
        }
    }
}

UIKIT_STATIC_INLINE void SJFLLabelAdjustBoxIfNeeded(UILabel *label, NSMutableArray<SJFLLayoutElement *> *m) {
    CGFloat preferredMaxLayoutWidth = label.preferredMaxLayoutWidth;
    if ( !SJFLFloatCompare(0, preferredMaxLayoutWidth) ) {
        SJFLLayoutAttributeUnit *_Nullable widthUnit = SJFLGetElement(m, SJFLAttributeWidth, SJFLPriorityRequired).target;
        if ( !widthUnit ) {
            widthUnit = [[SJFLLayoutAttributeUnit alloc] initWithView:label attribute:SJFLAttributeWidth];
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

UIKIT_STATIC_INLINE void SJFLLabelLayoutFixInnerSize(UILabel *view, SJFLLayoutAttributeUnit *_Nullable fit_width, SJFLLayoutAttributeUnit *_Nullable fit_height) {
    CGRect frame = view.frame;
    CGSize box = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    
    // 具有宽度约束
    if ( fit_width == nil ) {
        box.width = CGRectGetWidth(frame);
        if ( SJFLFloatCompare(0, box.width) )
            return;
    }
    // 具有高度约束
    else if ( fit_height == nil ) {
        box.height = CGRectGetHeight(frame);
        if ( SJFLFloatCompare(0, box.height) )
            return;
    }
    
    CGRect rect = [view textRectForBounds:CGRectMake(0, 0, box.width, box.height) limitedToNumberOfLines:view.numberOfLines];
    CGSize fit = CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
    
    BOOL needUpdate = NO;
    if ( fit_width != nil ) {
        if ( !SJFLFloatCompare(fit_width->offset.value, fit.width) ) {
            fit_width->offset.value = fit.width;
            needUpdate = YES;
        }
    }
    
    if ( fit_height != nil ) {
        if ( !SJFLFloatCompare(fit_height->offset.value, fit.height) ) {
            fit_height->offset.value = fit.height;
            needUpdate = YES;
        }
    }
    
    if ( needUpdate ) {
        SJFLRefreshLayoutsForRelatedView(view);
    }
}

UIKIT_STATIC_INLINE void SJFLButtonLayoutFixInnerSize(UIButton *view, SJFLLayoutAttributeUnit *_Nullable fit_width, SJFLLayoutAttributeUnit *_Nullable fit_height) {
    CGRect frame = view.frame;
    CGSize box = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    
    // 具有宽度约束
    if ( fit_width == nil ) {
        box.width = CGRectGetWidth(frame);
        if ( SJFLFloatCompare(0, box.width) )
            return;
    }
    // 具有高度约束
    else if ( fit_height == nil ) {
        box.height = CGRectGetHeight(frame);
        if ( SJFLFloatCompare(0, box.height) )
            return;
    }
    
    CGSize result = [view sizeThatFits:box];
    CGSize fit = CGSizeMake(ceil(result.width), ceil(result.height));
    
#ifdef DEBUG
    NSLog(@"%@", NSStringFromCGSize(result));
#endif
    
    BOOL needUpdate = NO;
    if ( fit_width != nil ) {
        if ( !SJFLFloatCompare(fit_width->offset.value, fit.width) ) {
            fit_width->offset.value = fit.width;
            needUpdate = YES;
        }
    }
    
    if ( fit_height != nil ) {
        if ( !SJFLFloatCompare(fit_height->offset.value, fit.height) ) {
            fit_height->offset.value = fit.height;
            needUpdate = YES;
        }
    }
    
    if ( needUpdate ) {
        SJFLRefreshLayoutsForRelatedView(view);
    }
}

UIKIT_STATIC_INLINE void SJFLImageViewLayoutFixInnerSize(UIImageView *view, SJFLLayoutAttributeUnit *_Nullable fit_width, SJFLLayoutAttributeUnit *_Nullable fit_height) {
    CGRect frame = view.frame;
    CGSize box = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    
    // 具有宽度约束
    if ( fit_width == nil ) {
        box.width = CGRectGetWidth(frame);
        if ( SJFLFloatCompare(0, box.width) )
            return;
    }
    // 具有高度约束
    else if ( fit_height == nil ) {
        box.height = CGRectGetHeight(frame);
        if ( SJFLFloatCompare(0, box.height) )
            return;
    }
    
    CGSize result = [view sizeThatFits:box];
    CGSize fit = CGSizeMake(ceil(result.width), ceil(result.height));
    
#ifdef DEBUG
    NSLog(@"%@", NSStringFromCGSize(result));
#endif
    
    BOOL needUpdate = NO;
    if ( fit_width != nil ) {
        if ( !SJFLFloatCompare(fit_width->offset.value, fit.width) ) {
            fit_width->offset.value = fit.width;
            needUpdate = YES;
        }
    }
    
    if ( fit_height != nil ) {
        if ( !SJFLFloatCompare(fit_height->offset.value, fit.height) ) {
            fit_height->offset.value = fit.height;
            needUpdate = YES;
        }
    }
    
    if ( needUpdate ) {
        SJFLRefreshLayoutsForRelatedView(view);
    }

}

UIKIT_STATIC_INLINE void SJFLViewLayoutFixInnerSize(UIView *view, SJFLLayoutAttributeUnit *_Nullable fit_width, SJFLLayoutAttributeUnit *_Nullable fit_height) {
    
    CGFloat maxX = 0;
    for ( UIView *sub in view.subviews ) {
        SJFLLayoutAttributeUnit *_Nullable right = [sub FL_elementForAttribute:SJFLAttributeRight].target;;
        CGFloat subMaxX = CGRectGetMaxX(sub.frame) - right.offset;
        if ( subMaxX > maxX ) maxX = subMaxX;
    }

    CGFloat maxY = 0;
    for ( UIView *sub in view.subviews ) {
        SJFLLayoutAttributeUnit *_Nullable bottom = [sub FL_elementForAttribute:SJFLAttributeBottom].target;
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
        SJFLRefreshLayoutsForRelatedView(view);
    }
    
//    NSLog(@"maxX: %lf, maxY: %lf", maxX, maxY);
}

UIKIT_STATIC_INLINE BOOL SJFLFloatCompare(CGFloat value1, CGFloat value2) {
    return floor(value1 + 0.5) == floor(value2 + 0.5);
}

NSMutableSet<UIView *> *SJFLGetElementsRelatedViews(NSArray<SJFLLayoutElement *> *m) {
    NSMutableSet *set = [NSMutableSet new];
    for ( SJFLLayoutElement *ele in m ) {
        UIView *dep_view = ele.dep_view;
        if ( dep_view ) [set addObject:ele.dep_view];
    }
    return set;
}

void SJFLRefreshLayoutsForRelatedView(UIView *view) {
    NSMutableSet *set = SJFLGetElementsRelatedViews(view.FL_elements);
    if ( view.superview ) [set addObject:view.superview];

    for ( UIView *view in set ) {
        [view layoutSubviews];
    }
}
@end
NS_ASSUME_NONNULL_END
