//
//  SJFLLayoutMask.h
//  Pods
//
//  Created by 畅三江 on 2019/4/19.
//

#import <Foundation/Foundation.h>
#import "SJFLLayoutMaskDefines.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLLayoutMask : NSObject<SJFLLayoutProtocol, SJFLLayoutUpdaterProtocol>
- (instancetype)initWithView:(__weak UIView *)view attributes:(SJFLAttributeMask)attrs;
- (instancetype)initWithView:(__weak UIView *)view attribute:(SJFLAttribute)attr;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END
