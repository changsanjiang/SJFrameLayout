//
//  SJFLWeakProxy.m
//  SJFLWeakProxy
//
//  Created by BlueDancer on 2019/5/8.
//

#import "SJFLWeakProxy.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SJFLWeakProxy
+ (instancetype)weakProxyWithTarget:(UIView *)target {
    SJFLWeakProxy *proxy = [SJFLWeakProxy alloc];
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
