//
//  SJFLViewAttribute.m
//  Pods
//
//  Created by 畅三江 on 2019/4/23.
//

#import "SJFLFrameAttributeUnit.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SJFLFrameAttributeUnit
- (instancetype)initWithView:(UIView *)view attribute:(SJFLFrameAttribute)attribute {
    self = [super init];
    if ( self ) {
        _view = view;
        _attribute = attribute;
    }
    return self;
}
@end
NS_ASSUME_NONNULL_END
