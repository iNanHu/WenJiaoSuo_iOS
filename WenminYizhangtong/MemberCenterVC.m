//
//  MemberCenterVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/7/28.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#define TableHeaderHeight 55
#define TableCellHeight 80 
#define TableCellId @"tableViewCellId"

#import "MemberCenterVC.h"
#import "WJSCommonDefine.h"
#import "WJSDataModel.h"
#import "WJSDataManager.h"

@interface MemberCenterVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headIconImgView;
@property (weak, nonatomic) IBOutlet UIImageView *myDegreeView;
@property (weak, nonatomic) IBOutlet UILabel *nickLab;
@property (weak, nonatomic) IBOutlet UILabel *degreeLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//data
@property (nonatomic, strong)NSMutableDictionary *dicUserInfo;
@property (nonatomic, strong)NSArray *arrImg;
@property (nonatomic, strong)NSArray *arrDetailInfo;
@property (nonatomic, strong)NSArray *arrTitleInfo;
@end

@implementation MemberCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"会员中心";
    _arrImg = @[@"tong",@"yin",@"jin",@"zuan"];
    _arrTitleInfo = @[@"铜牌经纪人",@"银牌经纪人",@"金牌经纪人",@"钻石合伙人"];
    _arrDetailInfo = @[@"3个",@"36个",@"120个",@"600个"];
    _dicUserInfo = [[WJSDataModel shareInstance] dicUserInfo];
    [self initCtrl];
    [self initData];
}

- (void)initData {
    
    NSString *strNickName = [_dicUserInfo objectForKey:@"username"];
    NSInteger rank = 0;
    NSString *strRank = [_dicUserInfo objectForKey:@"rank"];
    if ([strRank isEqual:[NSNull null]]) {
        rank = 0;
    }else {
        for (int i = 0; i < _arrTitleInfo.count; i++) {
            if ([strRank isEqualToString:_arrTitleInfo[i]]) {
                rank = i;
                break;
            }
        }
    }
    
   _headIconImgView.image = [UIImage imageNamed:@"default"];
    _myDegreeView.image = [UIImage imageNamed:_arrImg[rank]];
    _nickLab.text = [NSString stringWithFormat:@"Hi，%@",strNickName];
    _degreeLab.text = [NSString stringWithFormat:@"您当前为%@",_arrTitleInfo[rank]];
}

- (void)initCtrl {
    
    _headIconImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headIconImgView.layer.borderWidth = 4.0/UI_MAIN_SCALE;
    _headIconImgView.layer.cornerRadius = 40.f;
    _headIconImgView.layer.masksToBounds = YES;
    _myDegreeView.layer.cornerRadius = 15.f;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"MemberCenterCell" bundle:nil] forCellReuseIdentifier:TableCellId];
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0)
        return  TableHeaderHeight;
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return .1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _arrTitleInfo.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return TableCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, TableHeaderHeight)];
    [headView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, TableHeaderHeight)];
    [titleLab setText:@"等级"];
    [titleLab setFont:[UIFont systemFontOfSize:14.f]];
    titleLab.textColor = RGB(82, 82, 82);
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [headView addSubview:titleLab];
    
    UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, UI_SCREEN_WIDTH - 150, TableHeaderHeight)];
    [contentLab setText:@"荣升标准\n(一度粉丝与二度粉丝数量之和>=)"];
    contentLab.textColor = RGB(82, 82, 82);
    contentLab.lineBreakMode = UILineBreakModeWordWrap;
    [contentLab setNumberOfLines:0];
    [contentLab setTextAlignment:NSTextAlignmentCenter];
    [contentLab setFont:[UIFont systemFontOfSize:14.f]];
    [headView addSubview:contentLab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(150, 5, 2.0/UI_MAIN_SCALE, TableHeaderHeight - 10)];
    [lineView setBackgroundColor:RGB(0xA0, 0xA0, 0xA0)];
    [headView addSubview:lineView];
    
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableCellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableCellId];
    }
    UIImageView *iconView = [cell viewWithTag:100];
    UILabel *iconLab = [cell viewWithTag:101];
    UILabel *contentLab = [cell viewWithTag:102];
    [iconView setImage:[UIImage imageNamed:_arrImg[indexPath.row]]];
    [iconLab setText:_arrTitleInfo[indexPath.row]];
    [contentLab setText:_arrDetailInfo[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
