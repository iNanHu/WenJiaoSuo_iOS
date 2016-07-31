//
//  WJSTutotialVC.m
//  WenminYizhangtong
//
//  Created by 壹道IOS开发 on 16/7/28.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "WJSTutotialVC.h"

@interface WJSTutotialVC ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WJSTutotialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _strName;
    //加载注册界面
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_strLinkUrl]];
    [self.webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
