//
//  ResetPasswordViewController1.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/11.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "ResetPasswordViewController1.h"
#import "NetWork.h"
#import "ResetPasswordViewController2.h"

@interface ResetPasswordViewController1 () <UITextFieldDelegate>
{
    UITextField * fieldPhone;
    UITextField * fieldName;
    UIButton * buttonFinish;
}
@end

@implementation ResetPasswordViewController1

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:Color_Light_Gray];
    
    [self setupTitle:@"重置密码"];
    [self hideNextButton];
    
    fieldName = [[UITextField alloc] initWithFrame:CGRectMake( 20, 95, Screen_Width - 40, 35 )];
    fieldName.placeholder = @"姓名";
    fieldName.delegate = self;
    fieldName.backgroundColor = [UIColor whiteColor];
    fieldName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldName setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldName setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldName];
    [self.view addSubview:fieldName];
    
    fieldPhone = [[UITextField alloc] initWithFrame:CGRectMake( 20, 135, Screen_Width - 40, 35 )];
    fieldPhone.placeholder = @"手机号";
    fieldPhone.delegate = self;
    fieldPhone.keyboardType = UIKeyboardTypeNumberPad;
    fieldPhone.backgroundColor = [UIColor whiteColor];
    fieldPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldPhone setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldPhone setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldPhone];
    [self.view addSubview:fieldPhone];
    
    buttonFinish = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonFinish.frame = CGRectMake( 20, 190, Screen_Width - 40, 35 );
    [buttonFinish setBackgroundColor:Bg_Red];
    [buttonFinish.titleLabel setFont:[UIFont systemFontOfSize:Text_Size_Small]];
    [buttonFinish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonFinish setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [buttonFinish setTitle:@"提交" forState:UIControlStateNormal];
    [buttonFinish addTarget:self action:@selector(check1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonFinish];
}

- ( void ) check1
{
    FORCE_CLOSE_KEYBOARD;
    
    self.name = fieldName.text;
    if( [self.name isEqualToString:@""] )
    {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return;
    }
    self.phone = fieldPhone.text;
    if( [self.phone isEqualToString:@""] )
    {
        [SVProgressHUD showErrorWithStatus:@"请输入手机"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在验证" maskType:SVProgressHUDMaskTypeGradient];
    NSDictionary * request = @{ @"phone" : self.phone, @"type" : @"resetpwd" };
    [[NetWork shareInstance] httpRequestWithPostPut:@"signup/check" params:request method:@"POST" success:^(NSDictionary * response)
     {
         NSNumber * resultCode = [response objectForKey:@"result"];
         if( [resultCode intValue] == 2000 )
         {
             self.key1 = [NSString stringWithFormat:@"%@", [response objectForKey:@"key"]];
             [self check2];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"手机号不正确"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [SVProgressHUD showErrorWithStatus:@"验证失败"];
     }];
}

- ( void ) check2
{
    NSDictionary * request = @{ @"phone" : self.phone, @"key" : self.key1 };
    [[NetWork shareInstance] httpRequestWithPostPut:@"signup/verify" params:request method:@"POST" success:^(NSDictionary * response)
     {
         NSNumber * resultCode = [response objectForKey:@"result"];
         if( [resultCode intValue] == 2000 )
         {
             self.key2 = [NSString stringWithFormat:@"%@", [response objectForKey:@"key"]];
             ResetPasswordViewController2 * controller = [ResetPasswordViewController2 new];
             controller.key = self.key2;
             controller.name = self.name;
             controller.phone = self.phone;
             [SVProgressHUD dismiss];
             [self.navigationController pushViewController:controller animated:YES];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"验证失败"];
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
    [fieldName resignFirstResponder];
    return YES;
}

-(IBAction) textFieldDone:(id) sender
{
    [fieldPhone resignFirstResponder];
    [fieldName resignFirstResponder];
}

- ( void ) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [fieldPhone resignFirstResponder];
    [fieldName resignFirstResponder];
}

@end
