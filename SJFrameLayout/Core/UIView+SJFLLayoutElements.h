//
//  UIView+SJFLLayoutElements.h
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import <UIKit/UIKit.h>
#import "SJFLLayoutAttributeUnit.h"
#import "UIView+SJFLPrivate.h"
@class SJFLLayoutElement;

NS_ASSUME_NONNULL_BEGIN
@interface UIView (SJFLLayoutElements)<SJFLDependencyViewDidLayoutSubviewsProtocol>
@property (nonatomic, strong, nullable) NSDictionary<SJFLAttributeKey, SJFLLayoutElement *> *FL_elements;
- (SJFLLayoutElement *_Nullable)FL_elementForAttributeKey:(SJFLAttributeKey)attributeKey;

UIKIT_EXTERN
NSMutableSet<UIView *> *SJFLGetElementsRelatedViews(NSArray<SJFLLayoutElement *> *eles);

UIKIT_EXTERN
void SJFLRefreshLayoutsForRelatedView(UIView *view);
@end
NS_ASSUME_NONNULL_END
