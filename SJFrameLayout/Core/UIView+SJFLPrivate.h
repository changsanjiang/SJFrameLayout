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
@property (nonatomic, strong, nullable) NSArray<SJFLLayoutElement *> *FL_elements;
- (SJFLLayoutElement *_Nullable)FL_elementForAttribute:(SJFLAttribute)attribute;
@end
NS_ASSUME_NONNULL_END
