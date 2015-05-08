//
//  CommentTableViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/30.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "CommentTableViewController.h"
#import "CommentTableView.h"
#import "QuestionCommentTableHeaderView.h"
#import "Tool.h"
#import "AddCommentViewController.h"
#import "QuestionInfoViewController.h"

@interface CommentTableViewController ()<CommentTableViewDelegate, UIActionSheetDelegate>
{
    CommentTableView * tableView;
    QuestionCommentTableHeaderView * questionCommentHeaderView;
    UIActionSheet * sheetClickComment;
    UIActionSheet * sheetCare;
    int clickIndex;
}
@end

@implementation CommentTableViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    [self hideNextButton];
    
    tableView = [[CommentTableView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height + 10)];
    tableView.commentArray = self.commentArray;
    tableView.commentCount = self.commentCount;
    tableView.delegate = self;
    tableView.type = self.type;
    [self.view addSubview:tableView];
    
    if( self.type == 0 )
    {
        tableView.questionId = self.questionId;
        [self setupTitle:@"问题的评论"];
        NSString * title = [NSString stringWithFormat:@"问题：%@", self.questionTitle];
        questionCommentHeaderView = [[QuestionCommentTableHeaderView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, [Tool getHeightByString:title width:Screen_Width - 20 height:60 textSize:Text_Size_Small] + 60 ) title:title value:[NSString stringWithFormat:@"问题的评论 %d", self.commentCount]];
        [tableView addSelfHeaderView:questionCommentHeaderView];
        
        UITapGestureRecognizer * gestureHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickQuestionTitle:)];
        [questionCommentHeaderView addGestureRecognizer:gestureHead];
        
        UIView * bottom = [[UIView alloc] initWithFrame:CGRectMake( 0, Screen_Height - 40, Screen_Width, 40 )];
        bottom.backgroundColor = Color_Heavy_Gray;
        [self.view addSubview:bottom];
        
        UIButton * buttonComment = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonComment.backgroundColor = Color_Gray;
        buttonComment.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        buttonComment.frame = CGRectMake( 20, 7, 125, 26 );
        [buttonComment setTitle:@"评论灌水" forState:UIControlStateNormal];
        [buttonComment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buttonComment setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [buttonComment addTarget:self action:@selector(addQuestionComment) forControlEvents:UIControlEventTouchUpInside];
        [bottom addSubview:buttonComment];
        
        UIButton * buttonCare = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonCare.backgroundColor = Color_Gray;
        buttonCare.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        buttonCare.frame = CGRectMake( 175, 7, 125, 26 );
        [buttonCare setTitle:@"关心一下" forState:UIControlStateNormal];
        [buttonCare setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buttonCare setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [buttonCare addTarget:self action:@selector(showCare) forControlEvents:UIControlEventTouchUpInside];
        [bottom addSubview:buttonCare];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addQuestionComment:) name:AddNewQuestionComment object:nil];
        
        if( self.shouldRefresh )
        {
            [tableView startRefresh];
        }
    }
}

- ( void ) clickQuestionTitle : (UITapGestureRecognizer *)tap
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
        NSString * url = [NSString stringWithFormat:@"api/question/%@", self.questionId];
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

- ( void ) doBack
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AddNewQuestionComment object:nil];
    [super doBack];
}

- ( void ) addQuestionComment : ( NSNotification * ) noti
{
    NSDictionary * dic = [noti userInfo];
    CommentEntity * entity = [dic objectForKey:@"comment"];
    [self.commentArray insertObject:entity atIndex:0];
    self.commentCount ++;
    tableView.commentCount ++;
    [questionCommentHeaderView updateHeader:[NSString stringWithFormat:@"问题的评论 %d", self.commentCount]];
    [tableView updateTable];
}

- ( void ) addQuestionComment
{
    AddCommentViewController * controller = [AddCommentViewController new];
    controller.isEdit = NO;
    controller.questionId = self.questionId;
    controller.type = 0;
    controller.replyId = @"";
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) showCare
{
    sheetCare = [[UIActionSheet alloc] initWithTitle:@"关心一下" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"沉思中，稍后作答" otherButtonTitles:@"帮你留意着", @"爱莫能助的飘过", nil];
    [sheetCare showInView:self.view];
}

- ( void ) addQuestionCommentByString : ( NSString * ) info
{
    [SVProgressHUD showWithStatus:@"正在发表" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    [request setValue:0 forKey:@"commentType"];
    [request setValue:info forKey:@"content"];
    
    NSString * url = [NSString stringWithFormat:@"api/question/%@/comment", self.questionId];
    [[NetWork shareInstance] httpRequestWithPostPut:url params:request method:@"POST" success:^(NSDictionary * result)
     {
         int code = [result[ @"result"] intValue];
         if( code == 3000 )
         {
             NSString * commentId = [NSString stringWithFormat:@"%@", result[ @"id" ]];
             NSString * time = [NSString stringWithFormat:@"%@", result[ @"time" ]];
             [self addQuestionCommentSuccess:commentId time:time info:info];
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

- ( void ) addQuestionCommentSuccess : ( NSString * ) commentId time : ( NSString * ) time info : ( NSString * ) info
{
    CommentEntity * entity = [CommentEntity new];
    entity.commentId = commentId;
    entity.time = time;
    entity.questionId = self.questionId;
    entity.info = info;
    entity.type = 0;
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    entity.userHeadUrl = [userDefaults objectForKey:@"headUrl"];
    entity.userName = [userDefaults objectForKey:@"name"];
    entity.userId = [userDefaults objectForKey:@"userId"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AddNewQuestionComment object:nil userInfo:@{ @"comment" : entity }];
    [SVProgressHUD dismiss];
}

#pragma mark CommentTableViewDelegate
- ( void ) clickCommentAtIndex:(int)index
{
    clickIndex = index;
    sheetClickComment = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"回复" otherButtonTitles:@"复制", nil];
    [sheetClickComment showInView:self.view];
}

- ( void ) refreshSuccess
{
    [questionCommentHeaderView updateHeader:[NSString stringWithFormat:@"问题的评论 %d", tableView.commentArray.count]];
}

#pragma mark - UIActionSheetDelegate
- ( void ) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if( actionSheet == sheetClickComment )
    {
        if( buttonIndex == sheetClickComment.destructiveButtonIndex )
        {
            CommentEntity * temp = [self.commentArray objectAtIndex:clickIndex];
            AddCommentViewController * controller = [AddCommentViewController new];
            controller.isEdit = NO;
            controller.questionId = self.questionId;
            controller.type = 0;
            controller.replyId = temp.userId;
            controller.replyName = temp.userName;
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if( buttonIndex == sheetClickComment.firstOtherButtonIndex )
        {
            CommentEntity * temp = [self.commentArray objectAtIndex:clickIndex];
            UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = temp.info;
            [SVProgressHUD showSuccessWithStatus:@"文字已复制"];
        }
    }
    else if( actionSheet == sheetCare )
    {
        if( buttonIndex == sheetCare.destructiveButtonIndex )
        {
            [self addQuestionCommentByString:@"沉思中，稍后作答"];
        }
        else if( buttonIndex == sheetCare.firstOtherButtonIndex )
        {
            [self addQuestionCommentByString:@"帮你留意着"];
        }
        else if( buttonIndex == 2 )
        {
            [self addQuestionCommentByString:@"爱莫能助的飘过"];
        }
    }
}

@end
