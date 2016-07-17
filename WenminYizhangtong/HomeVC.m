//
//  HomeVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/6/19.
//  Copyright © 2016年 alexyang. All rights reserved.
//
#import "WJSTool.h"
#import "WJSCommonDefine.h"
#import "WJSDataManager.h"
#import "HomeVC.h"

#define SCROLL_HEIGHT 140
#define WJSInfoCellId @"UITableViewCellId"

@interface HomeVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UIScrollView *homeScrollView;
@property (strong, nonatomic) UITableView *homeTableView;
@property (nonatomic, strong) UIPageControl *homePageCtrl;
@property (nonatomic, strong) NSTimer *scrollTimer;

//data
@property (nonatomic, strong) NSMutableArray *infoArr;
@property (nonatomic, strong) NSArray *imgList;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSString *strJson = [WJSTool urlstring:@"http://www.youbicard.com/plus/data/excList.php?type=4&pan=1"];
//    NSLog(@"Json: %@",strJson);
    
    [self initData];
    [self initCtrl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)initData {
    
    _imgList = @[@"home_index1",@"home_index2",@"home_index3"];
    _infoArr = [NSMutableArray arrayWithCapacity:0];
    [_infoArr addObject:@{ WJSINFO_IMGURL:@"", WJSINFO_TITLE:@"天津文交所", WJSINFO_DETAIL:@"福利特区，范德萨发卡机了发送的记录方式记录积分楼上的" }];
    [_infoArr addObject:@{ WJSINFO_IMGURL:@"", WJSINFO_TITLE:@"北京文交所", WJSINFO_DETAIL:@"福利特区，范德萨发卡机了发送的记录方式记录积分楼上的" }];
    [_infoArr addObject:@{ WJSINFO_IMGURL:@"", WJSINFO_TITLE:@"汉唐文交所", WJSINFO_DETAIL:@"福利特区，范德萨发卡机了发送的记录方式记录积分楼上的" }];
    [_infoArr addObject:@{ WJSINFO_IMGURL:@"", WJSINFO_TITLE:@"金马甲文交所", WJSINFO_DETAIL:@"福利特区，范德萨发卡机了发送的记录方式记录积分楼上的" }];
    [_infoArr addObject:@{ WJSINFO_IMGURL:@"", WJSINFO_TITLE:@"博商文交所", WJSINFO_DETAIL:@"福利特区，范德萨发卡机了发送的记录方式记录积分楼上的" }];
    [_infoArr addObject:@{ WJSINFO_IMGURL:@"", WJSINFO_TITLE:@"东北文交所", WJSINFO_DETAIL:@"福利特区，范德萨发卡机了发送的记录方式记录积分楼上的" }];
    [_infoArr addObject:@{ WJSINFO_IMGURL:@"", WJSINFO_TITLE:@"武汉文交所", WJSINFO_DETAIL:@"福利特区，范德萨发卡机了发送的记录方式记录积分楼上的" }];
    
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSString *strResVal = [responseObject objectForKey:@"msg"];
        if ([strResVal isEqualToString:JSON_RES_SUCC]) {
            NSArray *arr = [responseObject objectForKey:@"data"];
            [[WJSDataModel shareInstance] setArrWJSList:arr];
        } else {
            NSLog(@"文交所列表获取失败！");
        }
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"error: %@",error);
    };
    [[WJSDataManager shareInstance] getWJSInfoListWithSucc:succBlock andFail:failBlock];
}

