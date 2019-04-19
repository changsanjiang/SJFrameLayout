//
//  SJFLMaker.h
//  Pods
//
//  Created by BlueDancer on 2019/4/18.
//

#import <Foundation/Foundation.h>
#import "SJFLLayout.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLMaker : NSObject
- (instancetype)initWithView:(UIView *)view;

#warning next ...
//        make.top.left.right.height.offset(20)

@property (nonatomic, strong, readonly) SJFLLayout *top;
@property (nonatomic, strong, readonly) SJFLLayout *left;
@property (nonatomic, strong, readonly) SJFLLayout *bottom;
@property (nonatomic, strong, readonly) SJFLLayout *right;

@property (nonatomic, strong, readonly) SJFLLayout *width;
@property (nonatomic, strong, readonly) SJFLLayout *height;

@property (nonatomic, strong, readonly) SJFLLayout *centerX;
@property (nonatomic, strong, readonly) SJFLLayout *centerY;

- (void)install;
@end
NS_ASSUME_NONNULL_END
