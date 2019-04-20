//
//  SJTestSubView.m
//  SJFrameLayout_Example
//
//  Created by 畅三江 on 2019/4/18.
//  Copyright © 2019 changsanjiang@gmail.com. All rights reserved.
//

#import "SJTestSubView.h"

@implementation SJTestSubView

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

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    NSLog(@"%@", self);
}

@end
