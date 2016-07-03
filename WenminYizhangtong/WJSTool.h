//
//  WJSTool.h
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/6/24.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJSTool : NSObject

+ (NSString*) urlstring:(NSString*)strurl;
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
@end
