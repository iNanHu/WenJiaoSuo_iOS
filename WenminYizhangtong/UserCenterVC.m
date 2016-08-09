//
//  UserCenterVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/6/19.
//  Copyright © 2016年 alexyang. All rights reserved.
//
#define NavToPersonDetail @"NavToPersonDetail"
#define TableViewCellId @"tableViewCellId"
#define NavToUserAboutVC @"NavToAboutVC"
#define NavToUserManagerVC @"NavToUserManagerVC"
#define TableHeaderHeight 80
#import "WJSTool.h"
#import "UserCenterVC.h"
#import "WJSUserManagerVC.h"
#import "QYTableViewHeader.h"
#import "WJSCommonDefine.h"
#import "WJSDataManager.h"
#import "WJSDataModel.h"
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
@property (strong, nonatomic) NSArray *arrImgName;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIActionSheet *myActionSheet;
@property (nonatomic, strong) UIImage *iconImg;
@end

@implementation UserCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.hidLeftButton = YES;
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self initData];
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
    _userIconBtn.center=CGPointMake(_bigImageView.center.x, _bigImageView.center.y+32);
    _userIconBtn.clipsToBounds=YES;
    _userIconBtn.contentMode=UIViewContentModeScaleAspectFill;
    [_userIconBtn addTarget:self action:@selector(openMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    _headView=[[QYTableViewHeader alloc]init];
    [_headView goodMenWithTableView:self.userTableView andBackGroundView:_bigImageView andSubviews:_userIconBtn];
    
    
    _userTableView.delegate = self;
    _userTableView.dataSource = self;
    [_userTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TableViewCellId];
    if ([_userTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_userTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_userTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_userTableView setLayoutMargins:UIEdgeInsetsZero];
    }

    [_userTableView setBackgroundColor:RGB(0xF7, 0xF7, 0xF7)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidLayoutSubviews {
    
    [_headView resizeView];
}

- (void)ModifyUserIcon {
    
}

- (void)initData {
    
    NSDictionary *dicUserInfo = [[WJSDataModel shareInstance] dicUserInfo];
    NSString *phoneNum = [dicUserInfo objectForKey:@"telphone"];
    //NSLog(@"UserCenter: %@ phoneNum:%@",dicUserInfo.description,phoneNum);
    if (dicUserInfo && ![[dicUserInfo objectForKey:@"telphone"]isEqual:[NSNull null]]) {
        _arrName = @[@[@""],@[@"账号管理"],@[@"推送消息提醒",@"意见反馈",@"关于我们",@"我要分享"]];
    } else {
        _arrName = @[@[@""],@[@"账号管理",@"完善信息"],@[@"推送消息提醒",@"意见反馈",@"关于我们",@"我要分享"]];
    }
    
    _arrImgName = @[@[@""],@[@"evaluate",@"user"],@[@"push_remind",@"feedback",@"about_us",@"check_version",@"share"]];
    [_userTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return nil;
    }
    
    NSString *strName = _arrName[indexPath.section][indexPath.row];
    NSString *strIconUrl = _arrImgName[indexPath.section][indexPath.row];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:TableViewCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellId];
    }
    cell.textLabel.text = strName;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        UISwitch *switchView = [UISwitch new];
        cell.accessoryView = switchView;
        cell.tag = indexPath.row;
        switchView.on = [[WJSDataModel shareInstance] enablePropel];
        [switchView addTarget:self action:@selector(switchValChanged:) forControlEvents:UIControlEventValueChanged];
    }
    [cell.imageView setImage:[UIImage imageNamed:strIconUrl]];
    return cell;
}

- (void)switchValChanged:(UISwitch *)switchVal {
    
    BOOL enableVal = switchVal.on;
    [[WJSDataModel shareInstance]setEnablePropel:enableVal];
}

