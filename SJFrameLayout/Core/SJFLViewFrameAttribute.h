//
//  SJFLViewAttribute.h
//  Pods
//
//  Created by 畅三江 on 2019/4/23.
//

#import <UIKit/UIKit.h>
#import "SJFLAttributes.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLViewFrameAttribute : NSObject
- (instancetype)initWithView:(UIView *)view attribute:(SJFLAttribute)attribute;
@property (nonatomic, weak, readonly, nullable) UIView *view;
@property (nonatomic, readonly) SJFLAttribute attribute;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END
