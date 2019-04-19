//
//  SJFLLayout.m
//  Pods
//
//  Created by BlueDancer on 2019/4/18.
//

#import "SJFLLayout.h"
#import "UIView+SJFLAdditions.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLLayout () {
    SJFLAttributeUnit *_Nullable FL_dependency;
    NSNumber *_Nullable FL_offset;
    SJFLAttributeUnit *FL_Unit;
}
@end

@implementation SJFLLayout
- (instancetype)initWithUnit:(SJFLAttributeUnit *)unit {
    self = [super init];
    if ( !self ) return nil;
    FL_Unit = unit;
    return self;
}

- (SJFLLayout * _Nonnull (^)(SJFLAttributeUnit *))equalTo {
    return ^SJFLLayout *(SJFLAttributeUnit *unit) {
        self->FL_dependency = unit;
        return self;
    };
}

- (void (^)(CGFloat))offset {
    return ^(CGFloat offset) {
        self->FL_offset = @(offset);
    };
}

- (SJFLLayoutElement *)generateElement {
    return [[SJFLLayoutElement alloc] initWithTarget:FL_Unit equalTo:FL_dependency offset:[FL_offset doubleValue]];
}
@end
NS_ASSUME_NONNULL_END
