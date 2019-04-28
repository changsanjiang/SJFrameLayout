//
//  SJDemo03ViewController.m
//  SJFrameLayout_Example
//
//  Created by BlueDancer on 2019/4/25.
//  Copyright © 2019 changsanjiang@gmail.com. All rights reserved.
//

#import "SJDemo03ViewController.h"
#import "SJTestView.h"
#import "SJTestView2.h"
#import "SJTestSubView.h"

#if __has_include(<SJFrameLayout/SJFrameLayout.h>)
#import <SJFrameLayout/SJFrameLayout.h>
#endif

NS_ASSUME_NONNULL_BEGIN
@interface SJDemo03ViewController ()
@property (nonatomic, strong) SJTestSubView *sub;
@property (nonatomic, strong) SJTestSubView *sub2;
@end

@implementation SJDemo03ViewController
static CGFloat inset = 8;
- (IBAction)test1:(id)sender {
    SJTestView *root = [SJTestView new];
    root.backgroundColor =  [UIColor colorWithRed:arc4random() % 256 / 255.0
                                            green:arc4random() % 256 / 255.0
                                             blue:arc4random() % 256 / 255.0
                                            alpha:1];
    [self.view addSubview:root];
    
#if __has_include(<SJFrameLayout/SJFrameLayout.h>)
    [root sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
        make.size.offset(200);
        make.top.equalTo(self.view.FL_safeTop).offset(8);
        make.centerX.offset(0);
    }];
#endif
    
    SJTestView2 *mid = [SJTestView2 new];
    mid.backgroundColor =  [UIColor colorWithRed:arc4random() % 256 / 255.0
                                           green:arc4random() % 256 / 255.0
                                            blue:arc4random() % 256 / 255.0
                                           alpha:1];
    [root addSubview:mid];
#if __has_include(<SJFrameLayout/SJFrameLayout.h>)
    [mid sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
        make.edges.box_offset(UIEdgeInsetsMake(2, 2, 2, 2));
    }];
#endif
    
    _sub = [SJTestSubView new];
    _sub.backgroundColor =  [UIColor colorWithRed:arc4random() % 256 / 255.0
                                           green:arc4random() % 256 / 255.0
                                            blue:arc4random() % 256 / 255.0
                                           alpha:1];
    [mid addSubview:_sub];
#if __has_include(<SJFrameLayout/SJFrameLayout.h>)
    [_sub sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
        make.top.left.offset(inset);
        make.right.offset(-inset);
        make.bottom.equalTo(mid.FL_centerY).offset(-inset * 0.5);
    }];
#endif
    
    _sub2 = [SJTestSubView new];
    _sub2.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
                                            green:arc4random() % 256 / 255.0
                                             blue:arc4random() % 256 / 255.0
                                            alpha:1];
    [mid addSubview:_sub2];
#if __has_include(<SJFrameLayout/SJFrameLayout.h>)
    [_sub2 sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
        make.top.equalTo(mid.FL_centerY).offset(inset * 0.5);
        make.left.offset(inset);
        make.bottom.right.offset(-inset);
    }];
#endif

//    [root layoutIfNeeded];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [root sj_removeFrameLayouts];
//        [mid sj_removeFrameLayouts];
//        [self->_sub sj_removeFrameLayouts];
//    });
}
- (IBAction)test2:(id)sender {
    inset += 1;
#if 0
    [_sub.superview.superview sj_removeFrameLayouts];
    [_sub.superview sj_removeFrameLayouts];
    
    [_sub sj_removeFrameLayouts];
    CGRect frame = _sub.frame;
    frame.origin.x += inset;
    frame.origin.y += inset;
    frame.size.width -= inset * 2;
    frame.size.height -= inset * 2;
    _sub.frame = frame;
    
    [_sub2 sj_removeFrameLayouts];
    frame = _sub2.frame;
    frame.origin.x += inset;
    frame.origin.y += inset;
    frame.size.width -= inset * 2;
    frame.size.height -= inset * 2;
    _sub2.frame = frame;
    
#elif __has_include(<SJFrameLayout/SJFrameLayout.h>)
    [_sub sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
        make.top.left.offset(inset);
        make.right.offset(-inset);
        make.bottom.equalTo(self->_sub.superview.FL_centerY).offset(-inset * 0.5);
    }];
    
    [_sub2 sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
        make.top.equalTo(self->_sub2.superview.FL_centerY).offset(inset * 0.5);
        make.left.offset(inset);
        make.bottom.right.offset(-inset);
    }];
#endif
}

- (void)_setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupViews];
}

+ (NSString *)routePath {
    return @"demos/3";
}

