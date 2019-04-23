//
//  UIView+SJFLLayoutAttributeUnits.h
//  Pods
//
//  Created by 畅三江 on 2019/4/18.
//

#import "SJFLLayoutAttributeUnit.h"

NS_ASSUME_NONNULL_BEGIN
@interface UIView (SJFLLayoutAttributeUnits)
@property (nonatomic, strong, readonly) SJFLLayoutAttributeUnit *FL_topUnit;
@property (nonatomic, strong, readonly) SJFLLayoutAttributeUnit *FL_leftUnit;
@property (nonatomic, strong, readonly) SJFLLayoutAttributeUnit *FL_bottomUnit;
@property (nonatomic, strong, readonly) SJFLLayoutAttributeUnit *FL_rightUnit;
@property (nonatomic, strong, readonly) SJFLLayoutAttributeUnit *FL_widthUnit;
@property (nonatomic, strong, readonly) SJFLLayoutAttributeUnit *FL_heightUnit;
@property (nonatomic, strong, readonly) SJFLLayoutAttributeUnit *FL_centerXUnit;
@property (nonatomic, strong, readonly) SJFLLayoutAttributeUnit *FL_centerYUnit;
- (SJFLLayoutAttributeUnit *_Nullable)FL_attributeUnitForAttribute:(SJFLAttribute)attr;
- (void)FL_resetAttributeUnits;
@end
NS_ASSUME_NONNULL_END
