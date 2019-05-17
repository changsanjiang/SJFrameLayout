//
//  SJFLWeakProxy.h
//  SJFLWeakProxy
//
//  Created by BlueDancer on 2019/5/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface SJFLWeakProxy : NSProxy
+ (instancetype)weakProxyWithTarget:(UIView *)target;

@property (nonatomic, weak, nullable) UIView *target;
@end
NS_ASSUME_NONNULL_END
