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
@property (nonatomic, assign) BOOL enablePropel;
@property (nonatomic, copy) NSArray *arrNewCategory; //分类信息
@property (nonatomic, copy) NSMutableDictionary *dicUserInfo;
@property (nonatomic, copy) NSArray *arrWJSList;
@property (nonatomic, copy) NSArray *arrShuffInfo; //轮播信息
@property (nonatomic, copy) NSMutableArray *arrQuotation; //行情信息
@property (nonatomic, copy) NSMutableArray *arrMyFansList; //粉丝列表

+(id)shareInstance;
@end
