//
//  RegisterViewController3.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/22.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "RegisterViewController3.h"
#import "RegisterViewController4.h"

@interface RegisterViewController3 ()<UITextFieldDelegate>
{
    UITextField * fieldCompany;
    UITextField * fieldPart;
    UITextField * fieldJob;
}
@end

@implementation RegisterViewController3

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTitle:@"工作信息"];
    [self setupNextButtonTitle:@"下一步"];
    self.view.backgroundColor = Color_Light_Gray;
    
    fieldCompany = [[UITextField alloc] initWithFrame:CGRectMake( 20, 94, Screen_Width - 40, 35 )];
    fieldCompany.placeholder = @"现工作单位，学生请填在读";
    fieldCompany.delegate = self;
    fieldCompany.backgroundColor = [UIColor whiteColor];
    fieldCompany.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldCompany setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldCompany];
    [fieldCompany setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:fieldCompany];
    
    fieldPart = [[UITextField alloc] initWithFrame:CGRectMake( 20, fieldCompany.frame.origin.y + 40, Screen_Width - 40, 35 )];
    fieldPart.placeholder = @"所在部门";
    fieldPart.delegate = self;
    fieldPart.backgroundColor = [UIColor whiteColor];
    fieldPart.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldPart setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldPart];
    [fieldPart setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:fieldPart];
    
    fieldJob = [[UITextField alloc] initWithFrame:CGRectMake( 20, fieldPart.frame.origin.y + 40, Screen_Width - 40, 35 )];
    fieldJob.placeholder = @"职位";
    fieldJob.delegate = self;
    fieldJob.backgroundColor = [UIColor whiteColor];
    fieldJob.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldJob setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldJob];
    [fieldJob setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:fieldJob];
}

- ( void ) doNext
{
    FORCE_CLOSE_KEYBOARD;
    
    self.company = fieldCompany.text;
    if( self.company.length < 1 || self.company.length > 20 )
    {
        [SVProgressHUD showErrorWithStatus:@"工作单位20个字以内"];
        return;
    }
    
    self.part = fieldPart.text;
    if( self.part.length > 10 )
    {
        [SVProgressHUD showErrorWithStatus:@"所在部门10个字以内"];
        return;
    }
    
    self.job = fieldJob.text;
    if( self.job.length < 1 || self.job.length > 20 )
    {
        [SVProgressHUD showErrorWithStatus:@"职位10个字以内"];
        return;
    }
    
    RegisterViewController4 * controller = [RegisterViewController4 new];
    controller.phone = self.phone;
    controller.password = self.password;
    controller.code = self.code;
    controller.key = self.key;
    controller.name = self.name;
    controller.birthYear = self.birthYear;
    controller.pku = self.pku;
    controller.nowHome = self.nowHome;
    controller.oldHome = self.oldHome;
    controller.net = self.net;
    controller.sex = self.sex;
    controller.headImageData = self.headImageData;
    controller.company = self.company;
    controller.part = self.part;
    controller.job = self.job;
    [self.navigationController pushViewController:controller animated:YES];
}

- ( BOOL ) textFieldShouldReturn:(UITextField *)textField
{
    [fieldCompany resignFirstResponder];
    [fieldPart resignFirstResponder];
    [fieldJob resignFirstResponder];
    return YES;
}

-(IBAction) textFieldDone:(id) sender
{
    [fieldCompany resignFirstResponder];
    [fieldPart resignFirstResponder];
    [fieldJob resignFirstResponder];
}

- ( void ) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [fieldCompany resignFirstResponder];
    [fieldPart resignFirstResponder];
    [fieldJob resignFirstResponder];
}

@end
