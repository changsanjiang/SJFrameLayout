//
//  SJFLLayoutAttributeUnit.m
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "SJFLLayoutAttributeUnit.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SJFLLayoutAttributeUnit
+ (NSString *)debug_attributeToString:(SJFLLayoutAttribute)attribute {
    switch ( attribute ) {
        case SJFLLayoutAttributeNone:
            return @"SJFLLayoutAttributeNone";
        case SJFLLayoutAttributeTop:
            return @"SJFLLayoutAttributeTop";
        case SJFLLayoutAttributeLeft:
            return @"SJFLLayoutAttributeLeft";
        case SJFLLayoutAttributeBottom:
            return @"SJFLLayoutAttributeBottom";
        case SJFLLayoutAttributeRight:
            return @"SJFLLayoutAttributeRight";
        case SJFLLayoutAttributeWidth:
            return @"SJFLLayoutAttributeWidth";
        case SJFLLayoutAttributeHeight:
            return @"SJFLLayoutAttributeHeight";
        case SJFLLayoutAttributeCenterX:
            return @"SJFLLayoutAttributeCenterX";
        case SJFLLayoutAttributeCenterY:
            return @"SJFLLayoutAttributeCenterY";
    }
}

- (instancetype)initWithView:(UIView *)view attribute:(SJFLLayoutAttribute)attribute {
    self = [super init];
    if ( !self ) return nil;
    _attribute = attribute;
    _view = view;
    self->multiplier = 1.0;
    return self;
}
- (void)equalTo:(SJFLFrameAttributeUnit *)viewAttribute {
    _equalToViewAttribute = viewAttribute;
}
@end
NS_ASSUME_NONNULL_END
