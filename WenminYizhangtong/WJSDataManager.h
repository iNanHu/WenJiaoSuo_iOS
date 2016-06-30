//
//  WJSDataManager.h
//  WenminYizhangtong
//
//  Created by 壹道IOS开发 on 16/6/30.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJSCommonDefine.h"

@interface WJSDataManager : NSObject

//注册账号
- (void)registerUserAccWithUserName:(NSString *)userName andUserEmail:(NSString *)userEmail andUserPsd:(NSString *)userPsd andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;
//登录账号
- (void)loginUserAccWithUserName:(NSString *)userName andUserPsd:(NSString *)userPsd andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;
//找回密码
- (void)FindPsdWithUserEmail:(NSString *)userEmail andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;
@end
