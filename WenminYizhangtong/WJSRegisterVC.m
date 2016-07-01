//
//  WJSRegisterVC.m
//  WenminYizhangtong
//
//  Created by 壹道IOS开发 on 16/6/30.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "WJSRegisterVC.h"
#import "WJSDataManager.h"

@interface WJSRegisterVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *psdText;
@property (weak, nonatomic) IBOutlet UITextField *confirmPsdText;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

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
    NSString *strInviteId;
    
    if ([strName isEqualToString:@""]) {
        NSLog(@"用户名不能为空！");
        return ;
    }
    if([strEmail isEqualToString:@""]) {
        NSLog(@"邮箱地址不能为空！");
        return ;
    }
    if ([strPsd isEqualToString:@""]) {
        NSLog(@"密码不能为空！");
        return ;
    }
    if ([strConfirmPsd isEqualToString:@""]) {
        NSLog(@"确认密码不能为空！");
        return ;
    }
    if ([strConfirmPsd isEqualToString:strPsd]) {
        NSLog(@"两次密码不一致，请重新输入！");
        return;
    }
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSLog(@"处理成功：%@",responseObject);
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"处理失败：%@",error);
    };
    [[WJSDataManager shareInstance]registerUserAccWithUserName:strName andInviteId:strInviteId andUserEmail:strEmail andUserPsd:strPsd andSucc:succBlock andFail:failBlock];
}

@end
