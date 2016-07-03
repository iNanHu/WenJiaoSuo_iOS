//
//  WJSDataModel.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/7/2.
//  Copyright © 2016年 alexyang. All rights reserved.
//

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
    return @"";
}

- (void)setUserPhone:(NSString *)userPhone {
    
}

- (NSString *)userEmail {
    return @"";
}

- (void)setUserEmail:(NSString *)userEmail {

}

- (NSString *)userPassword {
    return @"";
}

- (void)setUserPassword:(NSString *)userPassword {

}
@end
