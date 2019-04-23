//
//  SJDemoItem.m
//  SJFrameLayout_Example
//
//  Created by 畅三江 on 2019/4/23.
//  Copyright © 2019 changsanjiang@gmail.com. All rights reserved.
//

#import "SJDemoItem.h"

@implementation SJDemoItem
+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle routePath:(NSString *)routePath {
    SJDemoItem *item = [SJDemoItem new];
    item.title = title;
    item.subtitle = subtitle;
    item.routePath = routePath;
    return item;
}
@end
