//
//  SJFLLayoutAttributesDefines.h
//  Pods
//
//  Created by 畅三江 on 2019/4/23.
//

#ifndef SJFLLayoutAttributesDefines_h
#define SJFLLayoutAttributesDefines_h
#import "SJFLFrameAttributesDefines.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    SJFLLayoutAttributeNone = SJFLFrameAttributeNone,
    SJFLLayoutAttributeTop = SJFLFrameAttributeTop,
    SJFLLayoutAttributeLeft = SJFLFrameAttributeLeft,
    SJFLLayoutAttributeBottom = SJFLFrameAttributeBottom,
    SJFLLayoutAttributeRight = SJFLFrameAttributeRight,
    SJFLLayoutAttributeWidth = SJFLFrameAttributeWidth,
    SJFLLayoutAttributeHeight = SJFLFrameAttributeHeight,
    SJFLLayoutAttributeCenterX = SJFLFrameAttributeCenterX,
    SJFLLayoutAttributeCenterY = SJFLFrameAttributeCenterY,
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
NS_ASSUME_NONNULL_END
#endif /* SJFLLayoutAttributesDefines_h */
