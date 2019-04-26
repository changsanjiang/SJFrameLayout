//
//  SJFLLayoutWeakTarget.m
//  Pods-SJFrameLayout_Example
//
//  Created by BlueDancer on 2019/4/26.
//

#import "SJFLLayoutWeakTarget.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SJFLLayoutDeallocCallbackObject {
    void(^_block)(void);
}
- (instancetype)initWithDeallocCallback:(void(^)(void))block {
    self = [super init];
    if ( self ) {
        _block = block;
    }
    return self;
}
- (void)dealloc {
    if ( _block ) _block();
}
@end

@implementation SJFLLayoutWeakTarget
- (instancetype)initWithWeakTarget:(id)target {
    self = [super init];
    if ( self ) {
        _target = target;
    }
    return self;
}
@end
NS_ASSUME_NONNULL_END
