//
//  Tab1ViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/14.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "Tab1ViewController.h"
#import "AllQuestionView.h"
#import "AllActView.h"
#import "GoodAnswerView.h"
#import "LoginViewController.h"

#define viewHeight 106

@interface Tab1ViewController ()
{
    NSInteger nowIndex;
    UILabel * titleLabel;
    UIView * mainView;
    AllQuestionView * viewAllQuestion;
    AllActView * viewAllAct;
    GoodAnswerView * viewGoodAnswer;
}
@end

@implementation Tab1ViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    [self judgeLoginStatus];

    [self setupTitle:@"广场"];
    [self hideNextButton];
    [self hideBackButton];

    nowIndex = 0;
    viewAllQuestion = nil;
    viewAllAct = nil;
    viewGoodAnswer = nil;
    
    mainView = [[UIView alloc] initWithFrame:CGRectMake( 0, viewHeight, Screen_Width, Screen_Height - viewHeight )];
    [mainView setClipsToBounds:YES];
    [self.view addSubview:mainView];
    
    viewAllQuestion = [[AllQuestionView alloc] initWithFrame:CGRectMake( 0, -64, Screen_Width, Screen_Height - viewHeight + 64 )];
    [mainView addSubview:viewAllQuestion];
    
    NSArray * array = [[NSArray alloc] initWithObjects:@"问题", @"活动", @"优答", nil];
    UISegmentedControl * segmentedControl = [[UISegmentedControl alloc] initWithItems:array];
    segmentedControl.frame = CGRectMake( 20, 70, 280, 30 );
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = Bg_Red;
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
}

- ( void ) judgeLoginStatus
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * token = [userDefaults objectForKey:@"token"];
    if( token == nil || [token isEqualToString:@""] )
    {
        [self.navigationController pushViewController:[LoginViewController new] animated:NO];
    }
}


- ( void ) doRefreshSelfView
{
    if( viewAllQuestion != nil )
    {
        [viewAllQuestion startRefresh];
    }
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
    titleLabel.text = @"广场";
    self.navigationItem.titleView = titleLabel;
}

- ( void ) removeOldView
{
    switch( nowIndex )
    {
        case 0 :
        {
            [viewAllQuestion removeFromSuperview];
            break;
        }
        case 1 :
        {
            [viewAllAct removeFromSuperview];
            break;
        }
        case 2 :
        {
            [viewGoodAnswer removeFromSuperview];
            break;
        }
    }
}

- ( void ) segmentAction : ( UISegmentedControl * ) segment
{
    NSInteger index = segment.selectedSegmentIndex;
    switch( index )
    {
        case 0 :
        {
            if( nowIndex != 0 )
            {
                [self removeOldView];
                nowIndex = index;
                if( viewAllQuestion == nil )
                {
                    viewAllQuestion = [[AllQuestionView alloc] initWithFrame:CGRectMake( 0, -64, Screen_Width, Screen_Height - viewHeight + 64 )];
                }
                [mainView addSubview:viewAllQuestion];
            }
            break;
        }
        case 1 :
        {
            if( nowIndex != 1 )
            {
                [self removeOldView];
                nowIndex = index;
                if( viewAllAct == nil )
                {
                    viewAllAct = [[AllActView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height - viewHeight - 64 )];
                }
                [mainView addSubview:viewAllAct];
            }
            break;
        }
        case 2 :
        {
            if( nowIndex != 2 )
            {
                [self removeOldView];
                nowIndex = index;
                if( viewGoodAnswer == nil )
                {
                    viewGoodAnswer = [[GoodAnswerView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height - viewHeight - 64 )];
                }
                [mainView addSubview:viewGoodAnswer];
            }
            break;
        }
    }
}

@end
