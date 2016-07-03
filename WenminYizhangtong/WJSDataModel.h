//
//  WJSDataModel.h
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/7/2.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJSDataModel : NSObject

@property (nonatomic, copy) NSString *userEmail;
@property (nonatomic, copy) NSString *userPhone;
@property (nonatomic, copy) NSString *userPassword;
@property (nonatomic, copy) NSString *uId;
@property (nonatomic, copy) NSArray *arrWJSList;

+(id)shareInstance;
@end
