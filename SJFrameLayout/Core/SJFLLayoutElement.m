//
//  SJFLLayoutElement.m
//  Pods
//
//  Created by BlueDancer on 2019/4/18.
//

#import "SJFLLayoutElement.h"
#import "UIView+SJFLAdditions.h"
#import "UIView+SJFLPrivate.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLLayoutElement () {
    __weak UIView *_Nullable _view;
    __weak UIView *_Nullable _dep_view;
    CGFloat _before;
}
@property (nonatomic, readonly) CGFloat value;
@end

@implementation SJFLLayoutElement

- (instancetype)initWithTarget:(SJFLAttributeUnit *)target offset:(CGFloat)offset {
    return [self initWithTarget:target equalTo:nil offset:offset];
}

- (instancetype)initWithTarget:(SJFLAttributeUnit *)target equalTo:(nullable SJFLAttributeUnit *)dependency offset:(CGFloat)offset {
    self = [super init];
    if ( !self ) return nil;
    _target = target;
    _offset = offset;
    _before = -1;
    
    if ( !dependency ) {
        switch ( _target.attribute ) {
            case SJFLAttributeNone:
            case SJFLAttributeWidth:
            case SJFLAttributeHeight:
                dependency = [[SJFLAttributeUnit alloc] initWithView:target.view.superview attribute:SJFLAttributeNone];
                break;
            case SJFLAttributeTop:
            case SJFLAttributeLeft:
            case SJFLAttributeBottom:
            case SJFLAttributeRight:
            case SJFLAttributeCenterX:
            case SJFLAttributeCenterY: {
                dependency = [[SJFLAttributeUnit alloc] initWithView:target.view.superview attribute:target.attribute];
            }
                break;
        }
    }
    
    _dependency = dependency;
    
    _view = target.view;
    _dep_view = dependency.view;
    return self;
}

- (void)dependencyViewsDidLayoutSubViews {
    if ( !_dep_view || !_view )
        return;
    [self installValueToTargetIfNeeded];
}

- (void)installValueToTargetIfNeeded {
    UIView *_Nullable view = _view;
    if ( !SJFLViewAttributeCanSettable(view, _target.attribute) ) {
        return;
    }

    CGFloat newValue = self.value;
    if ( SJFLValueCompare(newValue, _before) ) {
        return;
    }
    
    // update
    _before = newValue;
    
    if ( view ) {
        switch ( _target.attribute ) {
            case SJFLAttributeNone:
                break;
            case SJFLAttributeTop: {
                SJFLViewSetY(view, newValue);
                
                [SJFLViewGetLayoutElement(view, SJFLAttributeBottom) installValueToTargetIfNeeded];
            }
                break;
            case SJFLAttributeLeft: {
                SJFLViewSetX(view, newValue);
                
                [SJFLViewGetLayoutElement(view, SJFLAttributeRight) installValueToTargetIfNeeded];
            }
                break;
            case SJFLAttributeBottom:
                SJFLViewSetBottom(view, newValue);
                break;
            case SJFLAttributeRight:
                SJFLViewSetRight(view, newValue);
                break;
            case SJFLAttributeWidth: {
                SJFLViewSetWidth(view, newValue);
                
                [SJFLViewGetLayoutElement(view, SJFLAttributeCenterX) installValueToTargetIfNeeded];
                [SJFLViewGetLayoutElement(view, SJFLAttributeRight) installValueToTargetIfNeeded];
            }
                break;
            case SJFLAttributeHeight: {
                SJFLViewSetHeight(view, newValue);
                
                [SJFLViewGetLayoutElement(view, SJFLAttributeCenterY) installValueToTargetIfNeeded];
                [SJFLViewGetLayoutElement(view, SJFLAttributeBottom) installValueToTargetIfNeeded];
            }
                break;
            case SJFLAttributeCenterX:
                SJFLViewSetCenterX(view, newValue);
                break;
            case SJFLAttributeCenterY:
                SJFLViewSetCenterY(view, newValue);
                break;
        }
    }
}

