//
//  SJFLLayoutElement.m
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "SJFLLayoutElement.h"
#import <objc/message.h>
#import "UIView+SJFLLayoutAttributeUnits.h"
#import "UIView+SJFLViewFrameAttributes.h"
#import "UIView+SJFLLayoutElements.h"

NS_ASSUME_NONNULL_BEGIN
#if 1
#ifdef DEBUG
#undef DEBUG
#endif
#endif

@interface SJFLLayoutSetInfo : NSObject
- (void)set:(SJFLAttribute)attribute;
- (BOOL)get:(SJFLAttribute)attribute;
@end

@implementation SJFLLayoutSetInfo {
    struct {
        BOOL isSetNone :1;
        BOOL isSetTop :1;
        BOOL isSetLeft :1;
        BOOL isSetBottom :1;
        BOOL isSetRight :1;
        BOOL isSetWidth :1;
        BOOL isSetHeight :1;
        BOOL isSetCenterX :1;
        BOOL isSetCenterY :1;
    } info;
}

- (void)set:(SJFLAttribute)attribute {
    switch ( attribute ) {
        case SJFLAttributeNone:
            info.isSetNone = YES;
            break;
        case SJFLAttributeTop:
            info.isSetTop = YES;
            break;
        case SJFLAttributeLeft:
            info.isSetLeft = YES;
            break;
        case SJFLAttributeBottom:
            info.isSetBottom = YES;
            break;
        case SJFLAttributeRight:
            info.isSetRight = YES;
            break;
        case SJFLAttributeWidth:
            info.isSetWidth = YES;
            break;
        case SJFLAttributeHeight:
            info.isSetHeight = YES;
            break;
        case SJFLAttributeCenterX:
            info.isSetCenterX = YES;
            break;
        case SJFLAttributeCenterY:
            info.isSetCenterY = YES;
            break;
    }
}
- (BOOL)get:(SJFLAttribute)attribute {
    switch ( attribute ) {
        case SJFLAttributeNone:
            return info.isSetNone;
        case SJFLAttributeTop:
            return info.isSetTop;
        case SJFLAttributeLeft:
            return info.isSetLeft;
        case SJFLAttributeBottom:
            return info.isSetBottom;
        case SJFLAttributeRight:
            return info.isSetRight;
        case SJFLAttributeWidth:
            return info.isSetWidth;
        case SJFLAttributeHeight:
            return info.isSetHeight;
        case SJFLAttributeCenterX:
            return info.isSetCenterX;
        case SJFLAttributeCenterY:
            return info.isSetCenterY;
    }
    return NO;
}
@end

