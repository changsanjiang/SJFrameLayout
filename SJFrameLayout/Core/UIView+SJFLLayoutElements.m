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
#import "SJFLLayoutWeakTarget.h"

NS_ASSUME_NONNULL_BEGIN

#define FL_log_layout (0)

#define SJFLTEST    (1)

#if SJFLTEST
static int call_cout01 = 0;
static int call_cout02 = 0;
static int call_cout03 = 0;
#endif

UIKIT_STATIC_INLINE void
SJFLSwizzleMethod(Class cls, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
    
    BOOL added = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if ( added )
        class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    else
        method_exchangeImplementations(originalMethod, swizzledMethod);
}

static Class FL_UILabelClass;
static Class FL_UIButtonClass;
static Class FL_UIImageViewClass;

// - 存储依赖父视图布局的视图
typedef NSNumber *SJFLLayoutSuperviewKey;
typedef NSNumber *SJFLLayoutTargetViewKey;
static NSMutableDictionary<SJFLLayoutSuperviewKey, NSMutableDictionary<SJFLLayoutTargetViewKey, SJFLLayoutWeakTarget *> *> *
FL_ViewMapLayoutSuperviews;
UIKIT_STATIC_INLINE void
SJFLViewMapAddOrRemoveLayoutViewToSuperview(UIView *layoutView, NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> * _Nullable elements) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FL_ViewMapLayoutSuperviews = NSMutableDictionary.new;
    });
    
    UIView *superview = layoutView.superview;
    SJFLLayoutSuperviewKey superviewKey = @([superview hash]);
    __auto_type _Nullable views = FL_ViewMapLayoutSuperviews[superviewKey];
    if ( !views ) FL_ViewMapLayoutSuperviews[superviewKey] = views = NSMutableDictionary.new;
    
    SJFLLayoutTargetViewKey targetViewKey = @([layoutView hash]);
    if ( elements ) {
        if ( !views[targetViewKey] ) {
            views[targetViewKey] = [[SJFLLayoutWeakTarget alloc] initWithWeakTarget:layoutView];
            SJFLLayoutDeallocCallbackObject *deallocCallbackObject = [[SJFLLayoutDeallocCallbackObject alloc] initWithDeallocCallback:^{
                views[targetViewKey] = nil;
                if ( views.count == 0 )
                    FL_ViewMapLayoutSuperviews[superviewKey] = nil;
            }];
            
            objc_setAssociatedObject(layoutView, (__bridge const void *)(deallocCallbackObject), deallocCallbackObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    else {
        views[targetViewKey] = nil;
    }
}

UIKIT_STATIC_INLINE void
SJFLViewMapLayoutSubviewsIfNeededForSuperview(UIView *superview) {
    SJFLLayoutSuperviewKey superviewKey = @([superview hash]);
    __auto_type _Nullable views = FL_ViewMapLayoutSuperviews[superviewKey];
    if ( views ) {
        [views enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, SJFLLayoutWeakTarget * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj->_target FL_layoutIfNeeded];
        }];
    }
}

//UIKIT_STATIC_INLINE BOOL
//SJFLViewHasFittingSizeUnits(UIView *layoutView, NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *elements) {
//    // - fitting size -
//    SJFLLayoutAttributeUnit *_Nullable fit_width = nil;
//    SJFLLayoutAttributeUnit *_Nullable fit_height = nil;
//
//    SJFLLayoutAttributeUnit *_Nullable widthUnit = elements[SJFLLayoutAttributeKeyWidth].target;
//    if ( widthUnit && widthUnit->priority == 1 ) fit_width = widthUnit;
//    SJFLLayoutAttributeUnit *_Nullable heightUnit = elements[SJFLLayoutAttributeKeyHeight].target;
//    if ( heightUnit && heightUnit->priority == 1 ) fit_height = heightUnit;
//
//    return fit_width != nil || fit_height != nil;
//}
//