+ (void)handleRequestWithParameters:(nullable SJParameters)parameters topViewController:(UIViewController *)topViewController completionHandler:(nullable SJCompletionHandler)completionHandler {
    [topViewController.navigationController pushViewController:self.new animated:YES];
}

- (instancetype)initWithNibName:(NSString *_Nullable)nibNameOrNil bundle:(NSBundle *_Nullable)nibBundleOrNil {
    self = [super initWithNibName:@"SJDemo03ViewController" bundle:nil];
    if ( self ) {}
    return self;
}
@end
NS_ASSUME_NONNULL_END


/**
 1. 调用 `layoutIfNeeded` 不一定会触发`layoutSubviews`
    - 当子视图frame被修改后, 调用父视图的layoutIfNeeded会立即触发`layoutSubviews`或者没有调用时会在下次运行循环时会触发
 
 以下为修改子视图frame时, layoutSubviews 的调用顺序
 
 SJTestView2: 		 0x7fbbdde17630 	 ==> Begin 	 {{{2, 2}, {196, 196}}}
 SJTestView2: 		 0x7fbbdde17630 	 ==> End 	 {{{2, 2}, {196, 196}}}
 SJTestSubView: 	 0x7fbbdde18100 	 ==> Begin 	 {{{10, 10}, {176, 176}}}
 SJTestSubView: 	 0x7fbbdde18100 	 ==> End 	 {{{10, 10}, {176, 176}}}
 
    ^^^1. 当子视图的frame被修改后, 会从父视图开始, 触发父视图的layoutSubviews, 再触发当前子视图的layoutSubviews
 
 SJTestView2: 		 0x7f9a85e20bd0 	 ==> Begin 	 {{{2, 2}, {196, 196}}}
 SJTestView2: 		 0x7f9a85e20bd0 	 ==> End 	 {{{2, 2}, {196, 196}}}
 SJTestSubView: 	 0x7f9a85e18a50 	 ==> Begin 	 {{{34, 115}, {128, 47}}}
 SJTestSubView: 	 0x7f9a85e18a50 	 ==> End 	 {{{34, 115}, {128, 47}}}
 SJTestSubView: 	 0x7f9a85e0ade0 	 ==> Begin 	 {{{34, 34}, {128, 30}}}
 SJTestSubView: 	 0x7f9a85e0ade0 	 ==> End 	 {{{34, 34}, {128, 30}}}
 
    ^^^2. 当多个子视图的frame被修改后, 还是会从父视图开始, 触发父视图的layoutSubviews, 再触发被修改frame的子视图的layoutSubviews
    ^^^3. 子视图修改frame后, 仅触发父视图的layoutSubviews, 并不会触发祖先的layoutSubviews
 
 当前的布局实现过程为:
    当监测到父视图 layoutSubviews 时, 开始修改子视图的frame.
    - 这里的坑主要是: 实现过程由于是监测父视图的layout时机, 而由以上结论得出系统的layout时机需子视图发生变化时, 才会触发父视图layout.

 整改:
    - 布局的起点, 应该从当前视图开始
    - 监测依赖视图的layout时机
        - 对应的依赖视图FL_layoutIfNeeded时, 更新自身依赖人家的属性(处理先: 直接全部更新, 后期优化更新对应属性)
        - 监测
            - 必须到位
            - FL_layoutIfNeeded 调用完之后, 通知观察者? 或者无需观察者?
                - 使用`无需观察者`方案. 依赖视图布局更新后, 当前视图应自动维护自己的布局.
                    - 当前视图如何知道, 依赖视图正在更新布局或者已更新完毕呢?
                        - KVO? or Notification? or mgr?
                            - Notification, 暂时先用通知来实现
                            - 使用 mgr. KVO和Notification 貌似会有很大的性能消耗.
                                - mgr 监听所有依赖视图的FL_layoutSubviews, 或者frame发生变化的时机. 由此更新当前视图

    - 当需自适应自身大小时
        - 如果存在子视图
            - 如果存在 elements, 则子视图设置完frame后, 会触发父视图自己的layoutSubviews, 此时可以修复父视图自身大小(需注意循环调用).
            - 如果不存在 elements, 要么使用inSize(>MaxX, MaxY), 要么使用所有子视图maxX, maxY(>inSize).
        - 如果不存在子视图, 使用inSize大小(>0). 否则为Zero.
        - 特殊自撑满视图的处理. (UILabel, UIButton, UIImageView)
        - 其他视图的统一处理.
 
 
    - 什么情况下需要更新自身的frame?
        - 依赖的视图发生变更时
            - 可能的依赖有:
                - 父视图
                - 其他子视图
        - 自撑满时, 需依赖子视图的情况
        - 自撑满时, 依赖自身内容的情况(Text, Image, inSize)
 */
