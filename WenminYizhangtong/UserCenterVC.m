//
//  UserCenterVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/6/19.
//  Copyright © 2016年 alexyang. All rights reserved.
//
#define TableViewCellId @"tableViewCellId"
#import "UserCenterVC.h"
#import "QYTableViewHeader.h"
#import "WJSCommonDefine.h"
#import "WJSDataManager.h"
#import "WJSLoginVC.h"
#import <UMSocial.h>
#import <UMSocialQQHandler.h>
#import <UMSocialWechatHandler.h>

@interface UserCenterVC ()<UMSocialUIDelegate>
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@property (strong, nonatomic) QYTableViewHeader *headView;
@property (strong, nonatomic) UIImageView *bigImageView;
@property (strong, nonatomic) UIButton *userIconBtn;
@property (strong, nonatomic) NSArray *arrName;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIActionSheet *myActionSheet;
@property (nonatomic, strong) UIImage *iconImg;
@end

@implementation UserCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.hidLeftButton = YES;
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)initView {
    
    UIImage *bgImg = [UIImage imageNamed:@"fj"];
    _bigImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    _bigImageView.image = bgImg;
    _bigImageView.clipsToBounds = YES;
    _bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIImage *iconImg = [UIImage imageNamed:@"tx"];
    _userIconBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [_userIconBtn setBackgroundImage:iconImg forState:UIControlStateNormal];
    _userIconBtn.center=CGPointMake(_bigImageView.center.x, _bigImageView.center.y);
    _userIconBtn.clipsToBounds=YES;
    _userIconBtn.contentMode=UIViewContentModeScaleAspectFill;
    [_userIconBtn addTarget:self action:@selector(openMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    _headView=[[QYTableViewHeader alloc]init];
    [_headView goodMenWithTableView:self.userTableView andBackGroundView:_bigImageView andSubviews:_userIconBtn];
    
    
    _userTableView.delegate = self;
    _userTableView.dataSource = self;
    [_userTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TableViewCellId];
    [_userTableView setBackgroundColor:RGB(0xF7, 0xF7, 0xF7)];
    
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSString *strResVal = [responseObject objectForKey:@"msg"];
        if ([strResVal isEqualToString:JSON_RES_SUCC]) {
            id data = [responseObject objectForKey:@"data"];
            NSLog(@"用户信息获取成功:%@",data);
        } else {
            id data = [responseObject objectForKey:@"data"];
            NSLog(@"用户信息失败:%@",data);
        }
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"error: %@",error);
    };
    [[WJSDataManager shareInstance]getUserDetailInfoWithSucc:succBlock andFail:failBlock];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidLayoutSubviews {
    [_headView resizeView];
}

- (void)ModifyUserIcon {
    
}

- (void)initData {
    _arrName = @[@[@"昵称"],@[@"我的等级"],@[@"关于我们",@"我要分享"],@[@"设置",@"退出登录"]];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 5)];
    [headView setBackgroundColor:[UIColor clearColor]];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, UI_SCREEN_WIDTH, 1.0/UI_MAIN_SCALE)];
    [lineView setBackgroundColor:RGB(0xA0, 0xA0, 0xA0)];
    [headView addSubview:lineView];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 10.f)];
    [footView setBackgroundColor:[UIColor clearColor]];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 1.0/UI_MAIN_SCALE)];
    [lineView setBackgroundColor:RGB(0xA0, 0xA0, 0xA0)];
    [footView addSubview:lineView];
    return footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arrDetail = [_arrName objectAtIndex:section];
    return arrDetail.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _arrName.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_arrName[indexPath.section][indexPath.row] isEqualToString:@"我要分享"]) {
        [self shareToSocialApp];
    } else if([_arrName[indexPath.section][indexPath.row] isEqualToString:@"退出登录"]) {
        [self Logout];
    }
}

- (void)Logout{
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        [self logoutResult:responseObject];
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        
    };
    [[WJSDataManager shareInstance]logoutUserAccWithSucc:succBlock andFail:failBlock];
}

- (void)logoutResult:(NSDictionary *) result {
    
    NSString *resVal = [result objectForKey:@"msg"];
    if ([resVal isEqualToString:JSON_RES_SUCC]) {
        [[WJSDataModel shareInstance] setUId:@""];
        NSLog(@"登出成功");
        [[WJSDataModel shareInstance] setUserPassword:@""];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WJSLoginVC *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"WJSLoginVC"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController pushViewController:loginVC animated:YES];
    } else {
        NSString *errMsg = [result objectForKey:@"data"];
        NSLog(@"登出失败，error[%@]",errMsg);
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_headView scrollViewDidScroll:scrollView];
    if (scrollView.contentOffset.y<self.bigImageView.frame.size.height-64) {
        //[self setNavbarBackgroundHidden:YES];
    }else
    {
        //[self setNavbarBackgroundHidden:NO];
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strName = [[_arrName objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:TableViewCellId];
    cell.textLabel.text= strName;
    return cell;
}

- (void)openMenu:(id)sender {
    
    _myActionSheet = [[UIActionSheet alloc]
                      initWithTitle:nil
                      delegate:self
                      cancelButtonTitle:@"取消"
                      destructiveButtonTitle:nil
                      otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
    [_myActionSheet showInView:self.view];
}

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _imagePickerController.allowsEditing = YES;
    }
    return _imagePickerController;
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == _myActionSheet.cancelButtonIndex){
        NSLog(@"取消");
    }
    switch (buttonIndex) {
        case 0:
            [self selectImageFromCamera];
            break;
        case 1:
            [self selectImageFromAlbum];
            break;
        default:
            break;
    }
}

//从摄像头获取视频或图片
- (void)selectImageFromCamera
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有摄像头
    if(![UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    self.imagePickerController.sourceType = sourceType;
    self.imagePickerController.allowsEditing = YES;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];  //需要以模态的形式展示
}
//从相册获取图片或视频
- (void)selectImageFromAlbum {
    
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    //拍照时才会保存图片到相册
    if (self.imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    _iconImg = image;
    [_userIconBtn setBackgroundImage:image forState:UIControlStateNormal];
    
}

- (void)shareToSocialApp {
    [UMSocialData defaultData].extConfig.title = @"文龙一账通";
    [UMSocialData defaultData].extConfig.qqData.url = @"http://bilibili.com";
    [UMSocialData defaultData].extConfig.qzoneData.url = @"http://bilibili.com";
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://bilibili.com";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://bilibili.com";
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = @"我的朋友圈";
    [UMSocialData defaultData].extConfig.wechatSessionData.shareText = @"我的微信";
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"507fcab25270157b37000010"
                                      shareText:@"我快要疯了"
                                     shareImage:[UIImage imageNamed:@"haha"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone]
                                       delegate:self];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        [self showAlertViewWithTitle:@"分享成功"];
        //得到分享到的平台名
        //NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    } else {
        [self showAlertViewWithTitle:@"分享失败"];
    }
}

-(NSURL *)documentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSURL *docURL = [NSURL URLWithString:documentsDirectory];
    return docURL;
}

#pragma mark 图片保存完毕的回调
- (void)image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
