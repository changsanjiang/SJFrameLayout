//
//  SJFLLayoutElement.m
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "SJFLLayoutElement.h"
#import <objc/message.h>
#import "UIView+SJFLLayoutAttributeUnits.h"
#import "UIView+SJFLFrameAttributeUnits.h"
#import "UIView+SJFLLayoutElements.h"

NS_ASSUME_NONNULL_BEGIN
#if 1
#ifdef DEBUG
#undef DEBUG
#endif
#endif

@interface SJFLLayoutSetInfo : NSObject
- (void)set:(SJFLLayoutAttribute)attribute;
- (BOOL)get:(SJFLLayoutAttribute)attribute;
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

- (void)set:(SJFLLayoutAttribute)attribute {
    switch ( attribute ) {
        case SJFLLayoutAttributeNone:
            info.isSetNone = YES;
            break;
        case SJFLLayoutAttributeTop:
            info.isSetTop = YES;
            break;
        case SJFLLayoutAttributeLeft:
            info.isSetLeft = YES;
            break;
        case SJFLLayoutAttributeBottom:
            info.isSetBottom = YES;
            break;
        case SJFLLayoutAttributeRight:
            info.isSetRight = YES;
            break;
        case SJFLLayoutAttributeWidth:
            info.isSetWidth = YES;
            break;
        case SJFLLayoutAttributeHeight:
            info.isSetHeight = YES;
            break;
        case SJFLLayoutAttributeCenterX:
            info.isSetCenterX = YES;
            break;
        case SJFLLayoutAttributeCenterY:
            info.isSetCenterY = YES;
            break;
    }
}
- (BOOL)get:(SJFLLayoutAttribute)attribute {
    switch ( attribute ) {
        case SJFLLayoutAttributeNone:
            return info.isSetNone;
        case SJFLLayoutAttributeTop:
            return info.isSetTop;
        case SJFLLayoutAttributeLeft:
            return info.isSetLeft;
        case SJFLLayoutAttributeBottom:
            return info.isSetBottom;
        case SJFLLayoutAttributeRight:
            return info.isSetRight;
        case SJFLLayoutAttributeWidth:
            return info.isSetWidth;
        case SJFLLayoutAttributeHeight:
            return info.isSetHeight;
        case SJFLLayoutAttributeCenterX:
            return info.isSetCenterX;
        case SJFLLayoutAttributeCenterY:
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
    SJFLLayoutAttribute _tar_attr;

    __weak UIView *_Nullable _dep_view;
    SJFLFrameAttribute _dep_attr;
}
@property (nonatomic, readonly) CGFloat value;
@end

@implementation SJFLLayoutElement
- (instancetype)initWithTarget:(SJFLLayoutAttributeUnit *)target {
    return [self initWithTarget:target superview:nil];
}

- (instancetype)initWithTarget:(SJFLLayoutAttributeUnit *)target superview:(nullable UIView *)superview {
    self = [super init];
    if ( !self ) return nil;
    _target = target;
    _tar_view = target.view;
    _tar_superview = superview?:_tar_view.superview;
    _tar_attr = target.attribute;
    
    SJFLFrameAttributeUnit *_Nullable dependency = target.equalToViewAttribute;
    if ( !dependency ) {
        switch ( target.attribute ) {
            case SJFLLayoutAttributeNone:
            case SJFLLayoutAttributeWidth:
            case SJFLLayoutAttributeHeight:
                dependency = [[SJFLFrameAttributeUnit alloc] initWithView:_tar_superview attribute:SJFLFrameAttributeNone];
                break;
            case SJFLLayoutAttributeTop:
            case SJFLLayoutAttributeLeft:
            case SJFLLayoutAttributeBottom:
            case SJFLLayoutAttributeRight:
            case SJFLLayoutAttributeCenterX:
            case SJFLLayoutAttributeCenterY: {
                dependency = SJFLFrameAtrributeUnitForAttribute(_tar_superview, (SJFLFrameAttribute)_tar_attr);
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

- (SJFLLayoutAttribute)tar_attr {
    return _tar_attr;
}

- (UIView *_Nullable)dep_view {
    return _dep_view;
}

- (void)refreshLayoutIfNeeded {
    UIView *_Nullable view = _tar_view;
    if ( !view ) {
        return;
    }
    
    SJFLLayoutAttribute tar_attr = _tar_attr;
    
    if ( !SJFLViewAttributeCanSettable(view, tar_attr) ) {
        return;
    }
    
    CGFloat newValue = self.value;
    
    SJFLLayoutSetInfo *info = [view FL_info];
    if ( [info get:tar_attr] && SJFLViewLayoutCompare(view, tar_attr, newValue) ) {
//        SJFLViewUpdateRelatedLayoutIfNeeded(view, tar_attr);
        return;
    }
    
    switch ( tar_attr ) {
        case SJFLLayoutAttributeNone: break; ///< Target does not need to do anything
        case SJFLLayoutAttributeTop:
            SJFLViewSetY(view, newValue);
            break;
        case SJFLLayoutAttributeLeft:
            SJFLViewSetX(view, newValue);
            break;
        case SJFLLayoutAttributeBottom:
            SJFLViewSetBottom(view, newValue);
            break;
        case SJFLLayoutAttributeRight:
            SJFLViewSetRight(view, newValue);
            break;
        case SJFLLayoutAttributeWidth:
            SJFLViewSetWidth(view, newValue);
            break;
        case SJFLLayoutAttributeHeight:
            SJFLViewSetHeight(view, newValue);
            break;
        case SJFLLayoutAttributeCenterX:
            SJFLViewSetCenterX(view, newValue);
            break;
        case SJFLLayoutAttributeCenterY:
            SJFLViewSetCenterY(view, newValue);
            break;
    }
    
#ifdef DEBUG
    printf("\n_tar_view:[%s]", _tar_view.description.UTF8String);
    printf("\n_tar_attr:[%s]", [SJFLLayoutAttributeUnit debug_attributeToString:tar_attr].UTF8String);
    printf("\n_dep_view:[%s]", _dep_view.description.UTF8String);
    printf("\n_dep_attr:[%s]", [SJFLLayoutAttributeUnit debug_attributeToString:_dep_attr].UTF8String);
    printf("\n");
    printf("\n");
#endif
    
    SJFLViewUpdateRelatedLayoutIfNeeded(view, tar_attr);
}

// value = dependency_value * multiplier + offset
- (CGFloat)value {
    CGFloat offset = self.offset;
    CGFloat value = 0;
    SJFLFrameAttribute dep_attr = _dep_attr;
    if ( dep_attr != SJFLFrameAttributeNone ) {
        SJFLLayoutAttribute tar_attr = _tar_attr;
        UIView *dep_view = _dep_view;
        CGRect dep_frame = dep_view.frame;
        if ( tar_attr == SJFLLayoutAttributeWidth || tar_attr == SJFLLayoutAttributeHeight ) {
            switch ( dep_attr ) {
                default: break;
                case SJFLLayoutAttributeWidth: {
                    value = CGRectGetWidth(dep_frame);
                }
                    break;
                case SJFLLayoutAttributeHeight: {
                    value = CGRectGetHeight(dep_frame);
                }
                    break;
            }
        }
        else {
            /**
             horizontal: left, width, right, centerX
             vertical: top, height, bottom, centerY
             
             top=> top, safeTop, bottom, safeBottom, centerY
             bottom=> top, safeTop, bottom, safeBottom, centerY
             centerY=> top, safeTop, bottom, safeBottom, centerY
             
             left=> left, safeLeft, right, safeRight, centerX
             right=> left, safeLeft, right, safeRight, centerX
             centerX=> left, safeLeft, right, safeRight, centerX
             */
            
            UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
            if (@available(iOS 11.0, *)) {
                safeAreaInsets = dep_view.safeAreaInsets;
            }
            UIView *tar_superview = _tar_superview;
            CGPoint point = CGPointZero;
            if ( SJFLVerticalLayoutContains(tar_attr) ) {
                switch ( dep_attr ) {
                    case SJFLFrameAttributeTop:
                        point = CGPointZero;
                        break;
                    case SJFLFrameAttributeSafeTop:
                        point = CGPointMake(0, safeAreaInsets.top);
                        break;
                    case SJFLLayoutAttributeCenterY:
                        point = CGPointMake(0, CGRectGetHeight(dep_frame) * 0.5);
                        break;
                    case SJFLLayoutAttributeBottom:
                        point = CGPointMake(0, CGRectGetHeight(dep_frame));
                        break;
                    case SJFLFrameAttributeSafeBottom:
                        point = CGPointMake(0, CGRectGetHeight(dep_frame) - safeAreaInsets.bottom);
                        break;
                    default:break;
                }
                
                value = [dep_view convertPoint:point toView:tar_superview].y;
            }
            else {
                switch ( dep_attr ) {
                    case SJFLLayoutAttributeLeft:
                        point = CGPointZero;
                        break;
                    case SJFLFrameAttributeSafeLeft:
                        point = CGPointMake(safeAreaInsets.left, 0);
                        break;
                    case SJFLLayoutAttributeCenterX:
                        point = CGPointMake(CGRectGetWidth(dep_frame) * 0.5, 0);
                        break;
                    case SJFLLayoutAttributeRight:
                        point = CGPointMake(CGRectGetWidth(dep_frame), 0);
                        break;
                    case SJFLFrameAttributeSafeRight:
                        point = CGPointMake(CGRectGetWidth(dep_frame) - safeAreaInsets.right, 0);
                        break;
                    default:break;
                }
                value = [dep_view convertPoint:point toView:tar_superview].x;
            }
        }
    }
    // else {  /* none, do nothing */ }
    
    return ceil(value * _target->multiplier + offset);
}

- (CGFloat)offset {
    if      ( _target->offset_t == SJFLCGFloatValue )
        return _target->offset.value;
    else if ( _dep_attr == SJFLFrameAttributeNone ) {
        if ( _target->offset_t == SJFLCGSizeValue ) {
            switch ( _tar_attr ) {
                case SJFLLayoutAttributeWidth:
                    return _target->offset.size.width;
                case SJFLLayoutAttributeHeight:
                    return _target->offset.size.height;
                default:
                    return 0;
            }
        }
    }
    else {
        switch ( _target->offset_t ) {
            case SJFLCGFloatValue:
                return _target->offset.value;
            case SJFLCGPointValue: {
                if ( _dep_attr == SJFLFrameAttributeTop || _dep_attr == SJFLFrameAttributeBottom )
                    return _target->offset.point.y;
                if ( _dep_attr == SJFLFrameAttributeLeft || _dep_attr == SJFLFrameAttributeRight )
                    return _target->offset.point.x;
            }
                break;
            case SJFLCGSizeValue: {
                if ( _dep_attr == SJFLFrameAttributeWidth )
                    return _target->offset.size.width;
                if ( _dep_attr == SJFLFrameAttributeHeight )
                    return _target->offset.size.height;
            }
                break;
            case SJFLUIEdgeInsetsValue: {
                if ( _dep_attr == SJFLFrameAttributeTop )
                    return _target->offset.edges.top;
                if ( _dep_attr == SJFLFrameAttributeLeft )
                    return _target->offset.edges.left;
                if ( _dep_attr == SJFLFrameAttributeBottom )
                    return -_target->offset.edges.bottom;
                if ( _dep_attr == SJFLFrameAttributeRight )
                    return -_target->offset.edges.right;
            }
                break;
        }
    }
    return 0;
}

// - update -

UIKIT_STATIC_INLINE void
SJFLViewUpdateRelatedLayoutIfNeeded(UIView *view, SJFLLayoutAttribute attr) {
    NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *m = SJFLElements(view);
    switch ( attr ) {
        case SJFLLayoutAttributeNone:
            break;
        case SJFLLayoutAttributeWidth: {
            if ( !SJFLFloatCompare(0, CGRectGetWidth(view.frame)) ) {
                [m[SJFLLayoutAttributeKeyLeft] refreshLayoutIfNeeded];
                [m[SJFLLayoutAttributeKeyCenterX] refreshLayoutIfNeeded];
                [m[SJFLLayoutAttributeKeyRight] refreshLayoutIfNeeded];
                [m[SJFLLayoutAttributeKeyHeight] refreshLayoutIfNeeded];
            }
        }
            break;
        case SJFLLayoutAttributeHeight: {
            if ( !SJFLFloatCompare(0, CGRectGetHeight(view.frame)) ) {
                [m[SJFLLayoutAttributeKeyTop] refreshLayoutIfNeeded];
                [m[SJFLLayoutAttributeKeyCenterY] refreshLayoutIfNeeded];
                [m[SJFLLayoutAttributeKeyBottom] refreshLayoutIfNeeded];
                [m[SJFLLayoutAttributeKeyWidth] refreshLayoutIfNeeded];
            }
        }
            break;
        case SJFLLayoutAttributeTop: {
            // update bottom layout
            [m[SJFLLayoutAttributeKeyBottom] refreshLayoutIfNeeded];
        }
            break;
        case SJFLLayoutAttributeLeft: {
            // update right layout
            [m[SJFLLayoutAttributeKeyRight] refreshLayoutIfNeeded];
        }
            break;
        case SJFLLayoutAttributeBottom: {
            [m[SJFLLayoutAttributeKeyWidth] refreshLayoutIfNeeded];
        }
            break;
        case SJFLLayoutAttributeRight: {
            [m[SJFLLayoutAttributeKeyHeight] refreshLayoutIfNeeded];
        }
            break;
        case SJFLLayoutAttributeCenterX:
            break;
        case SJFLLayoutAttributeCenterY:
            break;
    }
}

// 如果高度依赖于宽度, 则宽度布局完成后, 刷新高度

// - getter -

//UIKIT_STATIC_INLINE BOOL SJFLHorizontalLayoutContains(SJFLLayoutAttribute attr) {
//// horizontal: left, width, right, centerX
//    return (attr == SJFLLayoutAttributeLeft) || (attr == SJFLLayoutAttributeWidth) || (attr == SJFLLayoutAttributeRight) || (attr == SJFLLayoutAttributeCenterX);
//}

UIKIT_STATIC_INLINE BOOL SJFLVerticalLayoutContains(SJFLLayoutAttribute attr) {
// vertical: top, height, bottom, centerY
    return (attr == SJFLLayoutAttributeTop) || (attr == SJFLLayoutAttributeBottom) || (attr == SJFLLayoutAttributeHeight) || (attr == SJFLLayoutAttributeCenterY);
}

UIKIT_STATIC_INLINE BOOL SJFLFloatCompare(CGFloat value1, CGFloat value2) {
    return floor(value1 + 0.5) == floor(value2 + 0.5);
}

UIKIT_STATIC_INLINE BOOL SJFLViewLayoutCompare(UIView *view, SJFLLayoutAttribute attr, CGFloat value) {
    CGRect frame = view.frame;
    switch ( attr ) {
        case SJFLLayoutAttributeNone:
            return NO;
        case SJFLLayoutAttributeTop:
            return SJFLFloatCompare(value, CGRectGetMinY(frame));
        case SJFLLayoutAttributeLeft:
            return SJFLFloatCompare(value, CGRectGetMinX(frame));
        case SJFLLayoutAttributeBottom:
            return SJFLFloatCompare(value, CGRectGetMaxY(frame));
        case SJFLLayoutAttributeRight:
            return SJFLFloatCompare(value, CGRectGetMaxX(frame));
        case SJFLLayoutAttributeWidth:
            return SJFLFloatCompare(value, CGRectGetWidth(frame));
        case SJFLLayoutAttributeHeight:
            return SJFLFloatCompare(value, CGRectGetHeight(frame));
        case SJFLLayoutAttributeCenterX:
            return SJFLFloatCompare(value, CGRectGetWidth(frame) * 0.5 + CGRectGetMinX(frame));
        case SJFLLayoutAttributeCenterY:
            return SJFLFloatCompare(value, CGRectGetHeight(frame) * 0.5 + CGRectGetMinY(frame));
            break;
    }
}

UIKIT_STATIC_INLINE BOOL SJFLViewAttributeCanSettable(UIView *view, SJFLLayoutAttribute attr) {
    switch ( attr ) {
        case SJFLLayoutAttributeNone:
        case SJFLLayoutAttributeWidth:
        case SJFLLayoutAttributeHeight:
            return YES;
        case SJFLLayoutAttributeTop:
            return SJFLViewTopCanSettable(view);
        case SJFLLayoutAttributeLeft:
            return SJFLViewLeftCanSettable(view);
        case SJFLLayoutAttributeBottom:
            return SJFLViewBottomCanSettable(view);
        case SJFLLayoutAttributeRight:
            return SJFLViewRightCanSettable(view);
        case SJFLLayoutAttributeCenterX:
            return SJFLViewCenterXCanSettable(view);
        case SJFLLayoutAttributeCenterY:
            return SJFLViewCenterYCanSettable(view);
    }
    return NO;
}

UIKIT_STATIC_INLINE BOOL SJFLViewCenterXCanSettable(UIView *view) {
    SJFLLayoutSetInfo *info = view.FL_info;
    return [info get:SJFLLayoutAttributeWidth] || [info get:SJFLLayoutAttributeTop] || [info get:SJFLLayoutAttributeBottom];
}

UIKIT_STATIC_INLINE BOOL SJFLViewCenterYCanSettable(UIView *view) {
    SJFLLayoutSetInfo *info = view.FL_info;
    return [info get:SJFLLayoutAttributeHeight] || [info get:SJFLLayoutAttributeLeft] || [info get:SJFLLayoutAttributeRight];
}

UIKIT_STATIC_INLINE BOOL SJFLViewBottomCanSettable(UIView *view) {
    NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *m = SJFLElements(view);
    SJFLLayoutElement *_Nullable top = m[SJFLLayoutAttributeKeyTop];
    SJFLLayoutElement *_Nullable height = m[SJFLLayoutAttributeKeyHeight];
    if ( top != nil  && height != nil ) return NO;
    SJFLLayoutSetInfo *info = view.FL_info;
    return [info get:SJFLLayoutAttributeTop] || [info get:SJFLLayoutAttributeHeight];
}

UIKIT_STATIC_INLINE BOOL SJFLViewRightCanSettable(UIView *view) {
    NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *m = SJFLElements(view);
    SJFLLayoutElement *_Nullable left = m[SJFLLayoutAttributeKeyLeft];
    SJFLLayoutElement *_Nullable width = m[SJFLLayoutAttributeKeyWidth];
    if ( left != nil  && width != nil ) return NO;
    SJFLLayoutSetInfo *info = view.FL_info;
    return [info get:SJFLLayoutAttributeLeft] || [info get:SJFLLayoutAttributeWidth];
}

UIKIT_STATIC_INLINE BOOL SJFLViewTopCanSettable(UIView *view) {
    SJFLLayoutElement *_Nullable height = view.FL_elements[SJFLLayoutAttributeKeyHeight];
    if ( height ) {
        SJFLLayoutSetInfo *info = view.FL_info;
        return [info get:SJFLLayoutAttributeHeight];
    }
    return YES;
}

UIKIT_STATIC_INLINE BOOL SJFLViewLeftCanSettable(UIView *view) {
    SJFLLayoutElement *_Nullable width = view.FL_elements[SJFLLayoutAttributeKeyWidth];
    if ( width ) {
        SJFLLayoutSetInfo *info = view.FL_info;
        return [info get:SJFLLayoutAttributeWidth];
    }
    return YES;
}

// - setter -

UIKIT_STATIC_INLINE void SJFLViewSetX(UIView *view, CGFloat x) {
    CGRect frame = view.frame;
    if ( frame.origin.x != x ) {
        frame.origin.x = x;
        view.frame = frame;
    }
    [view.FL_info set:SJFLLayoutAttributeLeft];
}

UIKIT_STATIC_INLINE void SJFLViewSetY(UIView *view, CGFloat y) {
    CGRect frame = view.frame;
    if ( frame.origin.y != y ) {
        frame.origin.y = y;
        view.frame = frame;
    }
    [view.FL_info set:SJFLLayoutAttributeTop];
}

UIKIT_STATIC_INLINE void SJFLViewSetWidth(UIView *view, CGFloat width) {
    CGRect frame = view.frame;
    if ( width < 0 ) width = 0;
    if ( frame.size.width != width ) {
        frame.size.width = width;
        view.frame = frame;
    }
    [view.FL_info set:SJFLLayoutAttributeWidth];
}

UIKIT_STATIC_INLINE void SJFLViewSetHeight(UIView *view, CGFloat height) {
    CGRect frame = view.frame;
    if ( height < 0 ) height = 0;
    if ( frame.size.height != height ) {
        frame.size.height = height;
        view.frame = frame;
    }
    [view.FL_info set:SJFLLayoutAttributeHeight];
}

UIKIT_STATIC_INLINE void SJFLViewSetCenterX(UIView *view, CGFloat centerX) {
    CGPoint center = view.center;
    if ( center.x != centerX ) {
        center.x = centerX;
        view.center = center;
    }
    [view.FL_info set:SJFLLayoutAttributeCenterX];
}

UIKIT_STATIC_INLINE void SJFLViewSetCenterY(UIView *view, CGFloat centerY) {
    CGPoint center = view.center;
    if ( center.y != centerY ) {
        center.y = centerY;
        view.center = center;
    }
    [view.FL_info set:SJFLLayoutAttributeCenterY];
}

// set maxY
UIKIT_STATIC_INLINE void SJFLViewSetBottom(UIView *view, CGFloat bottom) {
    NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *m = SJFLElements(view);
    SJFLLayoutElement *_Nullable heightElement = m[SJFLLayoutAttributeKeyHeight];
    if ( !heightElement ) {
        // top + height = bottom
        // height = bottom - top
        CGRect frame = view.frame;
        CGFloat height = bottom - CGRectGetMinY(frame);
        if ( height < 0 ) height = 0;
        if ( height != frame.size.height ) {
            
            NSLog(@"height: \t %lf \t %lf", height, frame.size.height);
            
            frame.size.height = height;
            view.frame = frame;
        }
    }
    else {
        // top + height = bottom
        // top = bottom - height
        CGRect frame = view.frame;
        CGFloat top = bottom - CGRectGetHeight(frame);
        if ( top != frame.origin.y ) {
            frame.origin.y = top;
            view.frame = frame;
        }
    }
    [view.FL_info set:SJFLLayoutAttributeBottom];
}

// set maxX
UIKIT_STATIC_INLINE void SJFLViewSetRight(UIView *view, CGFloat right) {
    NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *m = SJFLElements(view);
    SJFLLayoutElement *_Nullable widthElement = m[SJFLLayoutAttributeKeyWidth];
    if ( !widthElement ) {
        // left + width = right
        // width = right - left
        CGRect frame = view.frame;
        CGFloat width = right - CGRectGetMinX(frame);
        if ( width < 0 ) width = 0;
        if ( width != frame.size.width ) {
            
            NSLog(@"width: \t %lf \t %lf", width, frame.size.width);
            
            frame.size.width = width;
            view.frame = frame;
        }
    }
    else {
        // left + width = right
        // left = right - width
        CGRect frame = view.frame;
        CGFloat left = right - CGRectGetWidth(frame);
        if ( left != frame.origin.x ) {
            frame.origin.x = left;
            view.frame = frame;
        }
    }
    [view.FL_info set:SJFLLayoutAttributeRight];
}
@end
NS_ASSUME_NONNULL_END
