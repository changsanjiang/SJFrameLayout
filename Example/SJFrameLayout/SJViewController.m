//
//  SJViewController.m
//  SJFrameLayout
//
//  Created by changsanjiang@gmail.com on 04/18/2019.
//  Copyright (c) 2019 changsanjiang@gmail.com. All rights reserved.
//

#import "SJViewController.h"
#if __has_include(<Masonry/Masonry.h>)
#import <Masonry.h>
#endif
#if __has_include(<SDAutoLayout/SDAutoLayout.h>)
#import <SDAutoLayout/SDAutoLayout.h>
#endif
#import "SJTestView.h"
#import "SJTestSubView.h"
#import "SJTestView2.h"
#import <SJFrameLayout.h>
//#import <MMPlaceHolder.h>
#import "SJTestLabel.h"
#import "SJTestButton.h"
#import "SJTestImageView.h"

#define ViewCount (1200)

@interface SJViewController ()
@property (nonatomic, strong) UIView *testView;
@property (nonatomic, strong) SJTestLabel *testLabel;
@property (nonatomic, strong) SJTestButton *testButton;
@end

@implementation SJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.FL_elements = nil;
    self.view.backgroundColor = [UIColor blackColor];
//    [self.view showPlaceHolder];
    
//    _testLabel = [[SJTestLabel alloc] initWithFrame:CGRectZero];
//    _testLabel.backgroundColor = [UIColor greenColor];
//    _testLabel.numberOfLines = 0;
////    _testLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:_testLabel];
//    [_testLabel sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
//        make.left.bottom.offset(0);
////        make.height.offset(80);
//    }];

    return;
    
    _testButton = [[SJTestButton alloc] initWithFrame:CGRectZero];
    _testButton.backgroundColor = [UIColor greenColor];
//    _testButton.titleLabel.numberOfLines = 0;
    [self.view addSubview:_testButton];
    
    [_testButton sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.bottom.offset(-40);
    }];
    
//    NSLog(@"%p", _testButton);
    
}
- (IBAction)testmas:(id)sender {
//    NSArray *arr = @[@"SDAutoLayout/SDAutoLayout.h", @"MMPlaceHolder.h", @"make.height.offset(80);", @"#if __has_include(<SDAutoLayout/SDAutoLayout.h>)"];
////    self->_testLabel.text = [NSString stringWithFormat:@"%@", arr[arc4random()%arr.count]];
//    [_testButton setTitle:arr[arc4random()%arr.count] forState:UIControlStateNormal];
//    return;
    
#if __has_include(<Masonry/Masonry.h>)
    UIView *subview1 = [SJTestView new];
    subview1.backgroundColor = [UIColor redColor];
    [self.view addSubview:subview1];
    [subview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.offset(40);
        //        make.left.offset(0);
        make.center.equalTo(self.view);
        make.size.offset(2500);
        //        make.right.offset(-20);
        //        make.bottom.offset(-200);
    }];
    
    UIView *ss = [UIView new];
    ss.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
                                         green:arc4random() % 256 / 255.0
                                          blue:arc4random() % 256 / 255.0
                                         alpha:1];
    [subview1 addSubview:ss];
    
    [ss mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 8, 8, 8));
//        make.size.offset(2500);
    }];
    
    for ( int i = 0 ; i < ViewCount ; ++ i ) {
        UIView *a = [UIView new];
        a.backgroundColor =  [UIColor colorWithRed:arc4random() % 256 / 255.0
                                             green:arc4random() % 256 / 255.0
                                              blue:arc4random() % 256 / 255.0
                                             alpha:1];
        [ss addSubview:a];

        [a mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(8 + i, 8 + i, 8 + i, 8 + i));
        }];
    }
#endif
}

- (IBAction)testSD:(id)sender {
#if __has_include(<SDAutoLayout/SDAutoLayout.h>)
    UIView *subview1 = [UIView new];
    subview1.backgroundColor =  [UIColor redColor];
    [self.view addSubview:subview1];
    
    subview1.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.view);
    
    UIView *ss = [UIView new];
    ss.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
                                         green:arc4random() % 256 / 255.0
                                          blue:arc4random() % 256 / 255.0
                                         alpha:1];
    [subview1 addSubview:ss];
    
    ss.sd_layout
    .topSpaceToView(subview1, 8)
    .leftSpaceToView(subview1, 8)
    .bottomSpaceToView(subview1, 8)
    .rightSpaceToView(subview1, 8)
    .widthIs(2500)
    .heightIs(2500);
    
    for ( int i = 0 ; i < ViewCount ; ++ i ) {
        UIView *a = [UIView new];
        a.backgroundColor =  [UIColor colorWithRed:arc4random() % 256 / 255.0
                                             green:arc4random() % 256 / 255.0
                                              blue:arc4random() % 256 / 255.0
                                             alpha:1];
        [ss addSubview:a];

        a.sd_layout
        .topSpaceToView(ss, 8 + i)
        .leftSpaceToView(ss, 8 + i)
        .bottomSpaceToView(ss, 8 + i)
        .rightSpaceToView(ss, 8 + i);
    }
#endif
}

- (IBAction)testsj:(id)sender {
    UIView *subview1 = [SJTestView new];
    subview1.backgroundColor = [UIColor redColor];
    [self.view addSubview:subview1];
    [subview1 sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
//        make.top.offset(40);
//        make.left.offset(0);
        make.center.equalTo(self.view);
//        make.right.offset(-20);
//        make.bottom.offset(-200);
    }];
    
    UIView *ss = [UIView new];
    ss.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
                                         green:arc4random() % 256 / 255.0
                                          blue:arc4random() % 256 / 255.0
                                         alpha:1];
    [subview1 addSubview:ss];

    [ss sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
        make.edges.box_equalTo(UIEdgeInsetsMake(8, 8, 8, 8));
        make.size.offset(2500);
    }];

    for ( int i = 0 ; i < ViewCount ; ++ i ) {
        UIView *a = [UIView new];
        a.backgroundColor =  [UIColor colorWithRed:arc4random() % 256 / 255.0
                                             green:arc4random() % 256 / 255.0
                                              blue:arc4random() % 256 / 255.0
                                             alpha:1];
        [ss addSubview:a];

        [a sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
            make.edges.box_equalTo(UIEdgeInsetsMake(8 + i, 8 + i, 8 + i, 8 + i));
        }];
    }
}
- (IBAction)clean:(id)sender {
    
    for (UIView *sub in self.view.subviews) {
        if ( ![sub isKindOfClass:[UIButton class]] ) {
            [sub removeFromSuperview];
        }
    }
}
- (IBAction)fl:(id)sender {

}


@end
