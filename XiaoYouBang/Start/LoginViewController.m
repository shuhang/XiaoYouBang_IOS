//
//  LoginViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/22.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController1.h"
#import "SVProgressHUD.h"
#import "NetWork.h"
#import "Tool.h"
#import "ResetPasswordViewController1.h"

@interface LoginViewController() <UITextFieldDelegate>
{
    UITextField * fieldPhone;
    UITextField * fieldPassword;
    UIButton * buttonLogin;
    UIButton * buttonResetPassword;
}
@end

@implementation LoginViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:false forKey:@"hasStartLogin"];
    [userDefaults synchronize];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self setupTitle:@"登陆"];
    [self setupNextButtonTitle:@"注册"];
    [self hideBackButton];
    
    [self.view setBackgroundColor:Color_Light_Gray];
    
    fieldPhone = [[UITextField alloc] initWithFrame:CGRectMake( 20, 95, Screen_Width - 40, 35 )];
    fieldPhone.placeholder = @"手机号";
    fieldPhone.delegate = self;
    fieldPhone.keyboardType = UIKeyboardTypeNumberPad;
    fieldPhone.backgroundColor = [UIColor whiteColor];
    fieldPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldPhone setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldPhone setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldPhone];
    [self.view addSubview:fieldPhone];
    
    fieldPassword = [[UITextField alloc] initWithFrame:CGRectMake( 20, 135, Screen_Width - 40, 35 )];
    fieldPassword.placeholder = @"密码";
    fieldPassword.secureTextEntry = YES;
    fieldPassword.delegate = self;
    fieldPassword.backgroundColor = [UIColor whiteColor];
    fieldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldPassword setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldPassword setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldPassword];
    [self.view addSubview:fieldPassword];
    
    buttonResetPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonResetPassword.frame = CGRectMake( Screen_Width - 100, 180, 80, 25 );
    [buttonResetPassword.titleLabel setFont:[UIFont systemFontOfSize:Text_Size_Big]];
    [buttonResetPassword setTitleColor:Text_Red forState:UIControlStateNormal];
    [buttonResetPassword setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [buttonResetPassword setTitle:@"忘记密码" forState:UIControlStateNormal];
    [buttonResetPassword addTarget:self action:@selector(doResetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonResetPassword];
    
    buttonLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonLogin.frame = CGRectMake( 20, 220, Screen_Width - 40, 35 );
    [buttonLogin setBackgroundColor:Bg_Red];
    [buttonLogin.titleLabel setFont:[UIFont systemFontOfSize:Text_Size_Small]];
    [buttonLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonLogin setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [buttonLogin setTitle:@"登陆" forState:UIControlStateNormal];
    [buttonLogin addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonLogin];
}

- ( BOOL ) textFieldShouldReturn:(UITextField *)textField
{
    [fieldPhone resignFirstResponder];
    [fieldPassword resignFirstResponder];
    return YES;
}

-(IBAction) textFieldDone:(id) sender
{
    [fieldPhone resignFirstResponder];
    [fieldPassword resignFirstResponder];
}

- ( void ) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [fieldPhone resignFirstResponder];
    [fieldPassword resignFirstResponder];
}

- ( void ) doNext
{
    RegisterViewController1 * controller = [RegisterViewController1 new];
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) doResetPassword
{
    ResetPasswordViewController1 * controller = [ResetPasswordViewController1 new];
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) loginSuccess
{
    [SVProgressHUD dismiss];
    self.tabBarController.tabBar.hidden = NO;
    BaseViewController * controller = [self.navigationController.viewControllers objectAtIndex:0];
    controller.hasRefreshed = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- ( void ) loadUserInfo : ( NSString * ) userId token : ( NSString * ) token
{
    [Tool getUserInfoById:userId token : token success:^( NSDictionary * result )
    {
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[NSString stringWithFormat:@"%@", userId] forKey:@"userId"];
        [userDefaults setObject:[NSString stringWithFormat:@"%@", token] forKey:@"token"];
        [userDefaults setObject:[NSString stringWithFormat:@"%@", result[ @"name" ]] forKey:@"name"];
        [userDefaults setObject:[NSString stringWithFormat:@"%@", result[ @"birthyear" ]] forKey:@"birthyear"];
        [userDefaults setObject:[NSNumber numberWithInt:[result[ @"sex" ] intValue]] forKey:@"sex"];
        [userDefaults setObject:[NSString stringWithFormat:@"%@%@", Server_Url, result[ @"headUrl" ]] forKey:@"headUrl"];
        [userDefaults setObject:[NSString stringWithFormat:@"%@", result[ @"pku" ]] forKey:@"pku"];
        [userDefaults setObject:[NSString stringWithFormat:@"%@", result[ @"base" ]] forKey:@"base"];
        [userDefaults setObject:[NSString stringWithFormat:@"%@", result[ @"hometown" ]] forKey:@"hometown"];
        [userDefaults setObject:[NSString stringWithFormat:@"%@", result[ @"qq" ]] forKey:@"qq"];
        [userDefaults setObject:[NSString stringWithFormat:@"%@", result[ @"company" ]] forKey:@"company"];
        [userDefaults setObject:[NSString stringWithFormat:@"%@", result[ @"department" ]] forKey:@"department"];
        [userDefaults setObject:[NSString stringWithFormat:@"%@", result[ @"job" ]] forKey:@"job"];
        [userDefaults setObject:[NSString stringWithFormat:@"%@", result[ @"intro" ]] forKey:@"intro"];
        [userDefaults setObject:[NSNumber numberWithInt:[result[ @"version" ] intValue]] forKey:@"version"];
        [userDefaults setObject:[NSNumber numberWithInt:[result[ @"praisedCount" ] intValue]] forKey:@"praisedCount"];
        [userDefaults setObject:[NSNumber numberWithInt:[result[ @"answerCount" ] intValue]] forKey:@"answerCount"];
        [userDefaults setObject:[NSNumber numberWithInt:[result[ @"questionCount" ] intValue]] forKey:@"questionCount"];
        [userDefaults setObject:result[ @"tags" ] forKey:@"tags"];
        if( result[ @"invitedBy" ] != nil )
        {
            NSDictionary * invitedBy = result[ @"invitedBy" ];
            [userDefaults setObject:[NSString stringWithFormat:@"%@", invitedBy[ @"name" ]] forKey:@"inviteUserName"];
            [userDefaults setObject:[NSString stringWithFormat:@"%@%@", Server_Url, invitedBy[ @"headUrl" ]] forKey:@"inviteUserHeadUrl"];
            [userDefaults setObject:[NSString stringWithFormat:@"%@", invitedBy[ @"id" ]] forKey:@"inviteUserId"];
        }
        else
        {
            [userDefaults setObject:@"" forKey:@"inviteUserName"];
            [userDefaults setObject:@"" forKey:@"inviteUserHeadUrl"];
            [userDefaults setObject:@"" forKey:@"inviteUserId"];
        }
        [userDefaults synchronize];
        
        [self loginSuccess];
    }
    error:^( NSError * error )
    {
        NSLog( @"%@", error );
        [SVProgressHUD showErrorWithStatus:@"登陆失败"];
    }];
}

- ( void ) doLogin
{
    FORCE_CLOSE_KEYBOARD;
    
    NSString * name = fieldPhone.text;
    if( [name isEqualToString:@""] )
    {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    NSString * password = fieldPassword.text;
    if( [password isEqualToString:@""] )
    {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    [request setValue:name forKey:@"username"];
    [request setValue:password forKey:@"password"];
    [[NetWork shareInstance] httpRequestWithGet:@"api/token" params:request success:^(NSDictionary * result)
    {
        NSNumber * code = [result objectForKey:@"result"];
        if( [code intValue] == 1000 )
        {
            [self loadUserInfo:[result objectForKey:@"id"] token:[result objectForKey:@"token"]];
        }
        else if( [code intValue] == 1001 )
        {
            [SVProgressHUD showErrorWithStatus:@"用户不存在"];
        }
        else if( [code intValue] == 1002 )
        {
            [SVProgressHUD showErrorWithStatus:@"密码错误"];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"登陆失败"];
        }
    }
    error:^(NSError * error)
    {
        NSLog( @"%@", error );
        [SVProgressHUD showErrorWithStatus:@"登陆失败"];
    }];
}

@end
