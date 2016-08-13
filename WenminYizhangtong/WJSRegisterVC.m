//
//  WJSRegisterVC.m
//  WenminYizhangtong
//
//  Created by 壹道IOS开发 on 16/6/30.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "WJSTool.h"
#import "WJSRegisterVC.h"
#import "WJSDataManager.h"
#define RegTableViewCellId @"RegTableViewCellId"
#define RegTableHeight 45

@interface WJSRegisterVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) NSArray *arrTitle;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITableView *regTableView;
@property (weak, nonatomic) IBOutlet UIButton *bgBtn;
@property (strong, nonatomic) NSMutableArray *arrTextField;
@property (strong, nonatomic) UIButton *getCodeBtn;
@property (nonatomic, strong) NSTimer *curTimer;
@property (assign, nonatomic) NSInteger timeCount;


@end

@implementation WJSRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arrTitle = @[@"手机号码",@"验证码",@"注册邮箱",@"密码",@"确认密码",@"邀请码"];
    _registerBtn.layer.cornerRadius = 5.f;
    [self initCtrl];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initCtrl {
    
    _arrTextField = [[NSMutableArray alloc] init];
    for(int i = 0; i < _arrTitle.count; i++){
        UITextField *textField = [UITextField new];
        [textField setBackgroundColor:[UIColor clearColor]];
        textField.tag = i;
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.textColor = [UIColor blackColor];
        [textField setFont:[UIFont systemFontOfSize:15.f]];
        NSString *strText = [_arrTitle objectAtIndex:i];
        [textField setValue:RGB(0x9B, 0x9B, 0x9B) forKeyPath:@"_placeholderLabel.textColor"];
        if ([strText containsString:@"密码"]) {
            textField.secureTextEntry = YES;
        }
        [_arrTextField addObject:textField];
    }
    [((UITextField *)_arrTextField[0]) becomeFirstResponder];
    
    _getCodeBtn = [UIButton new];
    _getCodeBtn.tag = _arrTitle.count;
    _getCodeBtn.layer.cornerRadius = 5.f;
    [_getCodeBtn setBackgroundColor:[UIColor redColor]];
    [_getCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    [_getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_getCodeBtn addTarget:self action:@selector(getPhoneCheckNum:) forControlEvents:UIControlEventTouchUpInside];
    [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    _regTableView.dataSource = self;
    _regTableView.delegate = self;
    [_regTableView setBackgroundColor:[UIColor clearColor]];
    [_regTableView registerNib:[UINib nibWithNibName:@"RegTableViewCell" bundle:nil] forCellReuseIdentifier:RegTableViewCellId];
    
    [_registerBtn addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgBtn addTarget:self action:@selector(viewEndEdit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark -
#pragma mark TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RegTableViewCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:RegTableViewCellId];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *strTitle = self.arrTitle[indexPath.row];
    UILabel *labTitle = [cell viewWithTag:100];
    
    labTitle.text = [NSString stringWithFormat:@"%@: ",strTitle];
    UITextField *textField = _arrTextField[indexPath.row];
    if(indexPath.row == 1) {
        UIButton *codeBtn = _getCodeBtn;
        codeBtn.frame = CGRectMake(UI_SCREEN_WIDTH - 130, 8, 120, 30);
        [cell addSubview:codeBtn];
        textField.frame = CGRectMake(130, 0, UI_SCREEN_WIDTH - 260, RegTableHeight);
        [cell addSubview:textField];
    } else {
        textField.frame = CGRectMake(130, 0, UI_SCREEN_WIDTH - 140, RegTableHeight);
        [cell addSubview:textField];
    }

    if (indexPath.row == self.arrTitle.count - 1) {
        textField.placeholder = @"可选字段";
    } else {
        textField.placeholder = [NSString stringWithFormat:@"请输入%@",strTitle];
    }
    [cell addSubview:textField];
    return cell;
}

- (void)viewEndEdit {
    for (UITextField *textField in _arrTextField)
        [textField resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RegTableHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

-(void)viewDidLayoutSubviews
{
    if ([self.regTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.regTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.regTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.regTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSTimer *)curTimer {
    if (!_curTimer) {
        _curTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self  selector:@selector(updateTime) userInfo:nil repeats:YES];
    }
    return _curTimer;
}

- (void)updateTime {
    
    _timeCount++;
    NSString *strTime = @"";
    if (_timeCount >= 60) {
        _timeCount = 0;
        strTime = [NSString stringWithFormat:@"获取验证码"];
        [_getCodeBtn setTitle:strTime forState:UIControlStateNormal];
        [_getCodeBtn setEnabled:YES];
        [_getCodeBtn setBackgroundColor:[UIColor redColor]];
        if ([_curTimer isValid]) {
            [_curTimer invalidate];
            _curTimer = nil;
        }
    } else {
        strTime = [NSString stringWithFormat:@"获取验证码(%ld)",(long)(60 - _timeCount)];
        [_getCodeBtn setTitle:strTime forState:UIControlStateNormal];
        [_getCodeBtn setEnabled:NO];
        [_getCodeBtn setBackgroundColor:RGB(0x9B, 0x9B, 0x9B)];
        
    }
}

- (void)getPhoneCheckNum:(id) sender {
    
    NSString *strName = ((UITextField *)_arrTextField[0]).text;
    
    if ([strName isEqualToString:@""]) {
        NSLog(@"手机号不能为空！");
        [self showAlertViewWithTitle:@"手机号不能为空！"];
        return ;
    }

    if (![WJSTool validateMobile:strName]) {
        NSLog(@"手机号格式错误！");
        [self showAlertViewWithTitle:@"手机号格式错误！"];
        return;
    }
    
    [self.curTimer setFireDate:[NSDate date]];
    
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSDictionary *dicInfo = (NSDictionary *)responseObject;
        NSString *strData = [dicInfo objectForKey:@"data"];
        NSString *strMsg = [dicInfo objectForKey:@"msg"];
        NSLog(@"success:[data %@] [msg %@]",strData,strMsg);
        [self showAlertViewWithTitle:strData];
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"fail:%@",error);
    };
    
    [[WJSDataManager shareInstance]getPhoneCheckNumWithPhoneNum:@"13616502532" andSucc:succBlock andFail:failBlock];
    return;
}

- (void)registerBtnClicked:(id)sender {
    
    NSString *strName = ((UITextField *)_arrTextField[0]).text;
    NSString *strCheckNum = ((UITextField *)_arrTextField[1]).text;
    NSString *strEmail = ((UITextField *)_arrTextField[2]).text;
    NSString *strPsd = ((UITextField *)_arrTextField[3]).text;
    NSString *strConfirmPsd = ((UITextField *)_arrTextField[4]).text;
    NSString *strInviteId = ((UITextField *)_arrTextField[5]).text;
    
    if ([strName isEqualToString:@""]) {
        NSLog(@"手机号不能为空！");
        [self showAlertViewWithTitle:@"手机号不能为空！"];
        return ;
    }
    
    if (![WJSTool validateMobile:strName]) {
        NSLog(@"手机号格式错误！");
        [self showAlertViewWithTitle:@"手机号格式错误！"];
        return;
    }
    
    if (!strCheckNum || [strCheckNum isEqualToString:@""]) {
        [self showAlertViewWithTitle:@"验证码不能为空！"];
        return;
    }
    
    if (![WJSTool chekSecurityCode:strCheckNum]) {
        [self showAlertViewWithTitle:@"验证码格式不正确！"];
        return;
    }
    
    if([strEmail isEqualToString:@""]) {
        NSLog(@"邮箱地址不能为空！");
        [self showAlertViewWithTitle:@"邮箱地址不能为空！"];
        return ;
    }
    if (![WJSTool validateEmail:strEmail]) {
        NSLog(@"邮箱格式错误！");
        [self showAlertViewWithTitle:@"邮箱格式错误！"];
        return ;
    }
    if ([strPsd isEqualToString:@""]) {
        NSLog(@"密码不能为空！");
        [self showAlertViewWithTitle:@"密码不能为空！"];
        return ;
    }
    if (![WJSTool validatePassword:strPsd]) {
        NSLog(@"密码格式错误！");
        [self showAlertViewWithTitle:@"密码格式错误！"];
        return ;
    }
    if ([strConfirmPsd isEqualToString:@""]) {
        NSLog(@"确认密码不能为空！");
        [self showAlertViewWithTitle:@"确认密码不能为空！"];
        return ;
    }
    if (![strConfirmPsd isEqualToString:strPsd]) {
        NSLog(@"两次密码不一致，请重新输入！");
        [self showAlertViewWithTitle:@"两次密码不一致，请重新输入！"];
        return;
    }
    SuccBlock succBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        
        NSString *msg = [responseObject objectForKey:@"msg"];
        NSString *data = [responseObject objectForKey:@"data"];
        NSLog(@"处理成功：[msg:%@,data:%@]",msg,data);
        [self registerResult:responseObject];
    };
    FailBlock failBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"处理失败：%@",error);
        [self showAlertViewWithTitle:[NSString stringWithFormat:@"%@",error]];
    };
    NSString *strMD5Psd = [WJSTool getMD5Val:strPsd];
    [[WJSDataManager shareInstance]registerUserAccWithUserName:strName andCheckNum:strCheckNum andInviteId:strInviteId andUserEmail:strEmail andUserPsd:strMD5Psd andSucc:succBlock andFail:failBlock];
}

- (void)registerResult:(NSDictionary *)result {
    
    NSString *resVal = [result objectForKey:@"msg"];
    if ([resVal isEqualToString:JSON_RES_SUCC]) {
        NSString *uId = [result objectForKey:@"data"];
        [[WJSDataModel shareInstance] setUId:uId];
        [self showAlertViewWithTitle:[NSString stringWithFormat:@"恭喜您成为普通文民！"]];
        [self performSelector:@selector(backToLastVC) withObject:nil afterDelay:1.0];
        
    } else {
        NSString *errMsg = [result objectForKey:@"data"];
        NSLog(@"注册失败，error[%@]",errMsg);
        [self showAlertViewWithTitle:[NSString stringWithFormat:@"注册失败,%@",errMsg]];
    }
}

- (void)backToLastVC {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
