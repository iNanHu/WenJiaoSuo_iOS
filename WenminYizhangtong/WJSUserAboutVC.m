//
//  WJSUserAboutVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/7/23.
//  Copyright © 2016年 alexyang. All rights reserved.
//
#define AboutTableCell @"aboutTableCell"
#define TableHead_Height 160
#define ICON_SIZE 80

#import "WJSUserAboutVC.h"
#import "WJSCommonDefine.h"

@interface WJSUserAboutVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *aboutTableView;
@property (strong, nonatomic) NSArray *arrName;

@end

@implementation WJSUserAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们";
    [self initData];
    [self initCtrl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initCtrl {
    _aboutTableView.delegate = self;
    _aboutTableView.dataSource = self;
    _aboutTableView.tableHeaderView = [self headeView];
    if ([_aboutTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_aboutTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_aboutTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_aboutTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [_aboutTableView setBackgroundColor:RGB(0xF7, 0xF7, 0xF7)];
    [_aboutTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:AboutTableCell];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initData {
    
    _arrName = @[@"联系我们",@"使用帮助",@"商务合作",@"产品介绍"];
}

- (UIView *)headeView {
    
    UIView *headView = [UIView new];
    headView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, TableHead_Height);
    
    UIImageView *iconView = [UIImageView new];
    iconView.frame = CGRectMake((UI_SCREEN_WIDTH - ICON_SIZE)/2, 20, ICON_SIZE, ICON_SIZE);
    iconView.image = [UIImage imageNamed:@"80"];
    iconView.layer.cornerRadius = 5.f;
    [headView addSubview:iconView];
    
    UILabel *verLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iconView.frame) + 10, UI_SCREEN_WIDTH, 30)];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    verLabel.text = [NSString stringWithFormat:@"版本 V%@",currentVersion];
    [verLabel setFont:[UIFont systemFontOfSize:14.f]];
    [verLabel setTextColor:[UIColor darkGrayColor]];
    [verLabel setTextAlignment:NSTextAlignmentCenter];
    [headView addSubview:verLabel];
    
    return headView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *strName = _arrName[indexPath.row];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:AboutTableCell];
    cell.textLabel.text= strName;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return .1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _arrName.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
