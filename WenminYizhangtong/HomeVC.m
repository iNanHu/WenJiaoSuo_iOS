//
//  HomeVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/6/19.
//  Copyright © 2016年 alexyang. All rights reserved.
//
#import "WJSTool.h"
#import "WJSCommonDefine.h"
#import "HomeDetailVC.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "WJSDataManager.h"
#import "WJSDataModel.h"
#import "QuotationVC.h"
#import "WJSTool.h"
#import "HomeVC.h"

#define SCROLL_HEIGHT 140
#define TableCell_Height 100
#define TableBar_Height 160
#define NavToHomeDetail @"NavToHomeDetail"
#define WJSInfoCellId @"UITableViewCellId"
#define WJSHeadCellId @"UIHeadCellId"

@interface HomeVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (strong, nonatomic) UIScrollView *homeScrollView;
@property (strong, nonatomic) UITableView *homeTableView;
@property (nonatomic, strong) UIPageControl *homePageCtrl;
@property (nonatomic, strong) NSTimer *scrollTimer;

//data
@property (nonatomic, strong) NSArray *infoArr;
@property (nonatomic, strong) NSArray *arrTitle;
@property (nonatomic, strong) NSArray *arrTitleImg;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initCtrl];
    [self loadScrollView];
    self.title = @"首页";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
}

- (void)initData {
    
    _arrTitle = @[@[@"大盘行情",@"文交所公告",@"羊毛专区"],@[@"文民社群",@"文民商学院",@"全民经纪"]];
    _arrTitleImg = @[@[@"dzp_icon",@"icon_gg",@"icon_hd"],@[@"sg_icon",@"agree_icons",@"icon_xh"]];
    
    _infoArr = [[WJSDataModel shareInstance] arrNewsDetailList];
    if (!_infoArr) {
        [self getNewsList];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewsList) name:NotiGetNewsCategorySucc object:nil];
}

- (void)getNewsList {
    NSArray *arrCategory = [[WJSDataModel shareInstance] arrNewCategory];
    if (arrCategory && arrCategory.count) {
        for (NSDictionary *dicInfo in arrCategory) {
            NSString *strCId = [dicInfo objectForKey:@"class_id"];
            NSString *strName = [dicInfo objectForKey:@"name"];
                SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
                    NSString *strResVal = [responseObject objectForKey:@"msg"];
                    if ([strResVal isEqualToString:JSON_RES_SUCC]) {
                        NSArray *arr = [responseObject objectForKey:@"data"];
                        [[WJSDataModel shareInstance]setArrNewsDetailList:arr];
                        _infoArr = [NSMutableArray arrayWithArray:arr];
                        
                        NSLog(@"新闻列表获取成功！");
                        [_homeTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                    } else {
                        NSLog(@"新闻列表获取失败！");
                    }
                };
                FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
                    NSLog(@"新闻列表获取 error: %@",error);
                };
                [[WJSDataManager shareInstance] getNewsListWithCId:strCId andOrder:nil andPage:nil andPageNum:nil andSucc:succBlock andFail:failBlock];
                break;
            }
        }
}

- (void)loadScrollView {
    
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSString *strResVal = [responseObject objectForKey:@"msg"];
        if ([strResVal isEqualToString:JSON_RES_SUCC]) {
            NSArray *arr = [responseObject objectForKey:@"data"];
            [[WJSDataModel shareInstance] setArrShuffInfo:arr];
            [self initShtffView];
            
        } else {
            NSLog(@"轮播信息获取失败！");
        }
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"error: %@",error);
    };
    [[WJSDataManager shareInstance]getBannerWithSucc:succBlock andFail:failBlock];
}

- (void)initShtffView {
    
    NSArray *arrShuffInfo = [[WJSDataModel shareInstance] arrShuffInfo];
    [_homeScrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH*[arrShuffInfo count], SCROLL_HEIGHT)];
    NSInteger index = 0;
    for (NSDictionary *dicInfo in arrShuffInfo) {
        NSString *strLinkName = [dicInfo objectForKey:@"image"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(index*UI_SCREEN_WIDTH,0,UI_SCREEN_WIDTH, SCROLL_HEIGHT);
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:strLinkName] forState:UIControlStateNormal];
        btn.tag = index++;
        [btn addTarget:self action:@selector(switchToDetailView:) forControlEvents:UIControlEventTouchUpInside];
        [_homeScrollView addSubview:btn];
    }
    _homePageCtrl.numberOfPages = [arrShuffInfo count];

}

- (void)switchToDetailView:(UIButton *) sender {
    
    NSArray *arrShuffInfo = [[WJSDataModel shareInstance] arrShuffInfo];
    if (arrShuffInfo && arrShuffInfo.count) {
        NSInteger index = sender.tag;
        NSDictionary *dicInfo = [arrShuffInfo objectAtIndex:index];
        if (dicInfo) {
            NSString *strLink = [dicInfo objectForKey:@"link"];
            if (strLink && ![strLink isEqualToString:@""]) {
                [self performSegueWithIdentifier:NavToHomeDetail sender:strLink];
            }
        }
        
    }
    
}

