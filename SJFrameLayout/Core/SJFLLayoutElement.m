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
#define FL_log_call_count (0)
#if FL_log_call_count
static int call_count01 = 0;
static int call_count02 = 0;
static int call_count03 = 0;
static int call_count04 = 0;

@implementation SJFLLayoutElementLog
+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"E: 01 - %d", call_count01);
        NSLog(@"E: 02 - %d", call_count02);
        NSLog(@"E: 03 - %d", call_count03);
        NSLog(@"E: 04 - %d", call_count04);
    });
}
@end
#endif

@interface SJFLLayoutElement () {
    SJFLLayoutAttributeUnit *_target;
    __weak UIView *_Nullable _tar_superview;
    __weak UIView *_Nullable _tar_view;
    SJFLLayoutAttribute _tar_attr;

    __weak UIView *_Nullable _dep_view;
    SJFLFrameAttribute _dep_attr;
    BOOL _is_dep_self;

    // - values -
    CGRect _dep_frame;
    CGRect _super_frame;
    CGFloat _value;
    CGFloat _offset;
    
    UIEdgeInsets _safeAreaInsets NS_AVAILABLE_IOS(11.0);
    BOOL _has_safe_attr NS_AVAILABLE_IOS(11.0);
}
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
    _is_dep_self = _dep_view == _tar_view;
    
    if ( @available(iOS 11.0, *) ) {
        switch ( _dep_attr ) {
            case SJFLFrameAttributeSafeTop:
            case SJFLFrameAttributeSafeLeft:
            case SJFLFrameAttributeSafeBottom:
            case SJFLFrameAttributeSafeRight: {
                _safeAreaInsets = _dep_view.safeAreaInsets;
                _has_safe_attr = YES;
            }
                break;
            case SJFLFrameAttributeNone:
            case SJFLFrameAttributeTop:
            case SJFLFrameAttributeLeft:
            case SJFLFrameAttributeBottom:
            case SJFLFrameAttributeRight:
            case SJFLFrameAttributeWidth:
            case SJFLFrameAttributeHeight:
            case SJFLFrameAttributeCenterX:
            case SJFLFrameAttributeCenterY:
                break;
        }
    }
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
    if ( SJFLViewLayoutCompare(*frame, tar_attr, newValue) ) {
        return;
    }
    
#if FL_log_call_count
    call_count04 += 1;
