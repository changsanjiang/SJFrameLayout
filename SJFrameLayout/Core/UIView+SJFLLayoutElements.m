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
#import "SJFLNotificationCenter.h"

NS_ASSUME_NONNULL_BEGIN

#define FL_log_layout (0)

static NSNotificationName const SJFLViewFinishedLayoutNotification    = @"SJFL_V_F_L";
static NSNotificationName const SJFLViewDidLayoutSubviewsNotification = @"SJFL_V_D_L_S";

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

@implementation UIView (SJFLPrivate)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzledSelector = @selector(FL_layoutSubviews);
        SJFLSwizzleMethod(UIView.class, originalSelector, swizzledSelector);
    });
}
static void *kSuperviewFinishedLayoutObservers = &kSuperviewFinishedLayoutObservers;
- (void)FL_layoutSubviews {
    [self FL_layoutSubviews];
    [SJFLNotificationCenter.defaultCenter postNotificationName:SJFLViewDidLayoutSubviewsNotification object:self];
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
    [SJFLNotificationCenter.defaultCenter postNotificationName:SJFLViewDidLayoutSubviewsNotification object:self];
}
@end

@protocol SJFLLayoutObserverDelegate;
@interface SJFLLayoutObserver : NSObject
- (instancetype)initWithView:(UIView *)view elements:(NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *)elements;
@property (nonatomic, weak, nullable) id<SJFLLayoutObserverDelegate> delegate;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

@protocol SJFLLayoutObserverDelegate <NSObject>
- (void)FL_obsever:(SJFLLayoutObserver *)observer viewFinishedLayout:(UIView *)view;
- (void)FL_observer:(SJFLLayoutObserver *)observer viewDidLayoutSubviews:(UIView *)view;
@end
@implementation SJFLLayoutObserver
- (instancetype)initWithView:(UIView *)view elements:(NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *)elements {
    self = [super init];
    if ( !self ) return nil;
    UIView *superview = view.superview;
    SJFLNotificationCenter *noteCenter = SJFLNotificationCenter.defaultCenter;
    [noteCenter addObserver:self selector:@selector(FL_viewDidLayoutSubviews:) name:SJFLViewDidLayoutSubviewsNotification object:view];
    [noteCenter addObserver:self selector:@selector(FL_viewDidLayoutSubviews:) name:SJFLViewDidLayoutSubviewsNotification object:superview];
    [elements enumerateKeysAndObjectsUsingBlock:^(SJFLLayoutAttributeKey  _Nonnull key, SJFLLayoutElement * _Nonnull obj, BOOL * _Nonnull stop) {
        UIView *dep_view = obj.dep_view;
        if ( dep_view != view )
            [noteCenter addObserver:self selector:@selector(FL_viewFinishedLayout:) name:SJFLViewFinishedLayoutNotification object:dep_view];
    }];
    return self;
}
- (void)dealloc {
    [SJFLNotificationCenter.defaultCenter removeObserver:self];
}
- (void)FL_viewFinishedLayout:(NSNotification *)note {
    [self.delegate FL_obsever:self viewFinishedLayout:note.object];
} 
- (void)FL_viewDidLayoutSubviews:(NSNotification *)note {
#if FL_log_layout
    UIView *v = note.object;
    printf("\n V_D_L_S: \t [%p \t %s \t %s]", self, NSStringFromClass(v.class).UTF8String, NSStringFromCGRect(v.frame).UTF8String);
#endif
    [self.delegate FL_observer:self viewDidLayoutSubviews:note.object];
}
@end


@interface UIView (SJFLLayoutObserver)<SJFLLayoutObserverDelegate>
@property (nonatomic, strong, nullable) SJFLLayoutObserver *FL_layoutObserver;
@end

@implementation UIView (SJFLLayoutObserver)
static void *kObserver = &kObserver;
- (void)setFL_layoutObserver:(SJFLLayoutObserver *_Nullable)FL_layoutObserver {
    FL_layoutObserver.delegate = self;
    objc_setAssociatedObject(self, kObserver, FL_layoutObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (SJFLLayoutObserver *_Nullable)FL_layoutObserver {
    return objc_getAssociatedObject(self, kObserver);
}
// dependency view has finished layout
- (void)FL_obsever:(SJFLLayoutObserver *)observer viewFinishedLayout:(UIView *)view {
    [self FL_layoutIfNeeded];
}
- (void)FL_observer:(SJFLLayoutObserver *)observer viewDidLayoutSubviews:(UIView *)view {
    [self FL_layoutIfNeeded];
}
@end

@implementation UIView (SJFLLayoutElements)
static void *kFL_Container = &kFL_Container;
- (SJFLLayoutElement *_Nullable)FL_elementForAttributeKey:(SJFLLayoutAttributeKey)attributeKey {
    return [objc_getAssociatedObject(self, kFL_Container) valueForKey:attributeKey];
}
- (void)setFL_elements:(NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> * _Nullable)FL_elements {
    self.FL_layoutObserver = [[SJFLLayoutObserver alloc] initWithView:self elements:FL_elements];
    objc_setAssociatedObject(self, kFL_Container, [FL_elements mutableCopy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *_Nullable)FL_elements {
    return objc_getAssociatedObject(self, kFL_Container);
}
- (void)FL_layoutIfNeeded {
#if FL_log_layout
    printf("\n before: \t [%p \t %s \t %s]", self, NSStringFromClass(self.class).UTF8String, NSStringFromCGRect(self.frame).UTF8String);
#endif
    
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
        
        BOOL finished = NO;
        if ( !CGRectEqualToRect(frame, previous) ) {
            self.frame = frame;
            finished = YES;
        }

        if ( SJFLViewLayoutFixInnerSizeIfNeeded(self, m) )
            goto handle_elements;
        else if ( finished )
            [SJFLNotificationCenter.defaultCenter postNotificationName:SJFLViewFinishedLayoutNotification object:self];
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
    
    static Class FL_UILabelClass;
    static Class FL_UIButtonClass;
    static Class FL_UIImageViewClass;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FL_UILabelClass = [UILabel class];
        FL_UIButtonClass = [UIButton class];
        FL_UIImageViewClass = [UIImageView class];
    });
    
    // - fitting size -
    SJFLLayoutAttributeUnit *_Nullable fit_width = nil;
    SJFLLayoutAttributeUnit *_Nullable fit_height = nil;
    
    SJFLLayoutAttributeUnit *_Nullable widthElement = m[SJFLLayoutAttributeKeyWidth].target;
    if ( widthElement && widthElement->priority == 1 ) fit_width = widthElement;
    SJFLLayoutAttributeUnit *_Nullable heightElement = m[SJFLLayoutAttributeKeyHeight].target;
    if ( heightElement && heightElement->priority == 1 ) fit_height = heightElement;
    
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
    return objc_getAssociatedObject(view, kFL_Container);
}
@end
NS_ASSUME_NONNULL_END
