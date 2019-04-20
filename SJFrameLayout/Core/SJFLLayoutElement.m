//
//  SJFLLayoutElement.m
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "SJFLLayoutElement.h"
#import <objc/message.h>
#import "UIView+SJFLAdditions.h"
#import "UIView+SJFLPrivate.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLLayoutSetInfo : NSObject
- (void)setLayout:(SJFLAttribute)attribute;
- (BOOL)isSet:(SJFLAttribute)attribute;
@end

@implementation SJFLLayoutSetInfo {
    struct {
        BOOL isSetNone;
        BOOL isSetTop;
        BOOL isSetLeft;
        BOOL isSetBottom;
        BOOL isSetRight;
        BOOL isSetWidth;
        BOOL isSetHeight;
        BOOL isSetCenterX;
        BOOL isSetCenterY;
    } info;
}

- (void)setLayout:(SJFLAttribute)attribute {
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
- (BOOL)isSet:(SJFLAttribute)attribute {
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
    __weak UIView *_Nullable _tar_view;
    SJFLAttribute _tar_attr;

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
    _target = target;
    _tar_view = target.view;
    _tar_attr = target.attribute;
    
    SJFLAttributeUnit *_Nullable dependency = target.equalToUnit;
    if ( !dependency ) {
        switch ( target.attribute ) {
            case SJFLAttributeNone:
            case SJFLAttributeWidth:
            case SJFLAttributeHeight:
                dependency = [[SJFLAttributeUnit alloc] initWithView:_tar_view.superview attribute:SJFLAttributeNone];
                break;
            case SJFLAttributeTop:
            case SJFLAttributeLeft:
            case SJFLAttributeBottom:
            case SJFLAttributeRight:
            case SJFLAttributeCenterX:
            case SJFLAttributeCenterY: {
                dependency = [[SJFLAttributeUnit alloc] initWithView:_tar_view.superview attribute:_tar_attr];
            }
                break;
        }
        [target equalTo:dependency];
    }
    _dep_view = dependency.view;
    _dep_attr = dependency.attribute;
    
    _before = -1;
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[_tar_view:%p,\t _tar_attr:%s,\t _dep_view:%p,\t _dep_attr:%s]", _tar_view, [SJFLAttributeUnit debug_attributeToString:_tar_attr].UTF8String, _dep_view, [SJFLAttributeUnit debug_attributeToString:_dep_attr].UTF8String];
}

- (UIView * _Nullable)dependencyView {
    return _dep_view;
}

- (void)dependencyViewsDidLayoutSubViews {
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
    
    if ( SJFLViewLayoutCompare(view, _tar_attr, newValue) ) {
        return;
    }
     
    // update
    _before = newValue;
    
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
    printf("\n_tar_attr:[%s]", [SJFLAttributeUnit debug_attributeToString:_tar_attr].UTF8String);
    printf("\n_dep_view:[%s]", _dep_view.description.UTF8String);
    printf("\n_dep_attr:[%s]", [SJFLAttributeUnit debug_attributeToString:_dep_attr].UTF8String);
    printf("\n");
    printf("\n");
#endif
    
    switch ( _tar_attr ) {
        case SJFLAttributeNone:
            break;
        case SJFLAttributeTop: {
            // update bottom layout
            [SJFLViewGetLayoutElement(view, SJFLAttributeBottom) installValueToTargetIfNeeded];
        }
            break;
        case SJFLAttributeLeft: {
            // update right layout
            [SJFLViewGetLayoutElement(view, SJFLAttributeRight) installValueToTargetIfNeeded];
        }
            break;
        case SJFLAttributeBottom:
            break;
        case SJFLAttributeRight:
            break;
        case SJFLAttributeWidth: {
            [SJFLViewGetLayoutElement(view, SJFLAttributeCenterX) installValueToTargetIfNeeded];
            [SJFLViewGetLayoutElement(view, SJFLAttributeRight) installValueToTargetIfNeeded];
        }
            break;
        case SJFLAttributeHeight: {
            [SJFLViewGetLayoutElement(view, SJFLAttributeCenterY) installValueToTargetIfNeeded];
            [SJFLViewGetLayoutElement(view, SJFLAttributeBottom) installValueToTargetIfNeeded];
        }
            break;
        case SJFLAttributeCenterX:
            break;
        case SJFLAttributeCenterY:
            break;
    }
}

// solve equation
- (CGFloat)value {
    UIView *dep_view = _dep_view;
    CGRect dep_frame = dep_view.frame;

    UIView *tar_view = _tar_view;
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

UIKIT_STATIC_INLINE CGPoint SJFLViewGetCenterPoint(UIView *view) {
    return (CGPoint){SJFLViewGetWidth(view) * 0.5, SJFLViewGetHeight(view) * 0.5};
}

UIKIT_STATIC_INLINE BOOL SJFLFloatIsZero(CGFloat value) {
    return fabs(value) <= 0.00001f;
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
    SJFLLayoutSetInfo *info = view.FL_info;
    return [info isSet:SJFLAttributeWidth] || [info isSet:SJFLAttributeTop] || [info isSet:SJFLAttributeBottom];
}

UIKIT_STATIC_INLINE BOOL SJFLViewCenterYCanSettable(UIView *view) {
    SJFLLayoutSetInfo *info = view.FL_info;
    return [info isSet:SJFLAttributeHeight] || [info isSet:SJFLAttributeLeft] || [info isSet:SJFLAttributeRight];
}

UIKIT_STATIC_INLINE BOOL SJFLViewBottomCanSettable(UIView *view) {
    SJFLLayoutSetInfo *info = view.FL_info;
    return [info isSet:SJFLAttributeHeight] || [info isSet:SJFLAttributeTop];
}

UIKIT_STATIC_INLINE BOOL SJFLViewRightCanSettable(UIView *view) {
    SJFLLayoutSetInfo *info = view.FL_info;
    return [info isSet:SJFLAttributeWidth] || [info isSet:SJFLAttributeLeft];
}

// - setter -

UIKIT_STATIC_INLINE void SJFLViewSetX(UIView *view, CGFloat x) {
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
    [view.FL_info setLayout:SJFLAttributeLeft];
}

UIKIT_STATIC_INLINE void SJFLViewSetY(UIView *view, CGFloat y) {
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
    [view.FL_info setLayout:SJFLAttributeTop];
}

UIKIT_STATIC_INLINE void SJFLViewSetWidth(UIView *view, CGFloat width) {
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
    [view.FL_info setLayout:SJFLAttributeWidth];
}

UIKIT_STATIC_INLINE void SJFLViewSetHeight(UIView *view, CGFloat height) {
    CGRect frame = view.frame;
    frame.size.height = height;
    view.frame = frame;
    [view.FL_info setLayout:SJFLAttributeHeight];
}

UIKIT_STATIC_INLINE void SJFLViewSetCenterX(UIView *view, CGFloat centerX) {
    CGPoint center = view.center;
    center.x = centerX;
    view.center = center;
    [view.FL_info setLayout:SJFLAttributeCenterX];
}

UIKIT_STATIC_INLINE void SJFLViewSetCenterY(UIView *view, CGFloat centerY) {
    CGPoint center = view.center;
    center.y = centerY;
    view.center = center;
    [view.FL_info setLayout:SJFLAttributeCenterY];
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
    [view.FL_info setLayout:SJFLAttributeBottom];
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
    [view.FL_info setLayout:SJFLAttributeRight];
}
@end
NS_ASSUME_NONNULL_END
