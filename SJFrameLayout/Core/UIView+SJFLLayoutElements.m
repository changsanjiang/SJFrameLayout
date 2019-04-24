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
    NSMutableDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *_Nullable
    m = objc_getAssociatedObject(self, kFL_Container);
    if ( m ) {
        // 布局应该从width和height优先安装
        
        // top 安装好之后, 会影响到什么, 或者什么可以定位到了 ?
        // - bottom
        // 当 top 和 bottom 同时安装之后, 会生成 height. 当width依赖height时, 此时可以刷新width
        
        // left 安装好之后, 会影响到什么, 或者什么可以定位到了 ?
        // - right
        // 当 left 和 right 同时安装之后, 会生成 width. 当height依赖width时, 此时可以刷新height
        
        // height 改变之后, 会影响到什么?
        // - centerY
        // - bottom
        
        // width 改变之后, 会影响到什么?
        // - centerX
        // - right
        
        // bottom 安装之后, 会影响到什么?
        // centerY 安装之后, 会影响到什么?
        // centerX 安装之后, 会影响到什么?
        
        SJFLLayoutElement *_Nullable top = m[SJFLLayoutAttributeKeyTop];
        SJFLLayoutElement *_Nullable left = m[SJFLLayoutAttributeKeyLeft];
        SJFLLayoutElement *_Nullable bottom = m[SJFLLayoutAttributeKeyBottom];
        SJFLLayoutElement *_Nullable right = m[SJFLLayoutAttributeKeyRight];
        SJFLLayoutElement *_Nullable width = m[SJFLLayoutAttributeKeyWidth];
        SJFLLayoutElement *_Nullable height = m[SJFLLayoutAttributeKeyHeight];
        SJFLLayoutElement *_Nullable centerX = m[SJFLLayoutAttributeKeyCenterX];
        SJFLLayoutElement *_Nullable centerY = m[SJFLLayoutAttributeKeyCenterY];
        
        CGRect previous = self.frame;
        CGRect frame = previous;
        if ( width ) [width refreshLayoutIfNeeded:&frame];
        if ( height ) [height refreshLayoutIfNeeded:&frame];
        
        if ( top ) [top refreshLayoutIfNeeded:&frame];
        if ( !height ) [bottom refreshLayoutIfNeeded:&frame];
        if ( width ) [width refreshLayoutIfNeeded:&frame];
        
        if ( left ) [left refreshLayoutIfNeeded:&frame];
        if ( left && width ) {}
        else if ( right ) [right refreshLayoutIfNeeded:&frame];
        if ( height ) [height refreshLayoutIfNeeded:&frame];
        
        if ( top && height ) {}
        else if ( bottom ) [bottom refreshLayoutIfNeeded:&frame];
        
        if ( centerX ) [centerX refreshLayoutIfNeeded:&frame];
        if ( centerY ) [centerY refreshLayoutIfNeeded:&frame];
        if ( !CGRectEqualToRect(frame, previous) )
            self.frame = frame;
        
        SJFLViewLayoutFixInnerSizeIfNeeded(self, m);
    }
    
    SJFLViewLayoutFixInnerSizeIfNeeded(view, nil);
}

//UIKIT_STATIC_INLINE BOOL SJFLViewBottomCanSettable(UIView *view) {
//    NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *m = SJFLElements(view);
//    SJFLLayoutElement *_Nullable top = m[SJFLLayoutAttributeKeyTop];
//    SJFLLayoutElement *_Nullable height = m[SJFLLayoutAttributeKeyHeight];
//    if ( top != nil  && height != nil ) return NO;
////    SJFLLayoutSetInfo *info = view.FL_info;
////    return [info get:SJFLLayoutAttributeTop] || [info get:SJFLLayoutAttributeHeight];
//}
//
//UIKIT_STATIC_INLINE BOOL SJFLViewRightCanSettable(UIView *view) {
//    NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *m = SJFLElements(view);
//    SJFLLayoutElement *_Nullable left = m[SJFLLayoutAttributeKeyLeft];
//    SJFLLayoutElement *_Nullable width = m[SJFLLayoutAttributeKeyWidth];
//    if ( left != nil  && width != nil ) return NO;
////    SJFLLayoutSetInfo *info = view.FL_info;
////    return [info get:SJFLLayoutAttributeLeft] || [info get:SJFLLayoutAttributeWidth];
//}

// fix inner size

UIKIT_STATIC_INLINE void SJFLViewLayoutFixInnerSizeIfNeeded(UIView *view, NSMutableDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *_Nullable m) {
    if ( !m ) m = objc_getAssociatedObject(view, kFL_Container);
    if ( !m ) return;
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
    static void *kBefore = &kBefore;
    id _Nullable beforeValue = objc_getAssociatedObject(view, kBefore);
    id _Nullable nowValue = [NSNumber numberWithLongLong:(long long)(__bridge void *)(view.attributedText?:view.text)]; // [NSString stringWithFormat:@"%p", view.attributedText?:view.text];
    if ( [beforeValue isEqual:nowValue] )
        return;
    objc_setAssociatedObject(view, kBefore, nowValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

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
        [view.FL_elementsCommonSuperview layoutSubviews];
    }
}

UIKIT_STATIC_INLINE void SJFLButtonLayoutFixInnerSize(UIButton *view, SJFLLayoutAttributeUnit *_Nullable fit_width, SJFLLayoutAttributeUnit *_Nullable fit_height) {
    static void *kBefore = &kBefore;
    id _Nullable beforeValue = objc_getAssociatedObject(view, kBefore);
    id _Nullable nowValue = [NSString stringWithFormat:@"%p, %p, %p", view.currentAttributedTitle?:view.currentTitle, view.currentImage, view.currentBackgroundImage];
    if ( [nowValue isEqual:beforeValue] )
        return;
    objc_setAssociatedObject(view, kBefore, nowValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
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
        [view.FL_elementsCommonSuperview layoutSubviews];
    }
}

UIKIT_STATIC_INLINE void SJFLImageViewLayoutFixInnerSize(UIImageView *view, SJFLLayoutAttributeUnit *_Nullable fit_width, SJFLLayoutAttributeUnit *_Nullable fit_height) {
    static void *kBefore = &kBefore;
    id _Nullable beforeValue = objc_getAssociatedObject(view, kBefore);
    id _Nullable nowValue = [NSString stringWithFormat:@"%p - %ld", view.image, (long)view.contentMode];
    if ( [beforeValue isEqual:nowValue] )
        return;
    objc_setAssociatedObject(view, kBefore, nowValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
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
        [view.FL_elementsCommonSuperview layoutSubviews];
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
        [view.FL_elementsCommonSuperview layoutSubviews];
    }
    
//    NSLog(@"maxX: %lf, maxY: %lf", maxX, maxY);
}

UIKIT_STATIC_INLINE BOOL SJFLFloatCompare(CGFloat value1, CGFloat value2) {
    return floor(value1 + 0.5) == floor(value2 + 0.5);
}

NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *_Nullable
SJFLElements(UIView *view) {
    return objc_getAssociatedObject(view, kFL_Container);
}
@end
NS_ASSUME_NONNULL_END
