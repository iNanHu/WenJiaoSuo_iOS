//
//  QuotationVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/6/19.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "QuotationVC.h"
#import "WJSTool.h"
#import "QuotationModel.h"
#import "QuotationCell.h"
#import "WJSDataManager.h"
#import "LiuXSegmentView.h"

#define TABLEVIEWCELLID @"tableviewcellId"

@interface QuotationVC ()
@property (nonatomic, strong) NSMutableArray *segDataArr;
@property (nonatomic, strong) LiuXSegmentView *segmentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *arrViews;
@property (nonatomic, strong) NSArray *arrQuotaInfo;
@property (nonatomic, strong) NSArray *arrListData;
@end

@implementation QuotationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initCtrl];
}
- (void)initData {
    
    _segDataArr = [NSMutableArray arrayWithCapacity:0];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"QuotationInfo" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    _arrQuotaInfo = [NSArray arrayWithArray:[data objectForKey:@"quotationInfoList"]];
    
    for(int i = 0; i < [_arrQuotaInfo count]; i++)
    {
        NSDictionary *dic = [_arrQuotaInfo objectAtIndex:i];
        NSString *name = [dic objectForKey:@"Name"];
        NSLog(@"name: %@",name);
        [_segDataArr addObject:name];
    }
    
//    NSString *name = [dicInfo objectForKey:QUOTA_NAME];
//    NSString *status = [dicInfo objectForKey:QUOTA_STATUS];
//    NSString *sales = [dicInfo objectForKey:QUOTA_SALES];
//    NSString *price = [dicInfo objectForKey:QUOTA_PRICE];
//    NSString *allPrice = [dicInfo objectForKey:QUOTA_ALL_PRICE];
//    NSString *rate = [dicInfo objectForKey:QUOTA_RATE];
    
    _arrListData = [[WJSDataModel shareInstance] arrQuotation];
    
//    _arrListData = @[@{QUOTA_NAME:@"广顺前邮",QUOTA_STATUS:@"已收盘",QUOTA_SALES:@"9.04亿",QUOTA_PRICE:@"2742.92",QUOTA_ALL_PRICE:@"60.36亿",QUOTA_RATE:@"1.22"},
//                     @{QUOTA_NAME:@"广顺前邮",QUOTA_STATUS:@"已收盘",QUOTA_SALES:@"9.04亿",QUOTA_PRICE:@"2742.92",QUOTA_ALL_PRICE:@"60.36亿",QUOTA_RATE:@"1.22"},
//                     @{QUOTA_NAME:@"广顺前邮",QUOTA_STATUS:@"已收盘",QUOTA_SALES:@"9.04亿",QUOTA_PRICE:@"2742.92",QUOTA_ALL_PRICE:@"60.36亿",QUOTA_RATE:@"1.22"},
//                     @{QUOTA_NAME:@"广顺前邮",QUOTA_STATUS:@"已收盘",QUOTA_SALES:@"9.04亿",QUOTA_PRICE:@"2742.92",QUOTA_ALL_PRICE:@"60.36亿",QUOTA_RATE:@"1.22"},
//                     @{QUOTA_NAME:@"广顺前邮",QUOTA_STATUS:@"已收盘",QUOTA_SALES:@"9.04亿",QUOTA_PRICE:@"2742.92",QUOTA_ALL_PRICE:@"60.36亿",QUOTA_RATE:@"1.22"},
//                     @{QUOTA_NAME:@"广顺前邮",QUOTA_STATUS:@"已收盘",QUOTA_SALES:@"9.04亿",QUOTA_PRICE:@"2742.92",QUOTA_ALL_PRICE:@"60.36亿",QUOTA_RATE:@"1.22"},
//                     @{QUOTA_NAME:@"广顺前邮",QUOTA_STATUS:@"已收盘",QUOTA_SALES:@"9.04亿",QUOTA_PRICE:@"2742.92",QUOTA_ALL_PRICE:@"60.36亿",QUOTA_RATE:@"1.22"},
//                     @{QUOTA_NAME:@"广顺前邮",QUOTA_STATUS:@"已收盘",QUOTA_SALES:@"9.04亿",QUOTA_PRICE:@"2742.92",QUOTA_ALL_PRICE:@"60.36亿",QUOTA_RATE:@"1.22"},
//                     @{QUOTA_NAME:@"广顺前邮",QUOTA_STATUS:@"已收盘",QUOTA_SALES:@"9.04亿",QUOTA_PRICE:@"2742.92",QUOTA_ALL_PRICE:@"60.36亿",QUOTA_RATE:@"1.22"}];
    
}
- (void)initCtrl {
    
    //隐藏导航栏左右按钮
    self.hidLeftButton = YES;
    self.hidRightButton = YES;
    self.navigationItem.hidesBackButton = YES;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 2*Tab_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 2*Tab_HEIGHT)];
    
    for (int i = 0; i < _segDataArr.count; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 20) style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerNib:[UINib nibWithNibName:@"QuotationCell" bundle:nil] forCellReuseIdentifier:TABLEVIEWCELLID];
        [_scrollView addSubview:tableView];
        [_arrViews addObject:tableView];
    }
    _segmentView = [[LiuXSegmentView alloc] initWithFrame:CGRectMake(0, 60, UI_SCREEN_WIDTH, 60) titles:_segDataArr clickBlick:^(NSInteger index){
        int posX = [UIScreen mainScreen].bounds.size.width * index;
        [_scrollView setContentOffset:CGPointMake(posX, 0) animated:YES];
    }];
    [self.view addSubview:_scrollView];
    [self.view addSubview:_segmentView];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrListData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 187;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_arrListData.count == 0) return nil;
    
    QuotationCell *cell = [tableView dequeueReusableCellWithIdentifier:TABLEVIEWCELLID];
    if (!cell) {
        cell = [[QuotationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TABLEVIEWCELLID];
    }
    
    [self setCellModel:cell withInfo:[_arrListData objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setCellModel:(QuotationCell *)cell withInfo:(NSDictionary *)dicInfo {
    
    if (!dicInfo) return ;
    
    NSArray *arrWJSList = [[WJSDataModel shareInstance] arrWJSList];
    QuotationModel *model = [[QuotationModel alloc] init];
    model.strWjsName = [dicInfo objectForKey:QUOTA_NAME];
    model.strUpCount = [NSString stringWithFormat:@"上涨数：%@",[dicInfo objectForKey:QUOTA_UPCOUNT] ];
    model.strDownCount = [NSString stringWithFormat:@"下跌数：%@",[dicInfo objectForKey:QUOTA_DOWNCOUNT] ];
    model.strPlateCount = [NSString stringWithFormat:@"平盘数：%@",[dicInfo objectForKey:QUOTA_PLATECOUNT] ];
    model.strTrading = [NSString stringWithFormat:@"成交量：%@",[dicInfo objectForKey:QUOTA_CJL] ];
    model.strTransactions = [NSString stringWithFormat:@"成交额：%@",[dicInfo objectForKey:QUOTA_CJE] ];
    model.strMarketCapitalisation = [NSString stringWithFormat:@"总市值：%@",[dicInfo objectForKey:QUOTA_ZSZ] ];
    model.strMoneyIn = [NSString stringWithFormat:@"今日开盘：%@",[dicInfo objectForKey:QUOTA_JRKP] ];
    model.strMoneyOut = [NSString stringWithFormat:@"最高指数：%@",[dicInfo objectForKey:QUOTA_ZGZS] ];
    model.strInflows = [NSString stringWithFormat:@"下最低指数：%@",[dicInfo objectForKey:QUOTA_ZDZS] ];
    
    [cell setQuotationModel:model];
    
    
//    UILabel *nameLab = (UILabel *)[cell viewWithTag:101];
//    UILabel *statusLab = (UILabel *)[cell viewWithTag:100];
//    UILabel *salesLab = (UILabel *)[cell viewWithTag:102];
//    UILabel *priceLab = (UILabel *)[cell viewWithTag:103];
//    UILabel *allPriceLab = (UILabel *)[cell viewWithTag:104];
//    UILabel *rateLab = (UILabel *)[cell viewWithTag:105];
//    
//    if (!nameLab || !statusLab || !salesLab || !priceLab || !allPriceLab || !rateLab) return ;
//    
//    [nameLab setFont:[UIFont boldSystemFontOfSize:16.f]];
//    [nameLab setTextColor:[UIColor blackColor]];
//    [nameLab setText:name];
//    
//    NSString *strStatus = @"";
//    for (int i = 0; i < status.length - 1; i++) {
//        strStatus = [strStatus stringByAppendingFormat:@"%@\n",[status substringWithRange:NSMakeRange(i, 1)]];
//    }
//    strStatus = [strStatus stringByAppendingFormat:@"%@",[status substringWithRange:NSMakeRange(status.length-1, 1)]];
//    
//    [statusLab setFont:[UIFont systemFontOfSize:14.f]];
//    [statusLab setTextColor:RGB(0xB0, 0xB0, 0xB0)];
//    [statusLab setText:strStatus];
//    [statusLab setTextAlignment:NSTextAlignmentCenter];
//    statusLab.numberOfLines = [statusLab.text length];
//    
//    [salesLab setFont:[UIFont systemFontOfSize:14.f]];
//    [salesLab setTextColor:RGB(0xB0, 0xB0, 0xB0)];
//    [salesLab setText:[NSString stringWithFormat:@"成交额:%@",sales]];
//    
//    [priceLab setFont:[UIFont systemFontOfSize:16.f]];
//    [priceLab setTextAlignment:NSTextAlignmentRight];
//    [priceLab setText:price];
//    
//    [allPriceLab setFont:[UIFont systemFontOfSize:14.f]];
//    [allPriceLab setTextColor:RGB(0xB0, 0xB0, 0xB0)];
//    [allPriceLab setTextAlignment:NSTextAlignmentRight];
//    [allPriceLab setText:[NSString stringWithFormat:@"市值:%@",allPrice]];
//    
//    [rateLab setText:rate];
//    [rateLab setTextColor:[UIColor whiteColor]];
//    [rateLab setFont:[UIFont systemFontOfSize:16.f]];
//    rateLab.layer.cornerRadius = 5.f;
//    CGFloat rateF = [rate floatValue];
//    if (rateF > 0.0)
//        [rateLab setBackgroundColor:[UIColor redColor]];
//    else
//        [rateLab setBackgroundColor:[UIColor greenColor]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        ;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
