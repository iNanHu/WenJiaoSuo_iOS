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
        [self loginResult:responseObject];
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
    
    };
    [[WJSDataManager shareInstance]loginUserAccWithUserName:usrName andUserPsd:usrPsd andSucc:succBlock andFail:failBlock];
}

- (void)loginResult:(NSDictionary *) result {
    NSString *resVal = [result objectForKey:@"msg"];
    if ([resVal isEqualToString:JSON_RES_SUCC]) {
        NSString *uId = [result objectForKey:@"data"];
        [[WJSDataModel shareInstance] setUId:uId];
        
        [self performSegueWithIdentifier:NAV_TO_HOMEVC sender:nil];
    } else {
        NSString *errMsg = [result objectForKey:@"data"];
        NSLog(@"登录失败，error[%@]",errMsg);
    }
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
