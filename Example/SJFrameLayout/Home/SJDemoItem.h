//
//  SJDemoItem.h
//  SJFrameLayout_Example
//
//  Created by 畅三江 on 2019/4/23.
//  Copyright © 2019 changsanjiang@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface SJDemoItem : NSObject
+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle routePath:(NSString *)routePath;
@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong, nullable) NSString *subtitle;
@property (nonatomic, strong, nullable) NSString *routePath;
@end
NS_ASSUME_NONNULL_END
