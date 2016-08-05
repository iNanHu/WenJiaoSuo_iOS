//
//  WJSDataManager.h
//  WenminYizhangtong
//
//  Created by 壹道IOS开发 on 16/6/30.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WJSDataModel.h"
#import "WJSCommonDefine.h"

@interface WJSDataManager : NSObject

+(id)shareInstance;

//用户相关接口
//注册账号
- (void)registerUserAccWithUserName:(NSString *)userName andInviteId:(NSString *)inviteId andUserEmail:(NSString *)userEmail andUserPsd:(NSString *)userPsd andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;
//登录账号
- (void)loginUserAccWithUserName:(NSString *)userName andUserPsd:(NSString *)userPsd andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;
//登出账号
- (void)logoutUserAccWithSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;
//找回密码
- (void)FindPsdWithUserEmail:(NSString *)userEmail andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;
//提交用户详细资料
- (void)commitDetailUserInfoWithUId:(NSString *)uid andUsrName:(NSString *)usrname andSex:(NSString *)sex
                       andCertiType:(NSString *)certifitype andCertiNum:(NSString *)certinum andTelPhone:(NSString *)telphone
                         andAddress:(NSString *)address andBankName:(NSString *)bankname andAccNum:(NSString *)accountNum
                         andBankLoc:(NSString *)banklocation andBranchName:(NSString *)branchname andCertiFrontImg:(NSData *)certiFrontImg andCertiBackImg:(NSData *)certiBackImg andBankCardImg:(NSData *)bankcardImg
                            andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;
//提交文交所开户申请
- (void)applyWJSInfoWithWjsId:(NSString *)wjsId andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;
//获取用户详细信息
- (void)getUserDetailInfoWithSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;
//获取用户二维码链接
- (void)getQRCodeWithInviteId:(NSString *)inviteId andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;
//获取下级用户列表
- (void)getFansListWithLevel:(NSInteger)levelId andPageSize:(NSInteger)pageSize andPageNum:(NSInteger)pageNum andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;
//改变用户头像
- (void)changeAvatarWithUId:(NSString *)uid andAvatorData:(NSData *)imgData
                    andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;
//获取文交所列表
- (void)getWJSInfoListWithSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;

//获取用户开户状态
- (void)getWJSApplyStatusWithUid:(NSString *)strUid andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;
//获取下级开户状态
- (void)getWJSFansApplyStatusWithUid:(NSString *) strUid andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;
//获取新闻列表
- (void)getNewsListWithCId:(NSString *)cid andOrder:(NSString *)order andPage:(NSString *)page andPageNum:(NSString *)pagenum
                   andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;
//获取新闻详情
- (void)getNewDetailWithId:(NSString *)newsId andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;
//获取新闻类别
- (void)getNewsCategoryInfoWithSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;
//获取轮播图片
- (void)getBannerWithSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;

//通用接口
//上传文件
- (NSURLSessionUploadTask*)uploadTaskWithImage:(UIImage*)image andImageName:(NSString *)strImgName completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock;
//上传文件
- (void)upWJSFileWithFile:(NSData *)file andSucc:(SuccBlock) succBlock andFail:(FailBlock) failBlock;
@end
