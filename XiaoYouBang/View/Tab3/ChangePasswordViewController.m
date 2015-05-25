//
//  ChangePasswordViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/25.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "NetWork.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>
{
    UITextField * fieldOldPassword;
    UITextField * fieldPassword1;
    UITextField * fieldPassword2;
    UIButton * buttonFinish;
}
@end

@implementation ChangePasswordViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:Color_Light_Gray];
    self.tabBarController.tabBar.hidden = YES;
    
    [self setupTitle:@"修改密码"];
    [self hideNextButton];
    
    fieldOldPassword = [[UITextField alloc] initWithFrame:CGRectMake( 20, 95, Screen_Width - 40, 35 )];
    fieldOldPassword.placeholder = @"输入原密码";
    fieldOldPassword.secureTextEntry = YES;
    fieldOldPassword.delegate = self;
    fieldOldPassword.backgroundColor = [UIColor whiteColor];
    fieldOldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldOldPassword setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldOldPassword setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldOldPassword];
    [self.view addSubview:fieldOldPassword];
    
    fieldPassword1 = [[UITextField alloc] initWithFrame:CGRectMake( 20, 135, Screen_Width - 40, 35 )];
    fieldPassword1.placeholder = @"输入密码";
    fieldPassword1.secureTextEntry = YES;
    fieldPassword1.delegate = self;
    fieldPassword1.backgroundColor = [UIColor whiteColor];
    fieldPassword1.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldPassword1 setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldPassword1 setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldPassword1];
    [self.view addSubview:fieldPassword1];
    
    fieldPassword2 = [[UITextField alloc] initWithFrame:CGRectMake( 20, 175, Screen_Width - 40, 35 )];
    fieldPassword2.placeholder = @"再次输入密码";
    fieldPassword2.secureTextEntry = YES;
    fieldPassword2.delegate = self;
    fieldPassword2.backgroundColor = [UIColor whiteColor];
    fieldPassword2.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldPassword2 setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldPassword2 setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldPassword2];
    [self.view addSubview:fieldPassword2];
    
    buttonFinish = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonFinish.frame = CGRectMake( 20, 230, Screen_Width - 40, 35 );
    [buttonFinish setBackgroundColor:Bg_Red];
    [buttonFinish.titleLabel setFont:[UIFont systemFontOfSize:Text_Size_Small]];
    [buttonFinish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonFinish setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [buttonFinish setTitle:@"提交" forState:UIControlStateNormal];
    [buttonFinish addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonFinish];
}

- ( void ) check
{
    FORCE_CLOSE_KEYBOARD;
    
    NSString * oldPassword = fieldOldPassword.text;
    if( oldPassword.length == 0 )
    {
        [SVProgressHUD showErrorWithStatus:@"请输入原密码"];
        return;
    }
    
    NSString * password1 = fieldPassword1.text;
    if( password1.length < 6 || password1.length > 16 )
    {
        [SVProgressHUD showErrorWithStatus:@"密码6~16位"];
        return;
    }
    
    NSString * password2 = fieldPassword2.text;
    if( ![password1 isEqualToString:password2] )
    {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在修改密码" maskType:SVProgressHUDMaskTypeGradient];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * request = @{
                               @"token" : [userDefaults objectForKey:@"token"],
                               @"oldpwd" : oldPassword,
                               @"newpwd" : password1
                                };
    [[NetWork shareInstance] httpRequestWithPostPut:@"api/user/changepwd" params:request method:@"PUT" success:^(NSDictionary * result)
     {
         int code = [result[ @"result"] intValue];
         if( code == 1000 )
         {
             [self changeSuccess];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"原密码不正确"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [SVProgressHUD showErrorWithStatus:@"修改失败"];
     }];
}

- ( void ) changeSuccess
{
    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

- ( BOOL ) textFieldShouldReturn:(UITextField *)textField
{
    [fieldOldPassword resignFirstResponder];
    [fieldPassword1 resignFirstResponder];
    [fieldPassword2 resignFirstResponder];
    return YES;
}

-(IBAction) textFieldDone:(id) sender
{
    [fieldOldPassword resignFirstResponder];
    [fieldPassword1 resignFirstResponder];
    [fieldPassword2 resignFirstResponder];
}

- ( void ) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [fieldOldPassword resignFirstResponder];
    [fieldPassword1 resignFirstResponder];
    [fieldPassword2 resignFirstResponder];
}

@end
