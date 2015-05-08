//
//  Tab1ViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/14.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "Tab2ViewController.h"
#import "MyAnswerView.h"
#import "MyMessageView.h"
#import "MyQuestionView.h"
#import "MySaveView.h"
#import "AnswerInfoViewController.h"
#import "QuestionInfoViewController.h"
#import "CommentTableViewController.h"
#import "NetWork.h"
#import "Tool.h"

#define viewHeight 106

@interface Tab2ViewController ()<MyAnswerViewDelegate, MySaveViewDelegate, MyMessageViewDelegate>
{
    NSInteger nowIndex;
    UIView * mainView;
    
    MyQuestionView * questionView;
    MyAnswerView * answerView;
    MyMessageView * messageView;
    MySaveView * saveView;
}
@end

@implementation Tab2ViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTitle:@"相关"];
    [self hideNextButton];
    [self hideBackButton];
    
    nowIndex = 0;
    questionView = nil;
    answerView = nil;
    messageView = nil;
    saveView = nil;
    
    mainView = [[UIView alloc] initWithFrame:CGRectMake( 0, viewHeight, Screen_Width, Screen_Height - viewHeight )];
    [mainView setClipsToBounds:YES];
    [self.view addSubview:mainView];
    
    questionView = [[MyQuestionView alloc] initWithFrame:CGRectMake( 0, -64, Screen_Width, Screen_Height - viewHeight + 64 )];
    [mainView addSubview:questionView];
    
    NSArray * array = [[NSArray alloc] initWithObjects:@"问过", @"答过", @"消息", @"收藏", nil];
    UISegmentedControl * segmentedControl = [[UISegmentedControl alloc] initWithItems:array];
    segmentedControl.frame = CGRectMake( 20, 70, Screen_Width - 40, 30 );
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = Bg_Red;
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
}

- ( void ) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- ( void ) removeOldView
{
    switch( nowIndex )
    {
        case 0 :
        {
            [questionView removeFromSuperview];
            break;
        }
        case 1 :
        {
            [answerView removeFromSuperview];
            break;
        }
        case 2 :
        {
            [messageView removeFromSuperview];
            break;
        }
        case 3 :
        {
            [saveView removeFromSuperview];
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
                if( questionView == nil )
                {
                    questionView = [[MyQuestionView alloc] initWithFrame:CGRectMake( 0, -64, Screen_Width, Screen_Height - viewHeight + 64 )];
                }
                [mainView addSubview:questionView];
            }
            break;
        }
        case 1 :
        {
            if( nowIndex != 1 )
            {
                [self removeOldView];
                nowIndex = index;
                if( answerView == nil )
                {
                    answerView = [[MyAnswerView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height - viewHeight - 50 )];
                    answerView.delegate = self;
                }
                [mainView addSubview:answerView];
            }
            break;
        }
        case 2 :
        {
            if( nowIndex != 2 )
            {
                [self removeOldView];
                nowIndex = index;
                if( messageView == nil )
                {
                    messageView = [[MyMessageView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height - viewHeight - 50 )];
                    messageView.delegate = self;
                }
                [mainView addSubview:messageView];
            }
            break;
        }
        case 3 :
        {
            if( nowIndex != 3 )
            {
                [self removeOldView];
                nowIndex = index;
                if( saveView == nil )
                {
                    saveView = [[MySaveView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height - viewHeight - 50 )];
                    saveView.delegate = self;
                }
                [mainView addSubview:saveView];
            }
            break;
        }
    }
}

- ( void ) loadAnswerInfo : ( NSString * ) answerId
{
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    NSString * url = [NSString stringWithFormat:@"api/answer/%@", answerId];
    [[NetWork shareInstance] httpRequestWithGet:url params:request success:^(NSDictionary * result)
     {
         if( [result[ @"result" ] intValue] == 4000 )
         {
             AnswerEntity * answer = [AnswerEntity new];
             [Tool loadAnswerInfoEntity:answer item:result];
             AnswerInfoViewController * controller = [AnswerInfoViewController new];
             controller.entity = answer;
             [SVProgressHUD dismiss];
             [self.navigationController pushViewController:controller animated:YES];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"加载失败"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [SVProgressHUD showErrorWithStatus:@"加载失败"];
     }];
}

- ( void ) loadQuestionInfo : ( NSString * ) questionId
{
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    NSString * url = [NSString stringWithFormat:@"api/question/%@", questionId];
    [[NetWork shareInstance] httpRequestWithGet:url params:request success:^(NSDictionary * result)
     {
         if( [result[ @"result" ] intValue] == 3000 )
         {
             QuestionEntity * question = [QuestionEntity new];
             [Tool loadQuestionInfoEntity:question item:result];
             QuestionInfoViewController * controller = [QuestionInfoViewController new];
             controller.entity = question;
             [SVProgressHUD dismiss];
             [self.navigationController pushViewController:controller animated:YES];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"加载失败"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [SVProgressHUD showErrorWithStatus:@"加载失败"];
     }];
}

#pragma mark MyAnswerViewDelegate
- ( void ) clickAnswer_mine:(AnswerEntity *)entity
{
    AnswerInfoViewController * controller = [AnswerInfoViewController new];
    controller.entity = entity;
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) loadQuestionSuccess_mine:(QuestionEntity *)entity
{
    QuestionInfoViewController * controller = [QuestionInfoViewController new];
    controller.entity = entity;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark MySaveViewDelegate
- ( void ) clickAnswer_save:(AnswerEntity *)entity
{
    AnswerInfoViewController * controller = [AnswerInfoViewController new];
    controller.entity = entity;
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) loadQuestionSuccess_save:(QuestionEntity *)entity
{
    QuestionInfoViewController * controller = [QuestionInfoViewController new];
    controller.entity = entity;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark MyMessageViewDelegate
- ( void ) clickMessage:(MessageEntity *)entity
{
    switch( entity.type )
    {
        case 0 :
        {
            CommentTableViewController * controller = [CommentTableViewController new];
            controller.type = 0;
            controller.questionId = entity.questionId;
            controller.questionTitle = entity.question;
            controller.shouldRefresh = YES;
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 1 :
        {
            [self loadAnswerInfo:entity.answerId];
            break;
        }
        case 2 :
        {
            [self loadQuestionInfo:entity.questionId];
            break;
        }
        case 3 :
        {
            break;
        }
        case 4 :
        {
            break;
        }
        case 5 :
        {
            break;
        }
        case 6 :
        {
            break;
        }
    }
}

@end
