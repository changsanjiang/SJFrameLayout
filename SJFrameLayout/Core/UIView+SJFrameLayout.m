//
//  UIView+SJFrameLayout.m
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "UIView+SJFrameLayout.h"

NS_ASSUME_NONNULL_BEGIN
@implementation UIView (SJFrameLayout)
- (void)sj_makeFrameLayout:(void(^)(SJFLLayoutMaker *make))block {
    SJFLLayoutMaker *maker = [[SJFLLayoutMaker alloc] initWithView:self];
    block(maker);
    [maker install];
}
- (void)sj_updateFrameLayout:(void(^)(SJFLLayoutMaker *make))block {
    SJFLLayoutMaker *maker = [[SJFLLayoutMaker alloc] initWithView:self];
    block(maker);
    [maker update];
}
@end
NS_ASSUME_NONNULL_END
