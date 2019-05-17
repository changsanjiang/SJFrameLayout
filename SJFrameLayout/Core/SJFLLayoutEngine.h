//
//  SJFLLayoutEngine.h
//  Pods
//
//  Created by BlueDancer on 2019/5/17.
//

#import <UIKit/UIKit.h>
#import "SJFLAttributesDefines.h"
#import "SJFLLayoutElement.h"

NS_ASSUME_NONNULL_BEGIN
typedef NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *SJFL_ElementsMap;

UIKIT_EXTERN void
SJFL_InstallLayout(UIView *layoutView, SJFL_ElementsMap elements);

UIKIT_EXTERN void
SJFL_RemoveLayout(UIView *layoutView);

UIKIT_EXTERN void
SJFL_LayoutIfNeeded(UIView *layoutView);
NS_ASSUME_NONNULL_END
