//
//  SJFLLayoutElement.h
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "SJFLAttributeUnit.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLLayoutElement : NSObject
- (instancetype)initWithTarget:(SJFLAttributeUnit *)target;

@property (nonatomic, strong, readonly) SJFLAttributeUnit *target;
@property (nonatomic, readonly) SJFLAttribute tar_attr;
@property (nonatomic, weak, readonly, nullable) UIView *tar_superview;
@property (nonatomic, weak, readonly, nullable) UIView *dep_view;

- (void)needRefreshLayout;
@end
NS_ASSUME_NONNULL_END
