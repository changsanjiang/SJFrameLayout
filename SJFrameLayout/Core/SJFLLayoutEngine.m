//
//  SJFLLayoutEngine.m
//  Pods
//
//  Created by BlueDancer on 2019/5/17.
//

#import "SJFLLayoutEngine.h"
#import <objc/message.h>
#import "LWZCommonWeakProxy.h"
#import "SJFLLayoutWeakTarget.h"

NS_ASSUME_NONNULL_BEGIN
@implementation UIView (SJFLWeakProxy)
- (LWZCommonWeakProxy *)SJFL_weakProxy {
    LWZCommonWeakProxy *_Nullable proxy = objc_getAssociatedObject(self, _cmd);
    if ( proxy == nil ) {
        proxy = [LWZCommonWeakProxy weakProxyWithTarget:self];
        objc_setAssociatedObject(self, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return proxy;
}
@end

#pragma mark -

typedef NSNumber *__SJFL_HashKey;
typedef NSMutableDictionary<__SJFL_HashKey, NSMutableDictionary<__SJFL_HashKey, LWZCommonWeakProxy *> *> *__SJFL_ViewsMap_t;
static __SJFL_ViewsMap_t __SJFL_ViewsMap;
static Class SJFL_UILabelClass;
static Class SJFL_UIButtonClass;
static Class SJFL_UIImageViewClass;

UIKIT_STATIC_INLINE void
__SJFL_ViewsMapInitialize(void) {
    __SJFL_ViewsMap = NSMutableDictionary.new;
}

static void
__SJFL_ViewsMapAdd(UIView *layoutView, SJFL_ElementsMap elements) {
    __SJFL_HashKey layoutViewKey = @([layoutView hash]);
    [elements enumerateKeysAndObjectsUsingBlock:^(SJFLLayoutAttributeKey  _Nonnull key, SJFLLayoutElement * _Nonnull obj, BOOL * _Nonnull stop) {
        UIView *dep_view = obj.dep_view;
        if ( dep_view != layoutView ) {
            __SJFL_HashKey key = @([dep_view hash]);
            __auto_type _Nullable subitems = __SJFL_ViewsMap[key];
            if ( subitems == nil ) {
                __SJFL_ViewsMap[key] = subitems = NSMutableDictionary.new;
            }
            
            __auto_type _Nullable layoutItem = subitems[layoutViewKey];
            if ( layoutItem == nil ) {
                subitems[layoutViewKey] = layoutView.SJFL_weakProxy;
            }
        }
    }];
}

static void *kAutoremove = &kAutoremove;
static void
__SJFL_ViewsMapAutoremove(UIView *layoutView, SJFL_ElementsMap elements) {
    __SJFL_HashKey layoutViewKey = @([layoutView hash]);
    SJFLLayoutDeallocCallbackObject *weak = [[SJFLLayoutDeallocCallbackObject alloc] initWithDeallocCallback:^{
        if ( elements != nil ) {
            [elements enumerateKeysAndObjectsUsingBlock:^(SJFLLayoutAttributeKey  _Nonnull key, SJFLLayoutElement * _Nonnull obj, BOOL * _Nonnull stop) {
                
#warning next ... autoremove 
                UIView *dep_view = obj.dep_view;
                __SJFL_HashKey dep_key = @([dep_view hash]);
                __auto_type _Nullable subitems = __SJFL_ViewsMap[dep_key];
                if ( subitems != nil ) {
                    subitems[layoutViewKey] = nil;
                    if ( subitems.count == 0 ) {
                        __SJFL_ViewsMap[key] = nil;
                    }
                }
            }];
        }
    }];
    objc_setAssociatedObject(layoutView, kAutoremove, weak, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

UIKIT_STATIC_INLINE void
__SJFL_ViewsMapRemove(UIView *layoutView) {
    objc_setAssociatedObject(layoutView, kAutoremove, nil, 0);
}

UIKIT_STATIC_INLINE void
__SJFL_ViewsMapUpdate(UIView *dep_view) {
    __SJFL_HashKey key = @([dep_view hash]);
    __auto_type _Nullable subitems = __SJFL_ViewsMap[key];
    if ( subitems != nil ) {
        [subitems enumerateKeysAndObjectsUsingBlock:^(__SJFL_HashKey  _Nonnull key, LWZCommonWeakProxy * _Nonnull proxy, BOOL * _Nonnull stop) {
            SJFL_LayoutIfNeeded(proxy.target);
        }];
    }
}

#pragma mark -

static void *kLayoutElements = &kLayoutElements;
void
SJFL_InstallLayout(UIView *layoutView, SJFL_ElementsMap elements) {
    objc_setAssociatedObject(layoutView, kLayoutElements, elements, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    __SJFL_ViewsMapAdd(layoutView, elements);
    __SJFL_ViewsMapAutoremove(layoutView, elements);
}

void
SJFL_RemoveLayout(UIView *layoutView) {
    __SJFL_ViewsMapRemove(layoutView);
    objc_setAssociatedObject(layoutView, kLayoutElements, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

UIKIT_STATIC_INLINE SJFLLayoutElement *_Nullable
__SJFL_GetLayoutElement(UIView *layoutView, SJFLLayoutAttributeKey attributeKey) {
    return ((SJFL_ElementsMap)objc_getAssociatedObject(layoutView, kLayoutElements))[attributeKey];
}

UIKIT_STATIC_INLINE SJFL_ElementsMap _Nullable
__SJFL_GetLayoutElements(UIView *layoutView) {
    return objc_getAssociatedObject(layoutView, kLayoutElements);
}

#pragma mark -
// fix inner size

UIKIT_STATIC_INLINE BOOL
__SJFL_HasFittingSize(__kindof UIView *view) {
    // - fitting size -
    SJFLLayoutAttributeUnit *_Nullable fit_width = nil;
    SJFLLayoutAttributeUnit *_Nullable fit_height = nil;
    
    SJFLLayoutAttributeUnit *_Nullable widthUnit = __SJFL_GetLayoutElement(view, SJFLLayoutAttributeKeyWidth).target;
    if ( widthUnit && widthUnit->priority == 1 ) fit_width = widthUnit;
    SJFLLayoutAttributeUnit *_Nullable heightUnit = __SJFL_GetLayoutElement(view, SJFLLayoutAttributeKeyHeight).target;
    if ( heightUnit && heightUnit->priority == 1 ) fit_height = heightUnit;
    
    return fit_width != nil || fit_height != nil;
}

UIKIT_STATIC_INLINE BOOL
__SJFL_FixLabelFittingSizeIfNeeded(UILabel *view, SJFLLayoutAttributeUnit *_Nullable fit_width, SJFLLayoutAttributeUnit *_Nullable fit_height) {
    //    static void *kPrevious = &kPrevious;
    //    id _Nullable previousValue = objc_getAssociatedObject(view, kPrevious);
    //    id _Nullable nowValue = [NSNumber numberWithLongLong:(long long)(__bridge void *)(view.attributedText?:view.text)];
    //    if ( [previousValue isEqual:nowValue] )
    //        return NO;
    //    objc_setAssociatedObject(view, kPrevious, nowValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    CGRect frame = view.frame;
    CGSize box = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    
    // 具有宽度约束
    if ( fit_width == nil ) {
        box.width = CGRectGetWidth(frame);
        if ( box.width <= 0 )
            return NO;
    }
    // 具有高度约束
    else if ( fit_height == nil ) {
        box.height = CGRectGetHeight(frame);
        if ( box.height <= 0 )
            return NO;
    }
    
    CGRect rect = [view textRectForBounds:CGRectMake(0, 0, box.width, box.height) limitedToNumberOfLines:view.numberOfLines];
    CGSize fit = CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
    
    BOOL fixed = NO;
    if ( fit_width != nil ) {
        if ( fit_width->offset.value != fit.width ) {
            fit_width->offset.value = fit.width;
            fixed = YES;
        }
    }
    
    if ( fit_height != nil ) {
        if ( fit_height->offset.value != fit.height ) {
            fit_height->offset.value = fit.height;
            fixed = YES;
        }
    }
    return fixed;
}

UIKIT_STATIC_INLINE BOOL
__SJFL_FixButtonFittingSizeIfNeeded(UIButton *view, SJFLLayoutAttributeUnit *_Nullable fit_width, SJFLLayoutAttributeUnit *_Nullable fit_height) {
    //    static void *kPrevious = &kPrevious;
    //    id _Nullable previousValue = objc_getAssociatedObject(view, kPrevious);
    //    id _Nullable nowValue = [NSString stringWithFormat:@"%p, %p, %p", view.currentAttributedTitle?:view.currentTitle, view.currentImage, view.currentBackgroundImage];
    //    if ( [nowValue isEqual:previousValue] )
    //        return NO;
    //    objc_setAssociatedObject(view, kPrevious, nowValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    CGRect frame = view.frame;
    CGSize box = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    
    // 具有宽度约束
    if ( fit_width == nil ) {
        box.width = CGRectGetWidth(frame);
        if ( box.width <= 0 )
            return NO;
    }
    // 具有高度约束
    else if ( fit_height == nil ) {
        box.height = CGRectGetHeight(frame);
        if ( box.height <= 0 )
            return NO;
    }
    
    CGSize result = [view sizeThatFits:box];
    CGSize fit = CGSizeMake(ceil(result.width), ceil(result.height));
    
    BOOL fixed = NO;
    if ( fit_width != nil ) {
        if ( fit_width->offset.value != fit.width ) {
            fit_width->offset.value = fit.width;
            fixed = YES;
        }
    }
    
    if ( fit_height != nil ) {
        if ( fit_height->offset.value != fit.height ) {
            fit_height->offset.value = fit.height;
            fixed = YES;
        }
    }
    return fixed;
}

UIKIT_STATIC_INLINE BOOL
__SJFL_FixImageViewFittingSizeIfNeeded(UIImageView *view, SJFLLayoutAttributeUnit *_Nullable fit_width, SJFLLayoutAttributeUnit *_Nullable fit_height) {
    //    static void *kPrevious = &kPrevious;
    //    id _Nullable previousValue = objc_getAssociatedObject(view, kPrevious);
    //    id _Nullable nowValue = [NSString stringWithFormat:@"%p - %ld", view.image, (long)view.contentMode];
    //    if ( [previousValue isEqual:nowValue] )
    //        return NO;
    //    objc_setAssociatedObject(view, kPrevious, nowValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    CGRect frame = view.frame;
    CGSize box = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    
    // 具有宽度约束
    if ( fit_width == nil ) {
        box.width = CGRectGetWidth(frame);
        if ( box.width <= 0 )
            return NO;
    }
    // 具有高度约束
    else if ( fit_height == nil ) {
        box.height = CGRectGetHeight(frame);
        if ( box.height <= 0 )
            return NO;
    }
    
    CGSize result = [view sizeThatFits:box];
    CGSize fit = CGSizeMake(ceil(result.width), ceil(result.height));
    
    BOOL fixed = NO;
    if ( fit_width != nil ) {
        if ( fit_width->offset.value != fit.width ) {
            fit_width->offset.value = fit.width;
            fixed = YES;
        }
    }
    
    if ( fit_height != nil ) {
        if ( fit_height->offset.value != fit.height ) {
            fit_height->offset.value = fit.height;
            fixed = YES;
        }
    }
    return fixed;
}

UIKIT_STATIC_INLINE BOOL
__SJFL_FixViewFittingSizeIfNeeded(UIView *view, SJFLLayoutAttributeUnit *_Nullable fit_width, SJFLLayoutAttributeUnit *_Nullable fit_height) {
    CGFloat maxX = 0;
    for ( UIView *sub in view.subviews ) {
        SJFLLayoutElement *_Nullable right = __SJFL_GetLayoutElement(sub, SJFLLayoutAttributeKeyRight);
        CGFloat subMaxX = CGRectGetMaxX(sub.frame) - right.offset;
        if ( subMaxX > maxX ) maxX = subMaxX;
    }
    
    CGFloat maxY = 0;
    for ( UIView *sub in view.subviews ) {
        SJFLLayoutElement *_Nullable bottom = __SJFL_GetLayoutElement(sub, SJFLLayoutAttributeKeyBottom);
        CGFloat subMaxY = CGRectGetMaxY(sub.frame) - bottom.offset;
        if ( subMaxY > maxY ) maxY = subMaxY;
    }
    
    CGSize intrinsicContentSize = view.intrinsicContentSize;
    if ( 0 == maxX ) {
        if ( intrinsicContentSize.width != UIViewNoIntrinsicMetric )
            maxX = intrinsicContentSize.width;
    }
    if ( 0 == maxY ) {
        if ( intrinsicContentSize.height != UIViewNoIntrinsicMetric )
            maxY = intrinsicContentSize.height;
    }
    
    BOOL fixed = NO;
    if ( maxX != fit_width->offset.value ) {
        fit_width->offset.value = maxX;
        fixed = YES;
    }
    
    if ( maxY != fit_height->offset.value ) {
        fit_height->offset.value = maxY;
        fixed = YES;
    }
    return fixed;
    //    NSLog(@"maxX: %lf, maxY: %lf", maxX, maxY);
}

UIKIT_STATIC_INLINE BOOL
__SJFL_FixInnerSizeIfNeeded(__kindof UIView *view) {
    // - fitting size -
    SJFLLayoutAttributeUnit *_Nullable fit_width = nil;
    SJFLLayoutAttributeUnit *_Nullable fit_height = nil;
    
    SJFLLayoutAttributeUnit *_Nullable widthUnit = __SJFL_GetLayoutElement(view, SJFLLayoutAttributeKeyWidth).target;
    if ( widthUnit && widthUnit->priority == 1 ) fit_width = widthUnit;
    SJFLLayoutAttributeUnit *_Nullable heightUnit = __SJFL_GetLayoutElement(view, SJFLLayoutAttributeKeyHeight).target;
    if ( heightUnit && heightUnit->priority == 1 ) fit_height = heightUnit;
    
    if ( fit_width != nil || fit_height != nil ) {
        if ( [view isKindOfClass:SJFL_UILabelClass] )
            return __SJFL_FixLabelFittingSizeIfNeeded(view, fit_width, fit_height);
        else if ( [view isKindOfClass:SJFL_UIButtonClass] )
            return __SJFL_FixButtonFittingSizeIfNeeded(view, fit_width, fit_height);
        else if ( [view isKindOfClass:SJFL_UIImageViewClass] )
            return __SJFL_FixImageViewFittingSizeIfNeeded(view, fit_width, fit_height);
        else
            return __SJFL_FixViewFittingSizeIfNeeded(view, fit_width, fit_height);
    }
    
    return NO;
}

#pragma mark -

UIKIT_STATIC_INLINE BOOL
__SJFL_Compare(CGRect frame, SJFLLayoutAttribute attr, CGFloat value) {
    switch ( attr ) {
        case SJFLLayoutAttributeNone:
            return NO;
        case SJFLLayoutAttributeTop:
            return value == frame.origin.y;
        case SJFLLayoutAttributeLeft:
            return value == frame.origin.x;
        case SJFLLayoutAttributeBottom:
            return value == frame.origin.y + frame.size.height;
        case SJFLLayoutAttributeRight:
            return value == frame.origin.x + frame.size.width;
        case SJFLLayoutAttributeWidth:
            return value == frame.size.width;
        case SJFLLayoutAttributeHeight:
            return value == frame.size.height;
        case SJFLLayoutAttributeCenterX:
            return value == frame.origin.x + frame.size.width * 0.5;
        case SJFLLayoutAttributeCenterY:
            return value == frame.origin.y + frame.size.height * 0.5;
            break;
    }
}

void
__SJFL_InstallElementLayoutIfNeeded(SJFLLayoutElement *element, CGRect *frame) {
    UIView *_Nullable view = element.tar_view;
    if ( view == nil ) {
        return;
    }
    
    CGFloat newValue = [element value:*frame];
    SJFLLayoutAttribute tar_attr = element.tar_attr;
    if ( __SJFL_Compare(*frame, tar_attr, newValue) ) {
        return;
    }
    
    switch ( tar_attr ) {
        case SJFLLayoutAttributeNone: break; ///< Target does not need to do anything
        case SJFLLayoutAttributeTop:{
            frame->origin.y = newValue;
        }
            break;
        case SJFLLayoutAttributeLeft: {
            frame->origin.x = newValue;
        }
            break;
        case SJFLLayoutAttributeBottom: {
            SJFLLayoutElement *_Nullable heightElement = __SJFL_GetLayoutElement(view, SJFLLayoutAttributeKeyHeight);
            if ( heightElement == nil ) {
                // top + height = bottom
                // height = bottom - top
                CGFloat height = newValue - frame->origin.y;
                if ( height < 0 ) height = 0;
                frame->size.height = height;
            }
            else {
                // top + height = bottom
                // top = bottom - height
                CGFloat top = newValue - frame->size.height;
                frame->origin.y = top;
            }
        }
            break;
        case SJFLLayoutAttributeRight: {
            SJFLLayoutElement *_Nullable widthElement = __SJFL_GetLayoutElement(view, SJFLLayoutAttributeKeyWidth);
            if ( widthElement == nil ) {
                // left + width = right
                // width = right - left
                CGFloat width = newValue - frame->origin.x;
                if ( width < 0 ) width = 0;
                frame->size.width = width;
            }
            else {
                // left + width = right
                // left = right - width
                CGFloat left = newValue - frame->size.width;
                frame->origin.x = left;
            }
        }
            break;
        case SJFLLayoutAttributeWidth: {
            if ( newValue < 0 ) newValue = 0;
            frame->size.width = newValue;        }
            break;
        case SJFLLayoutAttributeHeight: {
            if ( newValue < 0 ) newValue = 0;
            frame->size.height = newValue;
        }
            break;
        case SJFLLayoutAttributeCenterX: {
            // newValue = frame.origin.x + frame.origin.width * 0.5
            CGFloat x = newValue - frame->size.width * 0.5;
            frame->origin.x = x;
        }
            break;
        case SJFLLayoutAttributeCenterY: {
            // centerY = frame.origin.y + frame.origin.height * 0.5
            CGFloat y = newValue - frame->size.height * 0.5;
            frame->origin.y = y;
        }
            break;
    }

}

void
SJFL_LayoutIfNeeded(UIView *layoutView) {
    if ( layoutView != nil ) {
        SJFL_ElementsMap _Nullable m = __SJFL_GetLayoutElements(layoutView);
        if ( m != nil ) {
            SJFLLayoutElement *_Nullable top = m[SJFLLayoutAttributeKeyTop];
            SJFLLayoutElement *_Nullable left = m[SJFLLayoutAttributeKeyLeft];
            SJFLLayoutElement *_Nullable bottom = m[SJFLLayoutAttributeKeyBottom];
            SJFLLayoutElement *_Nullable right = m[SJFLLayoutAttributeKeyRight];
            SJFLLayoutElement *_Nullable width = m[SJFLLayoutAttributeKeyWidth];
            SJFLLayoutElement *_Nullable height = m[SJFLLayoutAttributeKeyHeight];
            SJFLLayoutElement *_Nullable centerX = m[SJFLLayoutAttributeKeyCenterX];
            SJFLLayoutElement *_Nullable centerY = m[SJFLLayoutAttributeKeyCenterY];
            
        handle_elements:;
            CGRect previous = layoutView.frame;
            CGRect frame = previous;
            if ( width != nil ) __SJFL_InstallElementLayoutIfNeeded(width, &frame);
            if ( height != nil ) __SJFL_InstallElementLayoutIfNeeded(height, &frame);
            
            if ( top != nil ) __SJFL_InstallElementLayoutIfNeeded(top, &frame);
            if ( height == nil && bottom != nil ) __SJFL_InstallElementLayoutIfNeeded(bottom, &frame);
            if ( width != nil ) __SJFL_InstallElementLayoutIfNeeded(width, &frame);
            
            if ( left != nil ) __SJFL_InstallElementLayoutIfNeeded(left, &frame);
            if ( left != nil  && width != nil ) {}
            else if ( right != nil ) __SJFL_InstallElementLayoutIfNeeded(right, &frame);
            if ( height != nil ) __SJFL_InstallElementLayoutIfNeeded(height, &frame);
            
            if ( top != nil && height != nil ) {}
            else if ( bottom != nil ) __SJFL_InstallElementLayoutIfNeeded(bottom, &frame);
            
            if ( centerX != nil ) __SJFL_InstallElementLayoutIfNeeded(centerX, &frame);
            if ( centerY != nil ) __SJFL_InstallElementLayoutIfNeeded(centerY, &frame);
            
            BOOL changed = NO;
            if ( !CGRectEqualToRect(frame, previous) ) {
                changed = YES;
                layoutView.frame = frame;
            }
            
            if ( __SJFL_FixInnerSizeIfNeeded(layoutView) )
                goto handle_elements;
            
            if ( changed ) {
                [m enumerateKeysAndObjectsUsingBlock:^(SJFLLayoutAttributeKey  _Nonnull key, SJFLLayoutElement * _Nonnull obj, BOOL * _Nonnull stop) {
                    UIView *dep_view = obj.dep_view;
                    if ( __SJFL_HasFittingSize(dep_view) ) {
                        SJFL_LayoutIfNeeded(dep_view);
                    }
                }];
            }
        }
    }
}

#pragma mark -

@implementation UIView (SJFL_Private)
static void
__SJFL_SwizzleMethod(Class cls, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
    
    BOOL added = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if ( added )
        class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    else
        method_exchangeImplementations(originalMethod, swizzledMethod);
}

+ (void)load {
    __SJFL_ViewsMapInitialize();
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SJFL_UILabelClass = UILabel.class;
        SJFL_UIButtonClass = UIButton.class;
        SJFL_UIImageViewClass = UIImageView.class;
        
        Class cls = UIView.class;
        __SJFL_SwizzleMethod(cls, @selector(FL_setFrame:), @selector(setFrame:));
        __SJFL_SwizzleMethod(cls, @selector(FL_setCenter:), @selector(setCenter:));
        __SJFL_SwizzleMethod(cls, @selector(FL_setBounds:), @selector(setBounds:));
        __SJFL_SwizzleMethod(cls, @selector(FL_safeAreaInsetsDidChange), @selector(safeAreaInsetsDidChange));
    });
}

- (void)FL_setFrame:(CGRect)frame {
    [self FL_setFrame:frame];
    __SJFL_ViewsMapUpdate(self);
}

- (void)FL_setBounds:(CGRect)bounds {
    [self FL_setBounds:bounds];
    __SJFL_ViewsMapUpdate(self);
}

- (void)FL_setCenter:(CGPoint)center {
    [self FL_setCenter:center];
    __SJFL_ViewsMapUpdate(self);
}

- (void)FL_safeAreaInsetsDidChange {
    [self FL_safeAreaInsetsDidChange];
    __SJFL_ViewsMapUpdate(self);
}
@end
NS_ASSUME_NONNULL_END
