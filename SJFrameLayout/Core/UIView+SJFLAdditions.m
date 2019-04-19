//
//  UIView+SJFLAdditions.m
//  Masonry
//
//  Created by BlueDancer on 2019/4/18.
//

#import "UIView+SJFLAdditions.h"
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN
@implementation UIView (SJFLAdditions)
- (SJFLAttributeUnit *)FL_Top {
    return [[SJFLAttributeUnit alloc] initWithView:self attribute:SJFLAttributeTop];
}
- (SJFLAttributeUnit *)FL_Left {
    return [[SJFLAttributeUnit alloc] initWithView:self attribute:SJFLAttributeLeft];
}
- (SJFLAttributeUnit *)FL_Bottom {
    return [[SJFLAttributeUnit alloc] initWithView:self attribute:SJFLAttributeBottom];
}
- (SJFLAttributeUnit *)FL_Right {
    return [[SJFLAttributeUnit alloc] initWithView:self attribute:SJFLAttributeRight];
}
- (SJFLAttributeUnit *)FL_Width {
    return [[SJFLAttributeUnit alloc] initWithView:self attribute:SJFLAttributeWidth];
}
- (SJFLAttributeUnit *)FL_Height {
    return [[SJFLAttributeUnit alloc] initWithView:self attribute:SJFLAttributeHeight];
}
- (SJFLAttributeUnit *)FL_CenterX {
    return [[SJFLAttributeUnit alloc] initWithView:self attribute:SJFLAttributeCenterX];
}
- (SJFLAttributeUnit *)FL_CenterY {
    return [[SJFLAttributeUnit alloc] initWithView:self attribute:SJFLAttributeCenterY];
}
@end
NS_ASSUME_NONNULL_END
