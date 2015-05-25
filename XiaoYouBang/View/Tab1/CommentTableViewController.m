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
#import "InviteViewController.h"
#import "MLTableAlert.h"

@interface CommentTableViewController ()<CommentTableViewDelegate>
{
    CommentTableView * tableView;
    QuestionCommentTableHeaderView * questionCommentHeaderView;
    MLTableAlert * alertClickComment;
    MLTableAlert * alertClickCare;
    int clickIndex;
}
@end

@implementation CommentTableViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
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
        buttonComment.frame = CGRectMake( 20, 7, ( Screen_Width - 70 ) / 2, 26 );
        [buttonComment setTitle:@"评论灌水" forState:UIControlStateNormal];
        [buttonComment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buttonComment setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [buttonComment addTarget:self action:@selector(addQuestionComment) forControlEvents:UIControlEventTouchUpInside];
        [bottom addSubview:buttonComment];
        
        UIButton * buttonCare = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonCare.backgroundColor = Color_Gray;
        buttonCare.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        buttonCare.frame = CGRectMake( 50 + ( Screen_Width - 70 ) / 2, 7, ( Screen_Width - 70 ) / 2, 26 );
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
    else if( self.type == 1 )
    {
        tableView.questionId = self.questionId;
        [self setupTitle:@"活动灌水"];
        NSString * title = [NSString stringWithFormat:@"活动：%@", self.questionTitle];
        questionCommentHeaderView = [[QuestionCommentTableHeaderView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, [Tool getHeightByString:title width:Screen_Width - 20 height:60 textSize:Text_Size_Small] + 60 ) title:title value:[NSString stringWithFormat:@"活动灌水 %d", self.commentCount]];
        [tableView addSelfHeaderView:questionCommentHeaderView];
        
        UITapGestureRecognizer * gestureHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickQuestionTitle:)];
        [questionCommentHeaderView addGestureRecognizer:gestureHead];
        
        UIView * bottom = [[UIView alloc] initWithFrame:CGRectMake( 0, Screen_Height - 40, Screen_Width, 40 )];
        bottom.backgroundColor = Color_Heavy_Gray;
        [self.view addSubview:bottom];
        
        UIButton * buttonComment = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonComment.backgroundColor = Color_Gray;
        buttonComment.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        buttonComment.frame = CGRectMake( 20, 7, ( Screen_Width - 70 ) / 2, 26 );
        [buttonComment setTitle:@"评论灌水" forState:UIControlStateNormal];
        [buttonComment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buttonComment setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [buttonComment addTarget:self action:@selector(addActComment) forControlEvents:UIControlEventTouchUpInside];
        [bottom addSubview:buttonComment];
        
        UIButton * buttonCare = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonCare.backgroundColor = Color_Gray;
        buttonCare.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        buttonCare.frame = CGRectMake( 50 + ( Screen_Width - 70 ) / 2, 7, ( Screen_Width - 70 ) / 2, 26 );
        [buttonCare setTitle:@"邀请报名" forState:UIControlStateNormal];
        [buttonCare setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buttonCare setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [buttonCare addTarget:self action:@selector(inviteJoin) forControlEvents:UIControlEventTouchUpInside];
        [bottom addSubview:buttonCare];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addQuestionComment:) name:AddNewActComment object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inviteUser:) name:ActInviteSuccess object:nil];

        if( self.shouldRefresh )
        {
            [tableView startRefresh];
        }
    }
    else if( self.type == 2 )
    {
        tableView.questionId = self.questionId;
        [self setupTitle:@"活动报名"];
        NSString * title = [NSString stringWithFormat:@"活动：%@", self.questionTitle];
        questionCommentHeaderView = [[QuestionCommentTableHeaderView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, [Tool getHeightByString:title width:Screen_Width - 20 height:60 textSize:Text_Size_Small] + 60 ) title:title value:[NSString stringWithFormat:@"活动报名 %d", self.commentCount]];
        [tableView addSelfHeaderView:questionCommentHeaderView];
        
        UITapGestureRecognizer * gestureHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickQuestionTitle:)];
        [questionCommentHeaderView addGestureRecognizer:gestureHead];
        
        UIView * bottom = [[UIView alloc] initWithFrame:CGRectMake( 0, Screen_Height - 40, Screen_Width, 40 )];
        bottom.backgroundColor = Color_Heavy_Gray;
        [self.view addSubview:bottom];
        
        UIButton * buttonComment = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonComment.backgroundColor = Color_Gray;
        buttonComment.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        buttonComment.frame = CGRectMake( ( Screen_Width - 100 ) / 2, 7, 100, 26 );
        [buttonComment setTitle:@"修改报名" forState:UIControlStateNormal];
        [buttonComment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buttonComment setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [buttonComment addTarget:self action:@selector(editJoin) forControlEvents:UIControlEventTouchUpInside];
        [bottom addSubview:buttonComment];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editActJoin:) name:EditActJoin object:nil];

        if( self.shouldRefresh )
        {
            [tableView startRefresh];
        }
    }
}

- ( void ) editActJoin : ( NSNotification * ) noti
{
    NSDictionary * dic = [noti userInfo];
    for( CommentEntity * comment in self.commentArray )
    {
        if( [Tool judgeIsMe:comment.userId] )
        {
            comment.info = [dic objectForKey:@"info"];
            break;
        }
    }
    [tableView updateTable];
}

