//
//  ResetPasswordViewController2.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/11.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "ResetPasswordViewController2.h"
#import "NetWork.h"

@interface ResetPasswordViewController2 ()<UITextFieldDelegate>
{
    UITextField * fieldPassword1;
    UITextField * fieldPassword2;
    UIButton * buttonFinish;
}
@end

@implementation ResetPasswordViewController2

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:Color_Light_Gray];
    
    [self setupTitle:@"重置密码"];
    [self hideNextButton];
    
    fieldPassword1 = [[UITextField alloc] initWithFrame:CGRectMake( 20, 95, Screen_Width - 40, 35 )];
    fieldPassword1.placeholder = @"输入密码";
    fieldPassword1.secureTextEntry = YES;
    fieldPassword1.delegate = self;
    fieldPassword1.backgroundColor = [UIColor whiteColor];
    fieldPassword1.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldPassword1 setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldPassword1 setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldPassword1];
    [self.view addSubview:fieldPassword1];
    
    fieldPassword2 = [[UITextField alloc] initWithFrame:CGRectMake( 20, 135, Screen_Width - 40, 35 )];
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
    buttonFinish.frame = CGRectMake( 20, 190, Screen_Width - 40, 35 );
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
    
    [SVProgressHUD showWithStatus:@"正在提交" maskType:SVProgressHUDMaskTypeGradient];
    NSDictionary * request = @{ @"username" : self.phone, @"code" : @"123456", @"key" : self.key, @"name" : self.name, @"password" : password1 };
    [[NetWork shareInstance] httpRequestWithPostPut:@"signup/resetpwd" params:request method:@"POST" success:^(NSDictionary * response)
     {
         NSNumber * resultCode = [response objectForKey:@"result"];
         if( [resultCode intValue] == 2000 )
         {
             [SVProgressHUD dismiss];
             BaseViewController * controller = [self.navigationController.viewControllers objectAtIndex:1];
             [self.navigationController popToViewController:controller animated:YES];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"手机号姓名不一致"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [SVProgressHUD showErrorWithStatus:@"验证失败"];
     }];
}

- ( BOOL ) textFieldShouldReturn:(UITextField *)textField
{
    [fieldPassword1 resignFirstResponder];
    [fieldPassword2 resignFirstResponder];
    return YES;
}

-(IBAction) textFieldDone:(id) sender
{
    [fieldPassword1 resignFirstResponder];
    [fieldPassword2 resignFirstResponder];
}

- ( void ) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [fieldPassword1 resignFirstResponder];
    [fieldPassword2 resignFirstResponder];
}

@end
