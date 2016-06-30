//
//  WJSHomeTabBarVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/6/29.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "WJSHomeTabBarVC.h"
#import "WJSCommonDefine.h"

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
    item1.image = IMAGEOF(@"tabbar_icon_news");
    item1.selectedImage = IMAGEOF(@"tabbar_icon_news_highlight");
    item1.title = @"首页";
    
    UITabBarItem* item2 = [self.tabBar.items objectAtIndex:1];
    item2.image = IMAGEOF(@"tabbar_icon_equity");
    item2.selectedImage = IMAGEOF(@"tabbar_icon_equity_highlight");
    item2.title = @"行情";
    
    UITabBarItem* item3 = [self.tabBar.items objectAtIndex:2];
    item3.image = IMAGEOF(@"tabbar_icon_onlie");
    item3.selectedImage = IMAGEOF(@"tabbar_icon_onlie_highlight");
    item3.title = @"一账通";
    
    UITabBarItem* item4 = [self.tabBar.items objectAtIndex:3];
    item4.image = IMAGEOF(@"tabbar_icon_mine");
    item4.selectedImage = IMAGEOF(@"tabbar_icon_mine_highlight");
    item4.title = @"个人中心";
}

- (void)setTabrItemStyleWithFontSize:(CGFloat)fontSize {
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(0x80, 0x80, 0x86), NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:fontSize],NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(0x4D, 0x32, 0x0E), NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:fontSize],NSFontAttributeName,nil] forState:UIControlStateSelected];
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