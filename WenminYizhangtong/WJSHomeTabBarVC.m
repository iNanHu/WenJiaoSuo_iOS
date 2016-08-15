//
//  WJSHomeTabBarVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/6/29.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "WJSHomeTabBarVC.h"
#import "WJSCommonDefine.h"
#import "WJSApplyStatusVC.h"

@interface WJSHomeTabBarVC ()

@end

@implementation WJSHomeTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置tabbar的背景颜色
    [self.tabBar setBarTintColor:UIColorFromRGB(0xffffff)];
    [self setTabrItemStyleWithFontSize:12.0f];
    
    UITabBarItem* item1 = [self.tabBar.items objectAtIndex:0];
    item1.image = IMAGEOF(@"tabbar_icon_news_highlight");
    item1.selectedImage = IMAGEOF(@"tabbar_icon_news_highlight");
    item1.title = @"首页";
    
    UITabBarItem* item2 = [self.tabBar.items objectAtIndex:1];
    item2.image = IMAGEOF(@"tabbar_icon_equity_highlight");
    item2.selectedImage = IMAGEOF(@"tabbar_icon_equity_highlight");
    item2.title = @"羊毛专区";
    
    UITabBarItem* item3 = [self.tabBar.items objectAtIndex:2];
    item3.image = IMAGEOF(@"tabbar_icon_onlie_highlight");
    item3.selectedImage = IMAGEOF(@"tabbar_icon_onlie_highlight");
    item3.title = @"一账通";
    
    UITabBarItem* item4 = [self.tabBar.items objectAtIndex:3];
    item4.image = IMAGEOF(@"tabbar_icon_mine_highlight");
    item4.selectedImage = IMAGEOF(@"tabbar_icon_mine_highlight");
    item4.title = @"个人中心";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SwitchToRegStatus) name:NotiWJSRegStatusFail object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SwitchToRegStatus) name:NotiWJSRegStatusSucc object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToMyFans) name:NotiNewFansJoin object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)switchToMyFans {
    self.selectedIndex = 3;
    [[NSNotificationCenter defaultCenter]postNotificationName:NotiTabToNewFansJoin object:nil];
}

- (void)SwitchToRegStatus {
    self.selectedIndex = 2;
    [[NSNotificationCenter defaultCenter]postNotificationName:NotiTabToRegStatusSucc object:nil];
}

- (void)setTabrItemStyleWithFontSize:(CGFloat)fontSize {
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(0x80, 0x80, 0x86), NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:fontSize],NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:fontSize],NSFontAttributeName,nil] forState:UIControlStateSelected];
}
- (void)viewWillLayoutSubviews {
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 45;
    tabFrame.origin.y = CGRectGetHeight(self.view.frame) - 45;
    self.tabBar.frame = tabFrame;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
