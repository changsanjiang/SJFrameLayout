//
//  SJTestView.m
//  SJFrameLayout_Example
//
//  Created by 畅三江 on 2019/4/18.
//  Copyright © 2019 changsanjiang@gmail.com. All rights reserved.
//

#import "SJTestView.h"

@implementation SJTestView

//- (void)layoutSubviews {
//    [super layoutSubviews];
//#ifdef DEBUG
//    NSLog(@"%@", self);
//#endif
//}

#if 0
- (void)layoutSubviews {
    printf("\n %s: \t\t %p \t ==> Begin \t {%s}", NSStringFromClass(self.class).UTF8String, self, NSStringFromCGRect(self.frame).UTF8String);
    [super layoutSubviews];
    printf("\n %s: \t\t %p \t ==> End \t {%s}", NSStringFromClass(self.class).UTF8String, self, NSStringFromCGRect(self.frame).UTF8String);
}
#endif

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%d - %s", (int)__LINE__, __func__);
#endif
}

@end
