//
//  WJSCommonDefine.h
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/6/28.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#ifndef WJSCommonDefine_h
#define WJSCommonDefine_h

#import <Foundation/NSURLSession.h>

#define iOS8                     ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iPhone6                  (([UIScreen mainScreen].bounds.size.width == 750) ? YES : NO)
#define iPhone6P                 (([UIScreen mainScreen].bounds.size.width == 1080) ? YES : NO)
#define Custom_Blue_Select       [[UIColor alloc] initWithRed:178.0/255.0 green:210.0/255.0 blue:252.0/255.0 alpha:1]
#define IMAGEOF(x)               ([UIImage imageNamed:x])
/*
 *  设备Bounds
 */
#define UI_SCREEN_BOUND ([[UIScreen mainScreen] bounds])

/**
 *  设备宽度
 */
#define UI_SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
/**
 *  设备高度
 */
#define UI_SCREEN_HEIGHT  ([[UIScreen mainScreen] bounds].size.height)

/*
 * 设备scale
 */

#define UI_MAIN_SCALE ([UIScreen mainScreen].scale)

/**
 *  设备高度
 */
#define Nav_HEIGHT  64
#define Tab_HEIGHT  60

#define TT_FLIP_TRANSITION_DURATION 0.5
/**
 *  设定颜色值
 */
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBA(r, g, b, a)    [UIColor colorWithRed:(CGFloat)((r)/255.0) green:(CGFloat)((g)/255.0) blue:(CGFloat)((b)/255.0) alpha:(CGFloat)(a)]

#define RGB(r, g, b)        RGBA(r, g, b, 1.0)

#define TABLE_BGCLR         RGB(0xF7, 0xF7, 0xF7)

//文交所资讯信息

#define WJSINFO_IMGURL      @"WJSInfoImgUrl"
#define WJSINFO_TITLE       @"WJSInfoTitleName"
#define WJSINFO_DETAIL      @"WJSInfoDetail"

#define JSON_RES_SUCC       @"success"
#define JSON_RES_FAIL       @"error"

//行情信息
#define QUOTA_NAME          @"name"
#define QUOTA_STATUS        @"status"
#define QUOTA_SALES         @"transaction"
#define QUOTA_PRICE         @"price"
#define QUOTA_ALL_PRICE     @"capitalization"
#define QUOTA_RATE          @"rate"

#define NAV_TO_HOMEVC       @"Nav_To_HomeVC"
//网络请求的回调信息
typedef void (^SuccBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);
typedef void (^FailBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

#endif /* WJSCommonDefine_h */
