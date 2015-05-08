//
//  RegisterViewController4.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/22.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "RegisterViewController4.h"
#import "RegisterViewController5.h"

@interface RegisterViewController4 ()<UITextFieldDelegate>
{
    UILabel * textLabel;
    UITextField * fieldTag1;
    UITextField * fieldTag2;
    UITextField * fieldTag3;
    UITextField * fieldTag4;
    UITextField * fieldTag5;
}
@end

@implementation RegisterViewController4

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    self.tags = [NSArray array];
    
    [self setupTitle:@"标签"];
    [self setupNextButtonTitle:@"下一步"];
    self.view.backgroundColor = Color_Light_Gray;
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake( 22, 84, Screen_Width - 40, 80 )];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = Color_Gray;
    textLabel.text = @"请填写以下的标签，以便大家了解你（皆为选填）可以是特长、兴趣爱好、资源、关注点或其它任何你觉得值得分享的东西";
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.numberOfLines = 4;
    textLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    [self.view addSubview:textLabel];
    
    fieldTag1 = [[UITextField alloc] initWithFrame:CGRectMake( 20, textLabel.frame.origin.y + 90, Screen_Width - 40, 35 )];
    fieldTag1.placeholder = @"标签1";
    fieldTag1.delegate = self;
    fieldTag1.backgroundColor = [UIColor whiteColor];
    fieldTag1.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldTag1 setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldTag1];
    [fieldTag1 setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:fieldTag1];
    
    fieldTag2 = [[UITextField alloc] initWithFrame:CGRectMake( 20, fieldTag1.frame.origin.y + 40, Screen_Width - 40, 35 )];
    fieldTag2.placeholder = @"标签2";
    fieldTag2.delegate = self;
    fieldTag2.backgroundColor = [UIColor whiteColor];
    fieldTag2.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldTag2 setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldTag2];
    [fieldTag2 setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:fieldTag2];
    
    fieldTag3 = [[UITextField alloc] initWithFrame:CGRectMake( 20, fieldTag2.frame.origin.y + 40, Screen_Width - 40, 35 )];
    fieldTag3.placeholder = @"标签3";
    fieldTag3.delegate = self;
    fieldTag3.backgroundColor = [UIColor whiteColor];
    fieldTag1.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldTag3 setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldTag3];
    [fieldTag3 setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:fieldTag3];
    
    fieldTag4 = [[UITextField alloc] initWithFrame:CGRectMake( 20, fieldTag3.frame.origin.y + 40, Screen_Width - 40, 35 )];
    fieldTag4.placeholder = @"标签4";
    fieldTag4.delegate = self;
    fieldTag4.backgroundColor = [UIColor whiteColor];
    fieldTag4.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldTag4 setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldTag4];
    [fieldTag4 setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:fieldTag4];
    
    fieldTag5 = [[UITextField alloc] initWithFrame:CGRectMake( 20, fieldTag4.frame.origin.y + 40, Screen_Width - 40, 35 )];
    fieldTag5.placeholder = @"标签5";
    fieldTag5.delegate = self;
    fieldTag5.backgroundColor = [UIColor whiteColor];
    fieldTag5.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldTag5 setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldTag5];
    [fieldTag5 setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:fieldTag5];
}

- ( void ) doNext
{
    FORCE_CLOSE_KEYBOARD;
    
    NSString * tag1 = fieldTag1.text;
    NSString * tag2 = fieldTag2.text;
    NSString * tag3 = fieldTag3.text;
    NSString * tag4 = fieldTag4.text;
    NSString * tag5 = fieldTag5.text;
    if( tag1.length > 6 || tag2.length > 6 || tag3.length > 6 || tag4.length > 6 || tag5.length > 6 )
    {
        [SVProgressHUD showErrorWithStatus:@"标签6个字以内"];
        return;
    }
    
    self.tags = [NSArray arrayWithObjects:tag1, tag2, tag3, tag4, tag5, nil];
    
    RegisterViewController5 * controller = [RegisterViewController5 new];
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
    controller.tags = self.tags;
    [self.navigationController pushViewController:controller animated:YES];
}

- ( BOOL ) textFieldShouldReturn:(UITextField *)textField
{
    [fieldTag1 resignFirstResponder];
    [fieldTag2 resignFirstResponder];
    [fieldTag3 resignFirstResponder];
    [fieldTag4 resignFirstResponder];
    [fieldTag5 resignFirstResponder];
    return YES;
}

-(IBAction) textFieldDone:(id) sender
{
    [fieldTag1 resignFirstResponder];
    [fieldTag2 resignFirstResponder];
    [fieldTag3 resignFirstResponder];
    [fieldTag4 resignFirstResponder];
    [fieldTag5 resignFirstResponder];
}

- ( void ) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [fieldTag1 resignFirstResponder];
    [fieldTag2 resignFirstResponder];
    [fieldTag3 resignFirstResponder];
    [fieldTag4 resignFirstResponder];
    [fieldTag5 resignFirstResponder];
}

@end
