//
//  WJSLoginVC.m
//  WenminYizhangtong
//
//  Created by 壹道IOS开发 on 16/6/30.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "WJSLoginVC.h"
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
    [self.loginBtn addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
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
        [self loginResult:0];
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
    
    };
    [[WJSDataManager shareInstance]loginUserAccWithUserName:usrName andUserPsd:usrPsd andSucc:succBlock andFail:failBlock];
}

- (void)loginResult:(NSInteger) result {
    
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
