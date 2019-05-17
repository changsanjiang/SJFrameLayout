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

NS_ASSUME_NONNULL_BEGIN
@interface SJFLLayoutElement () {
    SJFLLayoutAttributeUnit *_target;
    __weak UIView *_Nullable _tar_superview;
    __weak UIView *_Nullable _tar_view;
    __weak UIView *_Nullable _dep_view;

    // - values -
    struct {
        SJFLLayoutAttribute tar_attr;
        SJFLFrameAttribute dep_attr;
        BOOL is_dep_self :1;
    
        CGFloat value;
        CGFloat offset;
        CGRect dep_frame;
        CGRect super_frame;
        
        UIEdgeInsets safeAreaInsets NS_AVAILABLE_IOS(11.0);
        BOOL has_safe_attr :1 NS_AVAILABLE_IOS(11.0);
    } _values;
}
@end

@implementation SJFLLayoutElement
- (instancetype)initWithTarget:(SJFLLayoutAttributeUnit *)target {
    return [self initWithTarget:target superview:nil];
}

- (instancetype)initWithTarget:(SJFLLayoutAttributeUnit *)target superview:(nullable UIView *)superview {
    self = [super init];
    if ( self ) {
        _target = target;
        _tar_view = target->view;
        _tar_superview = superview?:_tar_view.superview;
        _values.tar_attr = target->attribute;
        
        SJFLFrameAttributeUnit *_Nullable dependent = target->equalToViewAttribute;
        if ( !dependent ) {
            switch ( target->attribute ) {
                case SJFLLayoutAttributeNone:
                case SJFLLayoutAttributeWidth:
                case SJFLLayoutAttributeHeight:
                    dependent = [[SJFLFrameAttributeUnit alloc] initWithView:_tar_superview attribute:SJFLFrameAttributeNone];
                    break;
                case SJFLLayoutAttributeTop:
                case SJFLLayoutAttributeLeft:
                case SJFLLayoutAttributeBottom:
                case SJFLLayoutAttributeRight:
                case SJFLLayoutAttributeCenterX:
                case SJFLLayoutAttributeCenterY: {
                    dependent = SJFLFrameAtrributeUnitForAttribute(_tar_superview, (SJFLFrameAttribute)_values.tar_attr);
                }
                    break;
            }
            target->equalToViewAttribute = dependent;
        }
        
        _dep_view = dependent.view;
        _values.dep_attr = dependent.attribute;
        _values.is_dep_self = (_dep_view == _tar_view);
        
        if ( @available(iOS 11.0, *) ) {
            switch ( _values.dep_attr ) {
                case SJFLFrameAttributeSafeTop:
                case SJFLFrameAttributeSafeLeft:
                case SJFLFrameAttributeSafeBottom:
                case SJFLFrameAttributeSafeRight: {
                    _values.safeAreaInsets = _dep_view.safeAreaInsets;
                    _values.has_safe_attr = YES;
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
    }
    return self;
}

- (UIView *_Nullable)tar_superview {
    return _tar_superview;
}

- (SJFLLayoutAttribute)tar_attr {
    return _values.tar_attr;
}

- (UIView *_Nullable)dep_view {
    return _dep_view;
}

- (UIView *_Nullable)tar_view {
    return _tar_view;
}

- (CGFloat)value:(CGRect)frame {
    CGFloat value = _values.value;
    
    CGRect dep_frame = (_values.is_dep_self)?frame:_dep_view.frame;
    BOOL isChanged_depFrame = !CGRectEqualToRect(dep_frame, _values.dep_frame);
    if ( isChanged_depFrame ) _values.dep_frame = dep_frame;
    
    CGRect super_frame = _tar_superview.frame;
    BOOL isChanged_superFrame = !CGRectEqualToRect(super_frame, _values.super_frame);
    if ( isChanged_superFrame ) _values.super_frame = super_frame;
    
    CGFloat offset = self.offset;
    BOOL isChanged_offset = offset != _values.offset;
    if ( isChanged_offset ) _values.offset = offset;
    
    BOOL isChanged_safeArea = NO;
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if ( @available(iOS 11.0, *) ) {
        if ( _values.has_safe_attr ) {
            safeAreaInsets = _dep_view.safeAreaInsets;
            isChanged_safeArea = !UIEdgeInsetsEqualToEdgeInsets(_values.safeAreaInsets, safeAreaInsets);
            if ( isChanged_safeArea ) _values.safeAreaInsets = safeAreaInsets;
        }
    }
    
    if ( isChanged_depFrame || isChanged_superFrame || isChanged_offset || isChanged_safeArea ) {
        // value = dependent_value * multiplier + offset
        _values.value = value = ceil(self.dep_value * _target->multiplier + offset);
    }
    return value;
}

- (CGFloat)dep_value {
    CGFloat dep_value = 0;
    if ( _values.dep_attr != SJFLFrameAttributeNone ) {
        SJFLLayoutAttribute tar_attr = _values.tar_attr;
        SJFLFrameAttribute dep_attr = _values.dep_attr;
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
                            dep_value = _values.dep_frame.size.width;
                        }
                            break;
                        case SJFLLayoutAttributeHeight: {
                            dep_value = _values.dep_frame.size.height;
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
                            if (@available(iOS 11.0, *)) {
                                point = CGPointMake(0, _values.safeAreaInsets.top);
                            }
                            break;
                        case SJFLLayoutAttributeCenterY:
                            point = CGPointMake(0, _values.dep_frame.size.height * 0.5);
                            break;
                        case SJFLLayoutAttributeBottom:
                            point = CGPointMake(0, _values.dep_frame.size.height);
                            break;
                        case SJFLFrameAttributeSafeBottom:
                            if (@available(iOS 11.0, *)) {
                                point = CGPointMake(0, _values.dep_frame.size.height - _values.safeAreaInsets.bottom);
                            }
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
                            if (@available(iOS 11.0, *)) {
                                point = CGPointMake(_values.safeAreaInsets.left, 0);
                            }
                            break;
                        case SJFLLayoutAttributeCenterX:
                            point = CGPointMake(_values.dep_frame.size.width * 0.5, 0);
                            break;
                        case SJFLLayoutAttributeRight:
                            point = CGPointMake(_values.dep_frame.size.width, 0);
                            break;
                        case SJFLFrameAttributeSafeRight:
                            if (@available(iOS 11.0, *)) {
                                point = CGPointMake(_values.dep_frame.size.width - _values.safeAreaInsets.right, 0);
                            }
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
    else if ( _values.dep_attr == SJFLFrameAttributeNone ) {
        if ( _target->offset_t == SJFLCGSizeValue ) {
            switch ( _values.tar_attr ) {
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
                if ( _values.dep_attr == SJFLFrameAttributeTop || _values.dep_attr == SJFLFrameAttributeBottom )
                    return _target->offset.point.y;
                if ( _values.dep_attr == SJFLFrameAttributeLeft || _values.dep_attr == SJFLFrameAttributeRight )
                    return _target->offset.point.x;
            }
                break;
            case SJFLCGSizeValue: {
                if ( _values.dep_attr == SJFLFrameAttributeWidth )
                    return _target->offset.size.width;
                if ( _values.dep_attr == SJFLFrameAttributeHeight )
                    return _target->offset.size.height;
            }
                break;
            case SJFLUIEdgeInsetsValue: {
                if ( _values.dep_attr == SJFLFrameAttributeTop )
                    return _target->offset.edges.top;
                if ( _values.dep_attr == SJFLFrameAttributeLeft )
                    return _target->offset.edges.left;
                if ( _values.dep_attr == SJFLFrameAttributeBottom )
                    return -_target->offset.edges.bottom;
                if ( _values.dep_attr == SJFLFrameAttributeRight )
                    return -_target->offset.edges.right;
            }
                break;
        }
    }
    return 0;
}
@end
NS_ASSUME_NONNULL_END