static NSMutableDictionary<SJFLLayoutTargetViewKey, SJFLLayoutWeakTarget *> *FL_ViewMapLayoutViews;
UIKIT_STATIC_INLINE void
SJFLViewMapAddOrRemoveLayoutView(UIView *layoutView, NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *elements) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FL_ViewMapLayoutViews = NSMutableDictionary.new;
    });
    
    if ( elements ) {
        SJFLLayoutTargetViewKey viewKey = @([layoutView hash]);
        FL_ViewMapLayoutViews[viewKey] = [[SJFLLayoutWeakTarget alloc] initWithWeakTarget:layoutView];
        
        SJFLLayoutDeallocCallbackObject *deallocCallbackObject = [[SJFLLayoutDeallocCallbackObject alloc] initWithDeallocCallback:^{
            FL_ViewMapLayoutViews[viewKey] = nil;
        }];
        objc_setAssociatedObject(layoutView, (__bridge const void *)(deallocCallbackObject), deallocCallbackObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else {
        SJFLLayoutTargetViewKey viewKey = @([layoutView hash]);
        FL_ViewMapLayoutViews[viewKey] = nil;
    }
}

UIKIT_STATIC_INLINE void
SJFLViewMapLayoutIfNeededForLayoutView(UIView *layoutView) {
    SJFLLayoutTargetViewKey viewKey = @([layoutView hash]);
    SJFLLayoutWeakTarget *_Nullable obj = FL_ViewMapLayoutViews[viewKey];
    if ( obj ) {
        [obj->_target FL_layoutIfNeeded];
    }
}

@implementation UIView (SJFLPrivate)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzledSelector = @selector(FL_layoutSubviews);
        SJFLSwizzleMethod(UIView.class, originalSelector, swizzledSelector);
        
        FL_UILabelClass = UILabel.class;
        FL_UIButtonClass = UIButton.class;
        FL_UIImageViewClass = UIImageView.class;
        
#if SJFLTEST
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@":--01 %d", call_cout01);
            NSLog(@":--02 %d", call_cout02);
            NSLog(@":--03 %d", call_cout03);
        });
#endif
    });
}
- (void)FL_layoutSubviews {
    [self FL_layoutSubviews];
    SJFLViewMapLayoutSubviewsIfNeededForSuperview(self);
    SJFLViewMapLayoutIfNeededForLayoutView(self);
}
@end

@implementation UIButton (SJFLPrivate)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzledSelector = @selector(FL_layoutSubviews_button);
        SJFLSwizzleMethod(UIButton.class, originalSelector, swizzledSelector);
    });
}
- (void)FL_layoutSubviews_button {
    [self FL_layoutSubviews_button];
    SJFLViewMapLayoutSubviewsIfNeededForSuperview(self);
    SJFLViewMapLayoutIfNeededForLayoutView(self);
}
@end

