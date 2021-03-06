//
//  AnswerInfoViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/2.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "AnswerInfoViewController.h"
#import "AnswerInfoView.h"
#import "NetWork.h"
#import "AddCommentViewController.h"
#import "CommentEntity.h"
#import "AddAnswerViewController.h"
#import "Tool.h"
#import "QuestionInfoViewController.h"

@interface AnswerInfoViewController ()<AnswerInfoViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
    AnswerInfoView * infoView;
    UIActionSheet * sheetClickComment;
    int clickIndex;
}
@end

@implementation AnswerInfoViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self setupTitle:[NSString stringWithFormat:@"%@的回答", self.entity.name]];
    [self hideNextButton];
    
    infoView = [[AnswerInfoView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height + 50) entity:self.entity];
    infoView.delegate = self;
    [self.view addSubview:infoView];
    
    [infoView updateHeader];
    [infoView updateTable];
    [infoView startRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAnswerComment:) name:AddNewAnswerComment object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editAnswer:) name:EditAnswerSuccess object:nil];
}

- ( void ) addAnswerComment : ( NSNotification * ) noti
{
    NSDictionary * dic = [noti userInfo];
    CommentEntity * entity = [dic objectForKey:@"comment"];
    [self.entity.commentArray insertObject:entity atIndex:0];
    self.entity.commentCount ++;
    [infoView updateHeader];
    [infoView updateTable];
}

- ( void ) editAnswer : ( NSNotification * ) noti
{
    NSDictionary * dic = [noti userInfo];
    self.entity.info = [dic objectForKey:@"info"];
    self.entity.editTime = [dic objectForKey:@"time"];
    [infoView updateHeader];
}

- ( void ) doBack
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AddNewAnswerComment object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EditAnswerSuccess object:nil];
    [super doBack];
}

#pragma mark AnswerInfoViewDelegate
- ( void ) praiseAnswer
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
        
        NSString * url = [NSString stringWithFormat:@"api/answer/%@/praise", self.entity.answerId];
        [[NetWork shareInstance] httpRequestWithPostPut:url params:request method:@"POST" success:^(NSDictionary * result)
         {
             int code = [result[ @"result"] intValue];
             if( code == 6000 )
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
    [infoView updatePraiseButton];
    [SVProgressHUD dismiss];
}

- ( void ) addComment
{
    AddCommentViewController * controller = [AddCommentViewController new];
    controller.isEdit = NO;
    controller.answerId = self.entity.answerId;
    controller.type = 1;
    controller.replyId = @"";
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) editAnswer
{
    AddAnswerViewController * controller = [AddAnswerViewController new];
    controller.isEdit = YES;
    controller.questionTitle = self.entity.questionTitle;
    controller.answerId = self.entity.answerId;
    controller.info = self.entity.info;
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) clickCommentAtIndex:(int)index
{
    clickIndex = index;
    sheetClickComment = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"回复" otherButtonTitles:@"复制", nil];
    [sheetClickComment showInView:self.view];
}

- ( void ) clickUser
{
    
}

- ( void ) clickQuestion
{
    if( self.isFromQuestionInfo )
    {
        [super doBack];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeGradient];
        
        NSMutableDictionary * request = [NSMutableDictionary dictionary];
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
        NSString * url = [NSString stringWithFormat:@"api/question/%@", self.entity.questionId];
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
}

- ( void ) addSave
{
    if( self.entity.isHasSaved )
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"收藏提示" message:@"确定要取消收藏吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"正在收藏" maskType:SVProgressHUDMaskTypeGradient];
        
        NSMutableDictionary * request = [NSMutableDictionary dictionary];
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
        [request setValue:self.entity.answerId forKey:@"answerId"];

        [[NetWork shareInstance] httpRequestWithPostPut:@"api/user/saveanswers/add" params:request method:@"POST" success:^(NSDictionary * result)
         {
             int code = [result[ @"result"] intValue];
             if( code == 4000 )
             {
                 [self addSaveSucces];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"收藏失败"];
             }
         }
         error:^(NSError * error)
         {
             NSLog( @"%@", error );
             [SVProgressHUD showErrorWithStatus:@"收藏失败"];
         }];
    }
}

- ( void ) cancleSave
{
    [SVProgressHUD showWithStatus:@"正在取消收藏" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    [request setValue:self.entity.answerId forKey:@"answerId"];
    
    [[NetWork shareInstance] httpRequestWithPostPut:@"api/user/saveanswers/delete" params:request method:@"POST" success:^(NSDictionary * result)
     {
         int code = [result[ @"result"] intValue];
         if( code == 4000 )
         {
             [self cancelSaveSuccess];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"取消失败"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [SVProgressHUD showErrorWithStatus:@"取消失败"];
     }];
}

- ( void ) addSaveSucces
{
    self.entity.isHasSaved = YES;
    [infoView updateSaveButton];
    [SVProgressHUD dismiss];
}

- ( void ) cancelSaveSuccess
{
    self.entity.isHasSaved = NO;
    [infoView updateSaveButton];
    [SVProgressHUD dismiss];
}

#pragma mark - UIAlertViewDelegate
- ( void ) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 1 )
    {
        [self cancleSave];
    }
}

#pragma mark - UIActionSheetDelegate
- ( void ) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if( actionSheet == sheetClickComment )
    {
        if( buttonIndex == sheetClickComment.destructiveButtonIndex )
        {
            CommentEntity * temp = [self.entity.commentArray objectAtIndex:clickIndex];
            AddCommentViewController * controller = [AddCommentViewController new];
            controller.isEdit = NO;
            controller.answerId = self.entity.answerId;
            controller.type = 1;
            controller.replyId = temp.userId;
            controller.replyName = temp.userName;
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if( buttonIndex == sheetClickComment.firstOtherButtonIndex )
        {
            CommentEntity * temp = [self.entity.commentArray objectAtIndex:clickIndex];
            UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = temp.info;
            [SVProgressHUD showSuccessWithStatus:@"文字已复制"];
        }
    }
}

@end
