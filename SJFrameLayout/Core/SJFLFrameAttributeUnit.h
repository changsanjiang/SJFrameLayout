//
//  SJFLViewAttribute.h
//  Pods
//
//  Created by 畅三江 on 2019/4/23.
//

#import <UIKit/UIKit.h>
#import "SJFLAttributesDefines.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLFrameAttributeUnit : NSObject
- (instancetype)initWithView:(UIView *)view attribute:(SJFLFrameAttribute)attribute;
@property (nonatomic, weak, readonly, nullable) UIView *view;
@property (nonatomic, readonly) SJFLFrameAttribute attribute;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END
