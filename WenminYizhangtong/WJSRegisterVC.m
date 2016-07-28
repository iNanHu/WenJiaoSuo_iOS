//
//  WJSRegisterVC.m
//  WenminYizhangtong
//
//  Created by 壹道IOS开发 on 16/6/30.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "WJSTool.h"
#import "WJSRegisterVC.h"
#import "WJSDataManager.h"

@interface WJSRegisterVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *psdText;
@property (weak, nonatomic) IBOutlet UITextField *confirmPsdText;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *regIdText;

@end

@implementation WJSRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerBtnClicked:(id)sender {
    
    NSString *strName = _nameText.text;
    NSString *strEmail = _emailText.text;
    NSString *strPsd = _psdText.text;
    NSString *strConfirmPsd = _confirmPsdText.text;
    NSString *strInviteId = @"0";
    
//    if ([strName isEqualToString:@""]) {
//        NSLog(@"用户名不能为空！");
//        return ;
//    }
//    
//    if (![WJSTool validateMobile:strName]) {
//        NSLog(@"手机号不能为空！");
//    }
//    if([strEmail isEqualToString:@""]) {
//        NSLog(@"邮箱地址不能为空！");
//        return ;
//    }
//    if (![WJSTool validateEmail:strEmail]) {
//        NSLog(@"邮箱格式错误！");
//        return ;
//    }
//    if ([strPsd isEqualToString:@""]) {
//        NSLog(@"密码不能为空！");
//        return ;
//    }
//    if (![WJSTool validatePassword:strPsd]) {
//        NSLog(@"密码格式错误！");
//        return ;
//    }
//    if ([strConfirmPsd isEqualToString:@""]) {
//        NSLog(@"确认密码不能为空！");
//        return ;
//    }
//    if (![strConfirmPsd isEqualToString:strPsd]) {
//        NSLog(@"两次密码不一致，请重新输入！");
//        return;
//    }
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        
        NSString *msg = [responseObject objectForKey:@"msg"];
        NSString *data = [responseObject objectForKey:@"data"];
        NSLog(@"处理成功：[msg:%@,data:%@]",msg,data);
        [self registerResult:responseObject];
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"处理失败：%@",error);
    };
    NSString *strMD5Psd = [WJSTool getMD5Val:strPsd];
    [[WJSDataManager shareInstance]registerUserAccWithUserName:strName andInviteId:strInviteId andUserEmail:strEmail andUserPsd:strMD5Psd andSucc:succBlock andFail:failBlock];
}

- (void)registerResult:(NSDictionary *)result {
    
    NSString *resVal = [result objectForKey:@"msg"];
    if ([resVal isEqualToString:JSON_RES_SUCC]) {
        NSString *uId = [result objectForKey:@"data"];
        [[WJSDataModel shareInstance] setUId:uId];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        NSString *errMsg = [result objectForKey:@"data"];
        NSLog(@"注册失败，error[%@]",errMsg);
    }
}

@end
