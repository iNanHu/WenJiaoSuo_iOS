//
//  QuotationCell.h
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/7/27.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuotationModel.h"

@interface QuotationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *wjsIconView;
@property (weak, nonatomic) IBOutlet UILabel *labWjsName;
@property (weak, nonatomic) IBOutlet UIImageView *wjsStateView;
@property (weak, nonatomic) IBOutlet UILabel *labUpCount;
@property (weak, nonatomic) IBOutlet UILabel *labPlatCount;
@property (weak, nonatomic) IBOutlet UILabel *labDownCount;
@property (weak, nonatomic) IBOutlet UILabel *labTrading;
@property (weak, nonatomic) IBOutlet UILabel *labTransactions;
@property (weak, nonatomic) IBOutlet UILabel *labMarketCapitalisation;
@property (weak, nonatomic) IBOutlet UILabel *labMoneyIn;
@property (weak, nonatomic) IBOutlet UILabel *labMoneyOut;
@property (weak, nonatomic) IBOutlet UILabel *labInflows;

- (void)setQuotationModel:(QuotationModel *)model;
@end
