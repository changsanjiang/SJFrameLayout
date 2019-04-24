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
static void *kFL_Container = &kFL_Container;
- (void)setFL_elements:(NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> * _Nullable)FL_elements {
    objc_setAssociatedObject(self, kFL_Container, [FL_elements mutableCopy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *_Nullable)FL_elements {
    return objc_getAssociatedObject(self, kFL_Container);
}

- (SJFLLayoutElement *_Nullable)FL_elementForAttributeKey:(SJFLLayoutAttributeKey)attributeKey {
    return [objc_getAssociatedObject(self, kFL_Container) valueForKey:attributeKey];
}

// -

- (void)FL_dependencyViewDidLayoutSubviews:(UIView *)view {
    if ( view != self ) {
        NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *_Nullable
        m = objc_getAssociatedObject(self, kFL_Container);
        if ( m ) {
            // 布局应该从width和height优先安装
            
            // top 安装好之后, 会影响到什么, 或者什么可以定位到了 ?
            // - bottom
            // 当 top 和 bottom 同时安装之后, 会生成 height. 当width依赖height时, 此时可以刷新width
            
            // left 安装好之后, 会影响到什么, 或者什么可以定位到了 ?
            // - right
            // 当 left 和 right 同时安装之后, 会生成 width. 当height依赖width时, 此时可以刷新height
            
            [m[SJFLLayoutAttributeKeyWidth] refreshLayoutIfNeeded];
            [m[SJFLLayoutAttributeKeyHeight] refreshLayoutIfNeeded];
            
            [m[SJFLLayoutAttributeKeyTop] refreshLayoutIfNeeded];
            [m[SJFLLayoutAttributeKeyBottom] refreshLayoutIfNeeded];
            [m[SJFLLayoutAttributeKeyWidth] refreshLayoutIfNeeded];
            
            [m[SJFLLayoutAttributeKeyLeft] refreshLayoutIfNeeded];
            [m[SJFLLayoutAttributeKeyRight] refreshLayoutIfNeeded];
            [m[SJFLLayoutAttributeKeyHeight] refreshLayoutIfNeeded];
            
            [m[SJFLLayoutAttributeKeyCenterX] refreshLayoutIfNeeded];
            [m[SJFLLayoutAttributeKeyCenterY] refreshLayoutIfNeeded];
        }
    }
    
    SJFLViewLayoutFixInnerSizeIfNeeded(self);
    SJFLViewLayoutFixInnerSizeIfNeeded(self.superview);
}

- (void)FL_elementDidRefreshLayout:(SJFLLayoutElement *)element {
    UIView *view = self;
    NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *m = SJFLElements(view);
    switch ( element.tar_attr ) {
        case SJFLLayoutAttributeNone:
            break;
        case SJFLLayoutAttributeWidth: {
            if ( 0 != CGRectGetWidth(view.frame) ) {
                [m[SJFLLayoutAttributeKeyLeft] refreshLayoutIfNeeded];
                [m[SJFLLayoutAttributeKeyCenterX] refreshLayoutIfNeeded];
                [m[SJFLLayoutAttributeKeyRight] refreshLayoutIfNeeded];
                [m[SJFLLayoutAttributeKeyHeight] refreshLayoutIfNeeded];
            }
        }
            break;
        case SJFLLayoutAttributeHeight: {
            if ( 0 != CGRectGetHeight(view.frame) ) {
                [m[SJFLLayoutAttributeKeyTop] refreshLayoutIfNeeded];
                [m[SJFLLayoutAttributeKeyCenterY] refreshLayoutIfNeeded];
                [m[SJFLLayoutAttributeKeyBottom] refreshLayoutIfNeeded];
                [m[SJFLLayoutAttributeKeyWidth] refreshLayoutIfNeeded];
            }
        }
            break;
        case SJFLLayoutAttributeTop: {
            // update bottom layout
            [m[SJFLLayoutAttributeKeyBottom] refreshLayoutIfNeeded];
        }
            break;
        case SJFLLayoutAttributeLeft: {
            // update right layout
            [m[SJFLLayoutAttributeKeyRight] refreshLayoutIfNeeded];
        }
            break;
        case SJFLLayoutAttributeBottom: {
            [m[SJFLLayoutAttributeKeyWidth] refreshLayoutIfNeeded];
        }
            break;
        case SJFLLayoutAttributeRight: {
            [m[SJFLLayoutAttributeKeyHeight] refreshLayoutIfNeeded];
        }
            break;
        case SJFLLayoutAttributeCenterX:
            break;
        case SJFLLayoutAttributeCenterY:
            break;
    }
}

// fix inner size

UIKIT_STATIC_INLINE void SJFLViewLayoutFixInnerSizeIfNeeded(UIView *view) {
    NSMutableDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *_Nullable m = objc_getAssociatedObject(view, kFL_Container);
    if ( !m )
        return;
    static Class FL_UILabelClass;
    static Class FL_UIButtonClass;
    static Class FL_UIImageViewClass;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FL_UILabelClass = [UILabel class];
        FL_UIButtonClass = [UIButton class];
        FL_UIImageViewClass = [UIImageView class];
    });
    
    if ( [view isKindOfClass:FL_UILabelClass] ) {
        SJFLLabelAdjustBoxIfNeeded((id)view, m);
    }
    
    // - fitting size -
    SJFLLayoutAttributeUnit *_Nullable fit_width = nil;
    SJFLLayoutAttributeUnit *_Nullable fit_height = nil;
    
    SJFLLayoutAttributeUnit *_Nullable widthElement = m[SJFLLayoutAttributeKeyWidth].target;
    if ( widthElement && widthElement->priority == 1 ) fit_width = widthElement;
    SJFLLayoutAttributeUnit *_Nullable heightElement = m[SJFLLayoutAttributeKeyHeight].target;
    if ( heightElement && heightElement->priority == 1 ) fit_height = heightElement;
    
    if ( fit_width != nil || fit_height != nil ) {
        if ( [view isKindOfClass:FL_UILabelClass] ) {
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

UIKIT_STATIC_INLINE void SJFLLabelAdjustBoxIfNeeded(UILabel *label, NSMutableDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *m ) {
    CGFloat preferredMaxLayoutWidth = label.preferredMaxLayoutWidth;
    if ( !SJFLFloatCompare(0, preferredMaxLayoutWidth) ) {
        SJFLLayoutAttributeUnit *_Nullable widthUnit = m[SJFLLayoutAttributeKeyWidth].target;
        if ( (widthUnit && widthUnit->priority == 1) || !widthUnit ) {
            widthUnit = [[SJFLLayoutAttributeUnit alloc] initWithView:label attribute:SJFLLayoutAttributeWidth];
            m[SJFLLayoutAttributeKeyWidth] = [[SJFLLayoutElement alloc] initWithTarget:widthUnit];
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
        SJFLLayoutElement *_Nullable right = [sub FL_elementForAttributeKey:SJFLLayoutAttributeKeyRight];;
        CGFloat subMaxX = CGRectGetMaxX(sub.frame) - right.offset;
        if ( subMaxX > maxX ) maxX = subMaxX;
    }

    CGFloat maxY = 0;
    for ( UIView *sub in view.subviews ) {
        SJFLLayoutElement *_Nullable bottom = [sub FL_elementForAttributeKey:SJFLLayoutAttributeKeyBottom];
        CGFloat subMaxY = CGRectGetMaxY(sub.frame) - bottom.offset;
        if ( subMaxY > maxY ) maxY = subMaxY;
    }
    
    CGSize intrinsicContentSize = view.intrinsicContentSize;
    if ( SJFLFloatCompare(0, maxX) ) {
        if ( intrinsicContentSize.width != UIViewNoIntrinsicMetric )
            maxX = intrinsicContentSize.width;
    }
    if ( SJFLFloatCompare(0, maxY) ) {
        if ( intrinsicContentSize.height != UIViewNoIntrinsicMetric )
            maxY = intrinsicContentSize.height;
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
    NSMutableSet *set = SJFLGetElementsRelatedViews(view.FL_elements.allValues);
    if ( view.superview ) [set addObject:view.superview];

    for ( UIView *view in set ) {
        [view layoutSubviews];
    }
}

NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *_Nullable
SJFLElements(UIView *view) {
    return objc_getAssociatedObject(view, kFL_Container);
}
@end
NS_ASSUME_NONNULL_END
