//
//  SJFLLayoutWeakTarget.h
//  Pods-SJFrameLayout_Example
//
//  Created by BlueDancer on 2019/4/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface SJFLLayoutDeallocCallbackObject : NSObject
- (instancetype)initWithDeallocCallback:(void(^)(void))block;
@end

@interface SJFLLayoutWeakTarget : NSObject {
    @public
    __weak id _Nullable _target;
}
- (instancetype)initWithWeakTarget:(id)target;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END
