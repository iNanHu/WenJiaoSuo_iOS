//
//  HomeDetailVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/7/23.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "HomeDetailVC.h"

@interface HomeDetailVC ()
@property (weak, nonatomic) IBOutlet UIWebView *homeDetailView;

@end

@implementation HomeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新闻中心";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.strDetailUrl]];
    [_homeDetailView loadRequest:request];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
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
