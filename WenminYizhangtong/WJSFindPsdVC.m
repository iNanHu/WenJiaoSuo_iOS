//
//  WJSFindPsdVC.m
//  WenminYizhangtong
//
//  Created by 壹道IOS开发 on 16/6/30.
//  Copyright © 2016年 alexyang. All rights reserved.
//
#import "WJSCommonDefine.h"
#import "WJSFindPsdVC.h"
#import "WJSDataModel.h"
#import "WJSDataManager.h"

@interface WJSFindPsdVC ()
@property (weak, nonatomic) IBOutlet UITextField *regEmailText;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation WJSFindPsdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _commitBtn.layer.cornerRadius = 5.f;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}


- (IBAction)comitBtnClick:(id)sender {
    NSString *strRegEmail = _regEmailText.text;
    NSString *strUserEmail = [[WJSDataModel shareInstance] userEmail];
    if (!strRegEmail || ![strRegEmail isEqualToString:strUserEmail]) {
        NSLog(@"注册邮箱输入错误，请重新输入！");
        [self showAlertViewWithTitle:@"注册邮箱输入错误，请重新输入！"];
        return ;
    }
    SuccBlock succ = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        [self findPsdResult:responseObject];
    };
    FailBlock fail = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"返回错误：%@",error);
        [self showAlertViewWithTitle:[NSString stringWithFormat:@"修改密码失败, %@",error]];
    };
    [[WJSDataManager shareInstance] FindPsdWithUserEmail:strUserEmail andSucc:succ andFail:fail];
}

- (void)findPsdResult:(NSDictionary *)result {
    
    NSString *resVal = [result objectForKey:@"msg"];
    if ([resVal isEqualToString:JSON_RES_SUCC]) {
        NSLog(@"修改密码成功!");
        [self showAlertViewWithTitle:@"修改密码成功!"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        NSString *errMsg = [result objectForKey:@"data"];
        [self showAlertViewWithTitle:[NSString stringWithFormat:@"修改密码失败, %@",errMsg]];
        NSLog(@"修改密码失败，error[%@]",errMsg);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
