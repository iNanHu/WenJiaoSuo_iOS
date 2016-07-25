//
//  PersonDetailVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/7/11.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#define CertiFrontUrl @"certiFrontUrl"
#define CertiBackUrl @"certiBackUrl"
#define BankFrontUrl @"bankFrontUrl"

#import "PersonDetailVC.h"
#import "WJSDataManager.h"
#import "WJSDataModel.h"

@interface PersonDetailVC () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textInviteId;
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumText;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UIButton *certificateBtn;
@property (weak, nonatomic) IBOutlet UITextField *certificateNumText;
@property (weak, nonatomic) IBOutlet UIButton *addressEditBtn;
@property (weak, nonatomic) IBOutlet UITextField *addressText;
@property (weak, nonatomic) IBOutlet UIButton *bankTypeBtn;
@property (weak, nonatomic) IBOutlet UITextField *bankAccountText;
@property (weak, nonatomic) IBOutlet UITextField *branchNameText;
@property (weak, nonatomic) IBOutlet UIButton *bankAddressEditBtn;
@property (weak, nonatomic) IBOutlet UITextField *bankAddressText;
@property (weak, nonatomic) IBOutlet UIButton *certiFrontBtn;
@property (weak, nonatomic) IBOutlet UIButton *certiBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *bankCardFrontBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UIScrollView *personScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *certiFrontImgView;
@property (weak, nonatomic) IBOutlet UIImageView *certiBackImgView;
@property (weak, nonatomic) IBOutlet UIImageView *bankFrontImgView;

//data
@property (nonatomic, strong) NSMutableDictionary *dicImgData;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) NSInteger imgType;
@end

@implementation PersonDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initCtrl];
    
}

- (void)initData {
    
    _dicImgData = [[NSMutableDictionary alloc] init];
    _imgType = -1;
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

- (void)leftAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initCtrl {
    
    //隐藏导航栏左右按钮
    self.hidLeftButton = NO;
    self.hidRightButton = YES;
    self.title = @"完善个人信息";
    
    //ScrollView
    _personScrollView.frame = CGRectMake(0, 40, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 40);
    _personScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, 800);
    // 设置内容的边缘和Indicators边缘
    _personScrollView.contentInset = UIEdgeInsetsMake(0, 40, 40, 0);
    _personScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 40, 0, 0);
    [_personScrollView flashScrollIndicators];
    _personScrollView.directionalLockEnabled = YES;
    _personScrollView.delegate = self;
    
    [_sexBtn addTarget:self action:@selector(showSexView) forControlEvents:UIControlEventTouchUpInside];
    [_certificateBtn addTarget:self action:@selector(showCertificateTypeView) forControlEvents:UIControlEventTouchUpInside];
    [_bankTypeBtn addTarget:self action:@selector(showBankNameView) forControlEvents:UIControlEventTouchUpInside];
    [_addressEditBtn addTarget:self action:@selector(showAddressView) forControlEvents:UIControlEventTouchUpInside];
    [_bankAddressEditBtn addTarget:self action:@selector(showBankBranchAddressView) forControlEvents:UIControlEventTouchUpInside];
    [_commitBtn addTarget:self action:@selector(commitUserDetailInfo) forControlEvents:UIControlEventTouchUpInside];
    [_certiFrontBtn addTarget:self action:@selector(openMenu:) forControlEvents:UIControlEventTouchUpInside];
    _certiFrontBtn.tag = 0;
    [_certiBackBtn addTarget:self action:@selector(openMenu:) forControlEvents:UIControlEventTouchUpInside];
    _certiBackBtn.tag = 1;
    [_bankCardFrontBtn addTarget:self action:@selector(openMenu:) forControlEvents:UIControlEventTouchUpInside];
    _bankCardFrontBtn.tag = 2;
}

- (void)commitUserDetailInfo {
    
    //NSString *strInviteId = _textInviteId.text;
    NSString *strUid = [[WJSDataModel shareInstance] uId];
    NSString *strUserName = _userNameText.text;
    NSString *strPhoneNum = _phoneNumText.text;
    NSString *strSex = _sexBtn.currentTitle;
    NSString *strCertiType = _certificateBtn.currentTitle;
    NSString *strCertiNum = _certificateNumText.text;
    NSString *strAddress = [NSString stringWithFormat:@"%@%@",_addressEditBtn.currentTitle,_addressText.text];
    NSString *strBankName = _bankTypeBtn.currentTitle;
    NSString *strBankAccount = _bankAccountText.text;
    NSString *strBankBranchName = _branchNameText.text;
    NSString *strBankAddress = [NSString stringWithFormat:@"%@%@",_bankAddressEditBtn.currentTitle,_bankAddressText.text];
    UIImage *certiFrontImg = [_dicImgData objectForKey:CertiFrontUrl];
    UIImage *certiBackImg = [_dicImgData objectForKey:CertiBackUrl];
    UIImage *bankFrontImg = [_dicImgData objectForKey:BankFrontUrl];
    NSData *certiFrontData = UIImagePNGRepresentation(certiFrontImg);
    NSData *certiBackData = UIImagePNGRepresentation(certiBackImg);
    NSData *bankFrontData = UIImagePNGRepresentation(bankFrontImg);
    
    if ([strSex isEqualToString:@"男"]) {
        strSex = @"1";
    } else {
        strSex = @"2";
    }
    
    [_certiFrontImgView setImage:certiFrontImg];
    [_certiBackImgView setImage:certiBackImg];
    [_bankFrontImgView setImage:bankFrontImg];
    
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        [self personCommitResult:responseObject];
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"提交个人详情失败！");
    };
    if (!strUid || [strUid isEqualToString:@""]) {
        NSLog(@"一账通：用户Uid不能为空！");
    }
    [[WJSDataManager shareInstance]commitDetailUserInfoWithUId:strUid andUsrName:strUserName andSex:strSex andCertiType:strCertiType andCertiNum:strCertiNum andTelPhone:strPhoneNum andAddress:strAddress andBankName:strBankName andAccNum:strBankAccount andBankLoc:strBankAddress andBranchName:strBankBranchName andCertiFrontImg:certiFrontData andCertiBackImg:certiBackData andBankCardImg:bankFrontData andSucc:succBlock andFail:failBlock];
}



