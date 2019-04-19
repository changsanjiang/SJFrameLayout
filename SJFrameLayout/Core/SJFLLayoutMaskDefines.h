//
//  SJFLLayoutMaskDefines.h
//  Pods
//
//  Created by BlueDancer on 2019/4/19.
//

#ifndef SJFLLayoutMaskDefines_h
#define SJFLLayoutMaskDefines_h
#import "SJFLAttributeUnit.h"
@class SJFLRecorder, SJFLLayoutMask;

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
    SJFLAttributeMaskEdge = SJFLAttributeMaskTop | SJFLAttributeMaskLeft | SJFLAttributeMaskBottom | SJFLAttributeMaskRight,
    SJFLAttributeMaskCenter = SJFLAttributeMaskCenterX | SJFLAttributeMaskCenterY,
    SJFLAttributeMaskSize = SJFLAttributeMaskWidth | SJFLAttributeMaskHeight,
    SJFLAttributeMaskAll = SJFLAttributeMaskNone | SJFLAttributeMaskEdge | SJFLAttributeMaskSize | SJFLAttributeMaskCenter
} SJFLAttributeMask;

NS_ASSUME_NONNULL_BEGIN
// - handlers -
typedef SJFLLayoutMask *_Nonnull(^SJFLEqualToHandler)(id layout);
typedef void(^SJFLOffsetHandler)(CGFloat offset);

@protocol SJFLLayoutProtocol <NSObject>
// - edges -
@property (nonatomic, strong, readonly) SJFLLayoutMask *top;
@property (nonatomic, strong, readonly) SJFLLayoutMask *left;
@property (nonatomic, strong, readonly) SJFLLayoutMask *bottom;
@property (nonatomic, strong, readonly) SJFLLayoutMask *right;
@property (nonatomic, strong, readonly) SJFLLayoutMask *edge;

// - size -
@property (nonatomic, strong, readonly) SJFLLayoutMask *width;
@property (nonatomic, strong, readonly) SJFLLayoutMask *height;
@property (nonatomic, strong, readonly) SJFLLayoutMask *size;

// - center -
@property (nonatomic, strong, readonly) SJFLLayoutMask *centerX;
@property (nonatomic, strong, readonly) SJFLLayoutMask *centerY;
@property (nonatomic, strong, readonly) SJFLLayoutMask *center;
@end
NS_ASSUME_NONNULL_END
#endif /* SJFLLayoutMaskDefines_h */
