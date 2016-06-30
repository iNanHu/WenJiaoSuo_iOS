//
//  WJSDataManager.m
//  WenminYizhangtong
//
//  Created by 壹道IOS开发 on 16/6/30.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "WJSDataManager.h"
#import <AFNetworking.h>
#define SERV_ADDR @"http://wmyzt.applinzi.comhttp://wmyzt.applinzi.com/api/"

@implementation WJSDataManager

+(id)shareInstance {
    
    static dispatch_once_t predicate;
    static WJSDataManager *dataManager;
    dispatch_once(&predicate, ^{
        dataManager = [[self alloc] init];
    });
    return dataManager;
}

//用户相关接口
- (void)registerUserAccWithUserName:(NSString *)userName andInviteId:(NSString *)inviteId andUserEmail:(NSString *)userEmail andUserPsd:(NSString *)userPsd andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock {
    
    NSString *strUrl = [NSString stringWithFormat:@"%@user/register",SERV_ADDR];
    NSDictionary *dicParams = @{@"invite":inviteId,
                                @"email":userEmail,
                                @"password":userPsd};
    [self postMsg:strUrl withParams:dicParams withSuccBlock:succBlock withFailBlock:failBlock];
}

- (void)loginUserAccWithUserName:(NSString *)userName andUserPsd:(NSString *)userPsd andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock {
    NSString *strUrl = [NSString stringWithFormat:@"%@user/login",SERV_ADDR];
    NSDictionary *dicParams = @{@"name":userName,
                                @"password":userPsd};
    [self postMsg:strUrl withParams:dicParams withSuccBlock:succBlock withFailBlock:failBlock];
}

- (void)FindPsdWithUserEmail:(NSString *)userEmail andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock {
    NSString *strUrl = [NSString stringWithFormat:@"%@user/reset_pass",SERV_ADDR];
    NSDictionary *dicParams = @{@"email":userEmail};
    [self postMsg:strUrl withParams:dicParams withSuccBlock:succBlock withFailBlock:failBlock];
}

- (void)commitDetailUserInfoWithUId:(NSString *)uid andUsrName:(NSString *)usrname andSex:(NSString *)sex
                       andCertiType:(NSString *)certifitype andCertiNum:(NSString *)certinum andTelPhone:(NSString *)telphone
                       andAddress:(NSString *)address andBankName:(NSString *)bankname andAccNum:(NSString *)accountNum
                         andBankLoc:(NSString *)banklocation andBranchName:(NSString *)branchname andCertiFrontImg:(NSData *)certiFrontImg andCertiBackImg:(NSString *)certiBackImg andBankCardImg:(NSData *)bankcardImg
                       andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@user/info",SERV_ADDR];
    NSDictionary *dicParams = @{@"uid":uid,
                                @"realname":usrname,
                                @"sex":sex,
                                @"certificate_type":certifitype,
                                @"certificate_number":certinum,
                                @"telphone":telphone,
                                @"address":address,
                                @"bank":bankname,
                                @"account_number":accountNum,
                                @"bank_location":banklocation,
                                @"branch_name":branchname,
                                @"certificate_front_image":certiFrontImg,
                                @"certificate_back_image":certiBackImg,
                                @"bank_card_image":bankcardImg};
    [self postMsg:strUrl withParams:dicParams withSuccBlock:succBlock withFailBlock:failBlock];
}

- (void)applyWJSInfoWithWjsId:(NSString *)wjsId andUId:(NSString *)uid andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock {
    
    NSString *strUrl = [NSString stringWithFormat:@"%@user/apply_wjs",SERV_ADDR];
    NSDictionary *dicParams = @{@"wjsid":wjsId,
                                @"uid":uid};
    [self postMsg:strUrl withParams:dicParams withSuccBlock:succBlock withFailBlock:failBlock];
}

- (void)getUserDetailInfoWithUid:(NSString *)uid andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock {
    
    NSString *strUrl = [NSString stringWithFormat:@"%@user/info",SERV_ADDR];
    NSDictionary *dicParams = @{@"uid":uid};
    [self postMsg:strUrl withParams:dicParams withSuccBlock:succBlock withFailBlock:failBlock];
}

- (void)getQRCodeWithInviteId:(NSString *)inviteId andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock {
    NSString *strUrl = [NSString stringWithFormat:@"%@user/getqr",SERV_ADDR];
    NSDictionary *dicParams = @{@"invite":inviteId};
    [self postMsg:strUrl withParams:dicParams withSuccBlock:succBlock withFailBlock:failBlock];
}

- (void)changeAvatarWithUId:(NSString *)uid andAvatorData:(NSData *)imgData
                         andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock {
    NSString *strUrl = [NSString stringWithFormat:@"%@user/change_avatar",SERV_ADDR];
    NSDictionary *dicParams = @{@"uid":uid,
                                @"file":imgData};
    [self postMsg:strUrl withParams:dicParams withSuccBlock:succBlock withFailBlock:failBlock];
}

//文交所新闻相关接口
- (void)getWJSInfoListWithSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@user/getlist",SERV_ADDR];
    [self getMsg:strUrl withSuccBlock:succBlock withFailBlock:failBlock];
}

- (void)getNewsListWithCId:(NSString *)cid andOrder:(NSString *)order andPage:(NSString *)page andPageNum:(NSString *)pagenum
                   andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock {
    NSString *strUrl = [NSString stringWithFormat:@"%@news/getlist",SERV_ADDR];
    NSDictionary *dicParams = @{@"cid":cid,
                                @"page":page,
                                @"pagenum":pagenum,
                                @"order":order};
    [self postMsg:strUrl withParams:dicParams withSuccBlock:succBlock withFailBlock:failBlock];
}

- (void)getNewDetailWithId:(NSString *)newsId andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock {
    
    NSString *strUrl = [NSString stringWithFormat:@"%@news/detail?id=%@",SERV_ADDR,newsId];
    [self getMsg:strUrl withSuccBlock:succBlock withFailBlock:failBlock];
}

- (void)getNewsCategoryInfoWithSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock {
    
    NSString *strUrl = [NSString stringWithFormat:@"%@news/getcategory",SERV_ADDR];
    [self getMsg:strUrl withSuccBlock:succBlock withFailBlock:failBlock];
}

- (void)getBannerWithSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock {
    
    NSString *strUrl = [NSString stringWithFormat:@"%@news/getbanner",SERV_ADDR];
    [self getMsg:strUrl withSuccBlock:succBlock withFailBlock:failBlock];
}

//通用接口
- (void)upWJSFileWithFile:(NSData *)file andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@common/upfile",SERV_ADDR];
    NSDictionary *dicParams = @{@"file":file};
    [self postMsg:strUrl withParams:dicParams withSuccBlock:succBlock withFailBlock:failBlock];
}


- (void)postMsg:(NSString *)url withParams:(NSDictionary *)params
  withSuccBlock:(SuccBlock) succBlock
  withFailBlock:(FailBlock) failBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *accetContentTypes = [NSSet setWithObjects:@"application/json"
                                @"text/html",
                                @"text/json",
                                @"text/javascript",
                                @"text/plain", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = accetContentTypes;
    
    [manager POST:url parameters:params progress:nil success:succBlock failure:failBlock];
}

- (void)getMsg:(NSString *)url withSuccBlock:(SuccBlock) succBlock withFailBlock:(FailBlock) failBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *accetContentTypes = [NSSet setWithObjects:@"application/json"
                                @"text/html",
                                @"text/json",
                                @"text/javascript",
                                @"text/plain", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = accetContentTypes;
    
    [manager GET:url parameters:nil progress:nil success:succBlock failure:failBlock];
}

@end
