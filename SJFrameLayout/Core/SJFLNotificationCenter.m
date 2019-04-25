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
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, SJFLNotificationObserver *> *> *container;
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

- (id)getNotifyKey:(NSNotificationName)aName target:(id)target {
    return [NSString stringWithFormat:@"%p:%p", aName, target];
}

- (id)getObserverKey:(id)notifyKey observer:(id)observer {
    return [NSString stringWithFormat:@"%@:%p", notifyKey, observer];
}

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(nullable NSNotificationName)aName object:(id)target {
    id notifyKey = [self getNotifyKey:aName target:target];
    __auto_type _Nullable m = _container[notifyKey];
    if ( !m )  {
        m = NSMutableDictionary.new;
        _container[notifyKey] = m;
    }
    
    id obKey = [self getObserverKey:notifyKey observer:observer];
    if ( !m[obKey] )
        m[obKey] = [[SJFLNotificationObserver alloc] initWithObserver:observer target:target selector:aSelector];
}
- (void)postNotificationName:(NSNotificationName)aName object:(id)target {
    id notifyKey = [self getNotifyKey:aName target:target];
    __auto_type _Nullable obs = _container[notifyKey];

    for ( SJFLNotificationObserver *ob in obs.allValues ) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [ob->_observer performSelector:ob->_selector
                            withObject:[[NSNotification alloc] initWithName:aName object:target userInfo:nil]];
#pragma clang diagnostic pop
    }
}
- (void)removeObserver:(id)observer {
    [_container enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull key, NSMutableDictionary<NSString *,SJFLNotificationObserver *> * _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *obKey = [self getObserverKey:key observer:observer];
        obj[obKey] = nil;
        if ( obj.count == 0 ) self->_container[key] = nil;
    }];
}
@end
NS_ASSUME_NONNULL_END