- (void)setBtnLayout:(UIButton *)selBtn {
    
    UIImage *image = [UIImage imageNamed:@"my_collection"];
    CGSize btnSize = [@"会员中心" sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(UI_SCREEN_WIDTH/3, TableHeaderHeight)];
    
    selBtn.titleEdgeInsets =UIEdgeInsetsMake(0.5*image.size.height + 10, -0.5*image.size.width, -0.5*image.size.height, 0.5*image.size.width);
    selBtn.imageEdgeInsets =UIEdgeInsetsMake(-0.5*btnSize.height, 0.5*btnSize.width, 0.5*btnSize.height, -0.5*btnSize.width);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, TableHeaderHeight)];
        [headView setBackgroundColor:[UIColor whiteColor]];

        UIButton *userCenterBtn = [UIButton new];
        userCenterBtn.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH/3, TableHeaderHeight);
        [userCenterBtn setTitle:@"会员中心" forState:UIControlStateNormal];
        [userCenterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [userCenterBtn setImage:[UIImage imageNamed:@"my_collection"] forState:UIControlStateNormal];
        userCenterBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [userCenterBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [self setBtnLayout:userCenterBtn];
        [userCenterBtn setBackgroundImage:[WJSTool ImageWithColor:RGB(0xA0, 0xA0, 0xA0) andFrame:userCenterBtn.frame] forState:UIControlStateHighlighted];
        [userCenterBtn addTarget:self action:@selector(onUserCenter) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:userCenterBtn];
        
        UIButton *mySuborBtn = [UIButton new];
        mySuborBtn.frame = CGRectMake(UI_SCREEN_WIDTH/3, 0, UI_SCREEN_WIDTH/3, TableHeaderHeight);
        [mySuborBtn setTitle:@"我的粉丝" forState:UIControlStateNormal];
        [mySuborBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [mySuborBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mySuborBtn setImage:[UIImage imageNamed:@"fast_open_account"] forState:UIControlStateNormal];
        mySuborBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self setBtnLayout:mySuborBtn];
        [mySuborBtn setBackgroundImage:[WJSTool ImageWithColor:RGB(0xA0, 0xA0, 0xA0) andFrame:userCenterBtn.frame] forState:UIControlStateHighlighted];
        [mySuborBtn addTarget:self action:@selector(onMySubor) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:mySuborBtn];
        
        UIButton *otherBtn = [UIButton new];
        otherBtn.frame = CGRectMake(2*UI_SCREEN_WIDTH/3, 0, UI_SCREEN_WIDTH/3, TableHeaderHeight);
        [otherBtn setTitle:@"我的自选" forState:UIControlStateNormal];
        [otherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [otherBtn setImage:[UIImage imageNamed:@"self_selector"] forState:UIControlStateNormal];
        otherBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [otherBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [self setBtnLayout:otherBtn];
        [otherBtn setBackgroundImage:[WJSTool ImageWithColor:RGB(0xA0, 0xA0, 0xA0) andFrame:userCenterBtn.frame] forState:UIControlStateHighlighted];
        [otherBtn addTarget:self action:@selector(onOptional) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:otherBtn];
        
        UIView *lineView = [UIView new];
        CGFloat lineHegiht = 1.0/UI_MAIN_SCALE;
        lineView.frame = CGRectMake(0, TableHeaderHeight - lineHegiht, UI_SCREEN_WIDTH, lineHegiht);
        [lineView setBackgroundColor:RGB(0xC0, 0xC0, 0xC0)];
        [headView addSubview:lineView];
        
        return headView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

- (void)onUserCenter {
    [self showAlertViewWithTitle:@"功能正在开发中，敬请期待！"];
}

- (void)onMySubor {
    
    [self performSegueWithIdentifier:NAV_TO_MYFANSVC sender:nil];
}

- (void)onOptional {
    
    [self showAlertViewWithTitle:@"功能正在开发中，敬请期待！"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0)
        return  TableHeaderHeight;
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0){
        return 0;
    } else {
        NSArray *arrDetail = [_arrName objectAtIndex:section];
        return arrDetail.count;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _arrName.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        self.hidesBottomBarWhenPushed = YES;
        NSString *strUid = [[WJSDataModel shareInstance] uId];
        if (strUid && ![strUid isEqualToString:@""]) {
            [self performSegueWithIdentifier:NavToUserManagerVC sender:nil];
        } else {
            [self segToLoginVC];
        }
        
    } else if(indexPath.section == 1 && indexPath.row == 1){
        self.hidesBottomBarWhenPushed = YES;
        [self performSegueWithIdentifier:NavToPersonDetail sender:nil];
    } else if(indexPath.section == 2 && indexPath.row == 2) {
        self.hidesBottomBarWhenPushed = YES;
        [self performSegueWithIdentifier:NavToUserAboutVC sender:nil];
    } else if(indexPath.section == 2 && indexPath.row == 3) {
        [self shareToSocialApp];
    }
}

- (void)segToLoginVC {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WJSLoginVC *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"WJSLoginVC"];
    NSMutableArray *arrViewList = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if (![tempVC isEqual:self]) {
            [arrViewList removeObject:tempVC];
        }
    }
    self.navigationController.viewControllers = arrViewList;
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_headView scrollViewDidScroll:scrollView];
    if (scrollView.contentOffset.y<self.bigImageView.frame.size.height-64) {
        //[self setNavbarBackgroundHidden:YES];
    }else
    {
        //[self setNavbarBackgroundHidden:NO];
    }
    
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
    
    NSString *strRegUrl = [NSString stringWithFormat:@"http://wmyzt.applinzi.com/register.html"];
    NSDictionary *dicUsesrInfo = [[WJSDataModel shareInstance] dicUserInfo];
    if (dicUsesrInfo) {
        NSString *strInviteId = [dicUsesrInfo objectForKey:USRINFO_INVITEID];
        if (strInviteId && ![strInviteId isEqual:[NSNull null]]&& ![strInviteId isEqualToString:@""]) {
            strRegUrl = [NSString stringWithFormat:@"http://wmyzt.applinzi.com/register.html?invite=%@",strInviteId];
        } else {
            [self showAlertViewWithTitle:@"您尚未完善您的信息，请在完善信息中进行填写！"];
        }
    } else {
        [self showAlertViewWithTitle:@"您尚未完善您的信息，请在完善信息中进行填写！"];
    }

    
    [UMSocialData defaultData].extConfig.title = @"文龙一账通";
    [UMSocialData defaultData].extConfig.qqData.url = strRegUrl;
    [UMSocialData defaultData].extConfig.qzoneData.url = strRegUrl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = strRegUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = strRegUrl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = @"一键注册";
    [UMSocialData defaultData].extConfig.wechatSessionData.shareText = @"一键注册";
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"507fcab25270157b37000010"
                                      shareText:@""
                                     shareImage:[UIImage imageNamed:@"80"]
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:NavToUserManagerVC]) {
        WJSUserManagerVC *destVC = segue.destinationViewController;
        NSDictionary *dicInfo = [[WJSDataModel shareInstance] dicUserInfo];
        destVC.dicUserInfo = dicInfo;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
