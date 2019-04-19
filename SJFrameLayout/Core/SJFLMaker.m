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
#import "SJFLRecorder.h"
#import "SJFLLayoutElement.h"
#import "SJFLAttributeUnit.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLMaker () {
    __weak UIView *_Nullable _view;
    NSMutableArray<SJFLLayout *> *_m;
}
@end

@implementation SJFLMaker
- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if ( !self ) return nil;
    _view = view;
    _m = [NSMutableArray array];
    return self;
}

- (SJFLLayout *)top {
    SJFLLayout *layout = [[SJFLLayout alloc] initWithAttribute:SJFLAttributeTop];
    [_m addObject:layout];
    return layout;
}

- (SJFLLayout *)left {
    SJFLLayout *layout = [[SJFLLayout alloc] initWithAttribute:SJFLAttributeLeft];
    [_m addObject:layout];
    return layout;
}

- (SJFLLayout *)bottom {
    SJFLLayout *layout = [[SJFLLayout alloc] initWithAttribute:SJFLAttributeBottom];
    [_m addObject:layout];
    return layout;
}

- (SJFLLayout *)right {
    SJFLLayout *layout = [[SJFLLayout alloc] initWithAttribute:SJFLAttributeRight];
    [_m addObject:layout];
    return layout;
}

- (SJFLLayout *)width {
    SJFLLayout *layout = [[SJFLLayout alloc] initWithAttribute:SJFLAttributeWidth];
    [_m addObject:layout];
    return layout;
}

- (SJFLLayout *)height {
    SJFLLayout *layout = [[SJFLLayout alloc] initWithAttribute:SJFLAttributeHeight];
    [_m addObject:layout];
    return layout;
}

- (SJFLLayout *)centerX {
    SJFLLayout *layout = [[SJFLLayout alloc] initWithAttribute:SJFLAttributeCenterX];
    [_m addObject:layout];
    return layout;
}

- (SJFLLayout *)centerY {
    SJFLLayout *layout = [[SJFLLayout alloc] initWithAttribute:SJFLAttributeCenterY];
    [_m addObject:layout];
    return layout;
}

- (void)install {
    SJFLRecorder *_Nullable rec_top = nil;
    SJFLRecorder *_Nullable rec_left = nil;
    SJFLRecorder *_Nullable rec_bottom = nil;
    SJFLRecorder *_Nullable rec_right = nil;
    SJFLRecorder *_Nullable rec_width = nil;
    SJFLRecorder *_Nullable rec_height = nil;
    SJFLRecorder *_Nullable rec_centerX = nil;
    SJFLRecorder *_Nullable rec_centerY = nil;
    
    for ( SJFLLayout *layout in _m ) {
        SJFLRecorder *recorder = [layout recorder];
        if ( [layout layoutExistsForAttribtue:SJFLAttributeTop] )       rec_top = recorder;
        if ( [layout layoutExistsForAttribtue:SJFLAttributeLeft] )      rec_left = recorder;
        if ( [layout layoutExistsForAttribtue:SJFLAttributeBottom] )    rec_bottom = recorder;
        if ( [layout layoutExistsForAttribtue:SJFLAttributeRight] )     rec_right = recorder;
        if ( [layout layoutExistsForAttribtue:SJFLAttributeWidth] )     rec_width = recorder;
        if ( [layout layoutExistsForAttribtue:SJFLAttributeHeight] )    rec_height = recorder;
        if ( [layout layoutExistsForAttribtue:SJFLAttributeCenterX] )   rec_centerX = recorder;
        if ( [layout layoutExistsForAttribtue:SJFLAttributeCenterY] )   rec_centerY = recorder;
    }
    
    NSMutableArray<SJFLLayoutElement *> *m = [NSMutableArray array];
    if ( rec_top )      [m addObject:[self createElementForRecorder:rec_top attribute:SJFLAttributeTop]];
    if ( rec_left )     [m addObject:[self createElementForRecorder:rec_left attribute:SJFLAttributeLeft]];
    if ( rec_bottom )   [m addObject:[self createElementForRecorder:rec_bottom attribute:SJFLAttributeBottom]];
    if ( rec_right )    [m addObject:[self createElementForRecorder:rec_right attribute:SJFLAttributeRight]];
    if ( rec_width )    [m addObject:[self createElementForRecorder:rec_width attribute:SJFLAttributeWidth]];
    if ( rec_height )   [m addObject:[self createElementForRecorder:rec_height attribute:SJFLAttributeHeight]];
    if ( rec_centerX )  [m addObject:[self createElementForRecorder:rec_centerX attribute:SJFLAttributeCenterX]];
    if ( rec_centerY )  [m addObject:[self createElementForRecorder:rec_centerX attribute:SJFLAttributeCenterY]];
    _view.FL_elements = m;
}

- (SJFLLayoutElement *)createElementForRecorder:(SJFLRecorder *)recorder attribute:(SJFLAttribute)attr {
    SJFLAttributeUnit *unit = [[SJFLAttributeUnit alloc] initWithView:_view attribute:attr];
    return [[SJFLLayoutElement alloc] initWithTarget:unit equalTo:recorder->FL_dependency offset:recorder->FL_offset];
}
@end
NS_ASSUME_NONNULL_END
