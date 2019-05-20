//
//  SJFLLayoutMaker.m
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "SJFLLayoutMaker.h"
#import <objc/message.h>
#import "UIView+SJFLFrameAttributeUnits.h"
#import "UIView+SJFLLayoutAttributeUnits.h"
#import "SJFLLayoutElement.h"
#import "SJFLLayoutAttributeUnit.h"
#import "SJFLLayoutEngine.h"

NS_ASSUME_NONNULL_BEGIN
#if 1
#ifdef DEBUG
#undef DEBUG
#endif
#endif

@interface SJFLLayoutMaker () {
    __weak UIView *_Nullable _view;
    __weak UIView *_Nullable _superview;
}
@end

@implementation SJFLLayoutMaker
- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if ( !self ) return nil;
    _view = view;
    _superview = view.superview;
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

RETURN_FL_MAKER_LAYOUT(top, SJFLLayoutAttributeTop);
RETURN_FL_MAKER_LAYOUT(left, SJFLLayoutAttributeLeft);
RETURN_FL_MAKER_LAYOUT(bottom, SJFLLayoutAttributeBottom);
RETURN_FL_MAKER_LAYOUT(right, SJFLLayoutAttributeRight);
RETURN_FL_MAKER_LAYOUT_MASK(edges, SJFLLayoutAttributeMaskEdges);

RETURN_FL_MAKER_LAYOUT(width, SJFLLayoutAttributeWidth);
RETURN_FL_MAKER_LAYOUT(height, SJFLLayoutAttributeHeight);
RETURN_FL_MAKER_LAYOUT_MASK(size, SJFLLayoutAttributeMaskSize);

RETURN_FL_MAKER_LAYOUT(centerX, SJFLLayoutAttributeCenterX);
RETURN_FL_MAKER_LAYOUT(centerY, SJFLLayoutAttributeCenterY);
RETURN_FL_MAKER_LAYOUT_MASK(center, SJFLLayoutAttributeMaskCenter);

- (void)install {
    __auto_type m = SJFLCreateElementsForAttributeUnits(_view, _superview);
    [_view FL_resetAttributeUnits];
    SJFLAddFittingSizeUnitsIfNeeded(_view, m);
    SJFL_InstallLayouts(_view, m);
    SJFL_LayoutIfNeeded(_view);
    
#ifdef DEBUG
    for ( SJFLLayoutElement *ele in m ) {
        printf("\nElement: %s", ele.description.UTF8String);
    }
    printf("\n");
    printf("\n");
#endif
}
- (void)update {
#warning next ..
//    // - elements
//    NSMutableDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *
//    m = _view.FL_elements?:@{}.mutableCopy;
//    __auto_type update = SJFLCreateElementsForAttributeUnits(_view, _superview);
//    [_view FL_resetAttributeUnits];
//    [m setDictionary:update];
//    SJFLAddFittingSizeUnitsIfNeeded(_view, m);
//    _view.FL_elements = m;
//    // - update
//    [_view FL_layoutIfNeeded_flag];
}

+ (void)removeAllLayouts:(UIView *)view {
    SJFL_RemoveLayouts(view);
}

#pragma mark -

