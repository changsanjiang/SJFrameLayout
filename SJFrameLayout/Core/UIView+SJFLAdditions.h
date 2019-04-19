//
//  UIView+SJFLAdditions.h
//  Masonry
//
//  Created by BlueDancer on 2019/4/18.
//

#import "SJFLAttributeUnit.h"

NS_ASSUME_NONNULL_BEGIN
@interface UIView (SJFLAdditions)
@property (nonatomic, strong, readonly) SJFLAttributeUnit *FL_Top;
@property (nonatomic, strong, readonly) SJFLAttributeUnit *FL_Left;
@property (nonatomic, strong, readonly) SJFLAttributeUnit *FL_Bottom;
@property (nonatomic, strong, readonly) SJFLAttributeUnit *FL_Right;
@property (nonatomic, strong, readonly) SJFLAttributeUnit *FL_Width;
@property (nonatomic, strong, readonly) SJFLAttributeUnit *FL_Height;
@property (nonatomic, strong, readonly) SJFLAttributeUnit *FL_CenterX;
@property (nonatomic, strong, readonly) SJFLAttributeUnit *FL_CenterY;
@end
NS_ASSUME_NONNULL_END
