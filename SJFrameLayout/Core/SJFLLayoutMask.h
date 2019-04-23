//
//  SJFLLayoutMask.h
//  Pods
//
//  Created by 畅三江 on 2019/4/19.
//

#import <Foundation/Foundation.h>
#import "SJFLLayoutAttributesDefines.h"
#import "SJFLLayoutMaskDefines.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLLayoutMask : NSObject<SJFLLayoutProtocol, SJFLLayoutUpdaterProtocol>
- (instancetype)initWithView:(UIView *)view attributes:(SJFLLayoutAttributeMask)attrs;
- (instancetype)initWithView:(UIView *)view attribute:(SJFLLayoutAttribute)attr;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END
