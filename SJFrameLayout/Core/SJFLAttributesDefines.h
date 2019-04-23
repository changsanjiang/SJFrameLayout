//
//  SJFLAttributesDefines.h
//  Pods
//
//  Created by 畅三江 on 2019/4/23.
//

#ifndef SJFLAttributesDefines_h
#define SJFLAttributesDefines_h

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    SJFLLayoutAttributeNone,
    SJFLLayoutAttributeTop,
    SJFLLayoutAttributeLeft,
    SJFLLayoutAttributeBottom,
    SJFLLayoutAttributeRight,
    SJFLLayoutAttributeWidth,
    SJFLLayoutAttributeHeight,
    SJFLLayoutAttributeCenterX,
    SJFLLayoutAttributeCenterY,
} SJFLLayoutAttribute;

typedef enum : NSUInteger {
    SJFLLayoutAttributeMaskNone = 1 << SJFLLayoutAttributeNone,
    SJFLLayoutAttributeMaskTop = 1 << SJFLLayoutAttributeTop,
    SJFLLayoutAttributeMaskLeft = 1 << SJFLLayoutAttributeLeft,
    SJFLLayoutAttributeMaskBottom = 1 << SJFLLayoutAttributeBottom,
    SJFLLayoutAttributeMaskRight = 1 << SJFLLayoutAttributeRight,
    SJFLLayoutAttributeMaskWidth = 1 << SJFLLayoutAttributeWidth,
    SJFLLayoutAttributeMaskHeight = 1 << SJFLLayoutAttributeHeight,
    SJFLLayoutAttributeMaskCenterX = 1 << SJFLLayoutAttributeCenterX,
    SJFLLayoutAttributeMaskCenterY = 1 << SJFLLayoutAttributeCenterY,
    SJFLLayoutAttributeMaskEdges = SJFLLayoutAttributeMaskTop | SJFLLayoutAttributeMaskLeft | SJFLLayoutAttributeMaskBottom | SJFLLayoutAttributeMaskRight,
    SJFLLayoutAttributeMaskCenter = SJFLLayoutAttributeMaskCenterX | SJFLLayoutAttributeMaskCenterY,
    SJFLLayoutAttributeMaskSize = SJFLLayoutAttributeMaskWidth | SJFLLayoutAttributeMaskHeight,
} SJFLLayoutAttributeMask;

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

typedef enum : NSUInteger {
    SJFLFrameAttributeNone = SJFLLayoutAttributeNone,
    SJFLFrameAttributeTop = SJFLLayoutAttributeTop,
    SJFLFrameAttributeLeft = SJFLLayoutAttributeLeft,
    SJFLFrameAttributeBottom = SJFLLayoutAttributeBottom,
    SJFLFrameAttributeRight = SJFLLayoutAttributeRight,
    SJFLFrameAttributeWidth = SJFLLayoutAttributeWidth,
    SJFLFrameAttributeHeight = SJFLLayoutAttributeHeight,
    SJFLFrameAttributeCenterX = SJFLLayoutAttributeCenterX,
    SJFLFrameAttributeCenterY = SJFLLayoutAttributeCenterY,
    
    SJFLFrameAttributeSafeTop,
    SJFLFrameAttributeSafeLeft,
    SJFLFrameAttributeSafeBottom,
    SJFLFrameAttributeSafeRight,
} SJFLFrameAttribute;

//UIKIT_STATIC_INLINE
//SJFLLayoutAttributeKey SJFLLayoutAttributeKeyForAttribute(SJFLLayoutAttribute attribtue) {
//    switch ( attribtue ) {
//        case SJFLLayoutAttributeNone:
//            return SJFLLayoutAttributeKeyNone;
//        case SJFLLayoutAttributeTop:
//            return SJFLLayoutAttributeKeyTop;
//        case SJFLLayoutAttributeLeft:
//            return SJFLLayoutAttributeKeyLeft;
//        case SJFLLayoutAttributeBottom:
//            return SJFLLayoutAttributeKeyBottom;
//        case SJFLLayoutAttributeRight:
//            return SJFLLayoutAttributeKeyRight;
//        case SJFLLayoutAttributeWidth:
//            return SJFLLayoutAttributeKeyWidth;
//        case SJFLLayoutAttributeHeight:
//            return SJFLLayoutAttributeKeyHeight;
//        case SJFLLayoutAttributeCenterX:
//            return SJFLLayoutAttributeKeyCenterX;
//        case SJFLLayoutAttributeCenterY:
//            return SJFLLayoutAttributeKeyCenterY;
//    }
//}

//UIKIT_STATIC_INLINE
//SJFLLayoutAttribute SJFLLayoutAttributeForAttributeKey(SJFLLayoutAttributeKey key) {
//    if ( key == SJFLLayoutAttributeKeyNone ) return SJFLLayoutAttributeNone;
//    if ( key == SJFLLayoutAttributeKeyTop ) return SJFLLayoutAttributeTop;
//    if ( key == SJFLLayoutAttributeKeyLeft ) return SJFLLayoutAttributeLeft;
//    if ( key == SJFLLayoutAttributeKeyBottom ) return SJFLLayoutAttributeBottom;
//    if ( key == SJFLLayoutAttributeKeyRight ) return SJFLLayoutAttributeRight;
//    if ( key == SJFLLayoutAttributeKeyWidth ) return SJFLLayoutAttributeWidth;
//    if ( key == SJFLLayoutAttributeKeyHeight ) return SJFLLayoutAttributeHeight;
//    if ( key == SJFLLayoutAttributeKeyCenterX ) return SJFLLayoutAttributeCenterX;
//    if ( key == SJFLLayoutAttributeKeyCenterY ) return SJFLLayoutAttributeCenterY;
//    return 0;
//}

NS_ASSUME_NONNULL_END
#endif /* SJFLAttributesDefines_h */
