//
//  SJFLLayoutMask.m
//  Pods
//
//  Created by BlueDancer on 2019/4/19.
//

#import "SJFLLayoutMask.h"
#import "SJFLRecorder.h"

typedef enum : NSUInteger {
    SJFLAttributeMaskNone = 1 << SJFLAttributeNone,
    SJFLAttributeMaskTop = 1 << SJFLAttributeTop,
    SJFLAttributeMaskLeft = 1 << SJFLAttributeLeft,
    SJFLAttributeMaskBottom = 1 << SJFLAttributeBottom,
    SJFLAttributeMaskRight = 1 << SJFLAttributeRight,
    SJFLAttributeMaskWidth = 1 << SJFLAttributeWidth,
    SJFLAttributeMaskHeight = 1 << SJFLAttributeHeight,
    SJFLAttributeMaskCenterX = 1 << SJFLAttributeCenterX,
    SJFLAttributeMaskCenterY = 1 << SJFLAttributeCenterY
} SJFLAttributeMask;

NS_ASSUME_NONNULL_BEGIN
@implementation SJFLLayoutMask {
    SJFLAttributeMask _attrs;
    SJFLRecorder *_recorder;
}

- (instancetype)initWithAttribute:(SJFLAttribute)attr {
    self = [super init];
    if ( !self ) return nil;
    _attrs = 1 << attr;
    _recorder = [SJFLRecorder new];
    return self;
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

- (SJFLLayoutMask *)width {
    _attrs |= SJFLAttributeMaskWidth;
    return self;
}

- (SJFLLayoutMask *)height {
    _attrs |= SJFLAttributeMaskHeight;
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
