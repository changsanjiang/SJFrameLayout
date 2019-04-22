//
//  SJTestSubView.m
//  SJFrameLayout_Example
//
//  Created by 畅三江 on 2019/4/18.
//  Copyright © 2019 changsanjiang@gmail.com. All rights reserved.
//

#import "SJTestSubView.h"

@implementation SJTestSubView

//- (void)layoutSubviews {
//    [super layoutSubviews];
//#ifdef DEBUG
//    NSLog(@"%@", self);
//#endif
//}

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%d - %s", (int)__LINE__, __func__);
#endif
}

@end
