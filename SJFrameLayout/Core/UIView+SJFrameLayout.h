//
//  UIView+SJFrameLayout.h
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import <UIKit/UIKit.h>
#import "SJFLLayoutMaker.h"

NS_ASSUME_NONNULL_BEGIN
@interface UIView (SJFrameLayout)
- (void)sj_makeFrameLayout:(void(^)(SJFLLayoutMaker *make))block;
- (void)sj_updateFrameLayout:(void(^)(SJFLLayoutMaker *make))block;
- (void)sj_removeFrameLayouts;
@end
NS_ASSUME_NONNULL_END
