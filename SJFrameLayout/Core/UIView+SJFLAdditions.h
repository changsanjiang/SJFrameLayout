//
//  UIView+SJFLAdditions.h
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
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
- (SJFLAttributeUnit *_Nullable)FL_attributeUnitForAttribute:(SJFLAttribute)attr;
- (void)FL_reset;
@end
NS_ASSUME_NONNULL_END
