//
//  SJFLViewAttribute.m
//  Pods
//
//  Created by 畅三江 on 2019/4/23.
//

#import "SJFLViewFrameAttribute.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SJFLViewFrameAttribute
- (instancetype)initWithView:(UIView *)view attribute:(SJFLAttribute)attribute {
    self = [super init];
    if ( self ) {
        _view = view;
        _attribute = attribute;
    }
    return self;
}
@end
NS_ASSUME_NONNULL_END
