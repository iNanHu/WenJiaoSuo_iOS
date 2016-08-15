//
//  WoolZoneVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/8/11.
//  Copyright © 2016年 alexyang. All rights reserved.
//
#define WoolZoneCellId @"tableCellId"
#define NavToWoolZoneDetailVC @"NavToWoolZoneDetail"
#define TableCellHeight 180

#import "WoolZoneVC.h"
#import "HomeDetailVC.h"
#import "WJSTool.h"
#import "WJSDataModel.h"
#import "WJSDataManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface WoolZoneVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *infoArr;

@end

@implementation WoolZoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidLeftButton = YES;
    self.title = @"羊毛专区";

    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"WoolZoonCell" bundle:nil] forCellReuseIdentifier:WoolZoneCellId];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self getWoolZoneList];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
}

- (void)getWoolZoneList {
    
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSString *strResVal = [responseObject objectForKey:@"msg"];
        if ([strResVal isEqualToString:JSON_RES_SUCC]) {
            NSArray *arr = [responseObject objectForKey:@"data"];
            [[WJSDataModel shareInstance]setArrNewsDetailList:arr];
            _infoArr = [NSMutableArray arrayWithArray:arr];
            
            NSLog(@"新闻列表获取成功！");
            [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        } else {
            NSLog(@"新闻列表获取失败！");
        }
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"新闻列表获取 error: %@",error);
    };
    [[WJSDataManager shareInstance] getNewsListWithCId:@"11" andOrder:nil andPage:nil andPageNum:nil andSucc:succBlock andFail:failBlock];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1f;
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
   
    return TableCellHeight;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WoolZoneCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WoolZoneCellId];
    }
    UIImageView *imgView = [cell viewWithTag:100];
    imgView.layer.cornerRadius = 8.f;
    //imgView.clipsToBounds = YES;
    imgView.layer.masksToBounds = YES;
//    imgView.layer.shadowColor = [UIColor blackColor].CGColor;
//    imgView.layer.shadowOffset = CGSizeMake(4, 4);
//    imgView.layer.shadowOpacity = 0.5;
//    imgView.layer.shadowRadius = 2.0;
    NSDictionary *dicInfo = [_infoArr objectAtIndex:indexPath.row];
    NSString *strImgUrl = [dicInfo objectForKey:WJSINFO_IMGURL];
    [imgView sd_setImageWithURL:[NSURL URLWithString:strImgUrl]];
    return cell;
     
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        NSDictionary *dicInfo = [_infoArr objectAtIndex:indexPath.row];
        NSString *strUrl = [dicInfo objectForKey:WJSINFO_URL];
        [self performSegueWithIdentifier:NavToWoolZoneDetailVC sender:strUrl];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:NavToWoolZoneDetailVC]) {
        HomeDetailVC *destVC = (HomeDetailVC *)segue.destinationViewController;
        destVC.strDetailUrl = sender;
        destVC.title = @"羊毛专区";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
