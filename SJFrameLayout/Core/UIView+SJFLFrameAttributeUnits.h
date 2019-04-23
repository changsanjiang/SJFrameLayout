//
//  UIView+SJFLFrameAttributes.h
//  Pods
//
//  Created by 畅三江 on 2019/4/23.
//

#import <UIKit/UIKit.h>
#import "SJFLFrameAttributeUnit.h"

NS_ASSUME_NONNULL_BEGIN
@interface UIView (SJFLFrameAttributeUnits)
@property (nonatomic, strong, readonly) SJFLFrameAttributeUnit *FL_top;
@property (nonatomic, strong, readonly) SJFLFrameAttributeUnit *FL_left;
@property (nonatomic, strong, readonly) SJFLFrameAttributeUnit *FL_bottom;
@property (nonatomic, strong, readonly) SJFLFrameAttributeUnit *FL_right;
@property (nonatomic, strong, readonly) SJFLFrameAttributeUnit *FL_width;
@property (nonatomic, strong, readonly) SJFLFrameAttributeUnit *FL_height;
@property (nonatomic, strong, readonly) SJFLFrameAttributeUnit *FL_centerX;
@property (nonatomic, strong, readonly) SJFLFrameAttributeUnit *FL_centerY;

@property (nonatomic, strong, readonly) SJFLFrameAttributeUnit *FL_safeTop;
@property (nonatomic, strong, readonly) SJFLFrameAttributeUnit *FL_safeLeft;
@property (nonatomic, strong, readonly) SJFLFrameAttributeUnit *FL_safeBottom;
@property (nonatomic, strong, readonly) SJFLFrameAttributeUnit *FL_safeRight;

- (SJFLFrameAttributeUnit *)FL_frameAtrributeUnitForAttribute:(SJFLFrameAttribute)attribtue;
@end
NS_ASSUME_NONNULL_END
