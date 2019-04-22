//
//  SJViewController.m
//  SJFrameLayout
//
//  Created by changsanjiang@gmail.com on 04/18/2019.
//  Copyright (c) 2019 changsanjiang@gmail.com. All rights reserved.
//

#import "SJViewController.h"
#import <Masonry.h>
#if __has_include(<SDAutoLayout/SDAutoLayout.h>)
#import <SDAutoLayout/SDAutoLayout.h>
#endif
#import "SJTestView.h"
#import "SJTestSubView.h"
#import "SJTestView2.h"
#import <SJFrameLayout.h>
//#import <MMPlaceHolder.h>
#import "SJTestLabel.h"


#define ViewCount (500)

@interface SJViewController ()
@property (nonatomic, strong) UIView *testView;
@property (nonatomic, strong) SJTestLabel *testLabel;
@end

@implementation SJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.FL_elements = nil;
    self.view.backgroundColor = [UIColor blackColor];
//    [self.view showPlaceHolder];
    
    _testLabel = [[SJTestLabel alloc] initWithFrame:CGRectZero];
    _testLabel.backgroundColor = [UIColor greenColor];
    _testLabel.numberOfLines = 0;
//    _testLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_testLabel];
    [_testLabel sj_makeFrameLayout:^(SJFLMaker * _Nonnull make) {
        make.left.bottom.offset(0);
//        make.height.offset(80);
    }];
}
- (IBAction)testmas:(id)sender {
    NSArray *arr = @[@"SDAutoLayout/SDAutoLayout.h", @"MMPlaceHolder.h", @"make.height.offset(80);", @"#if __has_include(<SDAutoLayout/SDAutoLayout.h>)"];
    self->_testLabel.text = [NSString stringWithFormat:@"%@", arr[arc4random()%arr.count]];
    return;
    
    
    UIView *subview1 = [UIView new];
    subview1.backgroundColor = [UIColor redColor];
    [self.view addSubview:subview1];
    [subview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(40);
        make.left.offset(180);
        make.right.offset(-20);
        make.bottom.offset(-200);
    }];
    
    UIView *sub = [UIView new];
    sub.backgroundColor = [UIColor greenColor];
    [self.view addSubview:sub];
    
    [sub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(subview1).offset(8);
        make.width.equalTo(subview1).multipliedBy(0.5).offset(20);
        make.height.equalTo(subview1).multipliedBy(0.5).offset(20);
    }];
    
//    for ( int i = 0 ; i < ViewCount ; ++ i ) {
//        UIView *s = [UIView new];
//        s.backgroundColor =  [UIColor colorWithRed:arc4random() % 256 / 255.0
//                                             green:arc4random() % 256 / 255.0
//                                              blue:arc4random() % 256 / 255.0
//                                             alpha:1];
//        [self.view.subviews.lastObject addSubview:s];
//        [s mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(subview1).offset(8 + i);
//            make.left.equalTo(subview1).offset(8 + i);
//            make.right.equalTo(subview1).offset(-(8 + i));
//            make.bottom.equalTo(subview1).offset(-(8 + i));
////            make.bottom.mas_offset(@(2));
////            make.edges.equalTo(self.view);
//        }];
//    }
    
    
//    UIView *subview1 = [UIView new];
//    subview1.backgroundColor = [UIColor redColor];
//    [self.view addSubview:subview1];
//    [subview1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(40);
//        make.left.offset(180);
//        make.right.offset(-20);
//        make.bottom.offset(-200);
//    }];
//    [subview1 showPlaceHolder];
//
//
//    UIView *s2 = [UIView new];
//    s2.backgroundColor = [UIColor greenColor];
//    [subview1 addSubview:s2];
//    [s2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.offset(-8);
//        make.right.offset(-8);
//        make.width.offset(50);
//        make.height.offset(50);
//    }];
//    [s2 showPlaceHolder];
//
//    UIView *s3 = [SJTestSubView new];
//    s3.backgroundColor = [UIColor purpleColor];
//    [self.view addSubview:s3];
//    [s3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(s2).offset(-8);
//        make.right.equalTo(s2).offset(-8);
//        make.width.offset(20);
//        make.height.offset(20);
//    }];
//
    
    
//    for ( int i = 0 ; i < ViewCount ; ++ i ) {
//        UIView *subview = [UIView new];
//        subview.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
//                                                  green:arc4random() % 256 / 255.0
//                                                   blue:arc4random() % 256 / 255.0
//                                                  alpha:1];
//        [self.view insertSubview:subview atIndex:0];
//
//        [subview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.offset(20);
//            make.bottom.right.offset(-20);
//        }];
//    }
    
//        UIView *subview1 = [UIView new];
//        [self.view addSubview:subview1];
//
//
//        subview1.backgroundColor = [UIColor redColor];
//        [subview1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.offset(40);
//            make.left.offset(20);
//            make.right.offset(-20);
//            make.bottom.offset(-20);
//        }];
//        [subview1 showPlaceHolder];
    //
    //    UIView *subview2 = [UIView new];
    //    [subview1 addSubview:subview2];
    //    subview2.backgroundColor = [UIColor greenColor];
    //    [subview2 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.left.offset(8);
    //        make.bottom.right.offset(-8);
    //    }];
    //
    //    //    [subview2 showPlaceHolder];
    //
    //    UIView *subview3 = [SJTestSubView new];
    //    [subview2 addSubview:subview3];
    //    subview3.backgroundColor = [UIColor blackColor];
    //    [subview3 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.offset(8);
    //        make.left.offset(16);
    //        make.width.offset(50);
    //        make.height.offset(50);
    //    }];
    //
    //    [subview3 showPlaceHolder];

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
    .widthIs(800)
    .heightIs(800);
    
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
    [subview1 sj_makeFrameLayout:^(SJFLMaker * _Nonnull make) {
//        make.top.offset(40);
//        make.left.offset(0);
        make.center.offset(0);
//        make.right.offset(-20);
//        make.bottom.offset(-200);
    }];
    
    UIView *ss = [UIView new];
    ss.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
                                         green:arc4random() % 256 / 255.0
                                          blue:arc4random() % 256 / 255.0
                                         alpha:1];
    [subview1 addSubview:ss];

    [ss sj_makeFrameLayout:^(SJFLMaker * _Nonnull make) {
        make.edges.box_equalTo(UIEdgeInsetsMake(8, 8, -8, -8));
        make.size.offset(800);
    }];

    for ( int i = 0 ; i < ViewCount ; ++ i ) {
        UIView *a = [UIView new];
        a.backgroundColor =  [UIColor colorWithRed:arc4random() % 256 / 255.0
                                             green:arc4random() % 256 / 255.0
                                              blue:arc4random() % 256 / 255.0
                                             alpha:1];
        [ss addSubview:a];

        [a sj_makeFrameLayout:^(SJFLMaker * _Nonnull make) {
            make.edges.box_equalTo(UIEdgeInsetsMake(8 + i, 8 + i, -(8 + i), -(8 + i)));
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
