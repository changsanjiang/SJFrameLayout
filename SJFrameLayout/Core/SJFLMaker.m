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
    [view FL_resetAttributeUnits];
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
    NSMutableArray<SJFLLayoutElement *> *m = SJFLCreateElementsForAttributeUnits(_view);
    SJFLAddOrRemoveFittingSizeUnitsIfNeeded(_view, m);
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
    NSMutableArray<SJFLLayoutElement *> *m = SJFLCreateElementsForAttributeUnits(_view);
    for ( SJFLLayoutElement *ele in m ) {
        [_view FL_replaceElementForAttribute:ele.tar_attr withElement:ele];
    }
    NSMutableArray<SJFLLayoutElement *> *now = [[_view FL_elements]/* 上面的replace会创建此数组, 所以必定有值 */ mutableCopy];
    SJFLAddOrRemoveFittingSizeUnitsIfNeeded(_view, now);
    [_view FL_removeAllElements];
    [_view FL_addElementsFromArray:now];
    [_view FL_resetAttributeUnits];
    SJFLRefreshLayoutsForRelatedView(_view);
}

UIKIT_STATIC_INLINE NSMutableArray<SJFLLayoutElement *> *SJFLCreateElementsForAttributeUnits(UIView *view) {
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

UIKIT_STATIC_INLINE NSArray<SJFLLayoutElement *> *SJFLAddOrRemoveFittingSizeUnitsIfNeeded(UIView *view, NSMutableArray<SJFLLayoutElement *> *m) {
    SJFLLayoutElement *_Nullable top = SJFLGetElement(m, SJFLAttributeTop, 0);
    SJFLLayoutElement *_Nullable bottom = SJFLGetElement(m, SJFLAttributeBottom, 0);
    SJFLLayoutElement *_Nullable height = SJFLGetElement(m, SJFLAttributeHeight, 0);

    SJFLLayoutElement *_Nullable left = SJFLGetElement(m, SJFLAttributeLeft, 0);
    SJFLLayoutElement *_Nullable right = SJFLGetElement(m, SJFLAttributeRight, 0);
    SJFLLayoutElement *_Nullable width = SJFLGetElement(m, SJFLAttributeWidth, 0);
    
    // Added FittingSize units
    // required
    // optional
    if ( (width != nil) || (left != nil && right != nil) ) {
        NSInteger index = SJFLGetIndex(m, SJFLAttributeWidth, 1);
        if ( index != NSNotFound ) [m removeObjectAtIndex:index];
    }
    else {
        // no - width
        SJFLAttributeUnit *widthUnit = [[SJFLAttributeUnit alloc] initWithView:view attribute:SJFLAttributeWidth];
        widthUnit->priority = SJFLPriorityFittingSize;
        SJFLLayoutElement *widthElem = [[SJFLLayoutElement alloc] initWithTarget:widthUnit];
        [m addObject:widthElem]; // 当视图本身没有width条件时, 才会添加
    }

    // height
    if ( height != nil || (top != nil && bottom != nil) ) {
        NSInteger index = SJFLGetIndex(m, SJFLAttributeHeight, 1);
        if ( index != NSNotFound ) [m removeObjectAtIndex:index];
    }
    else {
        // no - height
        SJFLAttributeUnit *heightUnit = [[SJFLAttributeUnit alloc] initWithView:view attribute:SJFLAttributeHeight];
        heightUnit->priority = SJFLPriorityFittingSize;
        SJFLLayoutElement *heightElem = [[SJFLLayoutElement alloc] initWithTarget:heightUnit];
        [m addObject:heightElem]; // 当视图本身没有height条件时, 才会添加
    }
    
    return m;
}
@end
NS_ASSUME_NONNULL_END
