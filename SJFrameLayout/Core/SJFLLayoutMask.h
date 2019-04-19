//
//  SJFLLayoutMask.h
//  Pods
//
//  Created by BlueDancer on 2019/4/19.
//

#import <Foundation/Foundation.h>
#import "SJFLLayoutMaskDefines.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFLLayoutMask : NSObject<SJFLLayoutProtocol>
- (instancetype)initWithAttributes:(SJFLAttributeMask)attrs;
- (instancetype)initWithAttribute:(SJFLAttribute)attr;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

// - handlers -
@property (nonatomic, copy, readonly) SJFLEqualToHandler equalTo;
@property (nonatomic, copy, readonly) SJFLOffsetHandler offset;

- (BOOL)layoutExistsForAttribtue:(SJFLAttribute)attr;
- (SJFLRecorder *)recorder;
@end
NS_ASSUME_NONNULL_END
