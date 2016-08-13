//
//  WJSTool.h
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/6/24.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIkit/UIKit.h>

@interface WJSTool : NSObject

//获取纯色图片
+ (UIImage *)ImageWithColor:(UIColor*)bgColor andFrame:(CGRect) rect;

+ (UIImage*) createRaduisImageWithColor: (UIColor*) color andFrame:(CGRect) rect;

+(NSDictionary *) getQuotationWithServ:(NSString*)servAddr andWJSId:(NSInteger) wjsId;
//MD5加密
+ (NSString *)getMD5Val:(NSString *)strVal;
//手机号
+ (BOOL)validateMobile:(NSString *)phoneNum;
//电子邮件
+ (BOOL) validateEmail:(NSString *)email;
//用户名验证
+ (BOOL) validateUserName:(NSString *)name;
//密码验证
+ (BOOL) validatePassword:(NSString *)passWord;
//身份证号验证
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
//手机验证码验证
+ (BOOL)chekSecurityCode:(NSString *) code;
@end
