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
#import <SJUIKit/NSObject+SJObserverHelper.h>
#import <SJUIKit/SJRunLoopTaskQueue.h>

NS_ASSUME_NONNULL_BEGIN

#define FL_log_layout (0)
#define FL_log_call_count    (1)

#if FL_log_call_count
static int call_cout00 = 0;
static int call_cout01 = 0;
static int call_cout02 = 0;
static int call_cout03 = 0;
static int call_cout04 = 0;
#endif

static Class FL_UILabelClass;
static Class FL_UIButtonClass;
static Class FL_UIImageViewClass;

@implementation UIView (SJFLPrivate)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FL_UILabelClass = UILabel.class;
        FL_UIButtonClass = UIButton.class;
        FL_UIImageViewClass = UIImageView.class;
        
#if FL_log_call_count
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@":--00 %d", call_cout00);
            NSLog(@":--01 %d", call_cout01);
            NSLog(@":--02 %d", call_cout02);
            NSLog(@":--03 %d", call_cout03);
            NSLog(@":--04 %d", call_cout04);
        });
#endif
    });
}
@end

@implementation UIView (SJFLLayoutElements)
static void *kFL_ElementsContainer = &kFL_ElementsContainer;

- (SJFLLayoutElement *_Nullable)FL_elementForAttributeKey:(SJFLLayoutAttributeKey)attributeKey {
    return [objc_getAssociatedObject(self, kFL_ElementsContainer) valueForKey:attributeKey];
}
- (void)setFL_elements:(NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> * _Nullable)FL_elements {
    objc_setAssociatedObject(self, kFL_ElementsContainer, [FL_elements mutableCopy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [FL_elements enumerateKeysAndObjectsUsingBlock:^(SJFLLayoutAttributeKey  _Nonnull key, SJFLLayoutElement * _Nonnull obj, BOOL * _Nonnull stop) {
        UIView *dep_view = obj.dep_view;
        NSKeyValueObservingOptions ops = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
        [dep_view sj_addObserver:self forKeyPath:@"frame" options:ops context:nil];
        [dep_view sj_addObserver:self forKeyPath:@"bounds" options:ops context:nil];
        [dep_view sj_addObserver:self forKeyPath:@"center" options:ops context:nil];
    }];

    [self FL_layoutIfNeeded];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(UIView *_Nullable)object change:(nullable NSDictionary<NSKeyValueChangeKey,id> *)change context:(nullable void *)context {
    if ( ![change[NSKeyValueChangeOldKey] isEqual:change[NSKeyValueChangeNewKey]] ) {
        
        printf("\n%s - %s - %s\n", keyPath.UTF8String, object.description.UTF8String, change.description.UTF8String);
        printf("\n====================\n");
        
#if FL_log_call_count
        call_cout00 += 1;
#endif
        BOOL changed = [self FL_layoutIfNeeded];
        if ( changed ) {
            [[self FL_elements] enumerateKeysAndObjectsUsingBlock:^(SJFLLayoutAttributeKey  _Nonnull key, SJFLLayoutElement * _Nonnull obj, BOOL * _Nonnull stop) {
                UIView *dep_view = obj.dep_view;
                if ( SJFLViewLayoutNeedFixInnerSize(dep_view) ) {
                    [dep_view FL_layoutIfNeeded];
                }
            }];
        }
    }
}

- (NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *_Nullable)FL_elements {
    return objc_getAssociatedObject(self, kFL_ElementsContainer);
}
- (BOOL)FL_layoutIfNeeded {
#if FL_log_layout
    printf("\n before: \t [%p \t %s \t %s]", self, NSStringFromClass(self.class).UTF8String, NSStringFromCGRect(self.frame).UTF8String);
#endif
    
#if FL_log_call_count
    call_cout01 += 1;
#endif

    BOOL changed = NO;
    NSMutableDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *_Nullable
    m = objc_getAssociatedObject(self, kFL_ElementsContainer);
    if ( m ) {
        
#if FL_log_call_count
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
            changed = YES;
            self.frame = frame;
//            printf("\n%p ==> %s", self, NSStringFromCGRect(frame).UTF8String);
#if FL_log_call_count
            call_cout03 += 1;
#endif
        }

        if ( SJFLViewLayoutFixInnerSizeIfNeeded(self, m) )
            goto handle_elements;
    }
    
#if FL_log_layout
    printf("\n end: \t\t [%p \t %s \t %s]\n", self, NSStringFromClass(self.class).UTF8String, NSStringFromCGRect(self.frame).UTF8String);
#endif
    
    return changed;
}

// fix inner size

UIKIT_STATIC_INLINE BOOL SJFLViewLayoutNeedFixInnerSize(__kindof UIView *view) {
    __auto_type m = SJFLGetElements(view);
    // - fitting size -
    SJFLLayoutAttributeUnit *_Nullable fit_width = nil;
    SJFLLayoutAttributeUnit *_Nullable fit_height = nil;
    
    SJFLLayoutAttributeUnit *_Nullable widthUnit = m[SJFLLayoutAttributeKeyWidth].target;
    if ( widthUnit && widthUnit->priority == 1 ) fit_width = widthUnit;
    SJFLLayoutAttributeUnit *_Nullable heightUnit = m[SJFLLayoutAttributeKeyHeight].target;
    if ( heightUnit && heightUnit->priority == 1 ) fit_height = heightUnit;
    
    return fit_width != nil || fit_height != nil;
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

@implementation UILabel (SJFLLayoutElements)
- (void)FL_layoutIfNeeded {
    NSMutableDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *_Nullable
    m = objc_getAssociatedObject(self, kFL_ElementsContainer);
    if ( m ) {
        SJFLFixLabelFittingWidthIfNeeded(self, m);
        [super FL_layoutIfNeeded];
    }
}

UIKIT_STATIC_INLINE void SJFLFixLabelFittingWidthIfNeeded(UIView *view, NSMutableDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *m ) {
    if ( [view isKindOfClass:FL_UILabelClass] ) {
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
@end
NS_ASSUME_NONNULL_END
