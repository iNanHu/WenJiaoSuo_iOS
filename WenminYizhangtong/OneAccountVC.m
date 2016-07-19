//
//  OneAccountVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/6/19.
//  Copyright © 2016年 alexyang. All rights reserved.
//
#define NavToPersonDetail @"NavToPersonDetail"
#import "OneAccountVC.h"

@interface OneAccountVC ()
@property (weak, nonatomic) IBOutlet UIWebView *regAccWebView;
@property (weak, nonatomic) IBOutlet UIButton *personDetailBtn;

@end

@implementation OneAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏导航栏左右按钮
    self.hidLeftButton = YES;
    self.hidRightButton = YES;
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    
    [_personDetailBtn addTarget:self action:@selector(onCommitPersonDetail) forControlEvents:UIControlEventTouchUpInside];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.youbiquan.com/frontend/open/account/1063/list.html?version=100&dataSource=ybq6"]];
    [self.regAccWebView loadRequest:request];
}

- (void)onCommitPersonDetail {
    [self performSegueWithIdentifier:NavToPersonDetail sender:nil];
}


@end
