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
    SJFLAttribute _attr;
    SJFLRecorder *_recorder;
    SJFLLayout *_Nullable _top;
    SJFLLayout *_Nullable _left;
    SJFLLayout *_Nullable _bottom;
    SJFLLayout *_Nullable _right;
    
    SJFLLayout *_Nullable _width;
    SJFLLayout *_Nullable _height;
    
    SJFLLayout *_Nullable _centerX;
    SJFLLayout *_Nullable _centerY;
}

- (instancetype)initWithAttribute:(SJFLAttribute)attr {
    self = [super init];
    if ( !self ) return nil;
    _attr = attr;
    _recorder = [SJFLRecorder new];
    return self;
}

- (SJFLLayout *)top {
    SJFLAttribute attr = SJFLAttributeTop;
    if ( _attr == attr )
        return self;
        
    if ( !_top ) {
        _top = [[SJFLLayout alloc] initWithAttribute:attr];
    }
    return _top;
}

- (SJFLLayout *)left {
    SJFLAttribute attr = SJFLAttributeLeft;
    if ( _attr == attr )
        return self;
    
    if ( !_left ) {
        _left = [[SJFLLayout alloc] initWithAttribute:attr];
    }
    return _left;
}

- (SJFLLayout *)bottom {
    SJFLAttribute attr = SJFLAttributeBottom;
    if ( _attr == attr )
        return self;
    
    if ( !_bottom ) {
        _bottom = [[SJFLLayout alloc] initWithAttribute:attr];
    }
    return _bottom;
}

- (SJFLLayout *)right {
    SJFLAttribute attr = SJFLAttributeRight;
    if ( _attr == attr )
        return self;
    
    if ( !_right ) {
        _right = [[SJFLLayout alloc] initWithAttribute:attr];
    }
    return _right;
}

- (SJFLLayout *)width {
    SJFLAttribute attr = SJFLAttributeWidth;
    if ( _attr == attr )
        return self;
    
    if ( !_width ) {
        _width = [[SJFLLayout alloc] initWithAttribute:attr];
    }
    return _width;
}

- (SJFLLayout *)height {
    SJFLAttribute attr = SJFLAttributeHeight;
    if ( _attr == attr )
        return self;
    
    if ( !_height ) {
        _height = [[SJFLLayout alloc] initWithAttribute:attr];
    }
    return _height;
}

- (SJFLLayout *)centerX {
    SJFLAttribute attr = SJFLAttributeCenterX;
    if ( _attr == attr )
        return self;
    
    if ( !_centerX ) {
        _centerX = [[SJFLLayout alloc] initWithAttribute:attr];
    }
    return _centerX;
}

- (SJFLLayout *)centerY {
    SJFLAttribute attr = SJFLAttributeCenterY;
    if ( _attr == attr )
        return self;
    
    if ( !_centerY ) {
        _centerY = [[SJFLLayout alloc] initWithAttribute:attr];
    }
    return _centerY;
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
    if ( attr == _attr )
        return YES;
    
    switch ( attr ) {
        case SJFLAttributeNone: break;
        case SJFLAttributeTop:
            return _top != nil;
        case SJFLAttributeLeft:
            return _left != nil;
        case SJFLAttributeBottom:
            return _bottom != nil;
        case SJFLAttributeRight:
            return _right != nil;
        case SJFLAttributeWidth:
            return _width != nil;
        case SJFLAttributeHeight:
            return _height != nil;
        case SJFLAttributeCenterX:
            return _centerX != nil;
        case SJFLAttributeCenterY:
            return _centerY != nil;
    }
    return NO;
}

- (SJFLRecorder *)recorder {
    return _recorder;
}
@end
NS_ASSUME_NONNULL_END
