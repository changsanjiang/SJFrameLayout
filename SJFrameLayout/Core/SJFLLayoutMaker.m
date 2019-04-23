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
    NSMutableDictionary<SJFLAttributeKey, SJFLLayoutElement *> *m = SJFLCreateElementsForAttributeUnits(_view);
    SJFLAddOrRemoveFittingSizeUnitsIfNeeded(_view, m);
    _view.FL_elements = m;
    [_view FL_resetAttributeUnits];
    SJFLAddObserverToRelatedViews(_view);
    
#ifdef DEBUG
    for ( SJFLLayoutElement *ele in m ) {
        printf("\nElement: %s", ele.description.UTF8String);
    }
    printf("\n");
    printf("\n");
#endif
}

UIKIT_STATIC_INLINE
NSMutableDictionary<SJFLAttributeKey, SJFLLayoutElement *> *SJFLCreateElementsForAttributeUnits(UIView *view) {
    NSMutableDictionary<SJFLAttributeKey, SJFLLayoutElement *> *m = [NSMutableDictionary dictionary];
    SJFLLayoutAttributeUnit *_Nullable top = [view FL_attributeUnitForAttribute:SJFLAttributeTop];
    SJFLLayoutAttributeUnit *_Nullable left = [view FL_attributeUnitForAttribute:SJFLAttributeLeft];
    SJFLLayoutAttributeUnit *_Nullable bottom = [view FL_attributeUnitForAttribute:SJFLAttributeBottom];
    SJFLLayoutAttributeUnit *_Nullable right = [view FL_attributeUnitForAttribute:SJFLAttributeRight];
    SJFLLayoutAttributeUnit *_Nullable width = [view FL_attributeUnitForAttribute:SJFLAttributeWidth];
    SJFLLayoutAttributeUnit *_Nullable height = [view FL_attributeUnitForAttribute:SJFLAttributeHeight];
    SJFLLayoutAttributeUnit *_Nullable centerX = [view FL_attributeUnitForAttribute:SJFLAttributeCenterX];
    SJFLLayoutAttributeUnit *_Nullable centerY = [view FL_attributeUnitForAttribute:SJFLAttributeCenterY];
    
    if ( top ) m[SJFLAttributeKeyForAttribute(SJFLAttributeTop)] = [[SJFLLayoutElement alloc] initWithTarget:top];
    if ( left ) m[SJFLAttributeKeyForAttribute(SJFLAttributeLeft)] = [[SJFLLayoutElement alloc] initWithTarget:left];
    if ( bottom ) m[SJFLAttributeKeyForAttribute(SJFLAttributeBottom)] = [[SJFLLayoutElement alloc] initWithTarget:bottom];
    if ( right ) m[SJFLAttributeKeyForAttribute(SJFLAttributeRight)] = [[SJFLLayoutElement alloc] initWithTarget:right];
    if ( width ) m[SJFLAttributeKeyForAttribute(SJFLAttributeWidth)] = [[SJFLLayoutElement alloc] initWithTarget:width];
    if ( height ) m[SJFLAttributeKeyForAttribute(SJFLAttributeHeight)] = [[SJFLLayoutElement alloc] initWithTarget:height];
    if ( centerX ) m[SJFLAttributeKeyForAttribute(SJFLAttributeCenterX)] = [[SJFLLayoutElement alloc] initWithTarget:centerX];
    if ( centerY ) m[SJFLAttributeKeyForAttribute(SJFLAttributeCenterY)] = [[SJFLLayoutElement alloc] initWithTarget:centerY];
    return m;
}


UIKIT_STATIC_INLINE NSMutableDictionary<SJFLAttributeKey, SJFLLayoutElement *> *
SJFLAddOrRemoveFittingSizeUnitsIfNeeded(UIView *view, NSMutableDictionary<SJFLAttributeKey, SJFLLayoutElement *> *m) {
    SJFLLayoutElement *_Nullable top = m[SJFLAttributeKeyTop];
    SJFLLayoutElement *_Nullable bottom = m[SJFLAttributeKeyBottom];
    SJFLLayoutElement *_Nullable height = m[SJFLAttributeKeyHeight];

    SJFLLayoutElement *_Nullable left = m[SJFLAttributeKeyLeft];
    SJFLLayoutElement *_Nullable right = m[SJFLAttributeKeyRight];
    SJFLLayoutElement *_Nullable width = m[SJFLAttributeKeyWidth];
    
    // - FittingSize units
    
    if ( width != nil || (left != nil && right != nil) )
    { /* nothing */ }
    else {
        // no - width
        SJFLLayoutAttributeUnit *widthUnit = [[SJFLLayoutAttributeUnit alloc] initWithView:view attribute:SJFLAttributeWidth];
        widthUnit->priority = SJFLPriorityFittingSize;
        // Will be added when the view itself has no width condition
        m[SJFLAttributeKeyWidth] = [[SJFLLayoutElement alloc] initWithTarget:widthUnit];
    }

    if ( height != nil || (top != nil && bottom != nil) )
    { /* nothing */ }
    else {
        // no - width
        SJFLLayoutAttributeUnit *heightUnit = [[SJFLLayoutAttributeUnit alloc] initWithView:view attribute:SJFLAttributeHeight];
        heightUnit->priority = SJFLPriorityFittingSize;
        
        // Will be added when the view itself has no height condition
        m[SJFLAttributeKeyHeight] = [[SJFLLayoutElement alloc] initWithTarget:heightUnit];
    }
    return m;
}

// - update

- (void)update {
    NSMutableDictionary<SJFLAttributeKey, SJFLLayoutElement *> *m = _view.FL_elements?:@{}.mutableCopy;
    NSMutableDictionary<SJFLAttributeKey, SJFLLayoutElement *> *update = SJFLCreateElementsForAttributeUnits(_view);
    [m setDictionary:update];
    
    SJFLAddOrRemoveFittingSizeUnitsIfNeeded(_view, m);
    _view.FL_elements = m;
    [_view FL_resetAttributeUnits];
    SJFLAddObserverToRelatedViews(_view);
    SJFLRefreshLayoutsForRelatedView(_view);
}

UIKIT_STATIC_INLINE
void SJFLRemoveObserverFromRelatedViews(UIView *view) {
    [view.superview FL_removeObserver:view];
    for ( UIView *dependecy in SJFLGetElementsRelatedViews([view FL_elements].allValues) ) {
        [dependecy FL_removeObserver:view];
    }
}

void SJFLAddObserverToRelatedViews(UIView *view) {
    [view.superview FL_addObserver:view];
    for ( UIView *dependency in SJFLGetElementsRelatedViews([view FL_elements].allValues) ) {
        [dependency FL_addObserver:view];
    }
}
@end
NS_ASSUME_NONNULL_END