- (void)initCtrl {
    
    //隐藏导航栏左右按钮
    self.hidLeftButton = YES;
    self.hidRightButton = YES;
    
    UIView *headView = [UIView new];
    headView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, SCROLL_HEIGHT);
    
    //初始化滑动控件pagecontrol
    _homePageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCROLL_HEIGHT - 20, UI_SCREEN_WIDTH, 20)];
    _homePageCtrl.currentPage = 0;
    _homePageCtrl.hidesForSinglePage = YES;
    _homePageCtrl.backgroundColor = [UIColor clearColor];
    [_homePageCtrl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
    
    //设置scrollview的属性
    _homeScrollView = [UIScrollView new];
    _homeScrollView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, SCROLL_HEIGHT);
    [_homeScrollView setPagingEnabled:YES];
    [_homeScrollView setBounces:NO];
    [_homeScrollView setShowsHorizontalScrollIndicator:NO];
    [_homeScrollView setShowsVerticalScrollIndicator:NO];
    [_homeScrollView setDelegate:self];
    [headView addSubview:_homeScrollView];
    [headView addSubview:_homePageCtrl];
    
    //tableview
    _homeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Nav_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - Tab_HEIGHT - Nav_HEIGHT) style:UITableViewStyleGrouped];
    [_homeTableView setBackgroundColor:TABLE_BGCLR];
    _homeTableView.tableHeaderView = headView;
    [_homeTableView registerNib:[UINib nibWithNibName:@"WJSInfoCell" bundle:nil] forCellReuseIdentifier:WJSInfoCellId];
    _homeTableView.dataSource = self;
    _homeTableView.delegate = self;
    [self.view addSubview:_homeTableView];
    
    [_homeTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(AutoChangeScrollVIewIndex) userInfo:nil repeats:YES];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (void)pageControlChanged:(UIPageControl *)pageControl
{
    //pagecontrol变化触发scrollview变化
    NSInteger pageIndex = _homePageCtrl.currentPage;
    int posX = [UIScreen mainScreen].bounds.size.width * pageIndex;
    [_homeScrollView setContentOffset:CGPointMake(posX, 0) animated:YES];
    
}

-(void)AutoChangeScrollVIewIndex
{
    //pagecontrol变化触发scrollview变化
    NSInteger pageIndex = _homePageCtrl.currentPage;
    pageIndex++;
    NSArray *arrShuffInfo = [[WJSDataModel shareInstance] arrShuffInfo];
    pageIndex = pageIndex%[arrShuffInfo count];
    _homePageCtrl.currentPage = pageIndex;
    int posX = [UIScreen mainScreen].bounds.size.width * pageIndex;
    [_homeScrollView setContentOffset:CGPointMake(posX, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int curPageIndex = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    _homePageCtrl.currentPage = curPageIndex;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
        [headView setBackgroundColor:[UIColor whiteColor]];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 1.0/UI_MAIN_SCALE)];
        [lineView setBackgroundColor:RGB(0xC0, 0xC0, 0xC0)];
        [headView addSubview:lineView];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 40)];
        [titleLab setText:@"文交所最新资讯"];
        [titleLab setFont:[UIFont systemFontOfSize:14.f]];
        [titleLab setTextColor:[UIColor blackColor]];
        [headView addSubview:titleLab];
        
        return headView;

    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 10.f;
    }
    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

- (void)getWJSInfoList {
    
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSString *resVal = [responseObject objectForKey:@"msg"];
        if ([resVal isEqualToString:JSON_RES_SUCC]) {
            NSString *uId = [responseObject objectForKey:@"data"];
            NSLog(@"返回成功，%@",uId);
        } else {
            NSString *errMsg = [responseObject objectForKey:@"data"];
            NSLog(@"获取失败，error[%@]",errMsg);
        }
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        
    };
    
    [[WJSDataManager shareInstance]getWJSInfoListWithSucc:succBlock andFail:failBlock];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    return _infoArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return TableBar_Height;
    }
    return TableCell_Height;
}

