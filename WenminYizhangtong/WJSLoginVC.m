//
//  WJSLoginVC.m
//  WenminYizhangtong
//
//  Created by 壹道IOS开发 on 16/6/30.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "WJSLoginVC.h"
#import "WJSTool.h"
#import "WJSCommonDefine.h"
#import "WJSDataManager.h"

@interface WJSLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *psdTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPsdBtn;
@end

@implementation WJSLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self.loginBtn addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
    [self initData];
}

- (void)initData {
    NSString *strUserName = [[WJSDataModel shareInstance] userPhone];
    NSString *strUserPsd = [[WJSDataModel shareInstance] userPassword];
    _nameTextFiled.text = strUserName;
    _psdTextFiled.text = strUserPsd;
    if (![strUserName isEqualToString:@""] && ![strUserPsd isEqualToString:@""]) {
        [self Login];
    }
}

- (void)Login {
    
    if ([_nameTextFiled.text isEqualToString:@""]) {
        return;
    }
    if ([_psdTextFiled.text isEqualToString:@""]) {
        return;
    }
    
    NSString *usrName = _nameTextFiled.text;
    NSString *usrPsd = _psdTextFiled.text;
    
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        [self loginResult:responseObject];
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
    
    };
    NSString *strMD5Psd = [WJSTool getMD5Val:usrPsd];
    [[WJSDataManager shareInstance]loginUserAccWithUserName:usrName andUserPsd:strMD5Psd andSucc:succBlock andFail:failBlock];
}

- (void)loginResult:(NSDictionary *) result {
    
    NSString *resVal = [result objectForKey:@"msg"];
    if ([resVal isEqualToString:JSON_RES_SUCC]) {
        NSString *uId = [result objectForKey:@"data"];
        [[WJSDataModel shareInstance] setUId:uId];
        [[WJSDataModel shareInstance]setUserPhone:_nameTextFiled.text];
        [[WJSDataModel shareInstance]setUserPassword:_psdTextFiled.text];
        [self getUserDetailInfo];
        NSLog(@"登录成功:%@",uId);
        [self performSegueWithIdentifier:NAV_TO_HOMEVC sender:nil];
    } else {
        NSString *errMsg = [result objectForKey:@"data"];
        NSLog(@"登录失败，error[%@]",errMsg);
    }
}

- (void)getUserDetailInfo {
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSString *strResVal = [responseObject objectForKey:@"msg"];
        if ([strResVal isEqualToString:JSON_RES_SUCC]) {
            [[WJSDataModel shareInstance]setDicUserInfo:[[NSMutableDictionary alloc]initWithDictionary:[responseObject objectForKey:@"data"]]];
            NSLog(@"用户信息获取成功:%@");
        } else {
            id data = [responseObject objectForKey:@"data"];
            NSLog(@"用户信息失败:%@",data);
        }
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"error: %@",error);
    };
    [[WJSDataManager shareInstance]getUserDetailInfoWithSucc:succBlock andFail:failBlock];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:NAV_TO_HOMEVC]) {
        
    }
}


@end
