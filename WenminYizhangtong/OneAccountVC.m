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
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    
    [_personDetailBtn addTarget:self action:@selector(onCommitPersonDetail) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onCommitPersonDetail {
    [self performSegueWithIdentifier:NavToPersonDetail sender:nil];
}


@end
