//
//  UIView+SJFLPrivate.h
//  Pods
//
//  Created by BlueDancer on 2019/4/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SJFLDependencyViewDidLayoutSubviewsProtocol <NSObject>
- (void)FL_dependencyViewDidLayoutSubviews:(UIView *)view;
@end

@interface UIView (SJFLPrivate)
// weak ref
- (void)FL_addObserver:(id<SJFLDependencyViewDidLayoutSubviewsProtocol>)observer;
- (void)FL_removeObserver:(id<SJFLDependencyViewDidLayoutSubviewsProtocol>)observer;
@end
NS_ASSUME_NONNULL_END
