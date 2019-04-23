//
//  SJFLLayoutElement.h
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "SJFLLayoutAttributeUnit.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLLayoutElement : NSObject
- (instancetype)initWithTarget:(SJFLLayoutAttributeUnit *)target;

@property (nonatomic, strong, readonly) SJFLLayoutAttributeUnit *target;
@property (nonatomic, readonly) SJFLAttribute tar_attr;
@property (nonatomic, weak, readonly, nullable) UIView *tar_superview;
@property (nonatomic, weak, readonly, nullable) UIView *dep_view;

- (void)refreshLayoutIfNeeded;
@end
NS_ASSUME_NONNULL_END
