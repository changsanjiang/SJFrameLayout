//
//  SJFLAttributeUnit.m
//  Pods
//
//  Created by BlueDancer on 2019/4/18.
//

#import "SJFLAttributeUnit.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SJFLAttributeUnit
- (instancetype)initWithView:(__weak UIView *)view attribute:(SJFLAttribute)attribute {
    self = [super init];
    if ( !self ) return nil;
    _attribute = attribute;
    _view = view;
    return self;
}
@end
NS_ASSUME_NONNULL_END
