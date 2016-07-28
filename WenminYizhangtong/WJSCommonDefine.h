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
//41E57868
#define WxShareAppSecret @"42f3ca39d8a2d2228a90eb4ed7a76522"
#define WxAppId @"wxe4083fddc9a7277b"
#define QQAppId @"1105481323"
#define QQAppKey @"2cHbXqfwpneKDypE"
#define UMAppKey @"YELO-EBZP-YUYW-J2WC-846U-4638-4CCJ-HYH6-6P9R"

#define QUOTATION_SERV_ADDR @"http://www.youbicard.com/plus/data/index.php?eid="

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

#define TT_FLIP_TRANSITION_DURATION 0.5

/*
 * 设备scale
 */

#define UI_MAIN_SCALE ([UIScreen mainScreen].scale)

/**
 *  设备高度
 */
#define Nav_HEIGHT  64
#define Tab_HEIGHT  45

#define TT_FLIP_TRANSITION_DURATION 0.5
/**
 *  设定颜色值
 */
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBA(r, g, b, a)    [UIColor colorWithRed:(CGFloat)((r)/255.0) green:(CGFloat)((g)/255.0) blue:(CGFloat)((b)/255.0) alpha:(CGFloat)(a)]

#define RGB(r, g, b)        RGBA(r, g, b, 1.0)

#define TABLE_BGCLR         RGB(0xF7, 0xF7, 0xF7)

//文交所资讯信息

#define WJSINFO_ID          @"content_id"
#define WJSINFO_IMGURL      @"image"
#define WJSINFO_TITLE       @"title"
#define WJSINFO_DETAIL      @"description"
#define WJSINFO_URL         @"curl"
#define WJSINFO_TIME        @"time"
#define WJSINFO_NAME        @"class_name"
#define WJSINFO_INDEX       @"i"
#define WJSINFO_VISIT_COUNT @"views"

#define JSON_RES_SUCC       @"success"
#define JSON_RES_FAIL       @"error"

//行情信息
#define QUOTA_NAME          @"文交所名称"             //文交所名称
#define QUOTA_STATUS        @"文交所状态"           //状态
#define QUOTA_UPCOUNT       @"上涨数"              //上涨数
#define QUOTA_DOWNCOUNT     @"下跌数"              //下跌数
#define QUOTA_PLATECOUNT    @"平盘数"              //平盘数
#define QUOTA_CJL           @"成交量"
#define QUOTA_CJE           @"成交额"      //成交总量
#define QUOTA_ZSZ           @"总市值"           //成交额
#define QUOTA_JRKP          @"今日开盘" //成交总量
#define QUOTA_ZGZS          @"最高指数"
#define QUOTA_ZDZS          @"最低指数"
#define QUOTA_ZRKP          @"昨日收盘"           //成交
#define QUOTA_GXSJ          @"更新时间"
#define QUOTA_CPZS          @"藏品总数"

#define NAV_TO_HOMEVC       @"Nav_To_HomeVC"
#define NAV_TO_TUTORIALVC @"SegToTutorialVC"
//网络请求的回调信息
typedef void (^SuccBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);
typedef void (^FailBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

#endif /* WJSCommonDefine_h */
