//
//  SJFLAttributesDefines.h
//  Pods
//
//  Created by 畅三江 on 2019/4/24.
//

#ifndef SJFLAttributesDefines_h
#define SJFLAttributesDefines_h
#import "SJFLFrameAttributesDefines.h"
#import "SJFLLayoutAttributesDefines.h"

typedef NSString *SJFLLayoutAttributeKey;
static SJFLLayoutAttributeKey const SJFLLayoutAttributeKeyNone = @"N";
static SJFLLayoutAttributeKey const SJFLLayoutAttributeKeyTop = @"T";
static SJFLLayoutAttributeKey const SJFLLayoutAttributeKeyLeft = @"L";
static SJFLLayoutAttributeKey const SJFLLayoutAttributeKeyBottom = @"B";
static SJFLLayoutAttributeKey const SJFLLayoutAttributeKeyRight = @"R";
static SJFLLayoutAttributeKey const SJFLLayoutAttributeKeyWidth = @"W";
static SJFLLayoutAttributeKey const SJFLLayoutAttributeKeyHeight = @"H";
static SJFLLayoutAttributeKey const SJFLLayoutAttributeKeyCenterX = @"CX";
static SJFLLayoutAttributeKey const SJFLLayoutAttributeKeyCenterY = @"CY";

UIKIT_STATIC_INLINE SJFLLayoutAttribute
SJFLLayoutAttributeForFrameAttribute(SJFLFrameAttribute frameAttribute) {
    switch ( frameAttribute ) {
        case SJFLFrameAttributeNone:
        case SJFLFrameAttributeTop:
        case SJFLFrameAttributeLeft:
        case SJFLFrameAttributeBottom:
        case SJFLFrameAttributeRight:
        case SJFLFrameAttributeWidth:
        case SJFLFrameAttributeHeight:
        case SJFLFrameAttributeCenterX:
        case SJFLFrameAttributeCenterY:
            return (SJFLLayoutAttribute)frameAttribute;
        case SJFLFrameAttributeSafeTop:
            return SJFLLayoutAttributeTop;
        case SJFLFrameAttributeSafeLeft:
            return SJFLLayoutAttributeLeft;
        case SJFLFrameAttributeSafeBottom:
            return SJFLLayoutAttributeBottom;
        case SJFLFrameAttributeSafeRight:
            return SJFLLayoutAttributeRight;
    }
}
#endif /* SJFLAttributesDefines_h */
