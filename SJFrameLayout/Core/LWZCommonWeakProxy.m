//
//  LWZCommonWeakProxy.m
//  LWZCommonWeakProxy
//
//  Created by BlueDancer on 2019/5/8.
//

#import "LWZCommonWeakProxy.h"

NS_ASSUME_NONNULL_BEGIN
@implementation LWZCommonWeakProxy
+ (instancetype)weakProxyWithTarget:(id)target {
    LWZCommonWeakProxy *proxy = [LWZCommonWeakProxy alloc];
    proxy.target = target;
    return proxy;
}

- (nullable NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [_target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:_target];
}
@end
NS_ASSUME_NONNULL_END
