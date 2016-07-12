//
//  UserCenterVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/6/19.
//  Copyright © 2016年 alexyang. All rights reserved.
//
#define TableViewCellId @"tableViewCellId"
#import "UserCenterVC.h"
#import "WJSCommonDefine.h"

@interface UserCenterVC ()
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@property (strong, nonatomic) NSArray *arrName;
@end

@implementation UserCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)initView {
    _userTableView.delegate = self;
    _userTableView.dataSource = self;
    [_userTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TableViewCellId];
    [_userTableView setBackgroundColor:RGB(0xF7, 0xF7, 0xF7)];
}

- (void)initData {
    _arrName = @[@[@"昵称"],@[@"性别",@"等级"],@[@"关于我们"]];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 5)];
    [headView setBackgroundColor:[UIColor clearColor]];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, UI_SCREEN_WIDTH, 1.0/UI_MAIN_SCALE)];
    [lineView setBackgroundColor:RGB(0xA0, 0xA0, 0xA0)];
    [headView addSubview:lineView];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 10.f)];
    [footView setBackgroundColor:[UIColor clearColor]];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 1.0/UI_MAIN_SCALE)];
    [lineView setBackgroundColor:RGB(0xA0, 0xA0, 0xA0)];
    [footView addSubview:lineView];
    return footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arrDetail = [_arrName objectAtIndex:section];
    return arrDetail.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _arrName.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45.f;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strName = [[_arrName objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:TableViewCellId];
    cell.textLabel.text= strName;
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
