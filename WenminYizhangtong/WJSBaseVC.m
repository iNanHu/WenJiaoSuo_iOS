//
//  SHBaseVC.m
//  SmartHouseNew
//
//  Created by shigaoyang on 15/2/6.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "WJSBaseVC.h"
#import "WJSCommonDefine.h"
#import "SHRefreshControl.h"
#import "UINavigationBar+Awesome.h"
#import "UIButton+ImageWithLabel.h"
#import "UINavigationController+Custom.h"

#define TOP_BAR_HEIGHT 60

@interface WJSBaseVC ()<UIGestureRecognizerDelegate>
{
    UIButton *_messageButton;
    UIButton *_leftButton;
    UILabel *_titleLabel;
    UIView *_titleView;
}

@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSObject *netStateObject;

@end

@implementation WJSBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad is : %@", NSStringFromClass([self class]));
    
    self.navigationController.navigationBar.hidden = YES;
    
    //添加titleView
    self.topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 90, 44)];
    [self.topBgView setBackgroundColor:RGB(0x0E, 0x94, 0xCC)];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    // 设置指示器位置
    self.activityView.frame = CGRectMake(0, 11, 20, 20);
    [self.activityView startAnimating];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.activityView.frame) + 5, 0, 65, 44)];
    self.titleLabel.textColor = [UIColor redColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.topBgView addSubview:self.titleLabel];
    [self.topBgView addSubview:self.activityView];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dic;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.navigationController.navigationBar setHidden:NO];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    _leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    [_leftButton setTintColor:[UIColor whiteColor]];
    
    [_leftButton setFrame:CGRectMake(0, 0, 40, 40)];
    [_leftButton addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    //0x2682F1
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    [self.view setBackgroundColor:RGB(250, 250, 250)];
    
    self.hidLeftButton = NO;
    self.hidRightButton = YES;
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ([self.navigationController.viewControllers count] == 1) {
        return NO;
    } else {
        return YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

// 显示菊花指示器
- (void)showActivityViewWithTitle:(NSString *)title {
    
    self.navigationItem.titleView = self.topBgView;
    self.titleLabel.text = title;
}

//隐藏菊花指示器
- (void)hidActivityViewWithTitle:(NSString *)title {
    
    self.navigationItem.titleView = nil;
}


- (void)rightAction:(UIButton *)sender{

}
- (void)leftAction:(UIButton *)sender{
    UIViewController *nav = self.navigationController;
    if (nav) {
        
//         NSString *types[4] = {kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
//         NSString *subtypes[4] = {kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
//         //立方 吸走 翻转 水波 翻页 翻页回
//         NSString *moreTypes[]={@"cube",@"suckEffect",@"oglFlip",@"rippleEffect",
//                                @"pageCurl",@"pageUnCurl",@"cameraIrisHollowOpen",
//                                @"cameraIrisHollowClose"};
        
//        CATransition *animation = [CATransition animation];
//        [animation setDuration:0.4];
//        [animation setType:@"oglFlip"];
//        
//        [animation setSubtype: kCATransitionFromRight];
//        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//        
//        [self.navigationController.view.layer addAnimation:animation forKey:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)setHidLeftButton:(BOOL)hidLeftButton
{
    _hidLeftButton = hidLeftButton;
    if (!_hidLeftButton) {
        
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_leftButton]];
    } else {
        
        [self.navigationItem setLeftBarButtonItem:nil];
    }
}

- (void)setHidRightButton:(BOOL)hidRightButton
{
    _hidRightButton = hidRightButton;
    if (!_hidRightButton) {
        
        _messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageButton setImage:[UIImage imageNamed:@"nav_add"] forState:UIControlStateNormal];
        _messageButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
        [_messageButton setTintColor:[UIColor whiteColor]];
        [_messageButton setFrame:CGRectMake(0, 0, 40, 40)];
        [_messageButton.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [_messageButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_messageButton]];
        
    }else {
        
        [self.navigationItem setRightBarButtonItem:nil];
    }
}

- (void)setLeftButtonTitle:(NSString *)leftButtonTitle andImage:(UIImage *)leftButtonImage
{
    self.hidLeftButton = NO;
    [_leftButton setFrame:CGRectMake(0, 0, 50, 40)];
    [_leftButton setTitle:leftButtonTitle forState:UIControlStateNormal];
    [_leftButton setImage:leftButtonImage forState:UIControlStateNormal];
}

- (void)setRightButtonTitle:(NSString *)rightButtonTitle andImage:(UIImage *)rightImage
{
    self.hidRightButton = NO;
    [_messageButton setFrame:CGRectMake(0, 0, 50, 40)];
    [_messageButton setTitle:rightButtonTitle forState:UIControlStateNormal];
    [_messageButton setImage:rightImage forState:UIControlStateNormal];
}

-(void)setScrollRefreshView:(UIScrollView *)scrollView {
    if (!_refreshCtrl) {
        _refreshCtrl = [SHRefreshControl attachToScrollView:scrollView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor redColor] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notifying refresh control of scrolling

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_refreshCtrl)
        [self.refreshCtrl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_refreshCtrl)
        [self.refreshCtrl scrollViewDidEndDragging];
}

#pragma mark - Listening for the user to trigger a refresh

- (void)refreshTriggered:(id)sender
{
    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:1.5 inModes:@[NSRunLoopCommonModes]];
}

- (void)finishRefreshControl
{
    if (_refreshCtrl)
        [self.refreshCtrl finishingLoading];
}
@end
