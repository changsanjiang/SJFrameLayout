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

#ifdef SJFLLib
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

- (void)refreshLayoutIfNeeded:(CGRect *)frame {
    UIView *_Nullable view = _tar_view;
    if ( !view ) {
        return;
    }
    
    CGFloat newValue = [self value:*frame];
    SJFLLayoutAttribute tar_attr = _tar_attr;
    
    if ( [view.FL_info get:tar_attr] && SJFLViewLayoutCompare(*frame, tar_attr, newValue) ) {
        return;
    }
    
    switch ( tar_attr ) {
        case SJFLLayoutAttributeNone: break; ///< Target does not need to do anything
        case SJFLLayoutAttributeTop:{
            frame->origin.y = newValue;
            [view.FL_info set:SJFLLayoutAttributeTop];
        }
            break;
        case SJFLLayoutAttributeLeft: {
            frame->origin.x = newValue;
            [view.FL_info set:SJFLLayoutAttributeLeft];
        }
            break;
        case SJFLLayoutAttributeBottom: {
            NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *m = SJFLElements(view);
            SJFLLayoutElement *_Nullable heightElement = m[SJFLLayoutAttributeKeyHeight];
            if ( !heightElement ) {
                // top + height = bottom
                // height = bottom - top
                CGFloat height = newValue - CGRectGetMinY(*frame);
                if ( height < 0 ) height = 0;
                frame->size.height = height;
            }
            else {
                // top + height = bottom
                // top = bottom - height
                CGFloat top = newValue - CGRectGetHeight(*frame);
                frame->origin.y = top;
            }
            [view.FL_info set:SJFLLayoutAttributeBottom];
        }
            break;
        case SJFLLayoutAttributeRight: {
            NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *m = SJFLElements(view);
            SJFLLayoutElement *_Nullable widthElement = m[SJFLLayoutAttributeKeyWidth];
            if ( !widthElement ) {
                // left + width = right
                // width = right - left
                CGFloat width = newValue - CGRectGetMinX(*frame);
                if ( width < 0 ) width = 0;
                frame->size.width = width;
            }
            else {
                // left + width = right
                // left = right - width
                CGFloat left = newValue - CGRectGetWidth(*frame);
                frame->origin.x = left;
            }
            [view.FL_info set:SJFLLayoutAttributeRight];
        }
            break;
        case SJFLLayoutAttributeWidth: {
            if ( newValue < 0 ) newValue = 0;
            frame->size.width = newValue;
            [view.FL_info set:SJFLLayoutAttributeWidth];
        }
            break;
        case SJFLLayoutAttributeHeight: {
            if ( newValue < 0 ) newValue = 0;
            frame->size.height = newValue;
            [view.FL_info set:SJFLLayoutAttributeHeight];
        }
            break;
        case SJFLLayoutAttributeCenterX: {
            // newValue = frame.origin.x + frame.origin.width * 0.5
            CGFloat x = newValue - CGRectGetWidth(*frame) * 0.5;
            frame->origin.x = x;
            [view.FL_info set:SJFLLayoutAttributeCenterX];
        }
            break;
        case SJFLLayoutAttributeCenterY: {
            // centerY = frame.origin.y + frame.origin.height * 0.5
            CGFloat y = newValue - CGRectGetHeight(*frame) * 0.5;
            frame->origin.y = y;
            [view.FL_info set:SJFLLayoutAttributeCenterY];
        }
            break;
    }
    
#ifdef SJFLLib
    printf("\n_tar_view:[%s]", _tar_view.description.UTF8String);
    printf("\n_tar_attr:[%s]", [SJFLLayoutAttributeUnit debug_attributeToString:tar_attr].UTF8String);
    printf("\n_dep_view:[%s]", _dep_view.description.UTF8String);
    printf("\n_dep_attr:[%s]", [SJFLLayoutAttributeUnit debug_attributeToString:_dep_attr].UTF8String);
    printf("\n");
    printf("\n");
#endif
}

// value = dependency_value * multiplier + offset
- (CGFloat)value:(CGRect)frame {
    CGFloat offset = self.offset;
    CGFloat value = 0;
    SJFLFrameAttribute dep_attr = _dep_attr;
    
    if ( dep_attr != SJFLFrameAttributeNone ) {
        SJFLLayoutAttribute tar_attr = _tar_attr;
        UIView *dep_view = _dep_view;
        CGRect dep_frame = CGRectZero;
        
        if ( dep_view != _tar_view )
            dep_frame = dep_view.frame;
        else
            dep_frame = frame; ///< 如果是自己, 就使用计算frame
        
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

UIKIT_STATIC_INLINE BOOL SJFLViewLayoutCompare(CGRect frame, SJFLLayoutAttribute attr, CGFloat value) {
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
@end
NS_ASSUME_NONNULL_END
