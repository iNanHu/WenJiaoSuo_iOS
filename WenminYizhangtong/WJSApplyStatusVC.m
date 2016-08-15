//
//  WJSApplyStattusVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/7/22.
//  Copyright © 2016年 alexyang. All rights reserved.
//
#define ApplyStatusCell @"ApplyStatusCell"
#define ApplyWJSLogo @"logo"
#define ApplyWJSName @"name"
#define ApplyWJSId @"wjsid"
#define ApplyWJSPass @"wjspass"
#define ApplyWJSStatus @"status"
#define ApplyWJSUsrName @"wjsusername"

#import "WJSApplyStatusVC.h"
#import <UIImageView+WebCache.h>
#import "OneAccountVC.h"
#import "WJSDataManager.h"
#import "WJSDataModel.h"

@interface WJSApplyStatusVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *applyStatusTableView;
@property (strong, nonatomic) NSMutableArray *arrApplyStatus;
@end

@implementation WJSApplyStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请进度";
    
    _applyStatusTableView.delegate = self;
    _applyStatusTableView.dataSource = self;
    [_applyStatusTableView registerNib:[UINib nibWithNibName:@"ApplyStatusCell" bundle:nil] forCellReuseIdentifier:ApplyStatusCell];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
}

- (void)initData {
    
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSString *resVal = [responseObject objectForKey:@"msg"];
        if ([resVal isEqualToString:JSON_RES_SUCC]) {
            NSArray *arrTemp = [responseObject objectForKey:@"data"];
            _arrApplyStatus = [NSMutableArray arrayWithArray:arrTemp];
            NSLog(@"getWJSInfoList 返回成功");
            [self.applyStatusTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        } else {
            NSString *errMsg = [responseObject objectForKey:@"data"];
            NSLog(@"getWJSInfoList 获取失败，error[%@]",errMsg);
        }
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"getWJSInfoList error:%@",error);
    };
    if(!_isFansApplyStatus)
        [[WJSDataManager shareInstance]getWJSApplyStatusWithUid:_strUid andSucc:succBlock andFail:failBlock];
    else
        [[WJSDataManager shareInstance]getWJSFansApplyStatusWithUid:_strUid andSucc:succBlock andFail:failBlock];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _arrApplyStatus.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_arrApplyStatus.count == 0) return nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ApplyStatusCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ApplyStatusCell];
    }
    cell.tag = indexPath.row;
    [self setCellModel:cell withInfo:[_arrApplyStatus objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setCellModel:(UITableViewCell *)cell withInfo:(NSDictionary *)dicInfo {
    
    if (!dicInfo) return ;
    
    NSString *strWjsId = [dicInfo objectForKey:ApplyWJSId];
    NSInteger nApplyStatus = [[dicInfo objectForKey:ApplyWJSStatus] integerValue];
    NSString *strUserName = [dicInfo objectForKey:ApplyWJSUsrName];
    NSString *strUserPass = [dicInfo objectForKey:ApplyWJSPass];
    NSString *strImgUrl = [dicInfo objectForKey:ApplyWJSLogo];
    NSString *strWjsName = [dicInfo objectForKey:ApplyWJSName];
    NSString *detailInfo = [NSString stringWithFormat:@"开户账号：%@ 密码：%@",strUserName,strUserPass];
    UIImageView *iconView = [cell viewWithTag:100];
    UILabel *titleLab = [cell viewWithTag:101];
    UILabel *statusLab = [cell viewWithTag:102];
    UILabel *accLab = [cell viewWithTag:103];
    [iconView sd_setImageWithURL:[NSURL URLWithString:strImgUrl] placeholderImage:[UIImage imageNamed:@"defCellImg"]];
    
    titleLab.text = strWjsName;
    
    if (nApplyStatus == 3) {
        accLab.text = detailInfo;
    }
    
    NSString *applyStatus = @"";
    switch (nApplyStatus) {
        case 1:
            applyStatus = @"待分配";
            break;
        case 2:
            applyStatus = @"已分配";
            break;
        case 3:
            applyStatus = @"已完成";
            break;
        case 4:
            applyStatus = @"已驳回";
            break;
        default:
            break;
    }

    statusLab.text = applyStatus;
    statusLab.layer.cornerRadius = 3.0f;
    statusLab.layer.borderWidth = 2.0/UI_MAIN_SCALE;
    [statusLab setTextColor:[UIColor redColor]];
    statusLab.layer.borderColor = [UIColor redColor].CGColor;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
