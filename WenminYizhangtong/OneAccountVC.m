//
//  OneAccountVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/6/19.
//  Copyright © 2016年 alexyang. All rights reserved.
//
#define NavToPersonDetail @"NavToPersonDetail"
#define NavToRegAccount @"SegToRegAccount"
#define AccountInfoCell @"AccountInfoCell"
#define NavToApplyStatus @"SegToApplyStatus"

#import <SDWebImage/SDImageCache.h>
#import <UIImageView+WebCache.h>
#import "WJSApplyStattusVC.h"
#import "WJSDataManager.h"
#import "RegAccountVC.h"
#import "OneAccountVC.h"
#import "WJSCommonDefine.h"

@interface OneAccountVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *personDetailBtn;
@property (weak, nonatomic) IBOutlet UITableView *wjsTableView;
@property (strong, nonatomic) NSMutableArray *arrWJSInfo;
@end

@implementation OneAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏导航栏左右按钮
    self.hidLeftButton = NO;
    self.hidRightButton = YES;
    self.navigationItem.hidesBackButton = YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.wjsTableView.dataSource = self;
    self.wjsTableView.delegate = self;
    [self.wjsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:AccountInfoCell];
    if ([self.wjsTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.wjsTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.wjsTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.wjsTableView setLayoutMargins:UIEdgeInsetsZero];
    }

    [_personDetailBtn addTarget:self action:@selector(onCommitPersonDetail) forControlEvents:UIControlEventTouchUpInside];
    [self initData];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(10, 5, 100, 30);
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"进度查询" forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)leftAction:(UIButton *)sender {
    
    [self performSegueWithIdentifier:NavToPersonDetail sender:nil];
}

- (void)rightAction {
    
    [self performSegueWithIdentifier:NavToApplyStatus sender:_arrWJSInfo];
}

- (void)initData {
    
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSString *resVal = [responseObject objectForKey:@"msg"];
        if ([resVal isEqualToString:JSON_RES_SUCC]) {
            NSArray *arrTemp = [responseObject objectForKey:@"data"];
            _arrWJSInfo = [NSMutableArray arrayWithArray:arrTemp];
            NSLog(@"getWJSInfoList 返回成功");
            [self.wjsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        } else {
            NSString *errMsg = [responseObject objectForKey:@"data"];
            NSLog(@"getWJSInfoList 获取失败，error[%@]",errMsg);
        }
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"getWJSInfoList error:%@",error);
    };
    [[WJSDataManager shareInstance]getWJSInfoListWithSucc:succBlock andFail:failBlock];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _arrWJSInfo.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 120)];
    [headView setBackgroundColor:[UIColor whiteColor]];

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 120)];
    imgView.image = [UIImage imageNamed:@"home_index1"];
    [headView addSubview:imgView];
    
    UIView *line = [UIView new];
    line.frame = CGRectMake(0, 119, UI_SCREEN_WIDTH, 0.5);
    [line setBackgroundColor:RGB(0xC0, 0xC0, 0xC0)];
    [headView addSubview:line];
    
    return headView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_arrWJSInfo.count == 0) return nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AccountInfoCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AccountInfoCell];
    }
    cell.tag = indexPath.row;
    [self setCellModel:cell withInfo:[_arrWJSInfo objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setCellModel:(UITableViewCell *)cell withInfo:(NSDictionary *)dicInfo {
    
    if (!dicInfo) return ;
    
    NSString *strImgUrl = [dicInfo objectForKey:WJSLogo];
    NSString *strTitleName = [dicInfo objectForKey:WJSName];
    NSInteger oneKey = [[dicInfo objectForKey:WJSOneKey]integerValue];
    
    if (!strImgUrl || [strImgUrl isEqualToString:@""]) {
        strImgUrl = @"defCellImg";
    }
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:strImgUrl] placeholderImage:[UIImage imageNamed:@"defCellImg"]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.textLabel setText:strTitleName];
    
    UIButton *onekeyBtn = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 95, 15, 80, 30)];
    NSString *strOneKey = oneKey == 1?@"一键开户":@"立即开户";
    onekeyBtn.tag = cell.tag;
    [onekeyBtn setTitle:strOneKey forState:UIControlStateNormal];
    [onekeyBtn addTarget:self action:@selector(registerAccount:) forControlEvents:UIControlEventTouchUpInside];
    onekeyBtn.layer.cornerRadius = 3.0f;
    onekeyBtn.layer.borderWidth = 2.0/UI_MAIN_SCALE;
    [onekeyBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    [onekeyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    onekeyBtn.layer.borderColor = [UIColor redColor].CGColor;
    [cell addSubview:onekeyBtn];
}

- (void)registerAccount:(UIButton *)sender {
    
    NSString *strTitle = sender.titleLabel.text;
    NSDictionary *userInfo = [_arrWJSInfo objectAtIndex:sender.tag];
    if ([strTitle isEqualToString:@"一键开户"]) {//一键开户
        SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            NSString *resVal = [responseObject objectForKey:@"msg"];
            if ([resVal isEqualToString:JSON_RES_SUCC]) {
                [self showAlertViewWithTitle:@"开户申请成功，请静待通知"];
                NSLog(@"applyWJSInfo 返回成功");
                [self.wjsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            } else {
                [self showAlertViewWithTitle:@"开户申请失败"];
                NSString *errMsg = [responseObject objectForKey:@"data"];
                NSLog(@"applyWJSInfo 获取失败，error[%@]",errMsg);
            }
        };
        FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            [self showAlertViewWithTitle:@"开户申请失败"];
            NSLog(@"getWJSInfoList error:%@",error);
        };
        NSString *wjsId = [userInfo objectForKey:WJSId];
        [[WJSDataManager shareInstance]applyWJSInfoWithWjsId:wjsId andSucc:succBlock andFail:failBlock];
    } else {//手动开户
        [self performSegueWithIdentifier:NavToRegAccount sender:userInfo];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.f;
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:NavToRegAccount]) {
        RegAccountVC *destVC = (RegAccountVC *)segue.destinationViewController;
        NSDictionary *userInfo = (NSDictionary *)sender;
        NSString *strLink = [userInfo objectForKey:WJSLink];
        NSString *strName = [userInfo objectForKey:WJSName];
        destVC.strLinkUrl = strLink;
        destVC.strName = strName;
    } else if([segue.identifier isEqualToString:NavToApplyStatus]) {
        WJSApplyStattusVC *destVC = (WJSApplyStattusVC *)segue.destinationViewController;
        destVC.arrWJSInfo = sender;
    }
}

- (void)onCommitPersonDetail {
    [self performSegueWithIdentifier:NavToPersonDetail sender:nil];
}

@end
