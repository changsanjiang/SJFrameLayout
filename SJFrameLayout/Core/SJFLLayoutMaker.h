//
//  SJFLLayoutMaker.h
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import <Foundation/Foundation.h>
#import "SJFLLayoutMask.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLLayoutMaker : NSObject<SJFLLayoutProtocol>
- (instancetype)initWithView:(UIView *)view;
- (void)install;
- (void)update;
+ (void)removeAllLayouts:(UIView *)view;
@end
NS_ASSUME_NONNULL_END