- (void)personCommitResult:(NSDictionary *) result {
    NSLog(@"提交个人详情成功！");
    NSString *resVal = [result objectForKey:@"msg"];
    if ([resVal isEqualToString:JSON_RES_SUCC]) {
        NSString *uId = [result objectForKey:@"data"];
        NSLog(@"一账通：success[%@]",uId);
        //[[WJSDataModel shareInstance] setUId:uId];
        
        //[self performSegueWithIdentifier:NAV_TO_HOMEVC sender:nil];
    } else {
        NSString *errMsg = [result objectForKey:@"data"];
        NSLog(@"一账通: error[%@]",errMsg);
    }
}


- (void)showSexView {
    
    PickerChoiceView *pickView = [[PickerChoiceView alloc] initWithFrame:self.view.bounds];
    pickView.customArr = @[@"男",@"女"];
    pickView.selectStr = @"---请选择性别---";
    pickView.delegate = self;
    _selectIndex = 0;
    [self.view addSubview:pickView];
}

- (void)showCertificateTypeView {
    
    PickerChoiceView *pickView = [[PickerChoiceView alloc] initWithFrame:self.view.bounds];
    pickView.delegate = self;
    pickView.customArr = @[@"身份证",@"军官证",@"护照",@"台胞证"];
    pickView.selectStr = @"---请选择证件类型---";
    _selectIndex = 1;
    [self.view addSubview:pickView];
}

- (void)showAddressView {
    
    TWSelectCityView *city = [[TWSelectCityView alloc] initWithTWFrame:self.view.bounds TWselectCityTitle:@"选择地区"];
    __weak typeof(self)blockself = self;
    [city showCityView:^(NSString *proviceStr, NSString *cityStr, NSString *distr) {
        NSString* address = [NSString stringWithFormat:@"%@%@%@",proviceStr,cityStr,distr];
        [blockself.addressEditBtn setTitle:address forState:UIControlStateNormal];
    }];
}

- (void)showBankNameView {
    
    PickerChoiceView *pickView = [[PickerChoiceView alloc] initWithFrame:self.view.bounds];
    pickView.customArr = @[@"工行",@"平安银行",@"建设银行",@"中国银行",@"招商银行",@"农行",@"民生",@"交行"];
    pickView.selectStr = @"---请选择开户银行---";
    pickView.delegate = self;
    _selectIndex = 2;
    [self.view addSubview:pickView];
}

- (void)showBankBranchAddressView {
    
    TWSelectCityView *city = [[TWSelectCityView alloc] initWithTWFrame:self.view.bounds TWselectCityTitle:@"选择地区"];
    __weak typeof(self)blockself = self;
    [city showCityView:^(NSString *proviceStr, NSString *cityStr, NSString *distr) {
        NSString* address = [NSString stringWithFormat:@"%@%@%@",proviceStr,cityStr,distr];
        [blockself.bankAddressEditBtn setTitle:address forState:UIControlStateNormal];
    }];
}

- (void)openMenu:(id)sender {
  
    _myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
    [_myActionSheet showInView:self.view];
    UIButton *selBtn = (UIButton *)sender;
    _imgType = selBtn.tag;
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

// 是否支持滑动至顶部
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
}

// 滑动到顶部时调用该方法
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScrollToTop");
}

// scrollView 已经滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //NSLog(@"scrollViewDidScroll");
}

// scrollView 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    //NSLog(@"scrollViewWillBeginDragging");
}

// scrollView 结束拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    //NSLog(@"scrollViewDidEndDragging");
}

// scrollView 开始减速（以下两个方法注意与以上两个方法加以区别）
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    //NSLog(@"scrollViewWillBeginDecelerating");
}

// scrollview 减速停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //NSLog(@"scrollViewDidEndDecelerating");
}

- (void)PickerSelectorIndixString:(NSString *)str {
    
    if (_selectIndex == 0) {
        [_sexBtn setTitle:str forState:UIControlStateNormal];
    } else if(_selectIndex == 1) {
        [_certificateBtn setTitle:str forState:UIControlStateNormal];
    } else if(_selectIndex == 2){
        [_bankTypeBtn setTitle:str forState:UIControlStateNormal];
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
    } else {
        [self selectImage:image];
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
    
    [self selectImage:image];
}

- (void)selectImage:(UIImage *) image {
    
    NSLog(@"didFinishSaveImage selIndex:%ld",(long)_imgType);
    if(_imgType == 0) {
        [_dicImgData setObject:image forKey:CertiFrontUrl];
    } else if(_imgType == 1) {
        [_dicImgData setObject:image forKey:CertiBackUrl];
    } else if(_imgType == 2){
        [_dicImgData setObject:image forKey:BankFrontUrl];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
