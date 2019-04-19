//
//  SJViewController.m
//  SJFrameLayout
//
//  Created by changsanjiang@gmail.com on 04/18/2019.
//  Copyright (c) 2019 changsanjiang@gmail.com. All rights reserved.
//

#import "SJViewController.h"
#import <Masonry.h>
#import <SJFrameLayout/UIView+SJFrameLayout.h>
#import <UIView+SJFLAdditions.h>
#import "SJTestView.h"
#import "SJTestSubView.h"
#import <MMPlaceHolder.h>

#define ViewCount (500)

@interface SJViewController ()

@end

@implementation SJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
//    [self.view showPlaceHolder];
}
- (IBAction)testmas:(id)sender {
    
    UIView *subview1 = [UIView new];
    subview1.backgroundColor = [UIColor redColor];
    [self.view addSubview:subview1];
    [subview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(40);
        make.left.offset(180);
        make.right.offset(-20);
        make.bottom.offset(-200);
    }];
    [subview1 showPlaceHolder];
    
    
    UIView *s2 = [UIView new];
    s2.backgroundColor = [UIColor greenColor];
    [subview1 addSubview:s2];
    [s2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-8);
        make.right.offset(-8);
        make.width.offset(50);
        make.height.offset(50);
    }];
    [s2 showPlaceHolder];
    
    UIView *s3 = [SJTestSubView new];
    s3.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:s3];
    [s3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(s2).offset(-8);
        make.right.equalTo(s2).offset(-8);
        make.width.offset(20);
        make.height.offset(20);
    }];
    
    
    
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
- (IBAction)testsj:(id)sender {
//    for ( int i = 0 ; i < ViewCount ; ++ i ) {
//        UIView *subview = [UIView new];
//        subview.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
//                                                  green:arc4random() % 256 / 255.0
//                                                   blue:arc4random() % 256 / 255.0
//                                                  alpha:1];
//        [self.view insertSubview:subview atIndex:0];
//
//        //        [subview mas_makeConstraints:^(MASConstraintMaker *make) {
//        //            make.top.left.offset(20);
//        //            make.bottom.right.offset(-20);
//        //        }];
//
//        [subview sj_makeFrameLayout:^(SJFLMaker * _Nonnull make) {
//            make.top.offset(20);
//            make.left.offset(20);
//            make.bottom.offset(-20);
//            make.right.offset(-20);
//
//
//        }];
//    }
    //
    
    
    
    UIView *subview1 = [UIView new];
    subview1.backgroundColor = [UIColor redColor];
    [self.view addSubview:subview1];
    [subview1 sj_makeFrameLayout:^(SJFLMaker * _Nonnull make) {
        make.top.offset(40);
        make.left.offset(180);
        make.right.offset(-20);
        make.bottom.offset(-200);
    }];
    [subview1 showPlaceHolder];
    
    
    UIView *s2 = [UIView new];
    [subview1 addSubview:s2];
    s2.backgroundColor = [UIColor greenColor];
    [s2 sj_makeFrameLayout:^(SJFLMaker * _Nonnull make) {
        make.bottom.offset(-8);
        make.right.offset(-8);
        make.width.offset(50);
        make.height.offset(50);
    }];
    [s2 showPlaceHolder];
    
    UIView *s3 = [SJTestSubView new];
    s3.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:s3];
    [s3 sj_makeFrameLayout:^(SJFLMaker * _Nonnull make) {
        make.bottom.equalTo(s2.FL_Bottom).offset(-8);
        make.right.equalTo(s2.FL_Right).offset(-8);
        make.width.offset(20);
        make.height.offset(20);
    }];
    
//    UIView *center = [UIView new];
//    center.backgroundColor = [UIColor purpleColor];
//    [self.view addSubview:center];
//    [center sj_makeFrameLayout:^(SJFLMaker * _Nonnull make) {
//        make.width.offset(20);
//        make.height.offset(20);
//        make.centerX.offset(100);
//        make.centerY.offset(100);
//
////        make.top.left.right.height.offset(20)
//    }];
    
    //
//        UIView *subview2 = [UIView new];
//        [subview1 addSubview:subview2];
//        subview2.backgroundColor = [UIColor greenColor];
//        [subview2 sj_makeFrameLayout:^(SJFLMaker * _Nonnull make) {
//            make.width.offset(100);
//            make.height.offset(100);
//            make.centerX.offset(0);
////            make.centerY.offset(0);
//            make.top.equalTo(self.view.FL_Top).offset(8);
//
////            make.centerX.equalTo(self.view.FL_CenterX);
////            make.centerY.equalTo(self.view.FL_CenterY);
//
////            make.centerX.equalTo(center.FL_CenterX);
////            make.centerY.equalTo(center.FL_CenterY);
//
////            make.top.offset(8);
////            make.left.offset(8);
////            make.right.offset(-8);
////            make.bottom.offset(-8);
//        }];
//            [subview2 showPlaceHolder];
//
//    NSLog(@"%p - %p", self.view, subview2);
//
//
//
//
//
//        UIView *subview3 = [SJTestSubView new];
//        [subview2 addSubview:subview3];
//        subview3.backgroundColor = [UIColor blackColor];
//        [subview3 sj_makeFrameLayout:^(SJFLMaker * _Nonnull make) {
//            make.bottom.offset(0);
//            make.right.offset(0);
//            make.width.offset(50);
//            make.height.offset(50);
//        }];
//
//        [subview3 showPlaceHolder];
    
    [self.view showPlaceHolder];

}
- (IBAction)clean:(id)sender {
    
    for (UIView *sub in self.view.subviews) {
        if ( ![sub isKindOfClass:[UIButton class]] ) {
            [sub removeFromSuperview];
        }
    }
}

@end
