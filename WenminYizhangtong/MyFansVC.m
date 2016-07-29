//
//  MyFansVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/7/28.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "MyFansVC.h"
#import "WJSDataModel.h"
#import "WJSDataManager.h"
#import "WJSApplyStatusVC.h"
#import "WJSCommonDefine.h"
#import "LiuXSegmentView.h"

#define TableViewCellId @"tableViewCellId"

@interface MyFansVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) LiuXSegmentView *segmentView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrFansList;
@end

@implementation MyFansVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的粉丝";
    self.hidLeftButton = NO;
    
    self.navigationItem.hidesBackButton = YES;
    
    _segmentView = [[LiuXSegmentView alloc] initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH, 45) titles:@[@"一度粉丝",@"二度粉丝"] clickBlick:^void(NSInteger index) {
        NSArray *arrTemp = [[WJSDataModel shareInstance] arrMyFansList];
        [self.arrFansList removeAllObjects];
        for (NSDictionary *dicInfo in arrTemp) {
            int level = [[dicInfo objectForKey:@"level"] intValue];
            if (level == index + 1)
                [self.arrFansList addObject:dicInfo];
        }
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
    _segmentView.defaultIndex = 0;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Nav_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - Nav_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableHeaderView = _segmentView;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TableViewCellId];
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [_tableView setBackgroundColor:RGB(0xF7, 0xF7, 0xF7)];
    
    [self initData];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (NSMutableArray *)arrFansList {
    
    if (!_arrFansList) {
        _arrFansList = [[NSMutableArray alloc] init];
    }
    return _arrFansList;
}

- (void)initData {
    
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSString *resVal = [responseObject objectForKey:@"msg"];
        if ([resVal isEqualToString:JSON_RES_SUCC]) {
            NSArray *arrTemp = [responseObject objectForKey:@"data"];
            for (NSDictionary *dicInfo in arrTemp) {
                int level = [[dicInfo objectForKey:@"level"] intValue];
                if (level == 1)
                    [self.arrFansList addObject:dicInfo];
            }
            [[WJSDataModel shareInstance] setArrMyFansList:[NSMutableArray arrayWithArray:arrTemp]];
            NSLog(@"getWJSInfoList 返回成功");
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        } else {
            NSString *errMsg = [responseObject objectForKey:@"data"];
            NSLog(@"getFansList 获取失败，error[%@]",errMsg);
        }
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"getFansList error:%@",error);
    };

    [[WJSDataManager shareInstance] getFansListWithSucc:succBlock andFail:failBlock];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicInfo = self.arrFansList[indexPath.row];
    NSString *strName = [dicInfo objectForKey:@"name"];
    NSString *strPhone = [dicInfo objectForKey:@"telphone"];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:TableViewCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellId];
    }
    cell.textLabel.text= strName;
    cell.detailTextLabel.text = strPhone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrFansList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dicInfo = self.arrFansList[indexPath.row];
    NSString *strUid = [dicInfo objectForKey:@"uid"];
    if (strUid) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WJSApplyStatusVC *destVC = [storyBoard instantiateViewControllerWithIdentifier:@"WJSApplyStatusVC"];
        destVC.strUid = nil;
        [self.navigationController pushViewController:destVC animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
