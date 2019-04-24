//
//  UIView+SJFLPrivate.m
//  Pods
//
//  Created by BlueDancer on 2019/4/23.
//

#import "UIView+SJFLPrivate.h"
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN
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

@interface SJFLWeakTarget : NSObject {
    @public
    __weak id _target;
}
- (instancetype)initWithTarget:(id)target;
@end

@implementation SJFLWeakTarget
- (instancetype)initWithTarget:(id)target {
    self = [super init];
    if ( self ) {
        _target = target;
    }
    return self;
}
@end

@implementation UIView (SJFLPrivate)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzledSelector = @selector(FL_layoutSubviews);
        SJFLSwizzleMethod(UIView.class, originalSelector, swizzledSelector);
    });
}
static void *FL_kContainer = &FL_kContainer;
- (void)FL_layoutSubviews {
    [self FL_layoutSubviews];
    for ( SJFLWeakTarget *target in ((NSDictionary *)objc_getAssociatedObject(self, FL_kContainer)).allValues ) {
        [target->_target FL_dependencyViewDidLayoutSubviews:self];
    }
}

- (void)FL_addObserver:(id<SJFLDependencyViewDidLayoutSubviewsProtocol>)observer {
    if ( observer ) {
        NSNumber *num = @([(id)observer hash]);
        SJFLObserversContainer(self)[num] = [[SJFLWeakTarget alloc] initWithTarget:observer];
    }
}

- (void)FL_removeObserver:(id<SJFLDependencyViewDidLayoutSubviewsProtocol>)observer {
    [((NSMutableDictionary *)objc_getAssociatedObject(self, FL_kContainer)) removeObjectForKey:@([(id)observer hash])];
}

UIKIT_STATIC_INLINE NSMutableDictionary<NSNumber *, SJFLWeakTarget *> *
SJFLObserversContainer(UIView *view) {
    void *p = FL_kContainer;
    NSMutableDictionary *_Nullable container = objc_getAssociatedObject(view, p);
    if ( !container ) {
        container = [NSMutableDictionary new];
        objc_setAssociatedObject(view, p, container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return container;
}
@end

@implementation UIButton (SJFLLayoutElements)
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
    for ( SJFLWeakTarget *target in ((NSDictionary *)objc_getAssociatedObject(self, FL_kContainer)).allValues ) {
        [target->_target FL_dependencyViewDidLayoutSubviews:self];
    }
}
@end

@implementation UIView (SJFLCommonSuperview)
static void *kCommonSuperview = &kCommonSuperview;
- (void)setFL_elementsCommonSuperview:(UIView *_Nullable)FL_elementsCommonSuperview {
    if ( FL_elementsCommonSuperview ) {
        objc_setAssociatedObject(self, kCommonSuperview, [[SJFLWeakTarget alloc] initWithTarget:FL_elementsCommonSuperview], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else {
        objc_setAssociatedObject(self, kCommonSuperview, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
- (UIView *_Nullable)FL_elementsCommonSuperview {
    SJFLWeakTarget *_Nullable t = objc_getAssociatedObject(self, kCommonSuperview);
    if ( t ) {
        return t->_target;
    }
    return nil;
}
@end
NS_ASSUME_NONNULL_END
