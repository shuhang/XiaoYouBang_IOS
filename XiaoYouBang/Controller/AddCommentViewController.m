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
    
    [self setupTitle:@"评论"];
    [self setupNextButtonTitle:@"发表"];
    
    GCPlaceholderTextView * temp = [[GCPlaceholderTextView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:temp];
    
    inputInfo = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake( 0, 74, Screen_Width, Screen_Height - 74 )];
    inputInfo.font = [UIFont systemFontOfSize:Text_Size_Big];
    inputInfo.placeholder = @"请写下你的评论...";
    [self.view addSubview:inputInfo];
    
    if( self.isEdit )
    {
        inputInfo.text = self.info;
    }
    else
    {
        if( ( self.type == 0 || self.type == 1 ) && self.replyId.length != 0 )
        {
            inputInfo.placeholder = [NSString stringWithFormat:@"回复%@的评论...", self.replyName];
        }
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
        info = [NSString stringWithFormat:@"回复 %@：%@", self.replyName, self.info];
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
    if( self.replyId.length != 0 )
    {
        info = [NSString stringWithFormat:@"回复 %@：%@", self.replyName, self.info];
    }
    entity.info = info;
    entity.type = 0;
    entity.replyId = self.replyId;
    if( self.replyId.length != 0 )
    {
        entity.replyName = self.replyName;
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
        info = [NSString stringWithFormat:@"回复 %@：%@", self.replyName, self.info];
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
    if( self.replyId.length != 0 )
    {
        info = [NSString stringWithFormat:@"回复 %@：%@", self.replyName, self.info];
    }
    entity.info = info;
    entity.type = 0;
    entity.replyId = self.replyId;
    if( self.replyId.length != 0 )
    {
        entity.replyName = self.replyName;
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
