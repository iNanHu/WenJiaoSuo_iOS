//
//  RegAccountVC.h
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/7/21.
//  Copyright © 2016年 alexyang. All rights reserved.
//
#import "WJSBaseVC.h"
#import <UIKit/UIKit.h>

@interface RegAccountVC : WJSBaseVC
@property (weak, nonatomic) IBOutlet UIWebView *regAccView;
@property (nonatomic, strong) NSString *strLinkUrl;
@property (nonatomic, strong) NSString *strName;
@end
