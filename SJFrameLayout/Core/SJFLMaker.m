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
#import "SJFLViewTreePlaceholder.h"

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
    if ( view.FL_elements != nil ) {    
        [view FL_resetAttributeUnits];
        view.FL_elements = nil;
    }
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
    _view.FL_needWidthToFit = SJFLViewLayoutNoWidth(_view);
    _view.FL_needHeightToFit = SJFLViewLayoutNoHeight(_view);
        
    NSMutableArray<SJFLLayoutElement *> *m = [NSMutableArray array];
    SJFLAttributeUnit *_Nullable top = [_view FL_attributeUnitForAttribute:SJFLAttributeTop];
    SJFLAttributeUnit *_Nullable left = [_view FL_attributeUnitForAttribute:SJFLAttributeLeft];
    SJFLAttributeUnit *_Nullable bottom = [_view FL_attributeUnitForAttribute:SJFLAttributeBottom];
    SJFLAttributeUnit *_Nullable right = [_view FL_attributeUnitForAttribute:SJFLAttributeRight];
    SJFLAttributeUnit *_Nullable width = [_view FL_attributeUnitForAttribute:SJFLAttributeWidth];
    SJFLAttributeUnit *_Nullable height = [_view FL_attributeUnitForAttribute:SJFLAttributeHeight];
    SJFLAttributeUnit *_Nullable centerX = [_view FL_attributeUnitForAttribute:SJFLAttributeCenterX];
    SJFLAttributeUnit *_Nullable centerY = [_view FL_attributeUnitForAttribute:SJFLAttributeCenterY];
    
    if ( top != nil ) [m addObject:[[SJFLLayoutElement alloc] initWithTarget:top]];
    if ( left != nil ) [m addObject:[[SJFLLayoutElement alloc] initWithTarget:left]];
    if ( bottom != nil ) [m addObject:[[SJFLLayoutElement alloc] initWithTarget:bottom]];
    if ( right != nil ) [m addObject:[[SJFLLayoutElement alloc] initWithTarget:right]];
    if ( width != nil ) [m addObject:[[SJFLLayoutElement alloc] initWithTarget:width]];
    if ( height != nil ) [m addObject:[[SJFLLayoutElement alloc] initWithTarget:height]];
    if ( centerX != nil ) [m addObject:[[SJFLLayoutElement alloc] initWithTarget:centerX]];
    if ( centerY != nil ) [m addObject:[[SJFLLayoutElement alloc] initWithTarget:centerY]];
    
    _view.FL_elements = m;
    
#ifdef DEBUG
    for ( SJFLLayoutElement *ele in m ) {
        printf("\nElement: %s", ele.description.UTF8String);
    }
    printf("\n");
    printf("\n");
#endif
}

UIKIT_STATIC_INLINE BOOL SJFLViewLayoutNoHeight(UIView *view) {
    SJFLAttributeUnit *_Nullable height = [view FL_attributeUnitForAttribute:SJFLAttributeHeight];
    SJFLAttributeUnit *_Nullable top = [view FL_attributeUnitForAttribute:SJFLAttributeTop];
    SJFLAttributeUnit *_Nullable bottom = [view FL_attributeUnitForAttribute:SJFLAttributeBottom];
    // vertical
    // - height
    // - top & bottom
    BOOL h = (height != nil) || (top != nil && bottom != nil);
    return !h;
}

UIKIT_STATIC_INLINE BOOL SJFLViewLayoutNoWidth(UIView *view) {
    SJFLAttributeUnit *_Nullable width = [view FL_attributeUnitForAttribute:SJFLAttributeWidth];
    SJFLAttributeUnit *_Nullable left = [view FL_attributeUnitForAttribute:SJFLAttributeLeft];
    SJFLAttributeUnit *_Nullable right = [view FL_attributeUnitForAttribute:SJFLAttributeRight];
    // horizontal
    // - width
    // - left & right
    BOOL v = (width != nil) || (left != nil && right != nil);
    return !v;
}

static CGFloat const SJFLViewPlacehoderLayoutWidth   = 1234;
static CGFloat const SJFLViewPlaceholdeLayoutrHeight = 1234;

UIKIT_STATIC_INLINE void SJFLViewSetPlaceholderLayoutIfNeeded(UIView *view) {
    if ( SJFLViewLayoutNoWidth(view) ) {
        view.FL_Width->offset_t = FL_CGFloatValue;
        view.FL_Width->offset.value = SJFLViewPlacehoderLayoutWidth;
    }
    
    if ( SJFLViewLayoutNoHeight(view) ) {
        view.FL_Height->offset_t = FL_CGFloatValue;
        view.FL_Height->offset.value = SJFLViewPlaceholdeLayoutrHeight;
    }
}
@end
NS_ASSUME_NONNULL_END
