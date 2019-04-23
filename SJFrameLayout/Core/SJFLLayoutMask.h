//
//  SJFLLayoutMask.h
//  Pods
//
//  Created by 畅三江 on 2019/4/19.
//

#import <Foundation/Foundation.h>
#import "SJFLAttributes.h"
#import "SJFLLayoutMaskDefines.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLLayoutMask : NSObject<SJFLLayoutProtocol, SJFLLayoutUpdaterProtocol>
- (instancetype)initWithView:(UIView *)view attributes:(SJFLAttributeMask)attrs;
- (instancetype)initWithView:(UIView *)view attribute:(SJFLAttribute)attr;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END
