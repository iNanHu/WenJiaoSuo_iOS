//
//  UIViewController+HUD.m
//  SmartHouseNew
//
//  Created by yyh on 15/6/12.
//  Copyright (c) 2015年 一道科技. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "WJSCommonDefine.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>

@implementation UIViewController (HUD)

- (void)showHudWithTitle:(NSString *)title {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[AppDelegate sharedAppDelegate].window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = title;
    hud.margin = 10.f;
    hud.yOffset = 5.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

- (void)showHud{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
- (void)hideHud {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

- (void)showHudProgressWithTitle:(NSString *)title {

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.detailsLabelText = title;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15.f];
    hud.margin = 27.f;
    hud.yOffset = 0;
    hud.removeFromSuperViewOnHide = YES;
}

- (void)showAlertViewWithTitle:(NSString *)title {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = title;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15.f];
    hud.margin = 27.f;
    hud.yOffset = 0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
    
}

- (void)showAlertViewWithTitle:(NSString *)title withOffset:(CGFloat)yOffset {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = title;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15.f];
    hud.margin = 27.f;
    hud.yOffset = yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

@end
