//
//  SJFLRecorder.h
//  Pods
//
//  Created by BlueDancer on 2019/4/19.
//

#import <Foundation/Foundation.h>
@class SJFLAttributeUnit;

NS_ASSUME_NONNULL_BEGIN
@interface SJFLRecorder : NSObject {
    @public
    SJFLAttributeUnit *_Nullable FL_dependency;
    CGFloat FL_offset;
}
@end
NS_ASSUME_NONNULL_END
