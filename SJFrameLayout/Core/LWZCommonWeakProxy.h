//
//  LWZCommonWeakProxy.h
//  LWZCommonWeakProxy
//
//  Created by BlueDancer on 2019/5/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface LWZCommonWeakProxy : NSProxy
+ (instancetype)weakProxyWithTarget:(id)target;

@property (nonatomic, weak, nullable) id target;
@end
NS_ASSUME_NONNULL_END
