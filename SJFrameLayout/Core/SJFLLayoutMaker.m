//
//  SJFLLayoutMaker.m
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "SJFLLayoutMaker.h"
#import <objc/message.h>
#import "UIView+SJFLLayoutAttributeUnits.h"
#import "UIView+SJFLLayoutElements.h"
#import "SJFLLayoutElement.h"
#import "SJFLLayoutAttributeUnit.h"

NS_ASSUME_NONNULL_BEGIN
#if 1
#ifdef DEBUG
#undef DEBUG
#endif
#endif

@interface SJFLLayoutMaker () {
    __weak UIView *_Nullable _view;
}
@end

@implementation SJFLLayoutMaker
- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if ( !self ) return nil;
    _view = view;
    SJFLRemoveObserverFromRelatedViews(view);
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
    NSMutableDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *m = SJFLCreateElementsForAttributeUnits(_view);
    SJFLAddFittingSizeUnitsIfNeeded(_view, m);
    _view.FL_elements = m;
    SJFLAddObserverToRelatedViews(_view);
    [_view FL_resetAttributeUnits];
    
#ifdef DEBUG
    for ( SJFLLayoutElement *ele in m ) {
        printf("\nElement: %s", ele.description.UTF8String);
    }
    printf("\n");
    printf("\n");
#endif
}

UIKIT_STATIC_INLINE
NSMutableDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *SJFLCreateElementsForAttributeUnits(UIView *view) {
    NSMutableDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *m = [NSMutableDictionary dictionary];
    SJFLLayoutAttributeUnit *_Nullable top = [view FL_attributeUnitForAttribute:SJFLLayoutAttributeTop];
    SJFLLayoutAttributeUnit *_Nullable left = [view FL_attributeUnitForAttribute:SJFLLayoutAttributeLeft];
    SJFLLayoutAttributeUnit *_Nullable bottom = [view FL_attributeUnitForAttribute:SJFLLayoutAttributeBottom];
    SJFLLayoutAttributeUnit *_Nullable right = [view FL_attributeUnitForAttribute:SJFLLayoutAttributeRight];
    SJFLLayoutAttributeUnit *_Nullable width = [view FL_attributeUnitForAttribute:SJFLLayoutAttributeWidth];
    SJFLLayoutAttributeUnit *_Nullable height = [view FL_attributeUnitForAttribute:SJFLLayoutAttributeHeight];
    SJFLLayoutAttributeUnit *_Nullable centerX = [view FL_attributeUnitForAttribute:SJFLLayoutAttributeCenterX];
    SJFLLayoutAttributeUnit *_Nullable centerY = [view FL_attributeUnitForAttribute:SJFLLayoutAttributeCenterY];
    
    if ( top ) m[SJFLLayoutAttributeKeyTop] = [[SJFLLayoutElement alloc] initWithTarget:top];
    if ( left ) m[SJFLLayoutAttributeKeyLeft] = [[SJFLLayoutElement alloc] initWithTarget:left];
    if ( bottom ) m[SJFLLayoutAttributeKeyBottom] = [[SJFLLayoutElement alloc] initWithTarget:bottom];
    if ( right ) m[SJFLLayoutAttributeKeyRight] = [[SJFLLayoutElement alloc] initWithTarget:right];
    if ( width ) m[SJFLLayoutAttributeKeyWidth] = [[SJFLLayoutElement alloc] initWithTarget:width];
    if ( height ) m[SJFLLayoutAttributeKeyHeight] = [[SJFLLayoutElement alloc] initWithTarget:height];
    if ( centerX ) m[SJFLLayoutAttributeKeyCenterX] = [[SJFLLayoutElement alloc] initWithTarget:centerX];
    if ( centerY ) m[SJFLLayoutAttributeKeyCenterY] = [[SJFLLayoutElement alloc] initWithTarget:centerY];
    return m;
}


UIKIT_STATIC_INLINE NSMutableDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *
SJFLAddFittingSizeUnitsIfNeeded(UIView *view, NSMutableDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *m) {
    SJFLLayoutElement *_Nullable top = m[SJFLLayoutAttributeKeyTop];
    SJFLLayoutElement *_Nullable bottom = m[SJFLLayoutAttributeKeyBottom];
    SJFLLayoutElement *_Nullable height = m[SJFLLayoutAttributeKeyHeight];

    SJFLLayoutElement *_Nullable left = m[SJFLLayoutAttributeKeyLeft];
    SJFLLayoutElement *_Nullable right = m[SJFLLayoutAttributeKeyRight];
    SJFLLayoutElement *_Nullable width = m[SJFLLayoutAttributeKeyWidth];
    
    // - FittingSize units
    
    if ( width != nil || (left != nil && right != nil) )
    { /* nothing */ }
    else {
        // no - width
        SJFLLayoutAttributeUnit *widthUnit = [[SJFLLayoutAttributeUnit alloc] initWithView:view attribute:SJFLLayoutAttributeWidth];
        widthUnit->priority = SJFLPriorityFittingSize;
        // Will be added when the view itself has no width condition
        m[SJFLLayoutAttributeKeyWidth] = [[SJFLLayoutElement alloc] initWithTarget:widthUnit];
    }

    if ( height != nil || (top != nil && bottom != nil) )
    { /* nothing */ }
    else {
        // no - height
        SJFLLayoutAttributeUnit *heightUnit = [[SJFLLayoutAttributeUnit alloc] initWithView:view attribute:SJFLLayoutAttributeHeight];
        heightUnit->priority = SJFLPriorityFittingSize;
        
        // Will be added when the view itself has no height condition
        m[SJFLLayoutAttributeKeyHeight] = [[SJFLLayoutElement alloc] initWithTarget:heightUnit];
    }
    return m;
}

// - update

- (void)update {
    NSMutableDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *m = _view.FL_elements?:@{}.mutableCopy;
    NSMutableDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *update = SJFLCreateElementsForAttributeUnits(_view);
    [m setDictionary:update];
    
    SJFLAddFittingSizeUnitsIfNeeded(_view, m);
    _view.FL_elements = m;
    SJFLAddObserverToRelatedViews(_view);
    SJFLRefreshLayoutsForRelatedView(_view);
    [_view FL_resetAttributeUnits];
}

UIKIT_STATIC_INLINE
void SJFLRemoveObserverFromRelatedViews(UIView *view) {
    [view FL_removeObserver:view];
    [view.superview FL_removeObserver:view];
    for ( UIView *dependecy in SJFLGetElementsRelatedViews([view FL_elements].allValues) ) {
        [dependecy FL_removeObserver:view];
    }
}

void SJFLAddObserverToRelatedViews(UIView *view) {
    [view FL_addObserver:view];
    [view.superview FL_addObserver:view];
    for ( UIView *dependency in SJFLGetElementsRelatedViews([view FL_elements].allValues) ) {
        [dependency FL_addObserver:view];
    }
}
@end
NS_ASSUME_NONNULL_END
