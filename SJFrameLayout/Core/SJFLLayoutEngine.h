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
typedef NSDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *SJFL_ElementsMap_t;
typedef NSMutableDictionary<SJFLLayoutAttributeKey, SJFLLayoutElement *> *SJFL_ElementsMutableMap_t;

UIKIT_EXTERN void
SJFL_InstallLayouts(UIView *layoutView, SJFL_ElementsMap_t elements);

UIKIT_EXTERN void
SJFL_updateLayouts(UIView *layoutView, SJFL_ElementsMap_t elements);

UIKIT_EXTERN void
SJFL_RemoveLayouts(UIView *layoutView);

UIKIT_EXTERN void
SJFL_LayoutIfNeeded(UIView *layoutView);
NS_ASSUME_NONNULL_END
