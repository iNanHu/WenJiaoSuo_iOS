//
//  LaunchVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/8/1.
//  Copyright © 2016年 alexyang. All rights reserved.
//
#define NavToDefaultHomeVC @"Nav_To_DHomeVC"
#define NavToLoginVC @"Nav_To_LoginVC"
#import "LaunchVC.h"
#import "WJSTool.h"
#import "WJSDataModel.h"
#import "WJSDataManager.h"
#import "WJSCommonDefine.h"

@interface LaunchVC ()

@end

@implementation LaunchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidLeftButton = YES;
    self.hidRightButton = YES;
    self.title = @"加载页面";
    self.navigationItem.hidesBackButton = YES;
    
    [self getNewsCategory];
    //初始化行情信息
    RunInBackground(initQuotationInfo, nil);
    sleep(3);
    [self initMainVC];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)initMainVC {
    
    NSString *strUserName = [[WJSDataModel shareInstance] userPhone];
    NSString *strUserPsd = [[WJSDataModel shareInstance] userPassword];
    if (strUserName && strUserPsd && ![strUserName isEqualToString:@""] && ![strUserPsd isEqualToString:@""]) {
        
        SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            [self loginResult:responseObject];
        };
        FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            [self performSegueWithIdentifier:NavToLoginVC sender:nil];
        };
        NSString *strMD5Psd = [WJSTool getMD5Val:strUserPsd];
        [[WJSDataManager shareInstance]loginUserAccWithUserName:strUserName andUserPsd:strMD5Psd andSucc:succBlock andFail:failBlock];
    }else {
        [self performSegueWithIdentifier:NavToLoginVC sender:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewsList) name:NotiGetNewsCategorySucc object:nil];
}

- (void)loginResult:(NSDictionary *) result {
  
    NSString *resVal = [result objectForKey:@"msg"];
    if ([resVal isEqualToString:JSON_RES_SUCC]) {
        NSString *uId = [result objectForKey:@"data"];
        [[WJSDataModel shareInstance] setUId:uId];
        [self getUserDetailInfo];
        NSLog(@"登录成功:%@",uId);
        [self performSegueWithIdentifier:NavToDefaultHomeVC sender:nil];
        
    } else {
        NSString *errMsg = [result objectForKey:@"data"];
        NSLog(@"登录失败，error[%@]",errMsg);
        [self performSegueWithIdentifier:NavToLoginVC sender:nil];
    }
}

- (void)getUserDetailInfo {
    
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSString *strResVal = [responseObject objectForKey:@"msg"];
        if ([strResVal isEqualToString:JSON_RES_SUCC]) {
            [[WJSDataModel shareInstance]setDicUserInfo:[[NSMutableDictionary alloc]initWithDictionary:[responseObject objectForKey:@"data"]]];
            [[NSNotificationCenter defaultCenter]postNotificationName:NotiGetUserInfoSucc object:nil];
            NSLog(@"用户信息获取成功:%@",strResVal);
        } else {
            id data = [responseObject objectForKey:@"data"];
            NSLog(@"用户信息失败:%@",data);
        }
    };
    
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"error: %@",error);
    };
    [[WJSDataManager shareInstance]getUserDetailInfoWithSucc:succBlock andFail:failBlock];
}

- (void)getNewsCategory {
    
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSString *strResVal = [responseObject objectForKey:@"msg"];
        if ([strResVal isEqualToString:JSON_RES_SUCC]) {
            NSArray *arr = [responseObject objectForKey:@"data"];
            [[WJSDataModel shareInstance] setArrNewCategory:arr];
            [[NSNotificationCenter defaultCenter]postNotificationName:NotiGetNewsCategorySucc object:nil];
            NSLog(@"新闻类别获取成功！");
        } else {
            NSLog(@"新闻类别获取失败！");
        }
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"error: %@",error);
    };
    [[WJSDataManager shareInstance] getNewsCategoryInfoWithSucc:succBlock andFail:failBlock];
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
                    
                    NSLog(@"新闻列表获取成功！");
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

- (void)initQuotationInfo {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"QuotationInfo" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray *arrQuotaInfo = [NSArray arrayWithArray:[data objectForKey:@"quotationInfoList"]];
    
    NSMutableArray *arrQuotation = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [arrQuotaInfo count]; i++)
    {
        NSDictionary *dic = [arrQuotaInfo objectAtIndex:i];
        NSString *index = [dic objectForKey:@"index"];
        NSDictionary *dicTemp = [WJSTool getQuotationWithServ:QUOTATION_SERV_ADDR andWJSId:[index integerValue]];
        if (dicTemp) {
            NSMutableDictionary *dicQuotation = [NSMutableDictionary dictionaryWithDictionary:dicTemp];
            [dicQuotation setObject:[dic objectForKey:@"Name"] forKey:@"文交所名称"];
            
            [arrQuotation addObject:dicQuotation];
            [[WJSDataModel shareInstance] setArrQuotation:arrQuotation];
        }
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
