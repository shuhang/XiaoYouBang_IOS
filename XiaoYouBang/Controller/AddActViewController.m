//
//  AddActViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/14.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "AddActViewController.h"
#import "GCPlaceholderTextView.h"
#import "NetWork.h"
#import "QuestionEntity.h"

@interface AddActViewController ()
{
    GCPlaceholderTextView * inputTitle;
    GCPlaceholderTextView * inputInfo;
    UITextField * fieldTime;
    UITextField * fieldPlace;
    UITextField * fieldMoney;
}
@end

@implementation AddActViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTitle:@"发起活动"];
    [self setupNextButtonTitle:@"发布"];
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = Color_With_Rgb( 255, 255, 255, 1 );
    
    GCPlaceholderTextView * temp = [[GCPlaceholderTextView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:temp];
    
    inputTitle = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake( 0, 74, Screen_Width, 60 )];
    inputTitle.font = [UIFont systemFontOfSize:Text_Size_Big];
    inputTitle.placeholder = @"请输入活动的标题，限30字...";
    [self.view addSubview:inputTitle];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake( 0, 144, 20, 1 )];
    view.backgroundColor = Color_Gray;
    [self.view addSubview:view];
    
//    fieldTime = [[UITextField alloc] initWithFrame:CGRectMake( 20, 95, Screen_Width - 40, 35 )];
//    fieldPhone.placeholder = @"手机号";
//    fieldPhone.delegate = self;
//    fieldPhone.backgroundColor = [UIColor whiteColor];
//    fieldPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
//    [fieldPhone setBorderStyle:UITextBorderStyleRoundedRect];
//    [fieldPhone setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
//    [self adjustTextField:fieldPhone];
//    [self.view addSubview:fieldPhone];
}

@end
