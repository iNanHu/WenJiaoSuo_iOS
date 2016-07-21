//
//  WJSDataModel.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/7/2.
//  Copyright © 2016年 alexyang. All rights reserved.
//
#define kUsernameKey @"login_username_key"
#define kPasswordKey @"login_pwd_key"
#import "WJSDataModel.h"

@implementation WJSDataModel

+(id)shareInstance {
    
    static dispatch_once_t predicate;
    static WJSDataModel *dataModel;
    dispatch_once(&predicate, ^{
        dataModel = [[self alloc] init];
    });
    return dataModel;
}

- (NSString *)userPhone {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:kUsernameKey];
}

- (void)setUserPhone:(NSString *)userPhone {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userPhone forKey:kUsernameKey];
    [userDefaults synchronize];
}

- (NSString *)userEmail {
    return @"";
}

- (void)setUserEmail:(NSString *)userEmail {

}

- (NSString *)userPassword {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:kPasswordKey];
}

- (void)setUserPassword:(NSString *)userPassword {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userPassword forKey:kPasswordKey];
    [userDefaults synchronize];
}
@end
