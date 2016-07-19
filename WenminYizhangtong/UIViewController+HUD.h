//
//  UIViewController+HUD.h
//  SmartHouseNew
//
//  Created by yyh on 15/6/12.
//  Copyright (c) 2015年 一道科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIViewController (HUD)

- (void)showHud;
- (void)hideHud;

- (void)showHudWithTitle:(NSString *)title;
- (void)showAlertViewWithTitle:(NSString *)title;
- (void)showAlertViewWithTitle:(NSString *)title withOffset:(CGFloat)yOffset;
- (void)showHudProgressWithTitle:(NSString *)title;
@end
