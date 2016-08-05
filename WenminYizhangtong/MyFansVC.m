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
@property (nonatomic, strong) NSMutableArray *arrFirstFansList;
@property (nonatomic, strong) NSMutableArray *arrSecondFansList;
@property (nonatomic, assign) NSInteger selectedIndex;   //默认选中的索引
@end

@implementation MyFansVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的粉丝";
    self.hidLeftButton = NO;
    
    self.navigationItem.hidesBackButton = YES;
    
    _segmentView = [[LiuXSegmentView alloc] initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH, 45) titles:@[@"一度粉丝",@"二度粉丝"] clickBlick:^void(NSInteger index) {
        [self initFansDataWithLevel:index];
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
    
    [self initFansDataWithLevel:1];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (NSMutableArray *)arrFirstFansList {
    
    if (!_arrFirstFansList) {
        _arrFirstFansList = [[NSMutableArray alloc] init];
    }
    return _arrFirstFansList;
}

- (NSMutableArray *)arrSecondFansList {
    
    if (!_arrSecondFansList) {
        _arrSecondFansList = [[NSMutableArray alloc] init];
    }
    return _arrSecondFansList;
}

- (void)initFansDataWithLevel:(NSInteger)levelId {
    
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        [_arrSecondFansList removeAllObjects];
        [_arrFirstFansList removeAllObjects];
        NSString *resVal = [responseObject objectForKey:@"msg"];
        if ([resVal isEqualToString:JSON_RES_SUCC]) {
            NSArray *arrTemp = [responseObject objectForKey:@"data"];
            for (NSDictionary *dicInfo in arrTemp) {
                
                id name = [dicInfo objectForKey:@"realname"];
                id phoneNum = [dicInfo objectForKey:@"telphone"];
                id uid = [dicInfo objectForKey:@"uid"];
                if ((name && ![name isEqual:[NSNull null]])
                    && (phoneNum && ![phoneNum isEqual:[NSNull null]])
                    && (uid && ![uid isEqual:[NSNull null]])) {
                    int level = [[dicInfo objectForKey:@"level"] intValue];
                    if (level == 1)
                        [self.arrFirstFansList addObject:dicInfo];
                    else {
                        [self.arrSecondFansList addObject:dicInfo];
                    }
                }
                
            }
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
    [[WJSDataManager shareInstance] getFansListWithLevel:levelId andPageSize:20 andPageNum:0 andSucc:succBlock andFail:failBlock];
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
    NSDictionary *dicInfo = nil;
    if (_selectedIndex == 0) {
        dicInfo = self.arrFirstFansList[indexPath.row];
    } else {
        dicInfo = self.arrSecondFansList[indexPath.row];
    }
    NSString *strName = [dicInfo objectForKey:@"realname"];
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
    
    if (_selectedIndex == 0) {
        return self.arrFirstFansList.count;
    } else {
        return self.arrSecondFansList.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dicInfo = nil;
    if (_selectedIndex == 0) {
        dicInfo = self.arrFirstFansList[indexPath.row];
    } else {
        dicInfo = self.arrSecondFansList[indexPath.row];
    }
    NSString *strUid = [dicInfo objectForKey:@"uid"];
    if (strUid) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WJSApplyStatusVC *destVC = [storyBoard instantiateViewControllerWithIdentifier:@"WJSApplyStatusVC"];
        destVC.strUid = strUid;
        destVC.isFansApplyStatus = YES;
        [self.navigationController pushViewController:destVC animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
