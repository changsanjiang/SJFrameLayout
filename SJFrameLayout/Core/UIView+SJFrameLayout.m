//
//  UIView+SJFrameLayout.m
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "UIView+SJFrameLayout.h"

NS_ASSUME_NONNULL_BEGIN
@implementation UIView (SJFrameLayout)
- (void)SJFL_makeLayouts:(void(^)(SJFLLayoutMaker *make))block {
    SJFLLayoutMaker *maker = [[SJFLLayoutMaker alloc] initWithView:self];
    block(maker);
    [maker install];
}
- (void)SJFL_remakeLayouts:(void(^)(SJFLLayoutMaker *make))block {
    [self SJFL_makeLayouts:block];
}
- (void)SJFL_updateLayouts:(void(^)(SJFLLayoutMaker *make))block {
    SJFLLayoutMaker *maker = [[SJFLLayoutMaker alloc] initWithView:self];
    block(maker);
    [maker update];
}
- (void)SJFL_removeLayouts:(SJFLLayoutAttributeMask)mask remake:(void(^)(SJFLLayoutMaker *make))block {
    
}
- (void)SJFL_removeLayouts:(SJFLLayoutAttributeMask)mask {
    
}
- (void)SJFL_removeAllLayouts {
    [SJFLLayoutMaker removeAllLayouts:self];
}
@end
NS_ASSUME_NONNULL_END
