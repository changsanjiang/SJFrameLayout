//
//  SJFLNotificationCenter.m
//  Pods-SJFrameLayout_Example
//
//  Created by BlueDancer on 2019/4/25.
//

#import "SJFLNotificationCenter.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLNotificationObserver : NSObject {
    @public
    __weak id _Nullable _observer;
    __weak id _Nullable _target;
    SEL _selector;
}
@end
@implementation SJFLNotificationObserver
- (instancetype)initWithObserver:(id)observer target:(id)target selector:(SEL)selector {
    self = [super init];
    if ( self ) {
        _observer = observer;
        _target = target;
        _selector = selector;
    }
    return self;
}
@end

@interface SJFLNotificationCenter ()
@property (nonatomic, strong, readonly) NSMutableDictionary<NSNotificationName, NSMutableArray<SJFLNotificationObserver *> *> *container;
@end

@implementation SJFLNotificationCenter
+ (instancetype)defaultCenter {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self new];
    });
    return _instance;
}
- (instancetype)init {
    self = [super init];
    if ( !self ) return nil;
    _container = NSMutableDictionary.dictionary;
    return self;
}
- (void)addObserver:(id)observer selector:(SEL)aSelector name:(nullable NSNotificationName)aName object:(nullable id)target {
    NSString *key = [NSString stringWithFormat:@"%p:%p", aName, target];
    __auto_type _Nullable m = _container[key];
    if ( !m )  {
        m = [NSMutableArray array];
        _container[key] = m;
    }
    [m addObject:[[SJFLNotificationObserver alloc] initWithObserver:observer target:target selector:aSelector]];
}
- (void)postNotificationName:(NSNotificationName)aName object:(nullable id)anObject {
    NSString *key = [NSString stringWithFormat:@"%p:%p", aName, anObject];
    __auto_type _Nullable obs = _container[key];
    for ( SJFLNotificationObserver * _Nonnull ob in obs ) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [ob->_observer performSelector:ob->_selector
                            withObject:[[NSNotification alloc] initWithName:aName object:anObject userInfo:nil]];
#pragma clang diagnostic pop
    }
}
- (void)removeObserver:(id)observer {
    [_container enumerateKeysAndObjectsUsingBlock:^(NSNotificationName  _Nonnull key, NSMutableArray<SJFLNotificationObserver *> * _Nonnull obs, BOOL * _Nonnull stop) {
        [obs enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(SJFLNotificationObserver * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ( obj->_observer == observer ) {
                [obs removeObjectAtIndex:idx];
            }
        }];
    }];
}
@end
NS_ASSUME_NONNULL_END
