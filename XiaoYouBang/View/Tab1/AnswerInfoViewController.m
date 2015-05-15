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
#import "MyDatabaseHelper.h"
#import "UserInfoViewController.h"
#import "UserEntity.h"
#import "MLTableAlert.h"

@interface AnswerInfoViewController ()<AnswerInfoViewDelegate, UIAlertViewDelegate>
{
    AnswerInfoView * infoView;
    int clickIndex;
    MLTableAlert * alertClickComment;
}
@end

@implementation AnswerInfoViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    
    if( self.entity.type == 0 )
    {
        [self setupTitle:[NSString stringWithFormat:@"%@的回答", self.entity.name]];
    }
    else if( self.entity.type == 1 )
    {
        [self setupTitle:[NSString stringWithFormat:@"%@的总结", self.entity.name]];
    }
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
    controller.type = self.entity.type;
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) clickCommentAtIndex:(int)index
{
    clickIndex = index;
    CommentEntity * temp1 = [self.entity.commentArray objectAtIndex:clickIndex];
    alertClickComment = [MLTableAlert tableAlertWithTitle:temp1.info cancelButtonTitle:@"取消" numberOfRows:^NSInteger(NSInteger section)
                         {
                             return 2;
                         }
                                                 andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                         {
                             static NSString *CellIdentifier = @"CellIdentifier";
                             NSArray * lickComment = @[ @"回复", @"复制" ];
                             UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                             if( cell == nil )
                             {
                                 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                             }
                             cell.textLabel.text = [lickComment objectAtIndex:indexPath.row];
                             cell.textLabel.textAlignment = NSTextAlignmentCenter;
                             
                             return cell;
                         }];
    
    alertClickComment.height = 200;
    
    [alertClickComment configureSelectionBlock:^(NSIndexPath *selectedIndex)
     {
         if( selectedIndex.row == 0 )
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
         else if( selectedIndex.row == 1 )
         {
             CommentEntity * temp = [self.entity.commentArray objectAtIndex:clickIndex];
             UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
             pasteboard.string = temp.info;
             [SVProgressHUD showSuccessWithStatus:@"文字已复制"];
         }
     }
     andCompletionBlock:^{}];
    
    [alertClickComment show];
}

- ( void ) clickUser
{
    if( [Tool judgeIsMe:self.entity.userId] )
    {
        [self showMe];
    }
    else
    {
        MyDatabaseHelper * helper = [MyDatabaseHelper new];
        UserEntity * user = [helper getUserById:self.entity.userId];
        if( user != nil )
        {
            UserInfoViewController * controller = [UserInfoViewController new];
            controller.entity = user;
            controller.shouldRefresh = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
        else
        {
            [self loadUserInfo];
        }
    }
}

- ( void ) loadUserInfo
{
    [SVProgressHUD showWithStatus:@"正在加载个人资料" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    NSString * url = [NSString stringWithFormat:@"api/user/%@", self.entity.userId];
    [[NetWork shareInstance] httpRequestWithGet:url params:request success:^(NSDictionary * result)
     {
         UserEntity * user = [UserEntity new];
         [Tool loadUserInfoEntity:user item:result];
         user.answerMe = [result[ @"answerMeCount" ] intValue];
         user.myAnswer = [result[ @"myAnswerCount" ] intValue];
         
         MyDatabaseHelper * helper = [MyDatabaseHelper new];
         [helper insertOrUpdateUsers:[NSArray arrayWithObjects:user, nil] updateTime:@"" symbol:NO];
         
         [SVProgressHUD dismiss];
         
         UserInfoViewController * controller = [UserInfoViewController new];
         controller.entity = user;
         controller.shouldRefresh = NO;
         [self.navigationController pushViewController:controller animated:YES];
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [SVProgressHUD showErrorWithStatus:@"加载失败"];
     }];
}

- ( void ) showMe
{
    UserInfoViewController * controller = [UserInfoViewController new];
    controller.entity = [Tool getMyEntity];
    [self.navigationController pushViewController:controller animated:YES];
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
    [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
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
@end
