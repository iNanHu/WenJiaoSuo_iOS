//
//  HomeVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/6/19.
//  Copyright © 2016年 alexyang. All rights reserved.
//
#import "WJSTool.h"
#import "HomeVC.h"

@interface HomeVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *homeScrollView;
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
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

- (void)initData {
    _imgList = @[@"home_index1",@"home_index2",@"home_index3"];
    _infoArr = [NSMutableArray arrayWithCapacity:0];
    [_infoArr addObject:@"aa"];
    [_infoArr addObject:@"bb"];
    [_infoArr addObject:@"cc"];
}

- (void)initCtrl {
    //初始化滑动控件pagecontrol
    _homePageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0, 204-20, self.view.frame.size.width, 20)];
    _homePageCtrl.numberOfPages = [_imgList count];
    _homePageCtrl.currentPage = 0;
    _homePageCtrl.hidesForSinglePage = YES;
    _homePageCtrl.backgroundColor = [UIColor clearColor];
    [_homePageCtrl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
    
    //设置scrollview的属性
    CGRect scrollViewRect = _homeScrollView.frame;
    _homeScrollView.frame = CGRectMake(CGRectGetMinX(scrollViewRect), CGRectGetMinY(scrollViewRect), self.view.frame.size.width, 140);
    [_homeScrollView setContentSize:CGSizeMake(self.view.frame.size.width*[_imgList count], 140)];
    [_homeScrollView setPagingEnabled:YES];
    [_homeScrollView setBounces:NO];
    [_homeScrollView setShowsHorizontalScrollIndicator:NO];
    [_homeScrollView setShowsVerticalScrollIndicator:NO];
    [_homeScrollView setDelegate:self];
    //加载图片
    for (int i = 0; i < [_imgList count]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width,0,self.view.frame.size.width, 140)];
        [imageView setImage:[UIImage imageNamed:[_imgList objectAtIndex:i]]];
        [_homeScrollView addSubview:imageView];
    }
    [self.view addSubview:_homePageCtrl];
    
    //tableview
    CGRect tableViewRect = _homeTableView.frame;
    _homeTableView.frame = CGRectMake(CGRectGetMinX(tableViewRect), CGRectGetMinY(tableViewRect), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 204);
    _homeTableView.tableHeaderView = nil;
    _homeTableView.dataSource = self;
    _homeTableView.delegate = self;
    
    _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(AutoChangeScrollVIewIndex) userInfo:nil repeats:YES];
    

}

- (void)pageControlChanged:(UIPageControl *)pageControl
{
    //pagecontrol变化触发scrollview变化
    int pageIndex = _homePageCtrl.currentPage;
    int posX = [UIScreen mainScreen].bounds.size.width * pageIndex;
    [_homeScrollView setContentOffset:CGPointMake(posX, 0) animated:YES];
    
}

-(void) AutoChangeScrollVIewIndex
{
    //pagecontrol变化触发scrollview变化
    int pageIndex = _homePageCtrl.currentPage;
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

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30)];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
    [titleLab setText:@"文交所资讯"];
    [titleLab setTextColor:[UIColor blackColor]];
    [headView addSubview:titleLab];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infoArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_infoArr.count == 0) {
        return nil;
    }
    NSString *identifier = @"msgcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
