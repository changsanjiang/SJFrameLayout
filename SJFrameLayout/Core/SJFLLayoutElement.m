//
//  SJFLLayoutElement.m
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "SJFLLayoutElement.h"
#import "UIView+SJFLAdditions.h"
#import "UIView+SJFLPrivate.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLLayoutElement () {
    __weak UIView *_Nullable _view;
    __weak UIView *_Nullable _dep_view;
    SJFLAttribute _dep_attr;
    CGFloat _before;
}
@property (nonatomic, readonly) CGFloat value;
@end

@implementation SJFLLayoutElement
- (instancetype)initWithTarget:(SJFLAttributeUnit *)target {
    self = [super init];
    if ( !self ) return nil;
    _before = -1;
    _target = target;
    _view = target.view;
    
    SJFLAttributeUnit *_Nullable dependency = target.equalToUnit;
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
        [target equalTo:dependency];
    }
    _dep_view = dependency.view;
    _dep_attr = dependency.attribute;
    return self;
}

- (UIView * _Nullable)dependencyView {
    return _dep_view;
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
    if ( SJFLFloatCompare(newValue, _before) ) {
        return;
    }
    
    // update
    _before = newValue;
    
    if ( view ) {
        switch ( _target.attribute ) {
            case SJFLAttributeNone: break; ///< Target does not need to do anything
            case SJFLAttributeTop: {
                SJFLViewSetY(view, newValue);
                
                // update bottom layout
                [SJFLViewGetLayoutElement(view, SJFLAttributeBottom) installValueToTargetIfNeeded];
            }
                break;
            case SJFLAttributeLeft: {
                SJFLViewSetX(view, newValue);
                
                // update right layout
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

// solve equation
- (CGFloat)value {
    UIView *dep_view = _dep_view;
    CGRect dep_frame = dep_view.frame;

    UIView *tar_view = _view;
    UIView *tar_superview = tar_view.superview;

    CGFloat dep_value = 0;
    
    SJFLAttribute dep_attr = _dep_attr;
    CGFloat offset = _target.offset;
    
    if ( dep_attr == SJFLAttributeNone ) {
        return offset;
    }
    
    switch ( dep_attr ) {
        case SJFLAttributeNone: break;
        case SJFLAttributeTop: { ///< top
            CGPoint top = [dep_view convertPoint:CGPointZero toView:tar_superview];
            dep_value = top.y + offset;
        }
            break;
        case SJFLAttributeLeft: { ///< left
            CGPoint left = [dep_view convertPoint:CGPointZero toView:tar_superview];
            dep_value = left.x + offset;
        }
            break;
        case SJFLAttributeBottom: { ///< top + height = maxY
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
            
            dep_value = top + height + offset; // return maxY
        }
            break;
        case SJFLAttributeRight: { ///< left + width = maxX
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
            
            dep_value = left + width + offset; // return maxX
        }
            break;
        case SJFLAttributeWidth: { ///< width
            dep_value = CGRectGetWidth(dep_frame) + offset;
        }
            break;
        case SJFLAttributeHeight: { ///< height
            dep_value = CGRectGetHeight(dep_frame) + offset;
        }
            break;
        case SJFLAttributeCenterX: {
            CGPoint center = [dep_view convertPoint:SJFLViewGetCenterPoint(dep_view) toView:tar_superview];
            dep_value = center.x + offset;
        }
            break;
        case SJFLAttributeCenterY: {
            CGPoint center = [dep_view convertPoint:SJFLViewGetCenterPoint(dep_view) toView:tar_superview];
            dep_value = center.y + offset;
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

UIKIT_STATIC_INLINE BOOL SJFLFloatIsZero(CGFloat value) {
    return fabs(value) <= 0.00001f;
}

UIKIT_STATIC_INLINE BOOL SJFLFloatCompare(CGFloat value1, CGFloat value2) {
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
    return !SJFLFloatIsZero(CGRectGetWidth(frame)) || !SJFLFloatIsZero(CGRectGetMinX(frame));
}

UIKIT_STATIC_INLINE BOOL SJFLViewCenterYCanSettable(UIView *view) {
    CGRect frame = view.frame;
    return !SJFLFloatIsZero(CGRectGetHeight(frame)) || !SJFLFloatIsZero(CGRectGetMinY(frame));
}

UIKIT_STATIC_INLINE BOOL SJFLViewBottomCanSettable(UIView *view) {
    CGRect frame = view.frame;
    return !SJFLFloatIsZero(CGRectGetMinY(frame)) || !SJFLFloatIsZero(CGRectGetHeight(frame)) || !SJFLFloatIsZero(SJFLViewGetCenterY(view));
}

UIKIT_STATIC_INLINE BOOL SJFLViewRightCanSettable(UIView *view) {
    CGRect frame = view.frame;
    return !SJFLFloatIsZero(CGRectGetMinX(frame)) || !SJFLFloatIsZero(CGRectGetWidth(frame)) || !SJFLFloatIsZero(SJFLViewGetCenterX(view));
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