- (void)setBtnLayout:(UIButton *)selBtn andTitle:(NSString *)title andImgUrl:(NSString *)url{
    
    UIImage *image = [UIImage imageNamed:url];
    CGSize btnSize = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(UI_SCREEN_WIDTH/4, TableBar_Height/2)];
    
    selBtn.titleEdgeInsets =UIEdgeInsetsMake(0.5*image.size.height, -0.5*image.size.width, -0.5*image.size.height, 0.5*image.size.width);
    selBtn.imageEdgeInsets =UIEdgeInsetsMake(-0.5*btnSize.height, 0.5*btnSize.width, 0.5*btnSize.height, -0.5*btnSize.width);
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WJSHeadCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WJSHeadCellId];
        }
        
        UIView *headView = [UIView new];
        headView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, TableBar_Height);
        CGFloat btnHeight = TableBar_Height/2;
        CGFloat btnWidth = UI_SCREEN_WIDTH/3;
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 3; j++) {
                NSString *strImgUrl = _arrTitleImg[i][j];
                NSString *strTitle = _arrTitle[i][j];
                CGRect btnFrame = CGRectMake(btnWidth * j, btnHeight * i, btnWidth, btnHeight);
                UIButton *btn = [UIButton new];
                btn.frame = btnFrame;
                btn.tag = i * 3 + j;
                [btn setTitle:strTitle forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:strImgUrl] forState:UIControlStateNormal];
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [btn setTitleColor:RGB(56, 56, 56) forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
                [self setBtnLayout:btn andTitle:strTitle andImgUrl:strImgUrl];
                [btn setBackgroundImage:[WJSTool ImageWithColor:RGB(0xA0, 0xA0, 0xA0) andFrame:btn.frame] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(onSwithcBtn:) forControlEvents:UIControlEventTouchUpInside];
                [headView addSubview:btn];
            }
        }
        [cell addSubview:headView];
        return cell;
        
    } else {
        
        if (_infoArr.count == 0) return nil;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WJSInfoCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WJSInfoCellId];
        }
        
        [self setCellModel:cell withInfo:[_infoArr objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
}

- (void)onSwithcBtn:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            QuotationVC *destVC = [storyBoard instantiateViewControllerWithIdentifier:@"QuotationVC"];
            if (destVC) {
                [self.navigationController pushViewController:destVC animated:YES];
            }
        }
            break;
        case 1:
        {
        
        }
            break;
        case 2:
        {
            [self.tabBarController setSelectedIndex:1];
        }
            break;
        case 3:
        {
        
        }
            break;
        case 4:
        {
            
        }
            break;
        case 5:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)setCellModel:(UITableViewCell *)cell withInfo:(NSDictionary *)dicInfo {
    
    if (!dicInfo) return ;
    
    NSString *strImgUrl = [dicInfo objectForKey:WJSINFO_IMGURL];
    NSString *strTitleName = [dicInfo objectForKey:WJSINFO_TITLE];
    NSString *strDetailText = [dicInfo objectForKey:WJSINFO_DETAIL];
    NSString *strTime = [dicInfo objectForKey:WJSINFO_TIME];
    NSString *strVistCo = [dicInfo objectForKey:WJSINFO_VISIT_COUNT];
    
    UIImageView *iconView = [cell viewWithTag:100];
    UILabel *titleLab = [cell viewWithTag:101];
    UILabel *contentView = [cell viewWithTag:102];
    UILabel *vistCountLab = [cell viewWithTag:104];
    UILabel *timeLab = [cell viewWithTag:103];
    
    [iconView sd_setImageWithURL:[NSURL URLWithString:strImgUrl]];
    
    [titleLab setText:strTitleName];
    [titleLab setTextColor:[UIColor blackColor]];
    
    [contentView setText:strDetailText];
    contentView.lineBreakMode = UILineBreakModeWordWrap;
    [contentView setFont:[UIFont systemFontOfSize:14.f]];
    [contentView setTextColor:RGB(0xB0, 0xB0, 0xB0)];
    [contentView setNumberOfLines:0];
    
    [vistCountLab setText:[NSString stringWithFormat:@"阅读: %@",strVistCo]];
    [vistCountLab setTextAlignment:NSTextAlignmentRight];
    [vistCountLab setTextColor:RGB(0xB0, 0xB0, 0xB0)];
    
    [timeLab setText:[self getData:[strTime integerValue]]];
    [timeLab setTextAlignment:NSTextAlignmentRight];
    [timeLab setTextColor:RGB(0xB0, 0xB0, 0xB0)];
}

- (NSString *)getData:(NSInteger) curTime {
    
    NSDate *curData = [NSDate dateWithTimeIntervalSince1970:curTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:curData];
    return strDate;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        NSDictionary *dicInfo = [_infoArr objectAtIndex:indexPath.row];
        NSString *strUrl = [dicInfo objectForKey:WJSINFO_URL];
        [self performSegueWithIdentifier:NavToHomeDetail sender:strUrl];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:NavToHomeDetail]) {
        HomeDetailVC *destVC = (HomeDetailVC *)segue.destinationViewController;
        destVC.strDetailUrl = sender;
        destVC.title = @"新闻中心";
    }
}

- (void)uploadFile {
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSString *resVal = [responseObject objectForKey:@"msg"];
        if ([resVal isEqualToString:JSON_RES_SUCC]) {
            NSString *uId = [responseObject objectForKey:@"data"];
            NSLog(@"返回成功，%@",uId);
        } else {
            NSString *errMsg = [responseObject objectForKey:@"data"];
            NSLog(@"获取失败，error[%@]",errMsg);
        }
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        
    };
    NSString *strImg = @"home_index2";
    UIImage *img = [UIImage imageNamed:strImg];
    NSData *imgData = UIImagePNGRepresentation(img);
    
    [[WJSDataManager shareInstance]upWJSFileWithFile:imgData andSucc:succBlock andFail:failBlock];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}

//
//- (void)finishRefreshControl {
//    
//    [self getNewsList];
//}

@end
