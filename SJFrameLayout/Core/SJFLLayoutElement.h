//
//  SJFLLayoutElement.h
//  Pods
//
//  Created by BlueDancer on 2019/4/18.
//

#import <Foundation/Foundation.h>
#import "SJFLAttributeUnit.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLLayoutElement : NSObject
- (instancetype)initWithTarget:(SJFLAttributeUnit *)target offset:(CGFloat)offset;

- (instancetype)initWithTarget:(SJFLAttributeUnit *)target equalTo:(nullable SJFLAttributeUnit *)dependency offset:(CGFloat)offset;

@property (nonatomic, strong, readonly) SJFLAttributeUnit *target;
@property (nonatomic, strong, readonly, nullable) SJFLAttributeUnit *dependency;
@property (nonatomic, readonly) CGFloat offset;

- (void)dependencyViewsDidLayoutSubViews;
@end
NS_ASSUME_NONNULL_END
