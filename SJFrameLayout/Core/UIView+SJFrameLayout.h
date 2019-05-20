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
- (void)SJFL_makeLayouts:(void(^)(SJFLLayoutMaker *make))block;
- (void)SJFL_remakeLayouts:(void(^)(SJFLLayoutMaker *make))block;
- (void)SJFL_updateLayouts:(void(^)(SJFLLayoutMaker *make))block;
- (void)SJFL_removeLayouts:(SJFLLayoutAttributeMask)mask remake:(void(^)(SJFLLayoutMaker *make))block;
- (void)SJFL_removeLayouts:(SJFLLayoutAttributeMask)mask;
- (void)SJFL_removeAllLayouts;
@end
NS_ASSUME_NONNULL_END
