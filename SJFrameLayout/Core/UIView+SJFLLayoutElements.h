//
//  UIView+SJFLLayoutElements.h
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import <UIKit/UIKit.h>
#import "SJFLAttributesDefines.h"
#import "SJFLLayoutAttributeUnit.h"
@class SJFLLayoutElement;

NS_ASSUME_NONNULL_BEGIN
UIKIT_EXTERN NSNotificationName const SJFLViewFinishedLayoutNotification;

@interface UIView (SJFLLayoutElements)
UIKIT_EXTERN NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *_Nullable
SJFLGetElements(UIView *view);
- (SJFLLayoutElement *_Nullable)FL_elementForAttributeKey:(SJFLLayoutAttributeKey)attributeKey;

@property (nonatomic, strong, nullable) NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *FL_elements;
- (void)FL_layoutIfNeeded;
@end
NS_ASSUME_NONNULL_END
