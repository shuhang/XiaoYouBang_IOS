//
//  AddCommentViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/30.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "AddCommentViewController.h"
#import "GCPlaceholderTextView.h"
#import "NetWork.h"
#import "CommentEntity.h"

@interface AddCommentViewController ()<UIAlertViewDelegate>
{
    GCPlaceholderTextView * inputInfo;
}
@end

@implementation AddCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = Color_With_Rgb( 255, 255, 255, 1 );
    
    GCPlaceholderTextView * temp = [[GCPlaceholderTextView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:temp];
    
    inputInfo = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake( 0, 74, Screen_Width, Screen_Height - 74 )];
    inputInfo.font = [UIFont systemFontOfSize:Text_Size_Big];
    [self.view addSubview:inputInfo];
    
    if( self.isEdit )
    {
        inputInfo.text = self.info;
    }
    
    if( self.type == 0 || self.type == 1 )
    {
        [self setupTitle:@"评论"];
        [self setupNextButtonTitle:@"发表"];
        if( self.replyId.length == 0 )
        {
            inputInfo.placeholder = @"请写下你的评论...";
        }
        else
        {
            inputInfo.placeholder = [NSString stringWithFormat:@"回复%@的评论...", self.replyName];
        }
    }
    else if( self.type == 2 )
    {
        
    }
    else if( self.type == 3 )
    {
        if( self.isEdit )
        {
            [self setupTitle:@"主人寄语"];
            [self setupNextButtonTitle:@"完成"];
            inputInfo.placeholder = @"请在你的留言板上，跟大家说句话吧";
        }
        else
        {
            [self setupTitle:@"留言板"];
            [self setupNextButtonTitle:@"发表"];
            if( self.replyId.length == 0 )
            {
                inputInfo.placeholder = [NSString stringWithFormat:@"请写下给%@的留言...", self.hostName];
            }
            else
            {
                inputInfo.placeholder = [NSString stringWithFormat:@"回复%@的评论...", self.replyName];
            }
        }
    }
    else if( self.type == 4 )
    {
        [self setupTitle:@"编辑自我介绍"];
        [self setupNextButtonTitle:@"完成"];
    }
}

- ( void ) doNext
{
    self.info = inputInfo.text;
    if( self.info.length < 1 || self.info.length > 2000 )
    {
        [SVProgressHUD showErrorWithStatus:@"最多2000字"];
        return;
    }
    
    if( self.type == 0 )
    {
        [self addQuestionComment];
    }
    else if( self.type == 1 )
    {
        [self addAnswerComment];
    }
    else if( self.type == 3 )
    {
        if( self.isEdit )
        {
            [self editLeaveWord];
        }
        else
        {
            [self addUserComment];
        }
    }
    else if( self.type == 4 )
    {
        [self editIntro];
    }
}

