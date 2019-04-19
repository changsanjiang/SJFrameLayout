//
//  SJFLLayout.h
//  Pods
//
//  Created by BlueDancer on 2019/4/18.
//

#import <Foundation/Foundation.h>
#import "SJFLAttributeUnit.h"
#import "SJFLLayoutElement.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLLayout : NSObject
- (instancetype)initWithUnit:(SJFLAttributeUnit *)unit;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, copy, readonly) SJFLLayout *(^equalTo)(SJFLAttributeUnit *unit);
@property (nonatomic, copy, readonly) void(^offset)(CGFloat offset);

- (SJFLLayoutElement *)generateElement;
@end
NS_ASSUME_NONNULL_END
