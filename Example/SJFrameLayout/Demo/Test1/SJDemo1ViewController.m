//
//  SJDemo1ViewController.m
//  SJFrameLayout_Example
//
//  Created by 畅三江 on 2019/4/23.
//  Copyright © 2019 changsanjiang@gmail.com. All rights reserved.
//

#import "SJDemo1ViewController.h"
#import <SJFrameLayout/SJFrameLayout.h>

NS_ASSUME_NONNULL_BEGIN
@interface SJDemo1ViewController ()
@property (nonatomic, strong, readonly) UIView *topView;
@property (nonatomic, strong, readonly) UIView *centerView;
@end

@implementation SJDemo1ViewController

- (void)_setupViews {
    self.title = @"demo 1";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _topView = [[UIView alloc] initWithFrame:CGRectZero];
    _topView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_topView];
    [_topView sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
        make.top.equalTo(self.view.FL_safeTop).offset(8);
        make.left.equalTo(self.view.FL_safeLeft).offset(8);
        make.right.equalTo(self.view.FL_safeRight).offset(-8);
        make.height.offset(80);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupViews];
}

+ (NSString *)routePath {
    return @"demos/1";
}

+ (void)handleRequestWithParameters:(nullable SJParameters)parameters topViewController:(UIViewController *)topViewController completionHandler:(nullable SJCompletionHandler)completionHandler {
    [topViewController.navigationController pushViewController:self.new animated:YES];
}
@end
NS_ASSUME_NONNULL_END