- (void)initCtrl {
    
    UIView *headView = [UIView new];
    headView.frame = CGRectMake(0, Tab_HEIGHT, UI_SCREEN_WIDTH, SCROLL_HEIGHT + 20);
    
    //初始化滑动控件pagecontrol
    _homePageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCROLL_HEIGHT - 20, UI_SCREEN_WIDTH, 20)];
    _homePageCtrl.numberOfPages = [_imgList count];
    _homePageCtrl.currentPage = 0;
    _homePageCtrl.hidesForSinglePage = YES;
    _homePageCtrl.backgroundColor = [UIColor clearColor];
    [_homePageCtrl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
    
    //设置scrollview的属性
    _homeScrollView = [UIScrollView new];
    _homeScrollView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, SCROLL_HEIGHT);
    [_homeScrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH*[_imgList count], SCROLL_HEIGHT)];
    [_homeScrollView setPagingEnabled:YES];
    [_homeScrollView setBounces:NO];
    [_homeScrollView setShowsHorizontalScrollIndicator:NO];
    [_homeScrollView setShowsVerticalScrollIndicator:NO];
    [_homeScrollView setDelegate:self];
    //加载图片
    for (int i = 0; i < [_imgList count]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*UI_SCREEN_WIDTH,0,UI_SCREEN_WIDTH, SCROLL_HEIGHT)];
        [imageView setImage:[UIImage imageNamed:[_imgList objectAtIndex:i]]];
        [_homeScrollView addSubview:imageView];
    }
    
    [headView addSubview:_homeScrollView];
    [headView addSubview:_homePageCtrl];
    
    //tableview
    _homeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Tab_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - Tab_HEIGHT) style:UITableViewStylePlain];
    [_homeTableView setBackgroundColor:TABLE_BGCLR];
    _homeTableView.tableHeaderView = headView;
    [_homeTableView registerNib:[UINib nibWithNibName:@"WJSInfoCell" bundle:nil] forCellReuseIdentifier:WJSInfoCellId];
    _homeTableView.dataSource = self;
    _homeTableView.delegate = self;
    [self.view addSubview:_homeTableView];
    
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
    pageIndex = pageIndex%[_imgList count];
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
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
    [headView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 40)];
    [titleLab setText:@"文交所最新资讯"];
    [titleLab setFont:[UIFont systemFontOfSize:14.f]];
    [titleLab setTextColor:[UIColor blackColor]];
    [headView addSubview:titleLab];
    
    UIView *line = [UIView new];
    line.frame = CGRectMake(0, 39, UI_SCREEN_WIDTH, 0.5);
    [line setBackgroundColor:RGB(0xC0, 0xC0, 0xC0)];
    [headView addSubview:line];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
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
    return _infoArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_infoArr.count == 0) return nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WJSInfoCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WJSInfoCellId];
    }
    
    [self setCellModel:cell withInfo:[_infoArr objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setCellModel:(UITableViewCell *)cell withInfo:(NSDictionary *)dicInfo {
    
    if (!dicInfo) return ;
    
    NSString *strImgUrl = [dicInfo objectForKey:WJSINFO_IMGURL];
    NSString *strTitleName = [dicInfo objectForKey:WJSINFO_TITLE];
    NSString *strDetailText = [dicInfo objectForKey:WJSINFO_DETAIL];
    
    if (!strImgUrl || [strImgUrl isEqualToString:@""]) {
        strImgUrl = @"defCellImg";
    }
    
    UIImageView *infoImgView = [cell viewWithTag:100];
    UILabel *titleLab = (UILabel *)[cell viewWithTag:101];
    UITextView *detailText = (UITextView *)[cell viewWithTag:102];
    
    if (!infoImgView || !titleLab || !detailText) return ;
    
    [titleLab setFont:[UIFont boldSystemFontOfSize:14.f]];
    [titleLab setTextColor:[UIColor blackColor]];
    
    [detailText setFont:[UIFont systemFontOfSize:14.f]];
    [detailText setTextColor:RGB(0xB0, 0xB0, 0xB0)];
    
    infoImgView.image = [UIImage imageNamed:strImgUrl];
    titleLab.text = strTitleName;
    detailText.text = strDetailText;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        //[self getWJSInfoList];
        [self uploadFile];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString *strImg = @"home_index1";
    UIImage *img = [UIImage imageNamed:strImg];
    NSData *imgData = UIImagePNGRepresentation(img);
    
    [[WJSDataManager shareInstance]upWJSFileWithFile:imgData andSucc:succBlock andFail:failBlock];
}

@end
