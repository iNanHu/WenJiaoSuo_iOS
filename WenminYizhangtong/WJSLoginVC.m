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
#import <JPUSHService.h>

@interface WJSLoginVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *psdTextFiled;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIView *nameTextView;
@property (weak, nonatomic) IBOutlet UIView *psdTextView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userIconView;
@property (weak, nonatomic) IBOutlet UIImageView *psdIconView;
@property (weak, nonatomic) IBOutlet UIButton *forgetPsdBtn;
@end

@implementation WJSLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.iconView.layer.cornerRadius = 40.f;
    [self.iconView.layer setMasksToBounds:YES];
    
    [self.psdIconView setImage:[UIImage imageNamed:@"psw"]];
    [self.userIconView setImage:[UIImage imageNamed:@"user"]];
    
    self.nameTextFiled.placeholder = @"请输入用户名";
    self.psdTextFiled.placeholder = @"请输入密码";
    self.psdTextFiled.secureTextEntry = YES;
    self.nameTextFiled.delegate = self;
    self.psdTextFiled.delegate = self;
    
    self.loginBtn.layer.cornerRadius = 5.f;
    
    self.nameTextView.layer.cornerRadius = 5.f;
    self.psdTextView.layer.cornerRadius = 5.f;
    self.nameTextView.layer.borderWidth = 2.0/UI_MAIN_SCALE;
    self.psdTextView.layer.borderWidth = 2.0/UI_MAIN_SCALE;
    self.nameTextView.layer.borderColor = RGB(0xA0, 0xA0, 0xA0).CGColor;
    self.psdTextView.layer.borderColor = RGB(0xA0, 0xA0, 0xA0).CGColor;
    
    self.nameTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.psdTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.nameTextFiled becomeFirstResponder];
    
    [self.registerBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [self.forgetPsdBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    self.registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.forgetPsdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [self.loginBtn addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewEndEdit)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(viewEndEdit)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    //self.navigationController.navigationBar.hidden = YES;
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
        [JPUSHService setTags:nil alias:_nameTextFiled.text fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
            NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
        }];
        [self getUserDetailInfo];
        NSLog(@"登录成功:%@",uId);
        [self showAlertViewWithTitle:@"登录成功！"];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSString *errMsg = [result objectForKey:@"data"];
        NSLog(@"登录失败，error[%@]",errMsg);
        [self showAlertViewWithTitle:[NSString stringWithFormat:@"登录失败，%@!",errMsg]];
        
    }
}

- (void)getUserDetailInfo {
    
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSString *strResVal = [responseObject objectForKey:@"msg"];
        if ([strResVal isEqualToString:JSON_RES_SUCC]) {
            [[WJSDataModel shareInstance]setDicUserInfo:[[NSMutableDictionary alloc]initWithDictionary:[responseObject objectForKey:@"data"]]];
            NSLog(@"用户信息获取成功:%@",strResVal);
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


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self viewBeginEdit:textField];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return YES;
}

- (void)viewBeginEdit:(UITextField *)textField {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect frame = self.view.frame;
        //frame.origin.y = -120;
        self.view.frame = frame;
    }];
}
- (void)viewEndEdit:(UITextField *)textField {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
    
}

- (void)viewEndEdit {
    
    [self.psdTextFiled resignFirstResponder];
    [self.nameTextFiled resignFirstResponder];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
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
