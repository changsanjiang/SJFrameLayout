//
//  UIView+SJFLPrivate.h
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import <UIKit/UIKit.h>
@class SJFLLayoutElement;

NS_ASSUME_NONNULL_BEGIN
@interface UIView (SJFLPrivate)
@property (nonatomic, strong, nullable) NSArray<SJFLLayoutElement *> *FL_elements;
@end
NS_ASSUME_NONNULL_END
