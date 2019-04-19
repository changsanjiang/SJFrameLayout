//
//  SJTestView.m
//  SJFrameLayout_Example
//
//  Created by BlueDancer on 2019/4/18.
//  Copyright © 2019 changsanjiang@gmail.com. All rights reserved.
//

#import "SJTestView.h"

@implementation SJTestView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"%d - %s", (int)__LINE__, __func__);
#endif
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    NSLog(@"%@", self);
}

@end