- (CGFloat)value {
    UIView *dep_view = _dep_view;
    CGRect dep_frame = dep_view.frame;

    UIView *tar_view = _view;
    UIView *tar_superview = tar_view.superview;

    CGFloat dep_value = 0;
    switch ( _dependency.attribute ) {
        case SJFLAttributeNone:
            break;
        case SJFLAttributeTop: {
            CGPoint top = [dep_view convertPoint:CGPointZero toView:tar_superview];
            dep_value = top.y + _offset;
        }
            break;
        case SJFLAttributeLeft: {
            CGPoint left = [dep_view convertPoint:CGPointZero toView:tar_superview];
            dep_value = left.x + _offset;
        }
            break;
        case SJFLAttributeBottom: {
            CGFloat top = 0;
            CGFloat height = 0;
            
            SJFLLayoutElement *_Nullable topElement = SJFLViewGetLayoutElement(tar_view, SJFLAttributeTop);
            if ( topElement != nil ) {
                top = topElement.value;
                height = CGRectGetHeight(dep_frame) - top;
            }
            else {
                SJFLLayoutElement *_Nullable heightElement = SJFLViewGetLayoutElement(tar_view, SJFLAttributeHeight);
                if ( heightElement != nil ) {
                    height = heightElement.value;
                 
                    CGPoint point = CGPointMake(0, CGRectGetHeight(dep_frame) - height);
                    top = [dep_view convertPoint:point toView:tar_superview].y;
                }
            }
            
            dep_value = top + height + _offset; // return maxY
        }
            break;
        case SJFLAttributeRight: {
            CGFloat left = 0;
            CGFloat width = 0;
            
            SJFLLayoutElement *_Nullable leftElement = SJFLViewGetLayoutElement(tar_view, SJFLAttributeLeft);
            if ( leftElement != nil ) {
                left = leftElement.value;
                width = CGRectGetWidth(dep_frame) - left;
            }
            else {
                SJFLLayoutElement *_Nullable widthElement = SJFLViewGetLayoutElement(tar_view, SJFLAttributeWidth);
                if ( widthElement != nil ) {
                    width = widthElement.value;
                    CGPoint point = CGPointMake(CGRectGetWidth(dep_frame) - width, 0);
                    left = [dep_view convertPoint:point toView:tar_superview].x;
                }
            }
            
            dep_value = left + width + _offset; // return maxX
        }
            break;
        case SJFLAttributeWidth: {
            dep_value = CGRectGetWidth(dep_frame) + _offset;
        }
            break;
        case SJFLAttributeHeight: {
            dep_value = CGRectGetHeight(dep_frame) + _offset;
        }
            break;
        case SJFLAttributeCenterX: {
            CGPoint center = [dep_view convertPoint:SJFLViewGetCenterPoint(dep_view) toView:tar_superview];
            dep_value = center.x + _offset;
        }
            break;
        case SJFLAttributeCenterY: {
            CGPoint center = [dep_view convertPoint:SJFLViewGetCenterPoint(dep_view) toView:tar_superview];
            dep_value = center.y + _offset;
        }
            break;
    }
    
    return dep_value;
}

// - getter -

UIKIT_STATIC_INLINE SJFLLayoutElement *_Nullable SJFLViewGetLayoutElement(UIView *view, SJFLAttribute attr) {
    for ( SJFLLayoutElement *ele in view.FL_elements ) {
        if ( ele.target.attribute == attr )
            return ele;
    }
    return nil;
}

UIKIT_STATIC_INLINE CGFloat SJFLViewGetWidth(UIView *view) {
    return view.frame.size.width;
}

UIKIT_STATIC_INLINE CGFloat SJFLViewGetHeight(UIView *view) {
    return view.frame.size.height;
}

UIKIT_STATIC_INLINE CGFloat SJFLViewGetCenterX(UIView *view) {
    return view.center.x;
}

UIKIT_STATIC_INLINE CGFloat SJFLViewGetCenterY(UIView *view) {
    return view.center.y;
}

UIKIT_STATIC_INLINE CGPoint SJFLViewGetCenterPoint(UIView *view) {
    return (CGPoint){SJFLViewGetWidth(view) * 0.5, SJFLViewGetHeight(view) * 0.5};
}

