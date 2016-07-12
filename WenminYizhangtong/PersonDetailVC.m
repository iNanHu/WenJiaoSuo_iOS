//
//  PersonDetailVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/7/11.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "PersonDetailVC.h"
#import "TWSelectCityView.h"
#import "PickerChoiceView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PersonDetailVC ()<TFPickerDelegate,UIImagePickerControllerDelegate>
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

//data
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation PersonDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initCtrl];
    
}

- (void)initData {
    _arrData = [NSMutableArray arrayWithCapacity:3];
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

- (void)initCtrl {
    
    [_sexBtn addTarget:self action:@selector(showSexView) forControlEvents:UIControlEventTouchUpInside];
    [_certificateBtn addTarget:self action:@selector(showCertificateTypeView) forControlEvents:UIControlEventTouchUpInside];
    [_bankTypeBtn addTarget:self action:@selector(showBankNameView) forControlEvents:UIControlEventTouchUpInside];
    [_addressEditBtn addTarget:self action:@selector(showAddressView) forControlEvents:UIControlEventTouchUpInside];
    [_bankAddressEditBtn addTarget:self action:@selector(showBankBranchAddressView) forControlEvents:UIControlEventTouchUpInside];
    [_commitBtn addTarget:self action:@selector(commitUserDetailInfo) forControlEvents:UIControlEventTouchUpInside];
    [_certiFrontBtn addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    [_certiBackBtn addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    [_bankCardFrontBtn addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
}

- (void)commitUserDetailInfo {
    NSMutableDictionary *dicUserDetail = [[NSMutableDictionary alloc]init];
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
    NSString *strCertiFrontName = @"";
    NSString *strCertiBackName = @"";
    NSString *strBankCardFrontName = @"";
    [dicUserDetail setObject:strUserName forKey:@"username"];
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
        NSString* address = [NSString stringWithFormat:@"%@->%@->%@",proviceStr,cityStr,distr];
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
        NSString* address = [NSString stringWithFormat:@"%@->%@->%@",proviceStr,cityStr,distr];
        [blockself.bankAddressEditBtn setTitle:address forState:UIControlStateNormal];
    }];
}

- (void)openMenu {
    //在这里呼出下方菜单按钮项
    _myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
    //刚才少写了这一句
    [_myActionSheet showInView:self.view];
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

- (void)PickerSelectorIndixString:(NSString *)str {
    
    //[_arrData setObject:str atIndexedSubscript:_selectIndex];
    if (_selectIndex == 0) {
        [_sexBtn setTitle:str forState:UIControlStateNormal];
    } else if(_selectIndex == 1) {
        [_certificateBtn setTitle:str forState:UIControlStateNormal];
    } else {
        [_bankAddressEditBtn setTitle:str forState:UIControlStateNormal];
    }
}

//从摄像头获取视频或图片
- (void)selectImageFromCamera
{
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频时长，默认10s
    self.imagePickerController.videoMaximumDuration = 15;
    
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    self.imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    
    //视频上传质量
    //UIImagePickerControllerQualityTypeHigh高清
    //UIImagePickerControllerQualityTypeMedium中等质量
    //UIImagePickerControllerQualityTypeLow低质量
    //UIImagePickerControllerQualityType640x480
    self.imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //设置摄像头模式（拍照，录制视频）为录像模式
    self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}
//从相册获取图片或视频
- (void)selectImageFromAlbum
{
    //NSLog(@"相册");
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
}

#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
