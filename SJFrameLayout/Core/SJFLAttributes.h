//
//  SJFLAttributes.h
//  Pods
//
//  Created by 畅三江 on 2019/4/23.
//

#ifndef SJFLAttributes_h
#define SJFLAttributes_h

typedef enum : NSUInteger {
    SJFLAttributeNone,
    SJFLAttributeTop,
    SJFLAttributeLeft,
    SJFLAttributeBottom,
    SJFLAttributeRight,
    SJFLAttributeWidth,
    SJFLAttributeHeight,
    SJFLAttributeCenterX,
    SJFLAttributeCenterY
} SJFLAttribute;

typedef enum : NSUInteger {
    SJFLAttributeMaskNone = 1 << SJFLAttributeNone,
    SJFLAttributeMaskTop = 1 << SJFLAttributeTop,
    SJFLAttributeMaskLeft = 1 << SJFLAttributeLeft,
    SJFLAttributeMaskBottom = 1 << SJFLAttributeBottom,
    SJFLAttributeMaskRight = 1 << SJFLAttributeRight,
    SJFLAttributeMaskWidth = 1 << SJFLAttributeWidth,
    SJFLAttributeMaskHeight = 1 << SJFLAttributeHeight,
    SJFLAttributeMaskCenterX = 1 << SJFLAttributeCenterX,
    SJFLAttributeMaskCenterY = 1 << SJFLAttributeCenterY,
    SJFLAttributeMaskEdges = SJFLAttributeMaskTop | SJFLAttributeMaskLeft | SJFLAttributeMaskBottom | SJFLAttributeMaskRight,
    SJFLAttributeMaskCenter = SJFLAttributeMaskCenterX | SJFLAttributeMaskCenterY,
    SJFLAttributeMaskSize = SJFLAttributeMaskWidth | SJFLAttributeMaskHeight,
    SJFLAttributeMaskAll = SJFLAttributeMaskNone | SJFLAttributeMaskEdges | SJFLAttributeMaskSize | SJFLAttributeMaskCenter
} SJFLAttributeMask;

#endif /* SJFLAttributes_h */
