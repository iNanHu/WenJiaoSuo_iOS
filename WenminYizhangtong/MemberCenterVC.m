//
//  MemberCenterVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/7/28.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "MemberCenterVC.h"
#import "WJSCommonDefine.h"
#import "WJSDataModel.h"
#import "WJSDataManager.h"

@interface MemberCenterVC ()
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headIconImgView;
@property (weak, nonatomic) IBOutlet UIImageView *myDegreeView;
@property (weak, nonatomic) IBOutlet UILabel *nickLab;
@property (weak, nonatomic) IBOutlet UIButton *tongBtn;
@property (weak, nonatomic) IBOutlet UIButton *yinBtn;
@property (weak, nonatomic) IBOutlet UIButton *jinBtn;
@property (weak, nonatomic) IBOutlet UIButton *zuanBtn;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIView *contentView;

//data
@property (nonatomic, strong)NSMutableDictionary *dicUserInfo;
@property (nonatomic, strong)NSArray *arrImg;
@property (nonatomic, strong)NSArray *arrDetailInfo;
@end

@implementation MemberCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"会员中心";
    _arrImg = @[@"生",@"意",@"兴",@"隆"];
    _arrDetailInfo = @[@"荣升标准：一度粉丝与二度粉丝数量之和超过3个。\n恭喜您，铜牌任务已通关！您已经迈上文交经纪人的康庄大道！再接再厉哦！",
                       @"荣升标准：一度粉丝与二度粉丝数量之和超过36个。\n恭喜您，银牌任务已通关！表现不错哦！即将进入中产阶层！为你加油哦！",
                       @"荣升标准：一度粉丝与二度粉丝数量之和超过120个。\n恭喜您，金牌任务已通关！您简直太出色了！此时的你，已经实现中产收入，迈向富豪阶层！",
                       @"荣升标准：一度粉丝与二度粉丝数量之和超过600个。\n恭喜您，荣升为文龙一账通的钻石合伙人！您证实了您是最杰出的！文龙一账通，整合文交全产业链，与您一起开启财富殿堂的大门！您即将年入千万级！请马上与客服联系，与我们正式签约。"];
    _dicUserInfo = [[WJSDataModel shareInstance] dicUserInfo];
    [self initCtrl];
    [self initData];
}

- (void)initData {
    
    NSString *strNickName = [_dicUserInfo objectForKey:@"username"];
    NSInteger rank = 0;
    NSString *strRank = [_dicUserInfo objectForKey:@"rank"];
    if ([strRank isEqual:[NSNull null]]) {
        rank = 0;
    }
    
   _headIconImgView.image = [UIImage imageNamed:@"58"];
    _myDegreeView.image = [UIImage imageNamed:_arrImg[rank]];
    _nickLab.text = [NSString stringWithFormat:@"Hi,%@",strNickName];
    _detailLab.text = _arrDetailInfo[rank];
}

- (void)initCtrl {
    
    _headIconImgView.layer.cornerRadius = 40.f;
    _myDegreeView.layer.cornerRadius = 15.f;
    
    _tongBtn.layer.cornerRadius = 30.f;
    _yinBtn.layer.cornerRadius = 30.f;
    _jinBtn.layer.cornerRadius = 30.f;
    _zuanBtn.layer.cornerRadius = 30.f;
    
    _tongBtn.layer.borderWidth = 2.0/UI_MAIN_SCALE;
    _tongBtn.layer.borderWidth = 2.0/UI_MAIN_SCALE;
    _yinBtn.layer.borderWidth = 2.0/UI_MAIN_SCALE;
    _jinBtn.layer.borderWidth = 2.0/UI_MAIN_SCALE;
    _zuanBtn.layer.borderWidth = 2.0/UI_MAIN_SCALE;
    
    _tongBtn.layer.masksToBounds = YES;
    _tongBtn.layer.masksToBounds = YES;
    _yinBtn.layer.masksToBounds = YES;
    _jinBtn.layer.masksToBounds = YES;
    _zuanBtn.layer.masksToBounds = YES;
    
    _tongBtn.tag = 0;
    _yinBtn.tag = 1;
    _jinBtn.tag = 2;
    _zuanBtn.tag = 3;
    
    [_tongBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_yinBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_jinBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_zuanBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _headView.layer.cornerRadius = 5.f;
    _contentView.layer.cornerRadius = 5.f;
    _detailLab.textColor = [UIColor whiteColor];
    _detailLab.font = [UIFont systemFontOfSize:14.f];
    [_contentView setBackgroundColor:RGB(37, 109, 236)];
}

- (void)btnAction:(UIButton *)btn {
    
    _tongBtn.layer.borderColor = RGB(0x9B, 0x9B, 0x9B).CGColor;
    _yinBtn.layer.borderColor = RGB(0x9B, 0x9B, 0x9B).CGColor;
    _jinBtn.layer.borderColor = RGB(0x9B, 0x9B, 0x9B).CGColor;
    _zuanBtn.layer.borderColor = RGB(0x9B, 0x9B, 0x9B).CGColor;
    btn.layer.borderColor = RGB(0xC0, 0xC0, 0xC0).CGColor;
    _detailLab.text = _arrDetailInfo[btn.tag];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
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
