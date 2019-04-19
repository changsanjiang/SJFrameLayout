//
//  SJFLMaker.h
//  Pods
//
//  Created by BlueDancer on 2019/4/18.
//

#import <Foundation/Foundation.h>
#import "SJFLLayoutMask.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLMaker : NSObject
@property (nonatomic, strong, readonly) SJFLLayoutMask *top;
@property (nonatomic, strong, readonly) SJFLLayoutMask *left;
@property (nonatomic, strong, readonly) SJFLLayoutMask *bottom;
@property (nonatomic, strong, readonly) SJFLLayoutMask *right;

@property (nonatomic, strong, readonly) SJFLLayoutMask *width;
@property (nonatomic, strong, readonly) SJFLLayoutMask *height;

@property (nonatomic, strong, readonly) SJFLLayoutMask *centerX;
@property (nonatomic, strong, readonly) SJFLLayoutMask *centerY;

- (instancetype)initWithView:(UIView *)view;
- (void)install;
@end
NS_ASSUME_NONNULL_END
