//
//  UIView+SJFrameLayout.h
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import <UIKit/UIKit.h>
#import "SJFLMaker.h"

NS_ASSUME_NONNULL_BEGIN
@interface UIView (SJFrameLayout)
- (void)sj_makeFrameLayout:(void(^)(SJFLMaker *make))block;
@end
NS_ASSUME_NONNULL_END
