//
//  SJFLViewTreePlaceholder.m
//  Pods
//
//  Created by 畅三江 on 2019/4/21.
//

#import "SJFLViewTreePlaceholder.h"
#import "UIView+SJFLAttributeUnits.h"
#import "UIView+SJFLPrivate.h"

NS_ASSUME_NONNULL_BEGIN
static CGFloat const SJFLViewPlacehoderLayoutWidth   = 1234;
static CGFloat const SJFLViewPlaceholdeLayoutrHeight = 1234;

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

UIKIT_STATIC_INLINE void _SJFLViewTreeSetPlaceholderLayoutIfNeeded(UIView *view) {
    for ( UIView *sub in view.subviews ) {
        SJFLViewSetPlaceholderLayoutIfNeeded(sub);
        _SJFLViewTreeSetPlaceholderLayoutIfNeeded(sub);
    }
}

void SJFLViewTreeSetPlaceholderLayoutIfNeeded(UIView *view) {
    SJFLViewSetPlaceholderLayoutIfNeeded(view);
    _SJFLViewTreeSetPlaceholderLayoutIfNeeded(view);
}

BOOL SJFLViewIsPlaceholderLayoutWidth(UIView *view) {
    return floor(view.frame.size.width) == SJFLViewPlacehoderLayoutWidth;
}

BOOL SJFLViewIsPlaceholderLayoutHeight(UIView *view) {
    return floor(view.frame.size.height) == SJFLViewPlaceholdeLayoutrHeight;
}
NS_ASSUME_NONNULL_END
