//
//  SJFLMaker.h
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import <Foundation/Foundation.h>
#import "SJFLLayoutMask.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLMaker : NSObject<SJFLLayoutProtocol>
- (instancetype)initWithView:(UIView *)view;
- (void)install;
- (void)update;
@end
NS_ASSUME_NONNULL_END
