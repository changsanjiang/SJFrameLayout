//
//  SJFLLayoutMask.m
//  Pods
//
//  Created by BlueDancer on 2019/4/19.
//

#import "SJFLLayoutMask.h"
#import "SJFLRecorder.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SJFLLayoutMask {
    SJFLAttributeMask _attrs;
    SJFLRecorder *_recorder;
}

- (instancetype)initWithAttributes:(SJFLAttributeMask)attrs {
    self = [super init];
    if ( !self ) return nil;
    _attrs = attrs;
    _recorder = [SJFLRecorder new];
    return self;
}

- (instancetype)initWithAttribute:(SJFLAttribute)attr {
    return [self initWithAttributes:1 << attr];
}

- (SJFLLayoutMask *)top {
    _attrs |= SJFLAttributeMaskTop;
    return self;
}

- (SJFLLayoutMask *)left {
    _attrs |= SJFLAttributeMaskLeft;
    return self;
}

- (SJFLLayoutMask *)bottom {
    _attrs |= SJFLAttributeMaskBottom;
    return self;
}

- (SJFLLayoutMask *)right {
    _attrs |= SJFLAttributeMaskRight;
    return self;
}

- (SJFLLayoutMask *)edge {
    _attrs |= SJFLAttributeMaskEdge;
    return self;
}

- (SJFLLayoutMask *)width {
    _attrs |= SJFLAttributeMaskWidth;
    return self;
}

- (SJFLLayoutMask *)height {
    _attrs |= SJFLAttributeMaskHeight;
    return self;
}

- (SJFLLayoutMask *)size {
    _attrs |= SJFLAttributeMaskSize;
    return self;
}

- (SJFLLayoutMask *)centerX {
    _attrs |= SJFLAttributeMaskCenterX;
    return self;
}

- (SJFLLayoutMask *)centerY {
    _attrs |= SJFLAttributeMaskCenterY;
    return self;
}

- (SJFLLayoutMask *)center {
    _attrs |= SJFLAttributeMaskCenter;
    return self;
}

- (SJFLEqualToHandler)equalTo {
    return ^SJFLLayoutMask *(id layout) {
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
    return _attrs & (1 << attr);
}

- (SJFLRecorder *)recorder {
    return _recorder;
}
@end
NS_ASSUME_NONNULL_END
