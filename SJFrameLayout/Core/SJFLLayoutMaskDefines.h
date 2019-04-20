//
//  SJFLLayoutMaskDefines.h
//  Pods
//
//  Created by 畅三江 on 2019/4/19.
//

#ifndef SJFLLayoutMaskDefines_h
#define SJFLLayoutMaskDefines_h
#import "SJFLAttributeUnit.h"
#import "SJFLBoxValue.h"
@class SJFLLayoutMask;

NS_ASSUME_NONNULL_BEGIN
@protocol SJFLLayoutProtocol <NSObject>
// - edges -
@property (nonatomic, strong, readonly) SJFLLayoutMask *top;
@property (nonatomic, strong, readonly) SJFLLayoutMask *left;
@property (nonatomic, strong, readonly) SJFLLayoutMask *bottom;
@property (nonatomic, strong, readonly) SJFLLayoutMask *right;
@property (nonatomic, strong, readonly) SJFLLayoutMask *edges;

// - size -
@property (nonatomic, strong, readonly) SJFLLayoutMask *width;
@property (nonatomic, strong, readonly) SJFLLayoutMask *height;
@property (nonatomic, strong, readonly) SJFLLayoutMask *size;

// - center -
@property (nonatomic, strong, readonly) SJFLLayoutMask *centerX;
@property (nonatomic, strong, readonly) SJFLLayoutMask *centerY;
@property (nonatomic, strong, readonly) SJFLLayoutMask *center;
@end

typedef SJFLLayoutMask *_Nonnull(^SJFLEqualToHandler)(id);
typedef void(^SJFLOffsetHandler)(CGFloat);

typedef SJFLLayoutMask *_Nonnull(^SJFLBoxEqualToHandler)(id);
typedef void(^SJFLBoxOffsetHandler)(id);


#define box_equalTo(...)                 equalTo(SJFLBoxValue((__VA_ARGS__)))
#define box_offset(...)                  box_offset(SJFLBoxValue((__VA_ARGS__)))

// - handlers -
@protocol SJFLLayoutUpdaterProtocol <NSObject>
@property (nonatomic, copy, readonly) SJFLEqualToHandler equalTo;
@property (nonatomic, copy, readonly) SJFLOffsetHandler offset;
@property (nonatomic, copy, readonly) SJFLEqualToHandler box_equalTo;
@property (nonatomic, copy, readonly) SJFLBoxOffsetHandler box_offset;
@end
NS_ASSUME_NONNULL_END
#endif /* SJFLLayoutMaskDefines_h */
