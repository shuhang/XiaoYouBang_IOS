//
//  LeavewordViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/13.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "LeavewordViewController.h"
#import "LeavewordView.h"
#import "Tool.h"
#import "AddCommentViewController.h"
#import <UIImageView+WebCache.h>

@interface LeavewordViewController ()<LeavewordViewDelegate, UIActionSheetDelegate>
{
    LeavewordView * tableView;
    UIView * headerView;
    UILabel * labelLeaveword;
    UIImageView * imageEdit;
    UIButton * buttonEdit;
    UIView * line;
    UILabel * labelCount;
    
    UIActionSheet * sheetClickComment;
    int clickIndex;
}
@end

@implementation LeavewordViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    self.leaveWord = @"";
    [self setupTitle:[NSString stringWithFormat:@"%@的留言板", self.userName]];
    [self hideNextButton];

    tableView = [[LeavewordView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height + 10)];
    tableView.delegate = self;
    tableView.userId = self.userId;
    [self.view addSubview:tableView];
    
    UIView * bottom = [[UIView alloc] initWithFrame:CGRectMake( 0, Screen_Height - 40, Screen_Width, 40 )];
    bottom.backgroundColor = Color_Heavy_Gray;
    [self.view addSubview:bottom];
    
    UIButton * buttonComment = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonComment.backgroundColor = Color_Gray;
    buttonComment.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    buttonComment.frame = CGRectMake( 20, 7, ( Screen_Width - 70 ) / 2, 26 );
    [buttonComment setTitle:@"留言" forState:UIControlStateNormal];
    [buttonComment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonComment setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [buttonComment addTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:buttonComment];
    
    UIButton * buttonCare = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonCare.backgroundColor = Color_Gray;
    buttonCare.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    buttonCare.frame = CGRectMake( 50 + ( Screen_Width - 70 ) / 2, 7, ( Screen_Width - 70 ) / 2, 26 );
    [buttonCare setTitle:@"欢迎一下" forState:UIControlStateNormal];
    [buttonCare setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonCare setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [buttonCare addTarget:self action:@selector(addWelcome) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:buttonCare];
    
    headerView = [[UIView alloc] initWithFrame:CGRectZero];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * headImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 15, 20, 40, 40 )];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:self.headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    [headerView addSubview:headImageView];
    
    UILabel * labelName = [[UILabel alloc] initWithFrame:CGRectMake( 75, 20, 100, 15 )];
    labelName.text = @"主人寄语";
    labelName.textColor = [UIColor blackColor];
    labelName.font = [UIFont systemFontOfSize:Text_Size_Small];
    [headerView addSubview:labelName];
    
    labelLeaveword = [[UILabel alloc] initWithFrame:CGRectMake( 75, 45, Screen_Width - 85, 0 )];
    labelLeaveword.textColor = Color_Heavy_Gray;
    labelLeaveword.numberOfLines = 0;
    labelLeaveword.font = [UIFont systemFontOfSize:Text_Size_Small];
    labelLeaveword.lineBreakMode = NSLineBreakByWordWrapping;
    [headerView addSubview:labelLeaveword];
    
    line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = Color_Light_Gray;
    [headerView addSubview:line];
    
    labelCount = [[UILabel alloc] initWithFrame:CGRectZero];
    labelCount.textColor = Color_Gray;
    labelCount.font = [UIFont systemFontOfSize:Text_Size_Small];
    labelCount.text = @"留言 0";
    [headerView addSubview:labelCount];
    
    if( [Tool judgeIsMe:self.userId] )
    {
        imageEdit = [[UIImageView alloc] initWithFrame:CGRectMake( Screen_Width - 83, 75, 12, 12 )];
        imageEdit.image = [UIImage imageNamed:@"edit_gray"];
        [headerView addSubview:imageEdit];
        
        buttonEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonEdit.frame = CGRectMake( Screen_Width - 80, 67, 80, 30 );
        [buttonEdit setTitle:@"编辑寄语" forState:UIControlStateNormal];
        buttonEdit.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        [buttonEdit setTitleColor:Color_Gray forState:UIControlStateNormal];
        [buttonEdit setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [buttonEdit addTarget:self action:@selector(editLeaveWord) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:buttonEdit];
        
        line.frame = CGRectMake( 0, 100, Screen_Width, 10 );
        labelCount.frame = CGRectMake( 15, 120, 100, 15 );
        headerView.frame = CGRectMake( 0, 0, Screen_Width, 140 );
    }
    else
    {
        line.frame = CGRectMake( 0, 75, Screen_Width, 10 );
        labelCount.frame = CGRectMake( 15, 95, 100, 15 );
        headerView.frame = CGRectMake( 0, 0, Screen_Width, 115 );
    }
    
    [tableView addSelfHeaderView:headerView];
    
    [tableView startRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addUserComment:) name:AddUserComment object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editLeaveWord:) name:EditLeaveWord object:nil];
}

- ( void ) doBack
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AddUserComment object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EditLeaveWord object:nil];
    if( tableView.commentArray.count > 0 )
    {
        CommentEntity * comment = [tableView.commentArray objectAtIndex:0];
        NSString * value = [NSString stringWithFormat:@"%@：%@", comment.userName, comment.info];
        NSDictionary * info = @{ @"count" : [NSNumber numberWithInteger:tableView.commentArray.count], @"value" : value };
        [[NSNotificationCenter defaultCenter] postNotificationName:LeaveWordBack object:nil userInfo:info];
    }
    [super doBack];
}

