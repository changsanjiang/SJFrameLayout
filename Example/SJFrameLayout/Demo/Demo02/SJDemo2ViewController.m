//
//  SJDemo2ViewController.m
//  SJFrameLayout_Example
//
//  Created by BlueDancer on 2019/4/24.
//  Copyright © 2019 changsanjiang@gmail.com. All rights reserved.
//

#import "SJDemo2ViewController.h"
#import <SJFrameLayout/SJFrameLayout.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

#define SubviewCount    (500)
#define Multiplier      (3)

@interface SJDemo2ViewController ()

@end

@implementation SJDemo2ViewController

- (IBAction)test:(id)sender {
    UIView *root = [UIView new];
    root.backgroundColor =  [UIColor colorWithRed:arc4random() % 256 / 255.0
                                            green:arc4random() % 256 / 255.0
                                             blue:arc4random() % 256 / 255.0
                                            alpha:1];
    [self.view addSubview:root];
    [root sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
        make.center.offset(0);
    }];
    
    
    UIView *container = [UIView new];
    container.backgroundColor =  [UIColor colorWithRed:arc4random() % 256 / 255.0
                                                 green:arc4random() % 256 / 255.0
                                                  blue:arc4random() % 256 / 255.0
                                                 alpha:1];
    [root addSubview:container];
    [container sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
        make.edges.box_equalTo(UIEdgeInsetsMake(8, 8, 8, 8));
        make.width.equalTo(self.view).multipliedBy(Multiplier);
        make.height.equalTo(container.FL_width);
    }];
    
    for ( int i = 0 ; i < SubviewCount ; ++ i ) {
        UIView *sub = [UIView new];
        sub.backgroundColor =   [UIColor colorWithRed:arc4random() % 256 / 255.0
                                                green:arc4random() % 256 / 255.0
                                                 blue:arc4random() % 256 / 255.0
                                                alpha:1];
        [container addSubview:sub];
        [sub sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
            CGFloat inset = 8 + i;
            make.edges.box_equalTo(UIEdgeInsetsMake(inset, inset, inset, inset));
        }];
    }
}

- (IBAction)testMas:(id)sender {
    UIView *root = [UIView new];
    root.backgroundColor =  [UIColor colorWithRed:arc4random() % 256 / 255.0
                                            green:arc4random() % 256 / 255.0
                                             blue:arc4random() % 256 / 255.0
                                            alpha:1];
    [self.view addSubview:root];
    [root mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
    
    UIView *container = [UIView new];
    container.backgroundColor =  [UIColor colorWithRed:arc4random() % 256 / 255.0
                                                 green:arc4random() % 256 / 255.0
                                                  blue:arc4random() % 256 / 255.0
                                                 alpha:1];
    [root addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 8, 8, 8));
        make.width.equalTo(self.view).multipliedBy(Multiplier);
        make.height.equalTo(container.mas_width);
    }];
    
    for ( int i = 0 ; i < SubviewCount ; ++ i ) {
        UIView *sub = [UIView new];
        sub.backgroundColor =   [UIColor colorWithRed:arc4random() % 256 / 255.0
                                                green:arc4random() % 256 / 255.0
                                                 blue:arc4random() % 256 / 255.0
                                                alpha:1];
        [container addSubview:sub];
        [sub mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat inset = 8 + i;
            make.edges.mas_equalTo(UIEdgeInsetsMake(inset, inset, inset, inset));
        }];
    }

}


- (void)_setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupViews];
}

+ (NSString *)routePath {
    return @"demos/2";
}

+ (void)handleRequestWithParameters:(nullable SJParameters)parameters topViewController:(UIViewController *)topViewController completionHandler:(nullable SJCompletionHandler)completionHandler {
    [topViewController.navigationController pushViewController:self.new animated:YES];
}

- (instancetype)initWithNibName:(NSString *_Nullable)nibNameOrNil bundle:(NSBundle *_Nullable)nibBundleOrNil {
    self = [super initWithNibName:@"SJDemo2ViewController" bundle:nil];
    if ( self ) {}
    return self;
}
@end
NS_ASSUME_NONNULL_END
