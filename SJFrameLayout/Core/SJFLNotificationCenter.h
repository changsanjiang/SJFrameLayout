//
//  SJFLNotificationCenter.h
//  Pods-SJFrameLayout_Example
//
//  Created by BlueDancer on 2019/4/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface SJFLNotificationCenter : NSObject
+ (instancetype)defaultCenter;
- (void)addObserver:(id)observer selector:(SEL)aSelector name:(nullable NSNotificationName)aName object:(id)anObject;
- (void)postNotificationName:(NSNotificationName)aName object:(id)anObject;
- (void)removeObserver:(id)observer;
@end
NS_ASSUME_NONNULL_END