@interface UIView (SJFLLayoutSetInfo)
@property (nonatomic, strong, readonly) SJFLLayoutSetInfo *FL_info;
@end
@implementation UIView (SJFLLayoutSetInfo)
- (SJFLLayoutSetInfo *)FL_info {
    SJFLLayoutSetInfo *_Nullable info = objc_getAssociatedObject(self, _cmd);
    if ( !info ) {
        info = [SJFLLayoutSetInfo new];
        objc_setAssociatedObject(self, _cmd, info, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return info;
}
@end

@interface SJFLLayoutElement () {
    @public
    SJFLLayoutAttributeUnit *_target;
    __weak UIView *_Nullable _tar_superview;
    __weak UIView *_Nullable _tar_view;
    SJFLAttribute _tar_attr;
    SJFLAttributeKey _key_tar_attr;

    __weak UIView *_Nullable _dep_view;
    SJFLAttribute _dep_attr;
}
@property (nonatomic, readonly) CGFloat value;
@end

@implementation SJFLLayoutElement
- (instancetype)initWithTarget:(SJFLLayoutAttributeUnit *)target {
    self = [super init];
    if ( !self ) return nil;
    _target = target;
    _tar_view = target.view;
    _tar_superview = _tar_view.superview;
    _tar_attr = target.attribute;
    _key_tar_attr = SJFLAttributeKeyForAttribute(_tar_attr);
    
    SJFLViewFrameAttribute *_Nullable dependency = target.equalToViewAttribute;
    if ( !dependency ) {
        switch ( target.attribute ) {
            case SJFLAttributeNone:
            case SJFLAttributeWidth:
            case SJFLAttributeHeight:
                dependency = [[SJFLViewFrameAttribute alloc] initWithView:_tar_superview attribute:SJFLAttributeNone];
                break;
            case SJFLAttributeTop:
            case SJFLAttributeLeft:
            case SJFLAttributeBottom:
            case SJFLAttributeRight:
            case SJFLAttributeCenterX:
            case SJFLAttributeCenterY: {
                dependency = [_tar_superview viewLayoutForAttribute:_tar_attr];
            }
                break;
        }
        [target equalTo:dependency];
    }
    _dep_view = dependency.view;
    _dep_attr = dependency.attribute;
    return self;
}
#ifdef DEBUG
- (NSString *)description {
    return [NSString stringWithFormat:@"[_tar_view:%p,\t _tar_attr:%s,\t _dep_view:%p,\t _dep_attr:%s,\t _priority:%d]", _tar_view, [SJFLLayoutAttributeUnit debug_attributeToString:_tar_attr].UTF8String, _dep_view, [SJFLLayoutAttributeUnit debug_attributeToString:_dep_attr].UTF8String, _target->priority];
}
#endif

- (UIView *_Nullable)tar_superview {
    return _tar_superview;
}

- (SJFLAttribute)tar_attr {
    return _tar_attr;
}

- (UIView *_Nullable)dep_view {
    return _dep_view;
}

- (void)refreshLayoutIfNeeded {
    if ( !_dep_view || !_tar_view )
        return;
    [self installValueToTargetIfNeeded];
}

- (void)installValueToTargetIfNeeded {
    UIView *_Nullable view = _tar_view;
    if ( !view ) {
        return;
    }
    
    if ( !SJFLViewAttributeCanSettable(view, _tar_attr) ) {
        return;
    }

    CGFloat newValue = self.value;
    
    SJFLLayoutSetInfo *info = [view FL_info];
    if ( [info get:_tar_attr] && SJFLViewLayoutCompare(view, _tar_attr, newValue) ) {
        SJFLViewUpdateRelatedLayoutIfNeeded(view, _tar_attr);
        return;
    }
    
    switch ( _tar_attr ) {
        case SJFLAttributeNone: break; ///< Target does not need to do anything
        case SJFLAttributeTop:
            SJFLViewSetY(view, newValue);
            break;
        case SJFLAttributeLeft:
            SJFLViewSetX(view, newValue);
            break;
        case SJFLAttributeBottom:
            SJFLViewSetBottom(view, newValue);
            break;
        case SJFLAttributeRight:
            SJFLViewSetRight(view, newValue);
            break;
        case SJFLAttributeWidth:
            SJFLViewSetWidth(view, newValue);
            break;
        case SJFLAttributeHeight:
            SJFLViewSetHeight(view, newValue);
            break;
        case SJFLAttributeCenterX:
            SJFLViewSetCenterX(view, newValue);
            break;
        case SJFLAttributeCenterY:
            SJFLViewSetCenterY(view, newValue);
            break;
    }
    
#ifdef DEBUG
    printf("\n_tar_view:[%s]", _tar_view.description.UTF8String);
    printf("\n_tar_attr:[%s]", [SJFLLayoutAttributeUnit debug_attributeToString:_tar_attr].UTF8String);
    printf("\n_dep_view:[%s]", _dep_view.description.UTF8String);
    printf("\n_dep_attr:[%s]", [SJFLLayoutAttributeUnit debug_attributeToString:_dep_attr].UTF8String);
    printf("\n");
    printf("\n");
#endif
    
    SJFLViewUpdateRelatedLayoutIfNeeded(view, _tar_attr);
}

// value = dependency_value * multiplier + offset
- (CGFloat)value {
    CGFloat offset = _target.offset;
    CGFloat value = 0;
    SJFLAttribute dep_attr = _dep_attr;
    if ( dep_attr != SJFLAttributeNone ) {
        SJFLAttribute tar_attr = _tar_attr;
        UIView *dep_view = _dep_view;
        UIView *tar_view = _tar_view;
        CGRect dep_frame = dep_view.frame;
        if ( tar_attr == SJFLAttributeWidth || tar_attr == SJFLAttributeHeight ) {
            switch ( dep_attr ) {
                default: break;
                case SJFLAttributeWidth: {
                    value = CGRectGetWidth(dep_frame);
                }
                    break;
                case SJFLAttributeHeight: {
                    value = CGRectGetHeight(dep_frame);
                }
                    break;
            }
        }
        else {
            /**
             horizontal: left, width, right, centerX
             vertical: top, height, bottom, centerY
             
             top=> top, bottom, centerY
             bottom=> top, bottom, centerY
             centerY=> top, bottom, centerY
             
             left=> left, right, centerX
             right=> left, right, centerX
             centerX=> left, right, centerX
             */
            
            CGPoint point = CGPointZero;
            if ( SJFLVerticalLayoutContains(tar_attr) ) {
                switch ( dep_attr ) {
                    case SJFLAttributeTop:
                        point = CGPointZero;
                        break;
                    case SJFLAttributeCenterY:
                        point = CGPointMake(0, CGRectGetHeight(dep_frame) * 0.5);
                        break;
                    case SJFLAttributeBottom:
                        point = CGPointMake(0, CGRectGetHeight(dep_frame));
                        break;
                    default:break;
                }
                
                value = [dep_view convertPoint:point toView:tar_view.superview].y;
            }
            else {
                switch ( dep_attr ) {
                    case SJFLAttributeLeft:
                        point = CGPointZero;
                        break;
                    case SJFLAttributeCenterX:
                        point = CGPointMake(CGRectGetWidth(dep_frame) * 0.5, 0);
                        break;
                    case SJFLAttributeRight:
                        point = CGPointMake(CGRectGetWidth(dep_frame), 0);
                        break;
                    default:break;
                }
                value = [dep_view convertPoint:point toView:tar_view.superview].x;
            }
        }
    }
    // else {  /* none, do nothing */ }
    
    return ceil(value * _target->multiplier + offset);
}

// - update -

UIKIT_STATIC_INLINE void SJFLViewUpdateRelatedLayoutIfNeeded(UIView *view, SJFLAttribute attr) {
    NSDictionary<SJFLAttributeKey, SJFLLayoutElement *> *m = [view FL_elements];
    switch ( attr ) {
        case SJFLAttributeNone:
            break;
        case SJFLAttributeTop: {
            // update bottom layout
            [m[SJFLAttributeKeyBottom] refreshLayoutIfNeeded];
        }
            break;
        case SJFLAttributeLeft: {
            // update right layout
            [m[SJFLAttributeKeyRight] refreshLayoutIfNeeded];
        }
            break;
        case SJFLAttributeBottom:
            break;
        case SJFLAttributeRight:
            break;
        case SJFLAttributeWidth: {
            [m[SJFLAttributeKeyLeft] refreshLayoutIfNeeded];
            [m[SJFLAttributeKeyCenterX] refreshLayoutIfNeeded];
            [m[SJFLAttributeKeyRight] refreshLayoutIfNeeded];
        }
            break;
        case SJFLAttributeHeight: {
            [m[SJFLAttributeKeyTop] refreshLayoutIfNeeded];
            [m[SJFLAttributeKeyCenterY] refreshLayoutIfNeeded];
            [m[SJFLAttributeKeyBottom] refreshLayoutIfNeeded];
        }
            break;
        case SJFLAttributeCenterX:
            break;
        case SJFLAttributeCenterY:
            break;
    }
}

// - getter -

//UIKIT_STATIC_INLINE BOOL SJFLHorizontalLayoutContains(SJFLAttribute attr) {
//// horizontal: left, width, right, centerX
//    return (attr == SJFLAttributeLeft) || (attr == SJFLAttributeWidth) || (attr == SJFLAttributeRight) || (attr == SJFLAttributeCenterX);
//}

UIKIT_STATIC_INLINE BOOL SJFLVerticalLayoutContains(SJFLAttribute attr) {
// vertical: top, height, bottom, centerY
    return (attr == SJFLAttributeTop) || (attr == SJFLAttributeBottom) || (attr == SJFLAttributeHeight) || (attr == SJFLAttributeCenterY);
}

UIKIT_STATIC_INLINE BOOL SJFLFloatCompare(CGFloat value1, CGFloat value2) {
    return floor(value1 + 0.5) == floor(value2 + 0.5);
}

UIKIT_STATIC_INLINE BOOL SJFLViewLayoutCompare(UIView *view, SJFLAttribute attr, CGFloat value) {
    CGRect frame = view.frame;
    switch ( attr ) {
        case SJFLAttributeNone:
            return NO;
        case SJFLAttributeTop:
            return SJFLFloatCompare(value, CGRectGetMinY(frame));
        case SJFLAttributeLeft:
            return SJFLFloatCompare(value, CGRectGetMinX(frame));
        case SJFLAttributeBottom:
            return SJFLFloatCompare(value, CGRectGetMaxY(frame));
        case SJFLAttributeRight:
            return SJFLFloatCompare(value, CGRectGetMaxX(frame));
        case SJFLAttributeWidth:
            return SJFLFloatCompare(value, CGRectGetWidth(frame));
        case SJFLAttributeHeight:
            return SJFLFloatCompare(value, CGRectGetHeight(frame));
        case SJFLAttributeCenterX:
            return SJFLFloatCompare(value, CGRectGetWidth(frame) * 0.5 + CGRectGetMinX(frame));
        case SJFLAttributeCenterY:
            return SJFLFloatCompare(value, CGRectGetHeight(frame) * 0.5 + CGRectGetMinY(frame));
            break;
    }
}

UIKIT_STATIC_INLINE BOOL SJFLViewAttributeCanSettable(UIView *view, SJFLAttribute attr) {
    switch ( attr ) {
        case SJFLAttributeNone:
        case SJFLAttributeWidth:
        case SJFLAttributeHeight:
            return YES;
        case SJFLAttributeTop:
            return SJFLViewTopCanSettable(view);
        case SJFLAttributeLeft:
            return SJFLViewLeftCanSettable(view);
        case SJFLAttributeBottom:
            return SJFLViewBottomCanSettable(view);
        case SJFLAttributeRight:
            return SJFLViewRightCanSettable(view);
        case SJFLAttributeCenterX:
            return SJFLViewCenterXCanSettable(view);
        case SJFLAttributeCenterY:
            return SJFLViewCenterYCanSettable(view);
    }
    return NO;
}

UIKIT_STATIC_INLINE BOOL SJFLViewCenterXCanSettable(UIView *view) {
    SJFLLayoutSetInfo *info = view.FL_info;
    return [info get:SJFLAttributeWidth] || [info get:SJFLAttributeTop] || [info get:SJFLAttributeBottom];
}

UIKIT_STATIC_INLINE BOOL SJFLViewCenterYCanSettable(UIView *view) {
    SJFLLayoutSetInfo *info = view.FL_info;
    return [info get:SJFLAttributeHeight] || [info get:SJFLAttributeLeft] || [info get:SJFLAttributeRight];
}

UIKIT_STATIC_INLINE BOOL SJFLViewBottomCanSettable(UIView *view) {
    NSDictionary<SJFLAttributeKey, SJFLLayoutElement *> *m = [view FL_elements];
    SJFLLayoutElement *_Nullable top = m[SJFLAttributeKeyTop];
    SJFLLayoutElement *_Nullable height = m[SJFLAttributeKeyHeight];
    if ( top != nil  && height != nil ) return NO;
    SJFLLayoutSetInfo *info = view.FL_info;
    return [info get:SJFLAttributeTop] || [info get:SJFLAttributeHeight];
}

UIKIT_STATIC_INLINE BOOL SJFLViewRightCanSettable(UIView *view) {
    NSDictionary<SJFLAttributeKey, SJFLLayoutElement *> *m = [view FL_elements];
    SJFLLayoutElement *_Nullable left = m[SJFLAttributeKeyLeft];
    SJFLLayoutElement *_Nullable width = m[SJFLAttributeKeyWidth];
    if ( left != nil  && width != nil ) return NO;
    SJFLLayoutSetInfo *info = view.FL_info;
    return [info get:SJFLAttributeLeft] || [info get:SJFLAttributeWidth];
}

UIKIT_STATIC_INLINE BOOL SJFLViewTopCanSettable(UIView *view) {
    SJFLLayoutElement *_Nullable height = view.FL_elements[SJFLAttributeKeyHeight];
    if ( height ) {
        SJFLLayoutSetInfo *info = view.FL_info;
        return [info get:SJFLAttributeHeight];
    }
    return YES;
}

UIKIT_STATIC_INLINE BOOL SJFLViewLeftCanSettable(UIView *view) {
    SJFLLayoutElement *_Nullable width = view.FL_elements[SJFLAttributeKeyWidth];
    if ( width ) {
        SJFLLayoutSetInfo *info = view.FL_info;
        return [info get:SJFLAttributeWidth];
    }
    return YES;
}

// - setter -

UIKIT_STATIC_INLINE void SJFLViewSetX(UIView *view, CGFloat x) {
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
    [view.FL_info set:SJFLAttributeLeft];
}

UIKIT_STATIC_INLINE void SJFLViewSetY(UIView *view, CGFloat y) {
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
    [view.FL_info set:SJFLAttributeTop];
}

UIKIT_STATIC_INLINE void SJFLViewSetWidth(UIView *view, CGFloat width) {
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
    [view.FL_info set:SJFLAttributeWidth];
}

UIKIT_STATIC_INLINE void SJFLViewSetHeight(UIView *view, CGFloat height) {
    CGRect frame = view.frame;
    frame.size.height = height;
    view.frame = frame;
    [view.FL_info set:SJFLAttributeHeight];
}

UIKIT_STATIC_INLINE void SJFLViewSetCenterX(UIView *view, CGFloat centerX) {
    CGPoint center = view.center;
    center.x = centerX;
    view.center = center;
    [view.FL_info set:SJFLAttributeCenterX];
}

UIKIT_STATIC_INLINE void SJFLViewSetCenterY(UIView *view, CGFloat centerY) {
    CGPoint center = view.center;
    center.y = centerY;
    view.center = center;
    [view.FL_info set:SJFLAttributeCenterY];
}

// set maxY
UIKIT_STATIC_INLINE void SJFLViewSetBottom(UIView *view, CGFloat bottom) {
    NSDictionary<SJFLAttributeKey, SJFLLayoutElement *> *m = [view FL_elements];
    SJFLLayoutElement *_Nullable heightElement = m[SJFLAttributeKeyHeight];
    if ( !heightElement ) {
        // top + height = bottom
        // height = bottom - top
        CGRect frame = view.frame;
        frame.size.height = bottom - CGRectGetMinY(frame);
        if ( frame.size.height < 0 ) frame.size.height = 0;
        view.frame = frame;
    }
    else {
        // top + height = bottom
        // top = bottom - height
        CGRect frame = view.frame;
        frame.origin.y = bottom - CGRectGetHeight(frame);
        view.frame = frame;
    }
    [view.FL_info set:SJFLAttributeBottom];
}

// set maxX
UIKIT_STATIC_INLINE void SJFLViewSetRight(UIView *view, CGFloat right) {
    NSDictionary<SJFLAttributeKey, SJFLLayoutElement *> *m = [view FL_elements];
    SJFLLayoutElement *_Nullable widthElement = m[SJFLAttributeKeyWidth];
    
    if ( !widthElement ) {
        // left + width = right
        // width = right - left
        CGRect frame = view.frame;
        frame.size.width = right - CGRectGetMinX(frame);
        if ( frame.size.width < 0 ) frame.size.width = 0;
        view.frame = frame;
    }
    else {
        // left + width = right
        // left = right - width
        CGRect frame = view.frame;
        frame.origin.x = right - CGRectGetWidth(frame);
        view.frame = frame;
    }
    [view.FL_info set:SJFLAttributeRight];
}
@end
NS_ASSUME_NONNULL_END
