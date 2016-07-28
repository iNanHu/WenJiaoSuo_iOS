//
//  QuotationCell.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/7/27.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "QuotationCell.h"
#import "WJSCommonDefine.h"
#import <UIImageView+WebCache.h>

@implementation QuotationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.line.layer.borderWidth = 1.0/UI_MAIN_SCALE;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setQuotationModel:(QuotationModel *)model {
    
    [self.wjsIconView setImage:[UIImage imageNamed:model.strWjsImgUrl]];
    [self.wjsStateView setImage:[UIImage imageNamed:model.strWjsState]];
    self.labWjsName.text = model.strWjsName;
    self.labUpCount.text = model.strUpCount;
    self.labPlatCount.text = model.strPlateCount;
    self.labDownCount.text = model.strDownCount;
    self.labTrading.text = model.strTrading;
    self.labTransactions.text = model.strTransactions;
    self.labMarketCapitalisation.text = model.strMarketCapitalisation;
    self.labMoneyIn.text = model.strMoneyIn;
    self.labMoneyOut.text = model.strMoneyOut;
    self.labInflows.text = model.strInflows;
}

@end
