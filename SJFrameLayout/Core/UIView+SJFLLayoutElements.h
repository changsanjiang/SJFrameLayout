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
- (SJFLLayoutElement *_Nullable)FL_elementForAttribute:(SJFLAttribute)attribute;
- (SJFLLayoutElement *_Nullable)FL_elementForAttribute:(SJFLAttribute)attribute priority:(char)priority; // width & height

- (void)FL_addElement:(SJFLLayoutElement *)element;
- (void)FL_addElementsFromArray:(NSArray<SJFLLayoutElement *> *)elements;
- (void)FL_replaceElementForAttribute:(SJFLAttribute)attribute withElement:(SJFLLayoutElement *)element;

- (void)FL_removeElementForAttribute:(SJFLAttribute)attribute;
- (void)FL_removeElement:(SJFLLayoutElement *)element;
- (void)FL_removeAllElements;

- (NSArray<SJFLLayoutElement *> *_Nullable)FL_elements;

UIKIT_EXTERN
SJFLLayoutElement *_Nullable SJFLGetElement(NSArray<SJFLLayoutElement *> *eles, SJFLAttribute attribute, char priority);

UIKIT_EXTERN
NSInteger SJFLGetIndex(NSArray<SJFLLayoutElement *> *m, SJFLAttribute attribute, char priority);

UIKIT_EXTERN
NSMutableSet<UIView *> *SJFLGetElementsRelatedViews(NSArray<SJFLLayoutElement *> *eles);

UIKIT_EXTERN
void SJFLRefreshLayoutsForRelatedView(UIView *view);
@end
NS_ASSUME_NONNULL_END