UIKIT_STATIC_INLINE BOOL SJFLValueIsZero(CGFloat value) {
    return fabs(value) <= 0.00001f;
}

UIKIT_STATIC_INLINE BOOL SJFLValueCompare(CGFloat value1, CGFloat value2) {
    return floor(value1 + 0.5) == floor(value2 + 0.5);
}

UIKIT_STATIC_INLINE BOOL SJFLViewAttributeCanSettable(UIView *view, SJFLAttribute attr) {
    switch ( attr ) {
        case SJFLAttributeNone:
        case SJFLAttributeTop:
        case SJFLAttributeLeft:
        case SJFLAttributeWidth:
        case SJFLAttributeHeight:
            return YES;
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
    CGRect frame = view.frame;
    return !SJFLValueIsZero(CGRectGetWidth(frame)) || !SJFLValueIsZero(CGRectGetMinX(frame));
}

UIKIT_STATIC_INLINE BOOL SJFLViewCenterYCanSettable(UIView *view) {
    CGRect frame = view.frame;
    return !SJFLValueIsZero(CGRectGetHeight(frame)) || !SJFLValueIsZero(CGRectGetMinY(frame));
}

UIKIT_STATIC_INLINE BOOL SJFLViewBottomCanSettable(UIView *view) {
    CGRect frame = view.frame;
    return !SJFLValueIsZero(CGRectGetMinY(frame)) || !SJFLValueIsZero(CGRectGetHeight(frame)) || !SJFLValueIsZero(SJFLViewGetCenterY(view));
}

UIKIT_STATIC_INLINE BOOL SJFLViewRightCanSettable(UIView *view) {
    CGRect frame = view.frame;
    return !SJFLValueIsZero(CGRectGetMinX(frame)) || !SJFLValueIsZero(CGRectGetWidth(frame)) || !SJFLValueIsZero(SJFLViewGetCenterX(view));
}

// - setter -

UIKIT_STATIC_INLINE void SJFLViewSetX(UIView *view, CGFloat x) {
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
}

UIKIT_STATIC_INLINE void SJFLViewSetY(UIView *view, CGFloat y) {
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
}

UIKIT_STATIC_INLINE void SJFLViewSetWidth(UIView *view, CGFloat width) {
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}

UIKIT_STATIC_INLINE void SJFLViewSetHeight(UIView *view, CGFloat height) {
    CGRect frame = view.frame;
    frame.size.height = height;
    view.frame = frame;
}

UIKIT_STATIC_INLINE void SJFLViewSetCenterX(UIView *view, CGFloat centerX) {
    CGPoint center = view.center;
    center.x = centerX;
    view.center = center;
}

UIKIT_STATIC_INLINE void SJFLViewSetCenterY(UIView *view, CGFloat centerY) {
    CGPoint center = view.center;
    center.y = centerY;
    view.center = center;
}

// set maxY
UIKIT_STATIC_INLINE void SJFLViewSetBottom(UIView *view, CGFloat bottom) {
    SJFLLayoutElement *_Nullable heightElement = SJFLViewGetLayoutElement(view, SJFLAttributeHeight);
    if ( !heightElement ) {
        // top + height = bottom
        // height = bottom - top
        CGRect frame = view.frame;
        frame.size.height = bottom - CGRectGetMinY(frame);
        view.frame = frame;
    }
    else {
        // top + height = bottom
        // top = bottom - height
        CGRect frame = view.frame;
        frame.origin.y = bottom - CGRectGetHeight(frame);
        view.frame = frame;
    }
}

// set maxX
UIKIT_STATIC_INLINE void SJFLViewSetRight(UIView *view, CGFloat right) {
    SJFLLayoutElement *_Nullable widthElement = SJFLViewGetLayoutElement(view, SJFLAttributeWidth);
    if ( !widthElement ) {
        // left + width = right
        // width = right - left
        CGRect frame = view.frame;
        frame.size.width = right - CGRectGetMinX(frame);
        view.frame = frame;
    }
    else {
        // left + width = right
        // left = right - width
        CGRect frame = view.frame;
        frame.origin.x = right - CGRectGetWidth(frame);
        view.frame = frame;
    }
}
@end
NS_ASSUME_NONNULL_END
