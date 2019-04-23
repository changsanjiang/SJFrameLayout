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
@property (nonatomic, strong, readonly) UIView *labelTopView;
@property (nonatomic, strong, readonly) UILabel *centerLabel;
@property (nonatomic, strong, readonly) UIView *labelBottomView;
@property (nonatomic, strong, readonly) UIButton *button;
@property (nonatomic, strong, readonly) UIView *bottomView;
@end

@implementation SJDemo1ViewController

- (void)_setupViews {
    self.title = @"demo 1";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // - top -
    _topView = [[UIView alloc] initWithFrame:CGRectZero];
    _topView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_topView];
    [_topView sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
        make.top.equalTo(self.view.FL_safeTop).offset(8);
        make.left.equalTo(self.view.FL_safeLeft).offset(8);
        make.right.equalTo(self.view.FL_safeRight).offset(-8);
        make.height.offset(40);
    }];
    
    
    // - center -
    _centerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _centerLabel.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_centerLabel];
    _centerLabel.text = @"Hello world!";
    [_centerLabel sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
        make.center.offset(0);
    }];
    
    // - label top view -
    _labelTopView = [[UIView alloc] initWithFrame:CGRectZero];
    _labelTopView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_labelTopView];
    [_labelTopView sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
        make.bottom.equalTo(self.centerLabel.FL_top).offset(-8);
        make.left.equalTo(self.centerLabel);
        make.size.offset(16);
    }];
    
    // - label bottom view -
    _labelBottomView = [[UIView alloc] initWithFrame:CGRectZero];
    _labelBottomView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_labelBottomView];
    [_labelBottomView sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
        make.top.equalTo(self.centerLabel.FL_bottom).offset(8);
        make.right.equalTo(self.centerLabel);
        make.size.offset(16);
    }];
    
    // - button -
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button setTitle:@"change label text" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    [_button sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
        make.top.equalTo(self.labelBottomView.FL_bottom).offset(8);
        make.centerX.offset(0);
    }];
    
    // - bottom -
    _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_bottomView];
    [_bottomView sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
        make.left.equalTo(self.view.FL_safeLeft).offset(8);
        make.bottom.equalTo(self.view.FL_safeBottom).offset(-8);
        make.right.equalTo(self.view.FL_safeRight).offset(-8);
        make.height.offset(40);
    }];
}

- (void)clickedButton:(UIButton *)btn {
    NSArray *allText = @[@"Hello world!", @"十五年前, 一见钟情", @"一次邂逅, 遇见一生所爱"];
    static int a = 0;
    _centerLabel.text = allText[++a % allText.count];
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

- (instancetype)initWithNibName:(NSString *_Nullable)nibNameOrNil bundle:(NSBundle *_Nullable)nibBundleOrNil {
    self = [super initWithNibName:@"SJDemo1ViewController" bundle:nil];
    if ( self ) {}
    return self;
}
@end
NS_ASSUME_NONNULL_END
