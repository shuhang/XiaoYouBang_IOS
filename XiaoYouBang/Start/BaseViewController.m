//
//  BaseViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/23.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"

@interface BaseViewController ()
@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hasRefreshed = true;
    
    [self setupTitle];
}

- ( void ) doRefreshSelfView
{
    
}

- ( void ) setupTitle
{
    if( OSVersionIsAtLast7 )
    {
        [self.navigationController.navigationBar setBarTintColor:Bg_Red];
    }
    else
    {
        [self.navigationController.navigationBar setTintColor:Bg_Red];
    }
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, 100, 30 )];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:Text_Size_Big];
    self.navigationItem.titleView = titleLabel;
    
    buttonNext = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonNext.frame = CGRectMake( 0, 0, 60, 44 );
    [buttonNext.titleLabel setFont:[UIFont systemFontOfSize:Text_Size_Big]];
    [buttonNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonNext addTarget:self action:@selector(doNext) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:buttonNext];
    
    self.navigationItem.rightBarButtonItem = item;
    
    buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame = CGRectMake( 0, 0, 60, 44 );
    [buttonBack.titleLabel setFont:[UIFont systemFontOfSize:Text_Size_Big]];
    [buttonBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonBack setTitle:@"<       " forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item1 = [[UIBarButtonItem alloc] initWithCustomView:buttonBack];
    
    self.navigationItem.leftBarButtonItem = item1;
}

- ( void ) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if( self.hasRefreshed == NO )
    {
        self.hasRefreshed = YES;
        [self doRefreshSelfView];
    }
}

- ( void ) doBack
{
    FORCE_CLOSE_KEYBOARD;
    [self.navigationController popViewControllerAnimated:YES];
}

- ( void ) doNext
{
    
}

- ( void ) setupTitle : ( NSString * ) text
{
    titleLabel.text = text;
}

- ( void ) setupNextButtonTitle : ( NSString * ) text
{
    [buttonNext setTitle:text forState:UIControlStateNormal];
}

- ( void ) hideBackButton
{
    buttonBack.hidden = YES;
}

- ( void ) hideNextButton
{
    buttonNext.hidden = YES;
}

- ( void ) adjustTextField:(UITextField *)field
{
    CGRect frame = [field frame];
    frame.size.width = 7;
    UIView *leftview1 = [[UIView alloc] initWithFrame:frame];
    field.leftViewMode = UITextFieldViewModeAlways;
    field.leftView = leftview1;
}

@end
