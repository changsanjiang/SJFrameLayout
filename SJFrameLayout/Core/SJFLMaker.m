//
//  SJFLMaker.m
//  Pods
//
//  Created by BlueDancer on 2019/4/18.
//

#import "SJFLMaker.h"
#import <objc/message.h>
#import "UIView+SJFLAdditions.h"
#import "UIView+SJFLPrivate.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLMaker ()
@property (nonatomic, weak, readonly, nullable) UIView *view;
@property (nonatomic, strong, readonly) SJFLAttributeUnit *unit;
@end

@implementation SJFLMaker
- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if ( !self ) return nil;
    _view = view;
    return self;
}
@synthesize top = _top;
- (SJFLLayout *)top {
    if ( !_top ) {
        _top = [[SJFLLayout alloc] initWithUnit:[[SJFLAttributeUnit alloc] initWithView:_view attribute:SJFLAttributeTop]];
    }
    return _top;
}
@synthesize left = _left;
- (SJFLLayout *)left {
    if ( !_left ) {
        _left = [[SJFLLayout alloc] initWithUnit:[[SJFLAttributeUnit alloc] initWithView:_view attribute:SJFLAttributeLeft]];
    }
    return _left;
}
@synthesize bottom = _bottom;
- (SJFLLayout *)bottom {
    if ( !_bottom ) {
        _bottom = [[SJFLLayout alloc] initWithUnit:[[SJFLAttributeUnit alloc] initWithView:_view attribute:SJFLAttributeBottom]];
    }
    return _bottom;
}
@synthesize right = _right;
- (SJFLLayout *)right {
    if ( !_right ) {
        _right = [[SJFLLayout alloc] initWithUnit:[[SJFLAttributeUnit alloc] initWithView:_view attribute:SJFLAttributeRight]];
    }
    return _right;
}
@synthesize width = _width;
- (SJFLLayout *)width {
    if ( !_width ) {
        _width = [[SJFLLayout alloc] initWithUnit:[[SJFLAttributeUnit alloc] initWithView:_view attribute:SJFLAttributeWidth]];
    }
    return _width;
}
@synthesize height = _height;
- (SJFLLayout *)height {
    if ( !_height ) {
        _height = [[SJFLLayout alloc] initWithUnit:[[SJFLAttributeUnit alloc] initWithView:_view attribute:SJFLAttributeHeight]];
    }
    return _height;
}
@synthesize centerX = _centerX;
- (SJFLLayout *)centerX {
    if ( !_centerX ) {
        _centerX = [[SJFLLayout alloc] initWithUnit:[[SJFLAttributeUnit alloc] initWithView:_view attribute:SJFLAttributeCenterX]];
    }
    return _centerX;
}
@synthesize centerY = _centerY;
- (SJFLLayout *)centerY {
    if ( !_centerY ) {
        _centerY = [[SJFLLayout alloc] initWithUnit:[[SJFLAttributeUnit alloc] initWithView:_view attribute:SJFLAttributeCenterY]];
    }
    return _centerY;
}
- (void)install {
    NSMutableArray<SJFLLayoutElement *> *m = [NSMutableArray array];
#define SJFLLayoutGenerateElement(_layout_) \
    if ( _layout_ != nil ) { \
        [m addObject:[_layout_ generateElement]]; \
    }
    
    SJFLLayoutGenerateElement(_top);
    SJFLLayoutGenerateElement(_left);
    SJFLLayoutGenerateElement(_bottom);
    SJFLLayoutGenerateElement(_right);
    SJFLLayoutGenerateElement(_width);
    SJFLLayoutGenerateElement(_height);
    SJFLLayoutGenerateElement(_centerX);
    SJFLLayoutGenerateElement(_centerY);
    
    _view.FL_elements = m;
}
@end
NS_ASSUME_NONNULL_END
