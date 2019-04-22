//
//  UIView+SJFLPrivate.h
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import <UIKit/UIKit.h>
#import "SJFLAttributeUnit.h"
@class SJFLLayoutElement;

NS_ASSUME_NONNULL_BEGIN
@interface UIView (SJFLPrivate)
- (void)FL_addElement:(SJFLLayoutElement *)element;
- (void)FL_addElementsFromArray:(NSArray<SJFLLayoutElement *> *)elements;
- (void)FL_replaceElementForAttribute:(SJFLAttribute)attribute withElement:(SJFLLayoutElement *)element;
- (void)FL_removeAllElements;
- (SJFLLayoutElement *_Nullable)FL_elementForAttribute:(SJFLAttribute)attribute;
@end
NS_ASSUME_NONNULL_END
