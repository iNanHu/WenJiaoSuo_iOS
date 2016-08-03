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
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrViews;
@property (nonatomic, strong) NSArray *arrImgInfo;
@property (nonatomic, strong) NSArray *arrQuotaInfo;
@property (nonatomic, strong) NSArray *arrListData;
@end

@implementation QuotationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [self initData];
    [self initCtrl];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
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
    
    _arrListData = [[WJSDataModel shareInstance] arrQuotation];
    
}
- (void)initCtrl {
    
    //隐藏导航栏左右按钮
    self.hidLeftButton = YES;
    self.hidRightButton = YES;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Nav_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - Tab_HEIGHT - Nav_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"QuotationCell" bundle:nil] forCellReuseIdentifier:TABLEVIEWCELLID];
    [self.view addSubview:_tableView];
    
    [_tableView setBackgroundColor:RGB(0xF7, 0xF7, 0xF7)];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _arrListData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_arrListData.count == 0) return nil;
    
    QuotationCell *cell = [tableView dequeueReusableCellWithIdentifier:TABLEVIEWCELLID];
    if (!cell) {
        cell = [[QuotationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TABLEVIEWCELLID];
    }
    
    [self setCellModel:cell withInfo:[_arrListData objectAtIndex:indexPath.section]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setCellModel:(QuotationCell *)cell withInfo:(NSDictionary *)dicInfo {
    
    if (!dicInfo) return ;
    
    QuotationModel *model = [[QuotationModel alloc] init];
    model.strWjsName = [dicInfo objectForKey:QUOTA_NAME];
    model.strWjsImgUrl = [dicInfo objectForKey:QUOTA_NAME];
    model.strUpCount = [NSString stringWithFormat:@"上涨数：%@",[dicInfo objectForKey:QUOTA_UPCOUNT] != nil?[dicInfo objectForKey:QUOTA_UPCOUNT]:@"--" ];
    model.strDownCount = [NSString stringWithFormat:@"下跌数：%@",[dicInfo objectForKey:QUOTA_DOWNCOUNT] != nil?[dicInfo objectForKey:QUOTA_DOWNCOUNT]:@"--" ];
    model.strPlateCount = [NSString stringWithFormat:@"平盘数：%@只",[dicInfo objectForKey:QUOTA_PLATECOUNT] != nil?[dicInfo objectForKey:QUOTA_PLATECOUNT]:@"--" ];
    model.strTrading = [NSString stringWithFormat:@"成交量：%@",[dicInfo objectForKey:QUOTA_CJL] != nil?[dicInfo objectForKey:QUOTA_CJL]:@"--" ];
    model.strTransactions = [NSString stringWithFormat:@"成交额：%@",[dicInfo objectForKey:QUOTA_CJE] != nil?[dicInfo objectForKey:QUOTA_CJE]:@"--" ];
    model.strMarketCapitalisation = [NSString stringWithFormat:@"总市值：%@",[dicInfo objectForKey:QUOTA_ZSZ] != nil?[dicInfo objectForKey:QUOTA_ZSZ]:@"--" ];
    model.strMoneyIn = [NSString stringWithFormat:@"今日开盘：%@",[dicInfo objectForKey:QUOTA_JRKP] != nil?[dicInfo objectForKey:QUOTA_JRKP]:@"--" ];
    model.strMoneyOut = [NSString stringWithFormat:@"最高指数：%@",[dicInfo objectForKey:QUOTA_ZGZS] != nil?[dicInfo objectForKey:QUOTA_ZGZS]:@"--" ];
    model.strInflows = [NSString stringWithFormat:@"最低指数：%@",[dicInfo objectForKey:QUOTA_ZDZS] != nil?[dicInfo objectForKey:QUOTA_ZDZS]:@"--" ];
    
    [cell setQuotationModel:model];
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//        
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//        
//    }
//    
//}

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
