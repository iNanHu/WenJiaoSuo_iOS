//
//  QuotationModel.h
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/7/27.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuotationModel : NSObject
@property (strong, nonatomic) NSString *strWjsImgUrl;   //文交所图片
@property (strong, nonatomic) NSString *strWjsName;     //文交所名称
@property (strong, nonatomic) NSString *strWjsState;    //文交所状态
@property (strong, nonatomic) NSString *strUpCount;     //上涨数
@property (strong, nonatomic) NSString *strPlateCount;  //平盘数
@property (strong, nonatomic) NSString *strDownCount;   //下跌数
@property (strong, nonatomic) NSString *strTrading;     //成交量
@property (strong, nonatomic) NSString *strTransactions;    //成交额
@property (strong, nonatomic) NSString *strMarketCapitalisation;    //总市值
@property (strong, nonatomic) NSString *strMoneyIn;     //资金流入
@property (strong, nonatomic) NSString *strMoneyOut;    //资金流出
@property (strong, nonatomic) NSString *strInflows;     //净流入
@end
