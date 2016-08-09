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

@interface WJSRegisterVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
//@property (strong, nonatomic) UITextField *nameText;
//@property (strong, nonatomic) UITextField *emailText;
//@property (strong, nonatomic) UITextField *psdText;
//@property (strong, nonatomic) UITextField *confirmPsdText;
//@property (strong, nonatomic) UITextField *regIdText;
@property (strong, nonatomic) NSArray *arrTitle;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITableView *regTableView;
@property (weak, nonatomic) IBOutlet UIButton *bgBtn;
@property (strong, nonatomic) NSMutableArray *arrTextField;


@end

@implementation WJSRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arrTitle = @[@"账户名称",@"注册邮箱",@"密码",@"确认密码",@"邀请码"];
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
//    UITextField *textField = [cell viewWithTag:101];
//    [textField setBackgroundColor:[UIColor clearColor]];
//    textField.tag = indexPath.row;
//    textField.delegate = self;
//    textField.userInteractionEnabled = YES;
//    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    textField.textColor = [UIColor whiteColor];
//    
//    switch (indexPath.row) {
//        case 0:
//        {
//            _nameText = textField;
//        }
//            break;
//        case 1:
//            _emailText = textField;
//            break;
//        case 2:
//            _psdText = textField;
//            break;
//        case 3:
//            _confirmPsdText = textField;
//            break;
//        case 4:
//            _regIdText = textField;
//            break;
//        default:
//            break;
//    }
//    [textField becomeFirstResponder];
    
    labTitle.text = [NSString stringWithFormat:@"%@: ",strTitle];
    UITextField *textField = _arrTextField[indexPath.row];
    textField.frame = CGRectMake(130, 0, UI_SCREEN_WIDTH - 10, 45);
    if (indexPath.row == self.arrTitle.count - 1) {
        textField.placeholder = @"可选字段";
    } else {
        textField.placeholder = [NSString stringWithFormat:@"请输入%@",strTitle];
    }
    [cell addSubview:textField];
    return cell;
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    //写你要实现的：页面跳转的相关代码
//    return YES;
//}

//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    [self viewBeginEdit:textField];
//}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    
//    return YES;
//}
//
//- (void)viewBeginEdit:(UITextField *)textField {
//    
//    [UIView animateWithDuration:0.2 animations:^{
//        
//        CGRect frame = self.view.frame;
//        frame.origin.y = -120;
//        self.view.frame = frame;
//    }];
//}
//- (void)viewEndEdit:(UITextField *)textField {
//    
//    [UIView animateWithDuration:0.2 animations:^{
//        
//        CGRect frame = self.view.frame;
//        frame.origin.y = 0;
//        self.view.frame = frame;
//    }];
//    
//}

- (void)viewEndEdit {
    for (UITextField *textField in _arrTextField)
        [textField resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
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

- (void)registerBtnClicked:(id)sender {
    
    NSString *strName = ((UITextField *)_arrTextField[0]).text;
    NSString *strEmail = ((UITextField *)_arrTextField[1]).text;
    NSString *strPsd = ((UITextField *)_arrTextField[2]).text;
    NSString *strConfirmPsd = ((UITextField *)_arrTextField[3]).text;
    NSString *strInviteId = ((UITextField *)_arrTextField[4]).text;
    
    if ([strName isEqualToString:@""]) {
        NSLog(@"用户名不能为空！");
        [self showAlertViewWithTitle:@"用户名不能为空！"];
        return ;
    }
    
    if (![WJSTool validateMobile:strName]) {
        NSLog(@"手机号格式错误！");
        [self showAlertViewWithTitle:@"手机号格式错误！"];
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
    [[WJSDataManager shareInstance]registerUserAccWithUserName:strName andInviteId:strInviteId andUserEmail:strEmail andUserPsd:strMD5Psd andSucc:succBlock andFail:failBlock];
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
