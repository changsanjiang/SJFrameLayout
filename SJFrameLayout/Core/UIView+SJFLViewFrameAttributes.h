//
//  UIView+SJFLViewFrameAttributes.h
//  Pods
//
//  Created by 畅三江 on 2019/4/23.
//

#import <UIKit/UIKit.h>
#import "SJFLViewFrameAttribute.h"

NS_ASSUME_NONNULL_BEGIN
@interface UIView (SJFLViewFrameAttributes)
@property (nonatomic, strong, readonly) SJFLViewFrameAttribute *FL_top;
@property (nonatomic, strong, readonly) SJFLViewFrameAttribute *FL_left;
@property (nonatomic, strong, readonly) SJFLViewFrameAttribute *FL_bottom;
@property (nonatomic, strong, readonly) SJFLViewFrameAttribute *FL_right;
@property (nonatomic, strong, readonly) SJFLViewFrameAttribute *FL_width;
@property (nonatomic, strong, readonly) SJFLViewFrameAttribute *FL_height;
@property (nonatomic, strong, readonly) SJFLViewFrameAttribute *FL_centerX;
@property (nonatomic, strong, readonly) SJFLViewFrameAttribute *FL_centerY;

- (SJFLViewFrameAttribute *)viewLayoutForAttribute:(SJFLAttribute)attribtue;
@end
NS_ASSUME_NONNULL_END
