//
//  QuotationVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/6/19.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "QuotationVC.h"
#import "WJSDataManager.h"
#import "LiuXSegmentView.h"

#define TABLEVIEWCELLID @"tableviewcellId"

@interface QuotationVC ()
@property (nonatomic, strong) NSMutableArray *segDataArr;
@property (nonatomic, strong) LiuXSegmentView *segmentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *arrViews;
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
    NSArray *arrTemp = [[WJSDataModel shareInstance] arrWJSList];
    for (NSDictionary *dic in arrTemp) {
        NSString *name = [dic objectForKey:@"name"];
        [_segDataArr addObject:name];
    }
    
    _segDataArr = [NSMutableArray arrayWithArray:@[@"南京",@"中南",@"南方",@"中艺",@"渤商",@"吉林",@"福利特"]];
//    NSString *name = [dicInfo objectForKey:QUOTA_NAME];
//    NSString *status = [dicInfo objectForKey:QUOTA_STATUS];
//    NSString *sales = [dicInfo objectForKey:QUOTA_SALES];
//    NSString *price = [dicInfo objectForKey:QUOTA_PRICE];
//    NSString *allPrice = [dicInfo objectForKey:QUOTA_ALL_PRICE];
//    NSString *rate = [dicInfo objectForKey:QUOTA_RATE];
    _arrListData = @[@{QUOTA_NAME:@"广顺前邮",QUOTA_STATUS:@"已收盘",QUOTA_SALES:@"9.04亿",QUOTA_PRICE:@"2742.92",QUOTA_ALL_PRICE:@"60.36亿",QUOTA_RATE:@"1.22"},
                     @{QUOTA_NAME:@"广顺前邮",QUOTA_STATUS:@"已收盘",QUOTA_SALES:@"9.04亿",QUOTA_PRICE:@"2742.92",QUOTA_ALL_PRICE:@"60.36亿",QUOTA_RATE:@"1.22"},
                     @{QUOTA_NAME:@"广顺前邮",QUOTA_STATUS:@"已收盘",QUOTA_SALES:@"9.04亿",QUOTA_PRICE:@"2742.92",QUOTA_ALL_PRICE:@"60.36亿",QUOTA_RATE:@"1.22"},
                     @{QUOTA_NAME:@"广顺前邮",QUOTA_STATUS:@"已收盘",QUOTA_SALES:@"9.04亿",QUOTA_PRICE:@"2742.92",QUOTA_ALL_PRICE:@"60.36亿",QUOTA_RATE:@"1.22"},
                     @{QUOTA_NAME:@"广顺前邮",QUOTA_STATUS:@"已收盘",QUOTA_SALES:@"9.04亿",QUOTA_PRICE:@"2742.92",QUOTA_ALL_PRICE:@"60.36亿",QUOTA_RATE:@"1.22"},
                     @{QUOTA_NAME:@"广顺前邮",QUOTA_STATUS:@"已收盘",QUOTA_SALES:@"9.04亿",QUOTA_PRICE:@"2742.92",QUOTA_ALL_PRICE:@"60.36亿",QUOTA_RATE:@"1.22"},
                     @{QUOTA_NAME:@"广顺前邮",QUOTA_STATUS:@"已收盘",QUOTA_SALES:@"9.04亿",QUOTA_PRICE:@"2742.92",QUOTA_ALL_PRICE:@"60.36亿",QUOTA_RATE:@"1.22"},
                     @{QUOTA_NAME:@"广顺前邮",QUOTA_STATUS:@"已收盘",QUOTA_SALES:@"9.04亿",QUOTA_PRICE:@"2742.92",QUOTA_ALL_PRICE:@"60.36亿",QUOTA_RATE:@"1.22"},
                     @{QUOTA_NAME:@"广顺前邮",QUOTA_STATUS:@"已收盘",QUOTA_SALES:@"9.04亿",QUOTA_PRICE:@"2742.92",QUOTA_ALL_PRICE:@"60.36亿",QUOTA_RATE:@"1.22"}];
}
- (void)initCtrl {
    
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
    return 60;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_arrListData.count == 0) return nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TABLEVIEWCELLID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TABLEVIEWCELLID];
    }
    
    [self setCellModel:cell withInfo:[_arrListData objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setCellModel:(UITableViewCell *)cell withInfo:(NSDictionary *)dicInfo {
    
    if (!dicInfo) return ;
 
    NSString *name = [dicInfo objectForKey:QUOTA_NAME];
    NSString *status = [dicInfo objectForKey:QUOTA_STATUS];
    NSString *sales = [dicInfo objectForKey:QUOTA_SALES];
    NSString *price = [dicInfo objectForKey:QUOTA_PRICE];
    NSString *allPrice = [dicInfo objectForKey:QUOTA_ALL_PRICE];
    NSString *rate = [dicInfo objectForKey:QUOTA_RATE];
    
    UILabel *nameLab = (UILabel *)[cell viewWithTag:101];
    UILabel *statusLab = (UILabel *)[cell viewWithTag:100];
    UILabel *salesLab = (UILabel *)[cell viewWithTag:102];
    UILabel *priceLab = (UILabel *)[cell viewWithTag:103];
    UILabel *allPriceLab = (UILabel *)[cell viewWithTag:104];
    UILabel *rateLab = (UILabel *)[cell viewWithTag:105];
    
    if (!nameLab || !statusLab || !salesLab || !priceLab || !allPriceLab || !rateLab) return ;
    
    [nameLab setFont:[UIFont boldSystemFontOfSize:16.f]];
    [nameLab setTextColor:[UIColor blackColor]];
    [nameLab setText:name];
    
    NSString *strStatus = @"";
    for (int i = 0; i < status.length - 1; i++) {
        strStatus = [strStatus stringByAppendingFormat:@"%@\n",[status substringWithRange:NSMakeRange(i, 1)]];
    }
    strStatus = [strStatus stringByAppendingFormat:@"%@",[status substringWithRange:NSMakeRange(status.length-1, 1)]];
    
    [statusLab setFont:[UIFont systemFontOfSize:14.f]];
    [statusLab setTextColor:RGB(0xB0, 0xB0, 0xB0)];
    [statusLab setText:strStatus];
    [statusLab setTextAlignment:NSTextAlignmentCenter];
    statusLab.numberOfLines = [statusLab.text length];
    
    [salesLab setFont:[UIFont systemFontOfSize:14.f]];
    [salesLab setTextColor:RGB(0xB0, 0xB0, 0xB0)];
    [salesLab setText:[NSString stringWithFormat:@"成交额:%@",sales]];
    
    [priceLab setFont:[UIFont systemFontOfSize:16.f]];
    [priceLab setTextAlignment:NSTextAlignmentRight];
    [priceLab setText:price];
    
    [allPriceLab setFont:[UIFont systemFontOfSize:14.f]];
    [allPriceLab setTextColor:RGB(0xB0, 0xB0, 0xB0)];
    [allPriceLab setTextAlignment:NSTextAlignmentRight];
    [allPriceLab setText:[NSString stringWithFormat:@"市值:%@",allPrice]];
    
    [rateLab setText:rate];
    [rateLab setTextColor:[UIColor whiteColor]];
    [rateLab setFont:[UIFont systemFontOfSize:16.f]];
    rateLab.layer.cornerRadius = 5.f;
    CGFloat rateF = [rate floatValue];
    if (rateF > 0.0)
        [rateLab setBackgroundColor:[UIColor redColor]];
    else
        [rateLab setBackgroundColor:[UIColor greenColor]];
    
    
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
