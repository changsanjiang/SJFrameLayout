//
//  SJFLLayout.m
//  Pods
//
//  Created by BlueDancer on 2019/4/19.
//

#import "SJFLLayout.h"
#import "SJFLRecorder.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SJFLLayout {
    SJFLAttribute _attrs;
    SJFLRecorder *_recorder;
}

- (instancetype)initWithAttribute:(SJFLAttribute)attr {
    self = [super init];
    if ( !self ) return nil;
    _attrs = attr;
    _recorder = [SJFLRecorder new];
    return self;
}

- (SJFLLayout *)top {
    _attrs |= SJFLAttributeTop;
    return self;
}

- (SJFLLayout *)left {
    _attrs |= SJFLAttributeLeft;
    return self;
}

- (SJFLLayout *)bottom {
    _attrs |= SJFLAttributeBottom;
    return self;
}

- (SJFLLayout *)right {
    _attrs |= SJFLAttributeRight;
    return self;
}

- (SJFLLayout *)width {
    _attrs |= SJFLAttributeWidth;
    return self;
}

- (SJFLLayout *)height {
    _attrs |= SJFLAttributeHeight;
    return self;
}

- (SJFLLayout *)centerX {
    _attrs |= SJFLAttributeCenterX;
    return self;
}

- (SJFLLayout *)centerY {
    _attrs |= SJFLAttributeCenterY;
    return self;
}

- (SJFLEqualToHandler)equalTo {
    return ^SJFLLayout *(id layout) {
        self->_recorder->FL_dependency = layout;
        return self;
    };
}
- (SJFLOffsetHandler)offset {
    return ^(CGFloat offset) {
        self->_recorder->FL_offset = offset;
    };
}

- (BOOL)layoutExistsForAttribtue:(SJFLAttribute)attr {
    return _attrs & attr;
}

- (SJFLRecorder *)recorder {
    return _recorder;
}
@end
NS_ASSUME_NONNULL_END
