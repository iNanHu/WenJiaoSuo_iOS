//
//  WJSDataManager.m
//  WenminYizhangtong
//
//  Created by 壹道IOS开发 on 16/6/30.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "WJSDataManager.h"
#import <AFNetworking.h>

@implementation WJSDataManager

- (void)registerUserAccWithUserName:(NSString *)userName andUserEmail:(NSString *)userEmail andUserPsd:(NSString *)userPsd andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock {
    NSString *strUrl = @"";
    NSDictionary *dicParams = @{@"userName":};
}

- (void)loginUserAccWithUserName:(NSString *)userName andUserPsd:(NSString *)userPsd andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock {

}

- (void)FindPsdWithUserEmail:(NSString *)userEmail andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock {
    
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
    
    [manager POST:url parameters:params
         progress:^(NSProgress * _Nonnull uploadProgress) {}
          success:succBlock
          failure:failBlock];
}

@end
