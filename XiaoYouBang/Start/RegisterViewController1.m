//
//  RegisterViewController1.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/22.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "RegisterViewController1.h"
#import "RegisterViewController2.h"
#import "SVProgressHUD.h"
#import "NetWork.h"

@interface RegisterViewController1() <UITextFieldDelegate>
{
    UILabel * textLabel;
    UITextField * fieldPhone;
    UITextField * fieldPassword1;
    UITextField * fieldPassword2;
    UITextField * fieldCode;
}
@end

@implementation RegisterViewController1

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    self.key1 = @"";
    
    [self setupTitle:@"手机注册"];
    [self setupNextButtonTitle:@"下一步"];
    
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
    
    fieldPassword1 = [[UITextField alloc] initWithFrame:CGRectMake( 20, 135, Screen_Width - 40, 35 )];
    fieldPassword1.placeholder = @"密码";
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
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake( 22, 220, Screen_Width - 40, 45 )];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = Color_Gray;
    textLabel.text = @"密码最长16位，由字母、数字和各类英文符号组成，字母区分大小写";
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.numberOfLines = 2;
    textLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    [self.view addSubview:textLabel];
    
    fieldCode = [[UITextField alloc] initWithFrame:CGRectMake( 20, 280, Screen_Width - 40, 35 )];
    fieldCode.placeholder = @"输入邀请码";
    fieldCode.delegate = self;
    fieldCode.backgroundColor = [UIColor whiteColor];
    fieldCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldCode setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldCode setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldCode];
    [self.view addSubview:fieldCode];
}

- ( void ) doNext
{
    FORCE_CLOSE_KEYBOARD;
    
    self.phone = fieldPhone.text;
    if( self.phone.length != 11 )
    {
        [SVProgressHUD showErrorWithStatus:@"手机号不正确"];
        return;
    }
    
    NSString * password1 = fieldPassword1.text;
    if( password1.length < 6 || password1.length > 16 )
    {
        [SVProgressHUD showErrorWithStatus:@"密码6-16位"];
        return;
    }
    
    NSString * password2 = fieldPassword2.text;
    if( ![password1 isEqualToString:password2] )
    {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
        return;
    }
    
    self.password = password1;
    
    self.code = fieldCode.text;
    if( self.code.length == 0 )
    {
        [SVProgressHUD showErrorWithStatus:@"请输入邀请码"];
        return;
    }
    
    [self checkPhone];
}

- ( void ) checkPhone
{
    [SVProgressHUD showWithStatus:@"正在验证" maskType:SVProgressHUDMaskTypeGradient];
    __block RegisterViewController1 * temp = self;
    NSDictionary * request = @{ @"phone" : self.phone };
    [[NetWork shareInstance] httpRequestWithPostPut:@"signup/check" params:request method:@"POST" success:^(NSDictionary * response)
    {
        NSNumber * resultCode = [response objectForKey:@"result"];
        if( [resultCode intValue] == 2000 )
        {
            self.key1 = [NSString stringWithFormat:@"%@", [response objectForKey:@"key"]];
            [temp sendCode];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"手机号已注册"];
        }
    }
    error:^(NSError * error)
    {
        NSLog( @"%@", error );
        [SVProgressHUD showErrorWithStatus:@"验证失败"];
    }];
}

- ( void ) sendCode
{
    NSDictionary * request = @{ @"code" : self.code };
    __block RegisterViewController1 * temp = self;
    [[NetWork shareInstance] httpRequestWithPostPut:@"invite/validate" params:request method:@"POST" success:^(NSDictionary * response)
     {
         NSNumber * resultCode = [response objectForKey:@"result"];
         if( [resultCode intValue] == 9000 )
         {
             [temp sendTestCode];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"验证码不正确"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [SVProgressHUD showErrorWithStatus:@"验证失败"];
     }];
}

- ( void ) sendTestCode
{
    NSDictionary * request = @{ @"phone" : self.phone, @"key" : self.key1 };
    [[NetWork shareInstance] httpRequestWithPostPut:@"signup/verify" params:request method:@"POST" success:^(NSDictionary * response)
     {
         NSNumber * resultCode = [response objectForKey:@"result"];
         if( [resultCode intValue] == 2000 )
         {
             self.key2 = [NSString stringWithFormat:@"%@", [response objectForKey:@"key"]];
             [SVProgressHUD dismiss];
             RegisterViewController2 * controller = [RegisterViewController2 new];
             controller.phone = self.phone;
             controller.password = self.password;
             controller.code = self.code;
             controller.key = self.key2;
             [self.navigationController pushViewController:controller animated:YES];
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
    [fieldPhone resignFirstResponder];
    [fieldPassword1 resignFirstResponder];
    [fieldPassword2 resignFirstResponder];
    return YES;
}

-(IBAction) textFieldDone:(id) sender
{
    [fieldPhone resignFirstResponder];
    [fieldPassword1 resignFirstResponder];
    [fieldPassword2 resignFirstResponder];
}

- ( void ) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [fieldPhone resignFirstResponder];
    [fieldPassword1 resignFirstResponder];
    [fieldPassword2 resignFirstResponder];
}

@end
