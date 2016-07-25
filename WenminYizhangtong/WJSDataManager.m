//
//  WJSDataManager.m
//  WenminYizhangtong
//
//  Created by 壹道IOS开发 on 16/6/30.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "WJSDataManager.h"
#import <AFNetworking.h>
#import "WJSURLSessionWrapperOperation.h"

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

- (void)logoutUserAccWithSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock {
    NSString *strUrl = [NSString stringWithFormat:@"%@user/logout",SERV_ADDR];
    [self postMsg:strUrl withParams:nil withSuccBlock:succBlock withFailBlock:failBlock];
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
    
    UIImage *img0 = [UIImage imageWithData:certiFrontImg];
    UIImage *img1 = [UIImage imageWithData:certiBackImg];
    UIImage *img2 = [UIImage imageWithData:bankcardImg];
    NSArray *arrImg = @[img0,img1,img2];
    NSArray *arrImgName = @[@"certificate_front_image",@"certificate_back_image",@"bank_card_image"];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@user/complete",SERV_ADDR];
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    NSMutableArray* result = [NSMutableArray array];
    for (UIImage* image in arrImg) {
        [result addObject:[NSNull null]];
    }
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 5;
    
    NSBlockOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{ // 回到主线程执行，方便更新 UI 等
            NSLog(@"上传完成!");
            NSInteger iCount = 0;
            for (id response in result) {
                if (response) {
                    NSString *strMsg = [response objectForKey:@"msg"];
                    if ([strMsg isEqualToString:@"success"]) {
                        iCount++;
                    }
                }
                NSLog(@"%@", response);
            }
            if (iCount == 3) {
                
                NSMutableDictionary *dicTemp = [[NSMutableDictionary alloc] init];
                for (NSString *strImg in arrImgName) {
                    for (id response in result) {
                        NSDictionary *dic = [response objectForKey:@"data"];
                        if (dic) {
                            NSString *title = [dic objectForKey:@"title"];
                            if ([title containsString:strImg]) {
                                NSString *strUrl = [dic objectForKey:@"url"];
                                [dicTemp setObject:strUrl forKey:strImg];
                                break;
                            }
                            
                        }
                    }
                }
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
                                            @"certificate_front_image":[dicTemp objectForKey:@"certificate_front_image"],
                                            @"certificate_back_image":[dicTemp objectForKey:@"certificate_back_image"],
                                            @"bank_card_image":[dicTemp objectForKey:@"bank_card_image"],
                                            };
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSSet *accetContentTypes = [NSSet setWithObjects:@"application/json",
                                            @"text/html",
                                            @"text/json",
                                            @"text/javascript",
                                            @"text/plain",nil];
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                manager.responseSerializer.acceptableContentTypes = accetContentTypes;
                
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                [manager.requestSerializer setValue:uid forHTTPHeaderField:@"access-token"];
                [manager POST:strUrl parameters:dicParams progress:nil success:succBlock failure:failBlock];
            } else {
                NSLog(@"提交失败！");
            }
            
        }];
    }];
    
    for (NSInteger i = 0; i < arrImg.count; i++) {
        
        NSURLSessionUploadTask* uploadTask = [[WJSDataManager shareInstance] uploadTaskWithImage:arrImg[i] andImageName:arrImgName[i] completion:^(NSURLResponse *response, NSDictionary* responseObject, NSError *error) {
            if (error) {
                NSLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
            } else {
                NSString *resVal = [responseObject objectForKey:@"msg"];
                NSString *uId = [responseObject objectForKey:@"data"];
                NSLog(@"第 %d 张图片上传成功: %@", (int)i + 1, uId);
                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    result[i] = responseObject;
                }
            }
            
        }];
        
        WJSURLSessionWrapperOperation *uploadOperation = [WJSURLSessionWrapperOperation operationWithURLSessionTask:uploadTask];
        
        [completionOperation addDependency:uploadOperation];
        [queue addOperation:uploadOperation];
    }
    
    [queue addOperation:completionOperation];
}

- (void)applyWJSInfoWithWjsId:(NSString *)wjsId andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock {
    
    NSString *strUrl = [NSString stringWithFormat:@"%@user/apply_wjs",SERV_ADDR];
    NSDictionary *dicParams = @{@"wjsid":wjsId};
    [self postMsg:strUrl withParams:dicParams withSuccBlock:succBlock withFailBlock:failBlock];
}

- (void)getUserDetailInfoWithSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock {
    
    NSString *strUrl = [NSString stringWithFormat:@"%@user/info",SERV_ADDR];
    [self getMsg:strUrl withSuccBlock:succBlock withFailBlock:failBlock];
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
    
    NSString *strUrl = [NSString stringWithFormat:@"%@wjs/getlist",SERV_ADDR];
    [self getMsg:strUrl withSuccBlock:succBlock withFailBlock:failBlock];
}

- (void)getNewsListWithCId:(NSString *)cid andOrder:(NSString *)order andPage:(NSString *)page andPageNum:(NSString *)pagenum
                   andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock {
    NSString *strUrl = [NSString stringWithFormat:@"%@news/getlist",SERV_ADDR];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] init];
    if(cid) [dicParams setObject:cid forKey:@"cid"];
    if(page) [dicParams setObject:page forKey:@"page"];
    if(pagenum) [dicParams setObject:pagenum forKey:@"pagenum"];
    if(order) [dicParams setObject:order forKey:@"order"];
    [self postMsg:strUrl withParams:dicParams withSuccBlock:succBlock withFailBlock:failBlock];
}

- (void)getWJSApplyStatus:(SuccBlock) succBlock andFail:(FailBlock) failBlock {
    
    NSString *strUrl = [NSString stringWithFormat:@"%@user/get_apply_status",SERV_ADDR];
    [self getMsg:strUrl withSuccBlock:succBlock withFailBlock:failBlock];
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

- (NSURLSessionUploadTask*)uploadTaskWithImage:(UIImage*)image andImageName:(NSString *)strImgName completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock {
    // 构造 NSURLRequest
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@%@.png",strImgName,str];
    NSError* error = NULL;
    NSString *strUrl = [NSString stringWithFormat:@"%@common/upfile",SERV_ADDR];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:strUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
    } error:&error];
    
    // 可在此处配置验证信息
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *accetContentTypes = [NSSet setWithObjects:@"application/json",
                                @"text/html",
                                @"text/json",
                                @"text/javascript",
                                @"text/plain",nil];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = accetContentTypes;
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:completionBlock];
    
    return uploadTask;
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
        } progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            NSLog(@"上传成功 %@", responseObject);
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"上传失败 %@", error);
        }];

}


- (void)postMsg:(NSString *)url withParams:(id)params
  withSuccBlock:(SuccBlock) succBlock
  withFailBlock:(FailBlock) failBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSSet *acceptContentTypes = [NSSet setWithObjects:@"application/json",
                                @"text/html",
                                @"text/json",
                                @"text/javascript",
                                @"text/plain",nil];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = acceptContentTypes;
    NSString *strUid = [[WJSDataModel shareInstance] uId];
    if (strUid && ![strUid isEqualToString:@""]) {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer setValue:strUid forHTTPHeaderField:@"access-token"];
    }
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
                                @"text/plain",nil];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = accetContentTypes;
    
    NSString *strUid = [[WJSDataModel shareInstance] uId];
    if (strUid && ![strUid isEqualToString:@""]) {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer setValue:strUid forHTTPHeaderField:@"access-token"];
    }
    
    [manager GET:url parameters:nil progress:nil success:succBlock failure:failBlock];
}

@end
