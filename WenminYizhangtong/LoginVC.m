//
//  LoginVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/6/15.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *psdTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginVC

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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