@implementation UIView (SJFLLayoutElements)
static void *kFL_ElementsContainer = &kFL_ElementsContainer;
- (SJFLLayoutElement *_Nullable)FL_elementForAttributeKey:(SJFLLayoutAttributeKey)attributeKey {
    return [objc_getAssociatedObject(self, kFL_ElementsContainer) valueForKey:attributeKey];
}
- (void)setFL_elements:(NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> * _Nullable)FL_elements {
    SJFLViewMapAddOrRemoveLayoutViewToSuperview(self, FL_elements);
    SJFLViewMapAddOrRemoveLayoutView(self, FL_elements);
    objc_setAssociatedObject(self, kFL_ElementsContainer, [FL_elements mutableCopy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *_Nullable)FL_elements {
    return objc_getAssociatedObject(self, kFL_ElementsContainer);
}
- (void)FL_layoutIfNeeded {
#if FL_log_layout
    printf("\n before: \t [%p \t %s \t %s]", self, NSStringFromClass(self.class).UTF8String, NSStringFromCGRect(self.frame).UTF8String);
#endif
    
#if SJFLTEST
    call_cout01 += 1;
#endif
    
    NSMutableDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *_Nullable
    m = objc_getAssociatedObject(self, kFL_ElementsContainer);
    if ( m ) {
        
#if DEBUG
        call_cout02 += 1;
#endif
        
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
        
        SJFLFixLabelFittingWidthIfNeeded(self, m);
        
        SJFLLayoutElement *_Nullable top = m[SJFLLayoutAttributeKeyTop];
        SJFLLayoutElement *_Nullable left = m[SJFLLayoutAttributeKeyLeft];
        SJFLLayoutElement *_Nullable bottom = m[SJFLLayoutAttributeKeyBottom];
        SJFLLayoutElement *_Nullable right = m[SJFLLayoutAttributeKeyRight];
        SJFLLayoutElement *_Nullable width = m[SJFLLayoutAttributeKeyWidth];
        SJFLLayoutElement *_Nullable height = m[SJFLLayoutAttributeKeyHeight];
        SJFLLayoutElement *_Nullable centerX = m[SJFLLayoutAttributeKeyCenterX];
        SJFLLayoutElement *_Nullable centerY = m[SJFLLayoutAttributeKeyCenterY];
        
    handle_elements:;
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
        
        if ( !CGRectEqualToRect(frame, previous) ) {
            self.frame = frame;
#if SJFLTEST
            call_cout03 += 1;
#endif
        }

        if ( SJFLViewLayoutFixInnerSizeIfNeeded(self, m) )
            goto handle_elements;
    }
    
#if FL_log_layout
    printf("\n end: \t\t [%p \t %s \t %s]\n", self, NSStringFromClass(self.class).UTF8String, NSStringFromCGRect(self.frame).UTF8String);
#endif
}

// fix inner size

UIKIT_STATIC_INLINE void SJFLFixLabelFittingWidthIfNeeded(UIView *view, NSMutableDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *m ) {
    if ( [view isKindOfClass:UILabel.class] ) {
        UILabel *label = (id)view;
        CGFloat preferredMaxLayoutWidth = label.preferredMaxLayoutWidth;
        if ( preferredMaxLayoutWidth > 0 ) {
            SJFLLayoutAttributeUnit *_Nullable widthUnit = m[SJFLLayoutAttributeKeyWidth].target;
            if ( (widthUnit && widthUnit->priority == 1) || !widthUnit ) {
                widthUnit = [[SJFLLayoutAttributeUnit alloc] initWithView:view attribute:SJFLLayoutAttributeWidth];
                m[SJFLLayoutAttributeKeyWidth] = [[SJFLLayoutElement alloc] initWithTarget:widthUnit];
            }
            widthUnit->offset_t = SJFLCGFloatValue;
            widthUnit->offset.value = preferredMaxLayoutWidth;
        }
    }
}


UIKIT_STATIC_INLINE BOOL SJFLViewLayoutFixInnerSizeIfNeeded(__kindof UIView *view, NSMutableDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *_Nullable m) {
    if ( !m )
        return NO;
    
    // - fitting size -
    SJFLLayoutAttributeUnit *_Nullable fit_width = nil;
    SJFLLayoutAttributeUnit *_Nullable fit_height = nil;
    
    SJFLLayoutAttributeUnit *_Nullable widthUnit = m[SJFLLayoutAttributeKeyWidth].target;
    if ( widthUnit && widthUnit->priority == 1 ) fit_width = widthUnit;
    SJFLLayoutAttributeUnit *_Nullable heightUnit = m[SJFLLayoutAttributeKeyHeight].target;
    if ( heightUnit && heightUnit->priority == 1 ) fit_height = heightUnit;
    
    if ( fit_width != nil || fit_height != nil ) {
        if ( [view isKindOfClass:FL_UILabelClass] )
            return SJFLFixLabelFittingSizeIfNeeded(view, fit_width, fit_height);
        else if ( [view isKindOfClass:FL_UIButtonClass] )
            return SJFLFixButtonFittingSizeIfNeeded(view, fit_width, fit_height);
        else if ( [view isKindOfClass:FL_UIImageViewClass] )
            return SJFLFixImageViewFittingSizeIfNeeded(view, fit_width, fit_height);
        else
            return SJFLFixViewFittingSizeIfNeeded(view, fit_width, fit_height);
    }
    
    return NO;
}

UIKIT_STATIC_INLINE BOOL SJFLFixLabelFittingSizeIfNeeded(UILabel *view, SJFLLayoutAttributeUnit *_Nullable fit_width, SJFLLayoutAttributeUnit *_Nullable fit_height) {
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

UIKIT_STATIC_INLINE BOOL SJFLFixButtonFittingSizeIfNeeded(UIButton *view, SJFLLayoutAttributeUnit *_Nullable fit_width, SJFLLayoutAttributeUnit *_Nullable fit_height) {
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

UIKIT_STATIC_INLINE BOOL SJFLFixImageViewFittingSizeIfNeeded(UIImageView *view, SJFLLayoutAttributeUnit *_Nullable fit_width, SJFLLayoutAttributeUnit *_Nullable fit_height) {
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

UIKIT_STATIC_INLINE BOOL SJFLFixViewFittingSizeIfNeeded(UIView *view, SJFLLayoutAttributeUnit *_Nullable fit_width, SJFLLayoutAttributeUnit *_Nullable fit_height) {
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

NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *_Nullable
SJFLGetElements(UIView *view) {
    return objc_getAssociatedObject(view, kFL_ElementsContainer);
}
@end
NS_ASSUME_NONNULL_END
