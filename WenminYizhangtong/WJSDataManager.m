//
//  WJSDataManager.m
//  WenminYizhangtong
//
//  Created by 壹道IOS开发 on 16/6/30.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "WJSDataManager.h"
#import <AFNetworking.h>
#define SERV_ADDR @"http://wmyzt.applinzi.com/api/"

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
    NSDictionary *dicParams = @{@"username":userName,
                                @"email":userEmail,
                                @"password":userPsd};
    //strUrl = [strUrl stringByAppendingFormat:@"?username=%@&email=%@&password=%@",userName,userEmail,userPsd];
    [self postMsg:strUrl withParams:dicParams withSuccBlock:succBlock withFailBlock:failBlock];
}

- (void)loginUserAccWithUserName:(NSString *)userName andUserPsd:(NSString *)userPsd andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock {
    NSString *strUrl = [NSString stringWithFormat:@"%@user/login",SERV_ADDR];
    NSDictionary *dicParams = @{@"name":userName,
                                @"pass":userPsd};
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
                         andBankLoc:(NSString *)banklocation andBranchName:(NSString *)branchname andCertiFrontImg:(NSData *)certiFrontImg andCertiBackImg:(NSData *)certiBackImg andBankCardImg:(NSData *)bankcardImg
                       andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@user/complete",SERV_ADDR];
    NSDictionary *dicParams = @{@"realname":usrname,
                                @"sex":sex,
                                @"certificate_type":certifitype,
                                @"certificate_number":certinum,
                                @"telphone":telphone,
                                @"address":address,
                                @"bank":bankname,
                                @"account_number":accountNum,
                                @"bank_location":banklocation,
                                @"branch_name":branchname,
                                };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName0 = [NSString stringWithFormat:@"%@0.png", str];
    NSString *fileName1 = [NSString stringWithFormat:@"%@1.png", str];
    NSString *fileName2 = [NSString stringWithFormat:@"%@2.png", str];
    NSSet *accetContentTypes = [NSSet setWithObjects:@"application/json",
                                @"text/html",
                                @"text/json",
                                @"text/javascript",
                                @"text/plain",nil];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = accetContentTypes;
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:uid forHTTPHeaderField:@"access-token"];
    
    [manager POST:strUrl parameters:dicParams constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        [formData appendPartWithFileData:certiFrontImg name:@"file" fileName:@"certificate_front_image" mimeType:@"image/png"];
        [formData appendPartWithFileData:certiBackImg name:@"file" fileName:@"certificate_back_image" mimeType:@"image/png"];
        [formData appendPartWithFileData:bankcardImg name:@"file" fileName:@"bank_card_image" mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        // 回到主队列刷新UI,用户自定义的进度条
        // dispatch_async(dispatch_get_main_queue(), ^{
        //    self.progressView.progress = 1.0 *
        //    uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        // });
    } success:succBlock failure:failBlock];

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
    
    NSString *strUrl = [NSString stringWithFormat:@"%@news/getlist",SERV_ADDR];
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

- (void)getWjsNameList:(SuccBlock) succBlock andFail:(FailBlock) failBlock {
    NSString *strUrl = [NSString stringWithFormat:@"%@wjs/getlist",SERV_ADDR];
    [self getMsg:strUrl withSuccBlock:succBlock withFailBlock:failBlock];
}
//通用接口
- (void)upWJSFileWithFile:(NSData *)file andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@common/upfile",SERV_ADDR];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        //NSDictionary *dicParams = @{@"file":fileName};
        NSSet *accetContentTypes = [NSSet setWithObjects:@"application/json",
                                    @"text/html",
                                    @"text/json",
                                    @"text/javascript",
                                    @"text/plain",nil];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = accetContentTypes;
        //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        [manager POST:strUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
            [formData appendPartWithFileData:file name:@"file" fileName:fileName mimeType:@"image/png"];

        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            // 回到主队列刷新UI,用户自定义的进度条
            // dispatch_async(dispatch_get_main_queue(), ^{
            //    self.progressView.progress = 1.0 *
            //    uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            // });
        } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            NSLog(@"上传成功 %@", responseObject);
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"上传失败 %@", error);
        }];

}


- (void)postMsg:(NSString *)url withParams:(id)params
  withSuccBlock:(SuccBlock) succBlock
  withFailBlock:(FailBlock) failBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSSet *accetContentTypes = [NSSet setWithObjects:@"application/json",
                                @"text/html",
                                @"text/json",
                                @"text/javascript",
                                @"text/plain",nil];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = accetContentTypes;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
    [manager POST:url parameters:params progress:nil success:succBlock failure:failBlock];
}


-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (void)getMsg:(NSString *)url withSuccBlock:(SuccBlock) succBlock withFailBlock:(FailBlock) failBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *accetContentTypes = [NSSet setWithObjects:@"application/json",
                                @"text/html",
                                @"text/json",
                                @"text/javascript",
                                @"text/plain", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = accetContentTypes;
    
    [manager GET:url parameters:nil progress:nil success:succBlock failure:failBlock];
}

@end
