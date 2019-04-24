//
//  SJFLLayoutElement.h
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "SJFLLayoutAttributeUnit.h"
@class SJFLLayoutElement;

NS_ASSUME_NONNULL_BEGIN
@interface SJFLLayoutElement : NSObject
- (instancetype)initWithTarget:(SJFLLayoutAttributeUnit *)target;
- (instancetype)initWithTarget:(SJFLLayoutAttributeUnit *)target superview:(nullable UIView *)superview; 

@property (nonatomic, strong, readonly) SJFLLayoutAttributeUnit *target;
@property (nonatomic, readonly) SJFLLayoutAttribute tar_attr;
@property (nonatomic, weak, readonly, nullable) UIView *tar_superview;
@property (nonatomic, weak, readonly, nullable) UIView *dep_view;
- (CGFloat)offset;
- (void)refreshLayoutIfNeeded:(CGRect *)frame;
@end
NS_ASSUME_NONNULL_END