- ( void ) editLeaveWord : ( NSNotification * ) noti
{
    NSDictionary * dic = [noti userInfo];

    self.leaveWord = dic[ @"info" ];
    [labelLeaveword setAttributedText:[Tool getModifyString:self.leaveWord]];
    [labelLeaveword sizeToFit];
    
    [self refreshHeader];
}

- ( void ) addUserComment : ( NSNotification * ) noti
{
    NSDictionary * dic = [noti userInfo];
    CommentEntity * entity = [dic objectForKey:@"comment"];
    [tableView addComment:entity];
    labelCount.text = [NSString stringWithFormat:@"留言 %d", [tableView getCommentCount]];
}

- ( void ) editLeaveWord
{
    AddCommentViewController * controller = [AddCommentViewController new];
    controller.isEdit = YES;
    controller.type = 3;
    controller.info = self.leaveWord;
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) addComment
{
    AddCommentViewController * controller = [AddCommentViewController new];
    controller.isEdit = NO;
    controller.userId = self.userId;
    controller.type = 3;
    controller.hostName = self.userName;
    controller.replyId = @"";
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) addWelcome
{
    [SVProgressHUD showWithStatus:@"正在发表" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    [request setValue:@"欢迎欢迎，热烈欢迎" forKey:@"content"];
    
    NSString * url = [NSString stringWithFormat:@"api/user/%@/comment", self.userId];
    [[NetWork shareInstance] httpRequestWithPostPut:url params:request method:@"POST" success:^(NSDictionary * result)
     {
         int code = [result[ @"result"] intValue];
         if( code == 4000 )
         {
             NSString * commentId = [NSString stringWithFormat:@"%@", result[ @"id" ]];
             NSString * time = [NSString stringWithFormat:@"%@", result[ @"time" ]];
             [self addWelcomeSuccess:commentId time:time];
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

- ( void ) addWelcomeSuccess : ( NSString * ) commentId time : ( NSString * ) time
{
    CommentEntity * entity = [CommentEntity new];
    entity.commentId = commentId;
    entity.time = time;
    entity.info = @"欢迎欢迎，热烈欢迎";
    entity.type = 0;
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    entity.userHeadUrl = [userDefaults objectForKey:@"headUrl"];
    entity.userName = [userDefaults objectForKey:@"name"];
    entity.userId = [userDefaults objectForKey:@"userId"];
    
    [tableView addComment:entity];
    labelCount.text = [NSString stringWithFormat:@"留言 %d", [tableView getCommentCount]];

    [SVProgressHUD dismiss];
}

- ( void ) refreshHeader
{
    if( [Tool judgeIsMe:self.userId] )
    {
        imageEdit.frame = CGRectMake( Screen_Width - 83, [Tool getBottom:labelLeaveword] + 10, 12, 12 );
        buttonEdit.frame = CGRectMake( Screen_Width - 80, [Tool getBottom:labelLeaveword] + 2, 80, 30 );
        
        line.frame = CGRectMake( 0, [Tool getBottom:buttonEdit], Screen_Width, 10 );
        labelCount.frame = CGRectMake( 15, [Tool getBottom:line] + 10, 100, 15 );
        headerView.frame = CGRectMake( 0, 0, Screen_Width, [Tool getBottom:labelCount] + 5 );
    }
    else
    {
        line.frame = CGRectMake( 0, [Tool getBottom:labelLeaveword] + 20, Screen_Width, 10 );
        labelCount.frame = CGRectMake( 15, [Tool getBottom:line] + 10, 100, 15 );
        headerView.frame = CGRectMake( 0, 0, Screen_Width, [Tool getBottom:labelCount] + 5 );
    }
    
    [tableView addSelfHeaderView:headerView];
}

#pragma mark LeavewordViewDelegate
- ( void ) refreshSuccess : ( NSString * ) leaveWord
{
    self.leaveWord = leaveWord;
    labelCount.text = [NSString stringWithFormat:@"留言 %d", [tableView getCommentCount]];
    [labelLeaveword setAttributedText:[Tool getModifyString:self.leaveWord]];
    [labelLeaveword sizeToFit];

    [self refreshHeader];
}

- ( void ) clickCommentAtIndex:(int)index
{
    clickIndex = index;
    sheetClickComment = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"回复" otherButtonTitles:@"复制", nil];
    [sheetClickComment showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- ( void ) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if( actionSheet == sheetClickComment )
    {
        if( buttonIndex == sheetClickComment.destructiveButtonIndex )
        {
            CommentEntity * temp = [tableView.commentArray objectAtIndex:clickIndex];
            AddCommentViewController * controller = [AddCommentViewController new];
            controller.isEdit = NO;
            controller.type = 3;
            controller.replyId = temp.userId;
            controller.replyName = temp.userName;
            controller.userId = self.userId;
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if( buttonIndex == sheetClickComment.firstOtherButtonIndex )
        {
            CommentEntity * temp = [tableView.commentArray objectAtIndex:clickIndex];
            UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = temp.info;
            [SVProgressHUD showSuccessWithStatus:@"文字已复制"];
        }
    }
}

@end