UIKIT_STATIC_INLINE SJFL_ElementsMutableMap_t
SJFLCreateElementsForAttributeUnits(UIView *view, UIView *superview) {
    SJFL_ElementsMutableMap_t map = [NSMutableDictionary dictionaryWithCapacity:8];
    SJFLLayoutAttributeUnit *_Nullable top = [view FL_attributeUnitForAttribute:SJFLLayoutAttributeTop];
    SJFLLayoutAttributeUnit *_Nullable left = [view FL_attributeUnitForAttribute:SJFLLayoutAttributeLeft];
    SJFLLayoutAttributeUnit *_Nullable bottom = [view FL_attributeUnitForAttribute:SJFLLayoutAttributeBottom];
    SJFLLayoutAttributeUnit *_Nullable right = [view FL_attributeUnitForAttribute:SJFLLayoutAttributeRight];
    SJFLLayoutAttributeUnit *_Nullable width = [view FL_attributeUnitForAttribute:SJFLLayoutAttributeWidth];
    SJFLLayoutAttributeUnit *_Nullable height = [view FL_attributeUnitForAttribute:SJFLLayoutAttributeHeight];
    SJFLLayoutAttributeUnit *_Nullable centerX = [view FL_attributeUnitForAttribute:SJFLLayoutAttributeCenterX];
    SJFLLayoutAttributeUnit *_Nullable centerY = [view FL_attributeUnitForAttribute:SJFLLayoutAttributeCenterY];
    
    if ( top != nil ) map[SJFLLayoutAttributeKeyTop] = [[SJFLLayoutElement alloc] initWithTarget:top superview:superview];
    if ( left != nil ) map[SJFLLayoutAttributeKeyLeft] = [[SJFLLayoutElement alloc] initWithTarget:left superview:superview];
    if ( bottom != nil ) map[SJFLLayoutAttributeKeyBottom] = [[SJFLLayoutElement alloc] initWithTarget:bottom superview:superview];
    if ( right != nil ) map[SJFLLayoutAttributeKeyRight] = [[SJFLLayoutElement alloc] initWithTarget:right superview:superview];
    if ( width != nil ) map[SJFLLayoutAttributeKeyWidth] = [[SJFLLayoutElement alloc] initWithTarget:width superview:superview];
    if ( height != nil ) map[SJFLLayoutAttributeKeyHeight] = [[SJFLLayoutElement alloc] initWithTarget:height superview:superview];
    if ( centerX != nil ) map[SJFLLayoutAttributeKeyCenterX] = [[SJFLLayoutElement alloc] initWithTarget:centerX superview:superview];
    if ( centerY != nil ) map[SJFLLayoutAttributeKeyCenterY] = [[SJFLLayoutElement alloc] initWithTarget:centerY superview:superview];
    return map;
}


UIKIT_STATIC_INLINE SJFL_ElementsMutableMap_t
SJFLAddFittingSizeUnitsIfNeeded(UIView *view, SJFL_ElementsMutableMap_t map) {
    SJFLLayoutElement *_Nullable top = map[SJFLLayoutAttributeKeyTop];
    SJFLLayoutElement *_Nullable bottom = map[SJFLLayoutAttributeKeyBottom];
    SJFLLayoutElement *_Nullable height = map[SJFLLayoutAttributeKeyHeight];
    
    SJFLLayoutElement *_Nullable left = map[SJFLLayoutAttributeKeyLeft];
    SJFLLayoutElement *_Nullable right = map[SJFLLayoutAttributeKeyRight];
    SJFLLayoutElement *_Nullable width = map[SJFLLayoutAttributeKeyWidth];
    
    // - FittingSize units
    
    if ( width != nil || (left != nil && right != nil) )
    { /* nothing */ }
    else {
        // no - width
        SJFLLayoutAttributeUnit *widthUnit = [[SJFLLayoutAttributeUnit alloc] initWithView:view attribute:SJFLLayoutAttributeWidth];
        widthUnit->priority = SJFLPriorityFittingSize;
        // Will be added when the view itself has no width condition
        map[SJFLLayoutAttributeKeyWidth] = [[SJFLLayoutElement alloc] initWithTarget:widthUnit];
    }
    
    if ( height != nil || (top != nil && bottom != nil) )
    { /* nothing */ }
    else {
        // no - height
        SJFLLayoutAttributeUnit *heightUnit = [[SJFLLayoutAttributeUnit alloc] initWithView:view attribute:SJFLLayoutAttributeHeight];
        heightUnit->priority = SJFLPriorityFittingSize;
        
        // Will be added when the view itself has no height condition
        map[SJFLLayoutAttributeKeyHeight] = [[SJFLLayoutElement alloc] initWithTarget:heightUnit];
    }
    return map;
}
@end
NS_ASSUME_NONNULL_END
