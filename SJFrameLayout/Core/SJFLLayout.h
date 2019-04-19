//
//  SJFLLayout.h
//  Pods
//
//  Created by BlueDancer on 2019/4/19.
//

#import <Foundation/Foundation.h>
#import "SJFLAttributeUnit.h"
@class SJFLRecorder, SJFLLayout;

NS_ASSUME_NONNULL_BEGIN
typedef SJFLLayout *_Nonnull(^SJFLEqualToHandler)(id layout);
typedef void(^SJFLOffsetHandler)(CGFloat offset);

@interface SJFLLayout : NSObject
- (instancetype)initWithAttribute:(SJFLAttribute)attr;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

// - edges -
@property (nonatomic, strong, readonly) SJFLLayout *top;
@property (nonatomic, strong, readonly) SJFLLayout *left;
@property (nonatomic, strong, readonly) SJFLLayout *bottom;
@property (nonatomic, strong, readonly) SJFLLayout *right;

// - size -
@property (nonatomic, strong, readonly) SJFLLayout *width;
@property (nonatomic, strong, readonly) SJFLLayout *height;

// - center -
@property (nonatomic, strong, readonly) SJFLLayout *centerX;
@property (nonatomic, strong, readonly) SJFLLayout *centerY;

// - handlers -
@property (nonatomic, copy, readonly) SJFLEqualToHandler equalTo;
@property (nonatomic, copy, readonly) SJFLOffsetHandler offset;

- (BOOL)layoutExistsForAttribtue:(SJFLAttribute)attr;
- (SJFLRecorder *)recorder;
@end
NS_ASSUME_NONNULL_END
