//
//  SJFLLayoutMask.h
//  Pods
//
//  Created by BlueDancer on 2019/4/19.
//

#import <Foundation/Foundation.h>
#import "SJFLAttributeUnit.h"
@class SJFLRecorder, SJFLLayoutMask;

NS_ASSUME_NONNULL_BEGIN
typedef SJFLLayoutMask *_Nonnull(^SJFLEqualToHandler)(id layout);
typedef void(^SJFLOffsetHandler)(CGFloat offset);

@interface SJFLLayoutMask : NSObject
- (instancetype)initWithAttribute:(SJFLAttribute)attr;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

// - edges -
@property (nonatomic, strong, readonly) SJFLLayoutMask *top;
@property (nonatomic, strong, readonly) SJFLLayoutMask *left;
@property (nonatomic, strong, readonly) SJFLLayoutMask *bottom;
@property (nonatomic, strong, readonly) SJFLLayoutMask *right;

// - size -
@property (nonatomic, strong, readonly) SJFLLayoutMask *width;
@property (nonatomic, strong, readonly) SJFLLayoutMask *height;

// - center -
@property (nonatomic, strong, readonly) SJFLLayoutMask *centerX;
@property (nonatomic, strong, readonly) SJFLLayoutMask *centerY;

// - handlers -
@property (nonatomic, copy, readonly) SJFLEqualToHandler equalTo;
@property (nonatomic, copy, readonly) SJFLOffsetHandler offset;

- (BOOL)layoutExistsForAttribtue:(SJFLAttribute)attr;
- (SJFLRecorder *)recorder;
@end
NS_ASSUME_NONNULL_END
