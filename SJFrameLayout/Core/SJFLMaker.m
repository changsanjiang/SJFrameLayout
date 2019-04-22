//
//  SJFLMaker.m
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "SJFLMaker.h"
#import <objc/message.h>
#import "UIView+SJFLAttributeUnits.h"
#import "UIView+SJFLPrivate.h"
#import "SJFLLayoutElement.h"
#import "SJFLAttributeUnit.h"

NS_ASSUME_NONNULL_BEGIN
#if 1
#ifdef DEBUG
#undef DEBUG
#endif
#endif

@interface SJFLMaker () {
    __weak UIView *_Nullable _view;
}
@end

@implementation SJFLMaker
- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if ( !self ) return nil;
    _view = view;
    return self;
} 

#define RETURN_FL_MAKER_LAYOUT(__layout__, __attr__) \
@synthesize __layout__ = _##__layout__; \
- (SJFLLayoutMask *)__layout__ { \
    if ( !_##__layout__ ) { \
        _##__layout__ = [[SJFLLayoutMask alloc] initWithView:_view attribute:__attr__]; \
    } \
    return _##__layout__; \
}

#define RETURN_FL_MAKER_LAYOUT_MASK(__layout__, __mask__) \
@synthesize __layout__ = _##__layout__; \
- (SJFLLayoutMask *)__layout__ { \
    if ( !_##__layout__ ) { \
        _##__layout__ = [[SJFLLayoutMask alloc] initWithView:_view attributes:__mask__]; \
    } \
    return _##__layout__; \
}

RETURN_FL_MAKER_LAYOUT(top, SJFLAttributeTop);
RETURN_FL_MAKER_LAYOUT(left, SJFLAttributeLeft);
RETURN_FL_MAKER_LAYOUT(bottom, SJFLAttributeBottom);
RETURN_FL_MAKER_LAYOUT(right, SJFLAttributeRight);
RETURN_FL_MAKER_LAYOUT_MASK(edges, SJFLAttributeMaskEdges);

RETURN_FL_MAKER_LAYOUT(width, SJFLAttributeWidth);
RETURN_FL_MAKER_LAYOUT(height, SJFLAttributeHeight);
RETURN_FL_MAKER_LAYOUT_MASK(size, SJFLAttributeMaskSize);

RETURN_FL_MAKER_LAYOUT(centerX, SJFLAttributeCenterX);
RETURN_FL_MAKER_LAYOUT(centerY, SJFLAttributeCenterY);
RETURN_FL_MAKER_LAYOUT_MASK(center, SJFLAttributeMaskCenter);

- (void)install {
    NSArray<SJFLLayoutElement *> *m = SJFLGenerateLayoutElements(_view);
    [_view FL_addElementsFromArray:m];
    [_view FL_resetAttributeUnits];
    
#ifdef DEBUG
    for ( SJFLLayoutElement *ele in m ) {
        printf("\nElement: %s", ele.description.UTF8String);
    }
    printf("\n");
    printf("\n");
#endif
}

- (void)update {
    NSArray<SJFLLayoutElement *> *m = SJFLGenerateLayoutElements(_view);
    for ( SJFLLayoutElement *ele in m ) {
        [_view FL_replaceElementForAttribute:ele.tar_attr withElement:ele];
    }
    [_view FL_resetAttributeUnits];
    [_view.superview layoutSubviews];
}

UIKIT_STATIC_INLINE NSArray<SJFLLayoutElement *> *SJFLGenerateLayoutElements(UIView *view) {
    NSMutableArray<SJFLLayoutElement *> *m = [NSMutableArray arrayWithCapacity:8];
    SJFLAttributeUnit *_Nullable top = [view FL_attributeUnitForAttribute:SJFLAttributeTop];
    SJFLAttributeUnit *_Nullable left = [view FL_attributeUnitForAttribute:SJFLAttributeLeft];
    SJFLAttributeUnit *_Nullable bottom = [view FL_attributeUnitForAttribute:SJFLAttributeBottom];
    SJFLAttributeUnit *_Nullable right = [view FL_attributeUnitForAttribute:SJFLAttributeRight];
    SJFLAttributeUnit *_Nullable width = [view FL_attributeUnitForAttribute:SJFLAttributeWidth];
    SJFLAttributeUnit *_Nullable height = [view FL_attributeUnitForAttribute:SJFLAttributeHeight];
    SJFLAttributeUnit *_Nullable centerX = [view FL_attributeUnitForAttribute:SJFLAttributeCenterX];
    SJFLAttributeUnit *_Nullable centerY = [view FL_attributeUnitForAttribute:SJFLAttributeCenterY];
    
    if ( top != nil ) [m addObject:[[SJFLLayoutElement alloc] initWithTarget:top]];
    if ( left != nil ) [m addObject:[[SJFLLayoutElement alloc] initWithTarget:left]];
    if ( bottom != nil ) [m addObject:[[SJFLLayoutElement alloc] initWithTarget:bottom]];
    if ( right != nil ) [m addObject:[[SJFLLayoutElement alloc] initWithTarget:right]];
    if ( width != nil ) [m addObject:[[SJFLLayoutElement alloc] initWithTarget:width]];
    if ( height != nil ) [m addObject:[[SJFLLayoutElement alloc] initWithTarget:height]];
    if ( centerX != nil ) [m addObject:[[SJFLLayoutElement alloc] initWithTarget:centerX]];
    if ( centerY != nil ) [m addObject:[[SJFLLayoutElement alloc] initWithTarget:centerY]];
    
    return m;
}
@end
NS_ASSUME_NONNULL_END
