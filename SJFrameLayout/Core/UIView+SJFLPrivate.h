//
//  UIView+SJFLPrivate.h
//  Pods
//
//  Created by BlueDancer on 2019/4/18.
//

#import <UIKit/UIKit.h>
#import "SJFLLayoutElement.h"

NS_ASSUME_NONNULL_BEGIN
UIKIT_EXTERN NSNotificationName const SJFLViewLayoutSubviewsNotification;

@interface UIView (SJFLPrivate)
+ (void)FL_layoutElementWantReceiveNotificationForLayoutSubviews;

@property (nonatomic, strong, nullable) NSArray<SJFLLayoutElement *> *FL_elements;

- (void)FL_replaceElement:(SJFLAttribute)attribute withElement:(SJFLLayoutElement *)element;
@end
NS_ASSUME_NONNULL_END
