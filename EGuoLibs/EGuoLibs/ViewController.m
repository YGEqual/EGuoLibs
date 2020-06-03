//
//  ViewController.m
//  EGuoLibs
//
//  Created by E.Guo on 2020/5/28.
//  Copyright © 2020 E.Guo. All rights reserved.
//

#import "ViewController.h"

//正则表达式
#import "EGRegularVC.h"
//数据持久化
#import "EGPerformanceVC.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *dataArray;
@end

static NSString *EGuoLibsCellID = @"EGuoLibsCellID";


@implementation ViewController
//初始化数据
- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.navigationItem.title = @"EGuoLibs";
    
    _dataArray = [@[@"正则表达式",@"数据持久化"] mutableCopy];
}

#pragma mark - UITableViewDelegate&&UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EGuoLibsCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:EGuoLibsCellID];
    }
    //    设置cell样式
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            {
                EGRegularVC *regularVC = [[EGRegularVC alloc]init];
                regularVC.navigationItem.title = @"正则表达式";
                [self.navigationController pushViewController:regularVC animated:YES];
            }
            break;
         case 1:
            {
                EGPerformanceVC *performanceVC = [[EGPerformanceVC alloc]init];
                performanceVC.navigationItem.title = @"数据持久化";
                [self.navigationController pushViewController:performanceVC animated:YES];
            }
            break;
        default:
            break;
    }
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.cellLayoutMarginsFollowReadableWidth = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;      _tableView.tableFooterView = [UIView new];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 2, 0, 2);
    }
    return _tableView;
}

@end
