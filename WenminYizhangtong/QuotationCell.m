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
    
    //分割线
    self.line = [[UIView alloc] init];
    CGRect lineRect = CGRectMake(0, 45, UI_SCREEN_WIDTH, 1.0/UI_MAIN_SCALE);
    self.line.frame = lineRect;
    self.line.layer.borderWidth = 0;
    [self.line setBackgroundColor:RGB(0xA0, 0xA0, 0xA0)];
    [self addSubview:self.line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

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