- ( void ) editLeaveWord
{
    FORCE_CLOSE_KEYBOARD;
    [SVProgressHUD showWithStatus:@"正在提交" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    [request setValue:self.info forKey:@"leaveWord"];
    
    [[NetWork shareInstance] httpRequestWithPostPut:@"api/user/leaveword" params:request method:@"PUT" success:^(NSDictionary * result)
     {
         int code = [result[ @"result" ] intValue];
         if( code == 1000 )
         {
             [self editLeaveWordSuccess];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"发表失败"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [SVProgressHUD showErrorWithStatus:@"发表失败"];
     }];
}

- ( void ) editLeaveWordSuccess
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EditLeaveWord object:nil userInfo:@{ @"info" : self.info }];
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- ( void ) addUserComment
{
    FORCE_CLOSE_KEYBOARD;
    [SVProgressHUD showWithStatus:@"正在发表" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    
    NSString * info = self.info;
    if( self.replyId.length != 0 )
    {
        [request setValue:self.replyId forKey:@"replyId"];
    }
    [request setValue:info forKey:@"content"];
    
    NSString * url = [NSString stringWithFormat:@"api/user/%@/comment", self.userId];
    [[NetWork shareInstance] httpRequestWithPostPut:url params:request method:@"POST" success:^(NSDictionary * result)
     {
         int code = [result[ @"result" ] intValue];
         if( code == 4000 )
         {
             NSString * commentId = [NSString stringWithFormat:@"%@", result[ @"id" ]];
             NSString * time = [NSString stringWithFormat:@"%@", result[ @"time" ]];
             [self addUserCommentSuccess:commentId time:time];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"发表失败"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [SVProgressHUD showErrorWithStatus:@"发表失败"];
     }];
}

- ( void ) addUserCommentSuccess : ( NSString * ) commentId time : ( NSString * ) time
{
    CommentEntity * entity = [CommentEntity new];
    entity.commentId = commentId;
    entity.time = time;
    NSString * info = self.info;
    entity.info = info;
    entity.type = 0;
    entity.replyId = self.replyId;
    if( self.replyId.length != 0 )
    {
        entity.replyName = self.replyName;
        entity.info = [NSString stringWithFormat:@"回复 %@：%@", entity.replyName, entity.info];
    }
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    entity.userHeadUrl = [userDefaults objectForKey:@"headUrl"];
    entity.userName = [userDefaults objectForKey:@"name"];
    entity.userId = [userDefaults objectForKey:@"userId"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AddUserComment object:nil userInfo:@{ @"comment" : entity }];
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- ( void ) editIntro
{
    FORCE_CLOSE_KEYBOARD;
    [SVProgressHUD showWithStatus:@"正在修改" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    [request setValue:self.info forKey:@"intro"];

    [[NetWork shareInstance] httpRequestWithPostPut:@"api/user" params:request method:@"PUT" success:^(NSDictionary * result)
     {
         int code = [result[ @"result"] intValue];
         if( code == 1000 )
         {
             [self editIntroSuccess];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"修改失败"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [SVProgressHUD showErrorWithStatus:@"修改失败"];
     }];
}

- ( void ) editIntroSuccess
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EditIntroSuccess object:nil userInfo:@{ @"info" : self.info }];
    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
    [super doBack];
}

- ( void ) addAnswerComment
{
    FORCE_CLOSE_KEYBOARD;
    [SVProgressHUD showWithStatus:@"正在发表" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    [request setValue:0 forKey:@"commentType"];
    
    NSString * info = self.info;
    if( self.replyId.length != 0 )
    {
        [request setValue:self.replyId forKey:@"replyId"];
    }
    [request setValue:info forKey:@"content"];
    
    NSString * url = [NSString stringWithFormat:@"api/answer/%@/comment", self.answerId];
    [[NetWork shareInstance] httpRequestWithPostPut:url params:request method:@"POST" success:^(NSDictionary * result)
     {
         int code = [result[ @"result"] intValue];
         if( code == 4000 )
         {
             NSString * commentId = [NSString stringWithFormat:@"%@", result[ @"id" ]];
             NSString * time = [NSString stringWithFormat:@"%@", result[ @"time" ]];
             [self addAnswerCommentSuccess:commentId time:time];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"发表失败"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [SVProgressHUD showErrorWithStatus:@"发表失败"];
     }];
}

- ( void ) addAnswerCommentSuccess : ( NSString * ) commentId time : ( NSString * ) time
{
    CommentEntity * entity = [CommentEntity new];
    entity.commentId = commentId;
    entity.time = time;
    entity.answerId = self.answerId;
    NSString * info = self.info;
    entity.info = info;
    entity.type = 0;
    entity.replyId = self.replyId;
    if( self.replyId.length != 0 )
    {
        entity.replyName = self.replyName;
        entity.info = [NSString stringWithFormat:@"回复 %@：%@", entity.replyName, entity.info];
    }
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    entity.userHeadUrl = [userDefaults objectForKey:@"headUrl"];
    entity.userName = [userDefaults objectForKey:@"name"];
    entity.userId = [userDefaults objectForKey:@"userId"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AddNewAnswerComment object:nil userInfo:@{ @"comment" : entity }];
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- ( void ) addQuestionComment
{
    FORCE_CLOSE_KEYBOARD;
    [SVProgressHUD showWithStatus:@"正在发表" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    [request setValue:0 forKey:@"commentType"];
    
    NSString * info = self.info;
    if( self.replyId.length != 0 )
    {
        [request setValue:self.replyId forKey:@"replyId"];
    }
    [request setValue:info forKey:@"content"];
    
    NSString * url = [NSString stringWithFormat:@"api/question/%@/comment", self.questionId];
    [[NetWork shareInstance] httpRequestWithPostPut:url params:request method:@"POST" success:^(NSDictionary * result)
     {
         int code = [result[ @"result"] intValue];
         if( code == 3000 )
         {
             NSString * commentId = [NSString stringWithFormat:@"%@", result[ @"id" ]];
             NSString * time = [NSString stringWithFormat:@"%@", result[ @"time" ]];
             [self addQuestionCommentSuccess:commentId time:time];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"发表失败"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [SVProgressHUD showErrorWithStatus:@"发表失败"];
     }];
}

- ( void ) addQuestionCommentSuccess : ( NSString * ) commentId time : ( NSString * ) time
{
    CommentEntity * entity = [CommentEntity new];
    entity.commentId = commentId;
    entity.time = time;
    entity.questionId = self.questionId;
    NSString * info = self.info;
    entity.info = info;
    entity.type = 0;
    entity.replyId = self.replyId;
    if( self.replyId.length != 0 )
    {
        entity.replyName = self.replyName;
        entity.info = [NSString stringWithFormat:@"回复 %@：%@", entity.replyName, entity.info];
    }
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    entity.userHeadUrl = [userDefaults objectForKey:@"headUrl"];
    entity.userName = [userDefaults objectForKey:@"name"];
    entity.userId = [userDefaults objectForKey:@"userId"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AddNewQuestionComment object:nil userInfo:@{ @"comment" : entity }];
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- ( void ) doBack
{
    FORCE_CLOSE_KEYBOARD;
    if( inputInfo.text.length == 0 )
    {
        [super doBack];
    }
    else
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出编辑吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

#pragma mark - UIAlertViewDelegate
- ( void ) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 1 )
    {
        [super doBack];
    }
}

@end
