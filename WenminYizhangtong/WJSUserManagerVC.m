//
//  WJSUserManagerVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/7/23.
//  Copyright © 2016年 alexyang. All rights reserved.
//
#define UserManagerTableCell @"UserManagerTableCell"

#import "WJSUserManagerVC.h"
#import "WJSCommonDefine.h"
#import "WJSDataModel.h"
#import "WJSDataManager.h"
#import "WJSLoginVC.h"

@interface WJSUserManagerVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *managerTableView;
@property (strong, nonatomic) NSArray *arrName;
@end

@implementation WJSUserManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号管理";
    [self initData];
    [self initCtrl];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)Logout{
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        [self logoutResult:responseObject];
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        
    };
    [[WJSDataManager shareInstance]logoutUserAccWithSucc:succBlock andFail:failBlock];
}

- (void)logoutResult:(NSDictionary *) result {
    
    NSString *resVal = [result objectForKey:@"msg"];
    if ([resVal isEqualToString:JSON_RES_SUCC]) {
        [[WJSDataModel shareInstance] setUId:@""];
        NSLog(@"登出成功");
        [[WJSDataModel shareInstance] setUserPassword:@""];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WJSLoginVC *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"WJSLoginVC"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController pushViewController:loginVC animated:YES];
    } else {
        NSString *errMsg = [result objectForKey:@"data"];
        NSLog(@"登出失败，error[%@]",errMsg);
    }
}

- (void)initCtrl {
    _managerTableView.delegate = self;
    _managerTableView.dataSource = self;
    if ([_managerTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_managerTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_managerTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_managerTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [_managerTableView setBackgroundColor:RGB(0xF7, 0xF7, 0xF7)];
    [_managerTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:UserManagerTableCell];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initData {
    
    _arrName = @[@[@"头像",@"昵称",@"账号",@"性别",@"邮箱",@"修改密码"],@[@"退出登录"]];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_dicUserInfo) return nil;
    
    NSString *strName = _arrName[indexPath.section][indexPath.row];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:UserManagerTableCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UserManagerTableCell];
    }

    if (indexPath.section == 0) {
        cell.textLabel.text = strName;
        //@[@[@"头像",@"昵称",@"账号",@"性别",@"邮箱",@"修改密码"],@[@"退出登录"]];
        switch (indexPath.row) {
            case 0:
            {
                UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 55, 2, 40, 40)];
                iconView.image  = [UIImage imageNamed:@"58"];
                [cell addSubview:iconView];
            }
                break;
            case 1:
            {
                UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 130, 0, 120, 45)];
                nickLabel.text = [_dicUserInfo objectForKey:@"username"];
                nickLabel.textAlignment = NSTextAlignmentRight;
                nickLabel.textColor = [UIColor blackColor];
                [cell addSubview:nickLabel];
            }
                break;
            case 2:
            {
                UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 130, 0, 120, 45)];
                nickLabel.text = [_dicUserInfo objectForKey:@"username"];
                nickLabel.textAlignment = NSTextAlignmentRight;
                nickLabel.textColor = [UIColor blackColor];
                [cell addSubview:nickLabel];
            }
                break;
            case 3:
            {
                UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 130, 0, 120, 45)];
                NSString *strSex = @"男";
                NSString *sex = [_dicUserInfo objectForKey:@"sex"];
                if (sex != [NSNull null]) {
                    NSInteger nSex = [[_dicUserInfo objectForKey:@"sex"] integerValue];
                    strSex = nSex == 0?@"男":@"女";
                }
                sexLabel.text = strSex;
                sexLabel.textAlignment = NSTextAlignmentRight;
                sexLabel.textColor = [UIColor blackColor];
                [cell addSubview:sexLabel];
            }
                break;
            case 4:
            {
                UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 130, 0, 120, 45)];
                emailLabel.text = [_dicUserInfo objectForKey:@"email"];
                emailLabel.textAlignment = NSTextAlignmentRight;
                emailLabel.textColor = [UIColor blackColor];
                [cell addSubview:emailLabel];
            }
                break;
            case 5:
            {
                UILabel *modifyPsdLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 130, 0, 100, 45)];
                modifyPsdLabel.text = @"修改密码";
                modifyPsdLabel.textColor = [UIColor blackColor];
                modifyPsdLabel.textAlignment = NSTextAlignmentRight;
                [cell addSubview:modifyPsdLabel];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            default:
                break;
        }
    } else {
        cell.textLabel.text= strName;
        [cell.textLabel setTextColor:[UIColor redColor]];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        
    }
    return cell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        NSArray *arrTemp = [_arrName objectAtIndex:0];
        CGFloat footerHeight = UI_SCREEN_HEIGHT - 65 - 45*(arrTemp.count + 1);
        return footerHeight;
    }
    
    return .1f;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_arrName[section] count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _arrName.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        [self Logout];
    }
}


@end
