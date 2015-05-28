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
#import "AddQuestionViewController.h"
#import "QuestionEntity.h"
#import "QuestionInfoViewController.h"
#import "AnswerInfoViewController.h"
#import "ActInfoViewController.h"
#import "AddActViewController.h"

#define viewHeight 106

@interface Tab1ViewController () <AllQuestionViewDelegate, AllActViewDelegate, GoodAnswerViewDelegate>
{
    NSInteger nowIndex;
    UIView * mainView;
    UIButton * rightButton;
    
    AllQuestionView * viewAllQuestion;
    AllActView * viewAllAct;
    GoodAnswerView * viewGoodAnswer;
    
    UISegmentedControl * segmentedControl;
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
    [self addRightButton];

    nowIndex = 0;
    viewAllQuestion = nil;
    viewAllAct = nil;
    viewGoodAnswer = nil;
    viewAllQuestion.selectedEntity = nil;
    
    mainView = [[UIView alloc] initWithFrame:CGRectMake( 0, viewHeight, Screen_Width, Screen_Height - viewHeight )];
    [mainView setClipsToBounds:YES];
    [self.view addSubview:mainView];
    
    viewAllQuestion = [[AllQuestionView alloc] initWithFrame:CGRectMake( 0, -64, Screen_Width, Screen_Height - viewHeight + 64 )];
    viewAllQuestion.delegate = self;
    [mainView addSubview:viewAllQuestion];
    
    NSArray * array = [[NSArray alloc] initWithObjects:@"问题", @"活动", @"优答", nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:array];
    segmentedControl.frame = CGRectMake( 20, 70, Screen_Width - 40, 30 );
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = Bg_Red;
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addQuestion:) name:AddNewQuestion object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAct:) name:AddNewAct object:nil];
}

- ( void ) addQuestion : ( NSNotification * ) noti
{
    NSDictionary * dic = [noti userInfo];
    QuestionEntity * entity = [dic objectForKey:@"question"];
    [viewAllQuestion.questionArray insertObject:entity atIndex:0];
    [viewAllQuestion reloadTable];
}

- ( void ) addAct : ( NSNotification * ) noti
{
    NSDictionary * dic = [noti userInfo];
    QuestionEntity * entity = [dic objectForKey:@"act"];
    [viewAllAct.actArray insertObject:entity atIndex:0];
    [viewAllAct reloadTable];
}

- ( void ) addRightButton
{
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake( 0, 0, 35, 35 );
    [rightButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(doAdd) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = item;
}

- ( void ) doAdd
{
    if( nowIndex == 0 )
    {
        AddQuestionViewController * controller = [AddQuestionViewController new];
        controller.type = 0;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        AddActViewController * controller = [AddActViewController new];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- ( void ) judgeLoginStatus
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * token = [userDefaults objectForKey:@"token"];
    if( token == nil || [token isEqualToString:@""] )
    {
        [self.navigationController pushViewController:[LoginViewController new] animated:NO];
    }
    else
    {
        self.hasRefreshed = NO;
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

- ( void ) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    if( nowIndex == 0 && viewAllQuestion != nil && viewAllQuestion.selectedEntity != nil )
    {
        [viewAllQuestion updateSelectCell];
        viewAllQuestion.selectedEntity = nil;
    }
    else if( nowIndex == 1 && viewAllAct != nil && viewAllAct.selectedEntity != nil )
    {
        [viewAllAct updateSelectCell];
        viewAllAct.selectedEntity = nil;
    }
    else if( nowIndex == 2 && viewGoodAnswer != nil && viewGoodAnswer.selectedEntity != nil )
    {
        [viewGoodAnswer updateSelectCell];
        viewGoodAnswer.selectedEntity = nil;
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
                rightButton.hidden = NO;
                [self removeOldView];
                nowIndex = index;
                if( viewAllQuestion == nil )
                {
                    viewAllQuestion = [[AllQuestionView alloc] initWithFrame:CGRectMake( 0, -64, Screen_Width, Screen_Height - viewHeight + 64 )];
                    viewAllQuestion.delegate = self;
                }
                [mainView addSubview:viewAllQuestion];
            }
            break;
        }
        case 1 :
        {
            if( nowIndex != 1 )
            {
                rightButton.hidden = NO;
                [self removeOldView];
                nowIndex = index;
                if( viewAllAct == nil )
                {
                    viewAllAct = [[AllActView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height - viewHeight - 50 )];
                    viewAllAct.delegate = self;
                }
                [mainView addSubview:viewAllAct];
            }
            break;
        }
        case 2 :
        {
            if( nowIndex != 2 )
            {
                rightButton.hidden = YES;
                [self removeOldView];
                nowIndex = index;
                if( viewGoodAnswer == nil )
                {
                    viewGoodAnswer = [[GoodAnswerView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height - viewHeight - 50 )];
                    viewGoodAnswer.delegate = self;
                }
                [mainView addSubview:viewGoodAnswer];
            }
            break;
        }
    }
}

#pragma mark AllQuestionViewDelegate
- ( void ) loadQuestionInfoSuccess:(QuestionEntity *)entity
{
    QuestionInfoViewController * controller = [QuestionInfoViewController new];
    controller.entity = entity;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark AllActViewDelegate
- ( void ) loadActInfoSuccess:(QuestionEntity *)entity
{
    ActInfoViewController * controller = [ActInfoViewController new];
    controller.entity = entity;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark GoodAnswerViewDelegate
- ( void ) clickAnswer:(AnswerEntity *)entity
{
    AnswerInfoViewController * controller = [AnswerInfoViewController new];
    controller.entity = entity;
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) loadQuestionSuccess:(QuestionEntity *)entity
{
    QuestionInfoViewController * controller = [QuestionInfoViewController new];
    controller.entity = entity;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