- ( void ) editJoin
{
    AddCommentViewController * controller = [AddCommentViewController new];
    controller.isEdit = YES;
    for( CommentEntity * comment in self.commentArray )
    {
        if( [Tool judgeIsMe:comment.userId] )
        {
            controller.info = comment.info;
            controller.commentId = comment.commentId;
            break;
        }
    }
    controller.questionId = self.questionId;
    controller.type = 2;
    controller.replyId = @"";
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) inviteUser : ( NSNotification * ) noti
{
    NSDictionary * dic = [noti userInfo];
    
    CommentEntity * entity = [CommentEntity new];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    entity.userHeadUrl = [userDefaults objectForKey:@"headUrl"];
    entity.userName = [userDefaults objectForKey:@"name"];
    entity.userId = [userDefaults objectForKey:@"userId"];
    entity.time = dic[ @"time" ];
    entity.info = [NSString stringWithFormat:@"邀请 %@ 参加：%@", dic[ @"userName" ], dic[ @"value" ]];
    [self.commentArray insertObject:entity atIndex:0];
    self.commentCount ++;
    tableView.commentCount ++;
    
    [questionCommentHeaderView updateHeader:[NSString stringWithFormat:@"活动灌水 %d", self.commentCount]];
    [tableView updateTable];
}

- ( void ) addActComment : ( NSNotification * ) noti
{
    NSDictionary * dic = [noti userInfo];
    CommentEntity * entity = [dic objectForKey:@"comment"];
    [self.commentArray insertObject:entity atIndex:0];
    self.commentCount ++;
    tableView.commentCount ++;
    [questionCommentHeaderView updateHeader:[NSString stringWithFormat:@"活动灌水 %d", self.commentCount]];
    [tableView updateTable];
}

- ( void ) addActComment
{
    AddCommentViewController * controller = [AddCommentViewController new];
    controller.isEdit = NO;
    controller.questionId = self.questionId;
    controller.type = 5;
    controller.replyId = @"";
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) inviteJoin
{
    InviteViewController * controller = [InviteViewController new];
    controller.arrayInviters = self.inviteArray;
    controller.questionId = self.questionId;
    controller.type = 1;
    controller.arrayJoin = self.joinArray;
    [self.navigationController pushViewController:controller animated:YES];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AddNewActComment object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ActInviteSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EditActJoin object:nil];
    [super doBack];
}

- ( void ) addQuestionComment : ( NSNotification * ) noti
{
    NSDictionary * dic = [noti userInfo];
    CommentEntity * entity = [dic objectForKey:@"comment"];
    [self.commentArray insertObject:entity atIndex:0];
    self.commentCount ++;
    tableView.commentCount ++;
    if( self.type == 0 )
    {
        [questionCommentHeaderView updateHeader:[NSString stringWithFormat:@"问题的评论 %d", self.commentCount]];
    }
    else
    {
        [questionCommentHeaderView updateHeader:[NSString stringWithFormat:@"活动灌水 %d", self.commentCount]];
    }
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
    alertClickCare = [MLTableAlert tableAlertWithTitle:@"关心一下" cancelButtonTitle:@"取消" numberOfRows:^NSInteger (NSInteger section)
    {
        return 3;
    }
    andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
    {
        static NSString *CellIdentifier = @"CellIdentifier";
        NSArray * arrayClickCare = @[ @"沉思中，稍后作答", @"帮你留意着", @"爱莫能助的飘过" ];
        UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
        if( cell == nil )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [arrayClickCare objectAtIndex:indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
                      
        return cell;
    }];

    alertClickCare.height = 245;

    [alertClickCare configureSelectionBlock:^(NSIndexPath *selectedIndex)
    {
        if( selectedIndex.row == 0 )
        {
            [self addQuestionCommentByString:@"沉思中，稍后作答"];
        }
        else if( selectedIndex.row == 1 )
        {
            [self addQuestionCommentByString:@"帮你留意着"];
        }
        else if( selectedIndex.row == 2 )
        {
            [self addQuestionCommentByString:@"爱莫能助的飘过"];
        }
    }
    andCompletionBlock:^{}];
    
    [alertClickCare show];
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
    if( self.type == 0 || self.type == 1 )
    {
        clickIndex = index;
        CommentEntity * temp1 = [tableView.commentArray objectAtIndex:clickIndex];
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
                 CommentEntity * temp = [tableView.commentArray objectAtIndex:clickIndex];
                 AddCommentViewController * controller = [AddCommentViewController new];
                 controller.isEdit = NO;
                 controller.questionId = self.questionId;
                 if( self.type == 0 )
                 {
                     controller.type = 0;
                 }
                 else if( self.type == 1 )
                 {
                     controller.type = 5;
                 }
                 controller.replyId = temp.userId;
                 controller.replyName = temp.userName;
                 [self.navigationController pushViewController:controller animated:YES];
             }
             else if( selectedIndex.row == 1 )
             {
                 CommentEntity * temp = [tableView.commentArray objectAtIndex:clickIndex];
                 UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
                 pasteboard.string = temp.info;
                 [SVProgressHUD showSuccessWithStatus:@"文字已复制"];
             }
         }
         andCompletionBlock:^{}];
        
        [alertClickComment show];
    }
}

- ( void ) refreshSuccess
{
    [questionCommentHeaderView updateHeader:[NSString stringWithFormat:@"问题的评论 %lu", (unsigned long)tableView.commentArray.count]];
}
@end
