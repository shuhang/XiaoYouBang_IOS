
//
//  QuestionInfoViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/29.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "QuestionInfoViewController.h"
#import "QuestionInfoView.h"
#import "AddAnswerViewController.h"
#import "AddCommentViewController.h"
#import "CommentEntity.h"
#import "NetWork.h"
#import "CommentTableViewController.h"
#import "AnswerInfoViewController.h"
#import "AddQuestionViewController.h"

@interface QuestionInfoViewController ()<QuestionInfoViewDelegate>
{
    QuestionInfoView * infoView;
}
@end

@implementation QuestionInfoViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self setupTitle:[NSString stringWithFormat:@"%@的提问", self.entity.userName]];
    [self hideNextButton];
    
    infoView = [[QuestionInfoView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height + 50)];
    infoView.entity = self.entity;
    infoView.delegate = self;
    [self.view addSubview:infoView];
    
    [infoView updateHeader];
    [infoView updateTable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAnswer:) name:AddNewAnswer object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addQuestionComment:) name:AddNewQuestionComment object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editQuestionSuccess:) name:EditQuestionSuccess object:nil];
}

- ( void ) editQuestionSuccess : ( NSNotification * ) noti
{
    NSDictionary * dic = [noti userInfo];
    self.entity.questionTitle = [dic objectForKey:@"title"];
    self.entity.info = [dic objectForKey:@"info"];
    self.entity.editTime = [dic objectForKey:@"time"];
    [infoView updateHeader];
}

- ( void ) addAnswer : ( NSNotification * ) noti
{
    NSDictionary * dic = [noti userInfo];
    AnswerEntity * entity = [dic objectForKey:@"answer"];
    [self.entity.answerArray insertObject:entity atIndex:0];
    self.entity.answerCount ++;
    self.entity.hasAnswered = YES;
    self.entity.myAnswer = entity;
    [infoView updateHeader];
    [infoView updateTable];
}

- ( void ) addQuestionComment : ( NSNotification * ) noti
{
    NSDictionary * dic = [noti userInfo];
    CommentEntity * entity = [dic objectForKey:@"comment"];
    [self.entity.commentArray insertObject:entity atIndex:0];
    self.entity.questionCommentCount ++;
    self.entity.allCommentCount ++;
    [infoView updateHeader];
}

- ( void ) doBack
{
    self.tabBarController.tabBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AddNewAnswer object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AddNewQuestionComment object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EditQuestionSuccess object:nil];
    [super doBack];
}

#pragma mark QuestionInfoViewDelegate
- ( void ) addOrEditAnswer
{
    if( self.entity.hasAnswered )
    {
        AnswerInfoViewController * controller = [AnswerInfoViewController new];
        controller.entity = self.entity.myAnswer;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        AddAnswerViewController * controller = [AddAnswerViewController new];
        controller.questionTitle = self.entity.questionTitle;
        controller.questionId = self.entity.questionId;
        controller.type = self.entity.type;
        controller.isEdit = NO;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- ( void ) addComment
{
    AddCommentViewController * controller = [AddCommentViewController new];
    controller.isEdit = NO;
    controller.questionId = self.entity.questionId;
    controller.type = 0;
    controller.replyId = @"";
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) editQuestion
{
    AddQuestionViewController * controller = [AddQuestionViewController new];
    controller.questionId = self.entity.questionId;
    controller.questionTitle = self.entity.questionTitle;
    controller.info = self.entity.info;
    controller.isEdit = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) inviteOther
{
    
}

- ( void ) praiseQuestion
{
    if( self.entity.hasPraised )
    {
        [SVProgressHUD showSuccessWithStatus:@"已经点过赞了亲"];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"正在点赞" maskType:SVProgressHUDMaskTypeGradient];
        
        NSMutableDictionary * request = [NSMutableDictionary dictionary];
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
        [request setValue:self.entity.userId forKey:@"praiseUser"];
        
        NSString * url = [NSString stringWithFormat:@"api/question/%@/praise", self.entity.questionId];
        [[NetWork shareInstance] httpRequestWithPostPut:url params:request method:@"POST" success:^(NSDictionary * result)
         {
             int code = [result[ @"result"] intValue];
             if( code == 3000 )
             {
                 [self praiseSuccess];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"点赞失败"];
             }
         }
         error:^(NSError * error)
         {
             NSLog( @"%@", error );
             [SVProgressHUD showErrorWithStatus:@"点赞失败"];
         }];
    }
}

- ( void ) praiseSuccess
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [self.entity.praiseArray addObject:[userDefaults objectForKey:@"name"]];
    self.entity.praiseCount ++;
    self.entity.hasPraised = YES;
    [infoView updateHeader];
    [SVProgressHUD dismiss];
}

- ( void ) clickComment
{
    CommentTableViewController * controller = [CommentTableViewController new];
    controller.questionTitle = self.entity.questionTitle;
    controller.questionId = self.entity.questionId;
    controller.type = 0;
    controller.fatherCommentArray = self.entity.commentArray;
    controller.commentArray = [NSMutableArray arrayWithArray:self.entity.commentArray];
    controller.commentCount = self.entity.questionCommentCount;
    controller.isFromQuestionInfo = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) clickUser
{
    
}

- ( void ) clickAnswerAtIndex:(int)index
{
    AnswerInfoViewController * controller = [AnswerInfoViewController new];
    controller.entity = [self.entity.answerArray objectAtIndex:index];
    controller.isFromQuestionInfo = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