#endif
    
    switch ( tar_attr ) {
        case SJFLLayoutAttributeNone: break; ///< Target does not need to do anything
        case SJFLLayoutAttributeTop:{
            frame->origin.y = newValue;
        }
            break;
        case SJFLLayoutAttributeLeft: {
            frame->origin.x = newValue;
        }
            break;
        case SJFLLayoutAttributeBottom: {
            NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *m = SJFLGetElements(view);
            SJFLLayoutElement *_Nullable heightElement = m[SJFLLayoutAttributeKeyHeight];
            if ( !heightElement ) {
                // top + height = bottom
                // height = bottom - top
                CGFloat height = newValue - frame->origin.y;
                if ( height < 0 ) height = 0;
                frame->size.height = height;
            }
            else {
                // top + height = bottom
                // top = bottom - height
                CGFloat top = newValue - frame->size.height;
                frame->origin.y = top;
            }
        }
            break;
        case SJFLLayoutAttributeRight: {
            NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *m = SJFLGetElements(view);
            SJFLLayoutElement *_Nullable widthElement = m[SJFLLayoutAttributeKeyWidth];
            if ( !widthElement ) {
                // left + width = right
                // width = right - left
                CGFloat width = newValue - frame->origin.x;
                if ( width < 0 ) width = 0;
                frame->size.width = width;
            }
            else {
                // left + width = right
                // left = right - width
                CGFloat left = newValue - frame->size.width;
                frame->origin.x = left;
            }
        }
            break;
        case SJFLLayoutAttributeWidth: {
            if ( newValue < 0 ) newValue = 0;
            frame->size.width = newValue;        }
            break;
        case SJFLLayoutAttributeHeight: {
            if ( newValue < 0 ) newValue = 0;
            frame->size.height = newValue;
        }
            break;
        case SJFLLayoutAttributeCenterX: {
            // newValue = frame.origin.x + frame.origin.width * 0.5
            CGFloat x = newValue - frame->size.width * 0.5;
            frame->origin.x = x;
        }
            break;
        case SJFLLayoutAttributeCenterY: {
            // centerY = frame.origin.y + frame.origin.height * 0.5
            CGFloat y = newValue - frame->size.height * 0.5;
            frame->origin.y = y;
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
    CGFloat value = _value;
    
    CGRect dep_frame = (_is_dep_self)?frame:_dep_view.frame;
    BOOL isChanged_depFrame = !CGRectEqualToRect(dep_frame, _dep_frame);
    if ( isChanged_depFrame ) _dep_frame = dep_frame;
    
    CGRect super_frame = _tar_superview.frame;
    BOOL isChanged_superFrame = !CGRectEqualToRect(super_frame, _super_frame);
    if ( isChanged_superFrame ) _super_frame = super_frame;
    
    CGFloat offset = self.offset;
    BOOL isChanged_offset = offset != _offset;
    if ( isChanged_offset ) _offset = offset;
    
    BOOL isChanged_safeArea = NO;
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if ( @available(iOS 11.0, *) ) {
        if ( _has_safe_attr ) {
            safeAreaInsets = _dep_view.safeAreaInsets;
            isChanged_safeArea = !UIEdgeInsetsEqualToEdgeInsets(_safeAreaInsets, safeAreaInsets);
            if ( isChanged_safeArea ) _safeAreaInsets = safeAreaInsets;
        }
    }
    
    if ( isChanged_depFrame || isChanged_superFrame || isChanged_offset || isChanged_safeArea ) {
        _value = value = ceil(self.dep_value * _target->multiplier + offset);
    }
    return value;
}

- (CGFloat)dep_value {
    CGFloat dep_value = 0;
    if ( _dep_attr != SJFLFrameAttributeNone ) {
        SJFLLayoutAttribute tar_attr = _tar_attr;
        SJFLFrameAttribute dep_attr = _dep_attr;
        if ( dep_attr != SJFLFrameAttributeNone ) {
            switch ( tar_attr ) {
                case SJFLLayoutAttributeNone: {
                    /* do nothing */
                }
                    break;
                    // - size
                case SJFLLayoutAttributeWidth: case SJFLLayoutAttributeHeight: {
                    switch ( dep_attr ) {
                        default: break;
                        case SJFLLayoutAttributeWidth: {
                            dep_value = _dep_frame.size.width;
                        }
                            break;
                        case SJFLLayoutAttributeHeight: {
                            dep_value = _dep_frame.size.height;
                        }
                            break;
                    }
                }
                    break;
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
                    
                    // - vertical
                case SJFLLayoutAttributeTop: case SJFLLayoutAttributeBottom: case SJFLLayoutAttributeCenterY: {
                    CGPoint point = CGPointZero;
                    switch ( dep_attr ) {
                        case SJFLFrameAttributeTop:
                            point = CGPointZero;
                            break;
                        case SJFLFrameAttributeSafeTop:
                            point = CGPointMake(0, _safeAreaInsets.top);
                            break;
                        case SJFLLayoutAttributeCenterY:
                            point = CGPointMake(0, _dep_frame.size.height * 0.5);
                            break;
                        case SJFLLayoutAttributeBottom:
                            point = CGPointMake(0, _dep_frame.size.height);
                            break;
                        case SJFLFrameAttributeSafeBottom:
                            point = CGPointMake(0, _dep_frame.size.height - _safeAreaInsets.bottom);
                            break;
                        default: break;
                    }
                    
                    dep_value = [_dep_view convertPoint:point toView:_tar_superview].y;
                }
                    break;
                    
                    // - horizontal
                case SJFLLayoutAttributeLeft: case SJFLLayoutAttributeRight: case SJFLLayoutAttributeCenterX: {
                    CGPoint point = CGPointZero;
                    switch ( dep_attr ) {
                        case SJFLLayoutAttributeLeft:
                            point = CGPointZero;
                            break;
                        case SJFLFrameAttributeSafeLeft:
                            point = CGPointMake(_safeAreaInsets.left, 0);
                            break;
                        case SJFLLayoutAttributeCenterX:
                            point = CGPointMake(_dep_frame.size.width * 0.5, 0);
                            break;
                        case SJFLLayoutAttributeRight:
                            point = CGPointMake(_dep_frame.size.width, 0);
                            break;
                        case SJFLFrameAttributeSafeRight:
                            point = CGPointMake(_dep_frame.size.width - _safeAreaInsets.right, 0);
                            break;
                        default: break;
                    }
                    
                    dep_value = [_dep_view convertPoint:point toView:_tar_superview].x;
                }
                    break;
            }
        }
    }
    // else {  /* none, do nothing */ }
    return dep_value;
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

// - getter -

//UIKIT_STATIC_INLINE BOOL SJFLHorizontalLayoutContains(SJFLLayoutAttribute attr) {
//// horizontal: left, width, right, centerX
//    return (attr == SJFLLayoutAttributeLeft) ||
//            (attr == SJFLLayoutAttributeWidth) ||
//             (attr == SJFLLayoutAttributeRight) ||
//              (attr == SJFLLayoutAttributeCenterX);
//}

//UIKIT_STATIC_INLINE BOOL SJFLVerticalLayoutContains(SJFLLayoutAttribute attr) {
//// vertical: top, height, bottom, centerY
//    return (attr == SJFLLayoutAttributeTop) ||
//            (attr == SJFLLayoutAttributeBottom) ||
//             (attr == SJFLLayoutAttributeHeight) ||
//              (attr == SJFLLayoutAttributeCenterY);
//}

UIKIT_STATIC_INLINE BOOL SJFLViewLayoutCompare(CGRect frame, SJFLLayoutAttribute attr, CGFloat value) {
    switch ( attr ) {
        case SJFLLayoutAttributeNone:
            return NO;
        case SJFLLayoutAttributeTop:
            return value == frame.origin.y;
        case SJFLLayoutAttributeLeft:
            return value == frame.origin.x;
        case SJFLLayoutAttributeBottom:
            return value == frame.origin.y + frame.size.height;
        case SJFLLayoutAttributeRight:
            return value == frame.origin.x + frame.size.width;
        case SJFLLayoutAttributeWidth:
            return value == frame.size.width;
        case SJFLLayoutAttributeHeight:
            return value == frame.size.height;
        case SJFLLayoutAttributeCenterX:
            return value == frame.origin.x + frame.size.width * 0.5;
        case SJFLLayoutAttributeCenterY:
            return value == frame.origin.y + frame.size.height * 0.5;
            break;
    }
}
@end
NS_ASSUME_NONNULL_END
