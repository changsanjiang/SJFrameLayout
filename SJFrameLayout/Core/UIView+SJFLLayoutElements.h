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
@interface UIView (SJFLLayoutElements)
UIKIT_EXTERN NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *_Nullable
SJFLGetElements(UIView *view);

@property (nonatomic, strong, nullable) NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *FL_elements;
- (void)FL_layoutIfNeeded_flag;
@end
NS_ASSUME_NONNULL_END
