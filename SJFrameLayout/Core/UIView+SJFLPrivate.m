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

@interface SJFLDependencyObserveTarget : NSObject {
    @public
    __weak id<SJFLDependencyViewDidLayoutSubviewsProtocol> _Nullable _observer;
}
- (instancetype)initWithTarget:(id<SJFLDependencyViewDidLayoutSubviewsProtocol>)observer;
@end

@implementation SJFLDependencyObserveTarget
- (instancetype)initWithTarget:(id<SJFLDependencyViewDidLayoutSubviewsProtocol>)obs {
    self = [super init];
    if ( self ) {
        _observer = obs;
    }
    return self;
}
#ifdef DEBUG
- (NSString *)description {
    return [NSString stringWithFormat:@"[observer: %@]", self->_observer];
}
#endif
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

- (void)FL_layoutSubviews {
    [self FL_layoutSubviews];
    for ( SJFLDependencyObserveTarget *target in SJFLGetObserversContainerIfExists(self).allValues ) {
        [target->_observer FL_dependencyViewDidLayoutSubviews:self];
    }
}

- (void)FL_addObserver:(id<SJFLDependencyViewDidLayoutSubviewsProtocol>)observer {
    if ( observer ) {
        NSNumber *num = @([observer hash]);
        SJFLObserversContainer(self)[num] = [[SJFLDependencyObserveTarget alloc] initWithTarget:observer];
    }
}

- (void)FL_removeObserver:(id<SJFLDependencyViewDidLayoutSubviewsProtocol>)observer {
    NSNumber *num = @([observer hash]);
    [SJFLGetObserversContainerIfExists(self) removeObjectForKey:num];
}

static void *FL_kContainer = &FL_kContainer;
UIKIT_STATIC_INLINE NSMutableDictionary<NSNumber *, SJFLDependencyObserveTarget *> *_Nullable
SJFLGetObserversContainerIfExists(UIView *view) {
    return objc_getAssociatedObject(view, FL_kContainer);
}

UIKIT_STATIC_INLINE NSMutableDictionary<NSNumber *, SJFLDependencyObserveTarget *> *
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
    for ( SJFLDependencyObserveTarget *target in SJFLGetObserversContainerIfExists(self).allValues ) {
        [target->_observer FL_dependencyViewDidLayoutSubviews:self];
    }
}
@end
NS_ASSUME_NONNULL_END
