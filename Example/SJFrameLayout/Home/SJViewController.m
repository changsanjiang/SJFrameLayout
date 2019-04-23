//
//  SJViewController.m
//  SJFrameLayout
//
//  Created by changsanjiang@gmail.com on 04/18/2019.
//  Copyright (c) 2019 changsanjiang@gmail.com. All rights reserved.
//

#import "SJViewController.h"
#import <SJFrameLayout/SJFrameLayout.h>
#import "SJHomeTableViewCell.h"
#import "SJDemoItem.h"
#import <SJRouter/SJRouter.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *SJHomeTableViewCellID = @"SJHomeTableViewCell";

@interface SJViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) NSArray<SJDemoItem *> *demos;
@end

@implementation SJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupViews];
    [self _makeDemos];
}

- (void)_makeDemos {
    NSMutableArray<SJDemoItem *> *m = [NSMutableArray array];
    [m addObject:[SJDemoItem itemWithTitle:@"demo 1" subtitle:@"" routePath:@"demos/1"]];
    _demos = m;
    [_tableView reloadData];
}

- (void)_setupViews {
    self.title = @"Home";
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:SJHomeTableViewCell.class forCellReuseIdentifier:SJHomeTableViewCellID];
    [self.view addSubview:_tableView];
    [_tableView sj_makeFrameLayout:^(SJFLLayoutMaker * _Nonnull make) {
        make.edges.offset(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _demos.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:SJHomeTableViewCellID forIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(SJHomeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = _demos[indexPath.row].title;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [SJRouter.shared handleRequest:[[SJRouteRequest alloc] initWithPath:_demos[indexPath.row].routePath parameters:nil] completionHandler:nil];
}
@end
NS_ASSUME_NONNULL_END
