//
//  AddQuestionViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/28.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "AddQuestionViewController.h"
#import "GCPlaceholderTextView.h"
#import "NetWork.h"
#import "QuestionEntity.h"

@interface AddQuestionViewController ()<UIAlertViewDelegate>
{
    GCPlaceholderTextView * inputTitle;
    GCPlaceholderTextView * inputInfo;
}
@end

@implementation AddQuestionViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self setupTitle:@"添加提问"];
    [self setupNextButtonTitle:@"发布"];
    
    GCPlaceholderTextView * temp = [[GCPlaceholderTextView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:temp];
    
    inputTitle = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake( 0, 74, Screen_Width, 60 )];
    inputTitle.font = [UIFont systemFontOfSize:Text_Size_Big];
    inputTitle.placeholder = @"请简要描述你的问题，至少包含一个问号";
    [self.view addSubview:inputTitle];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake( 0, 144, 20, 1 )];
    view.backgroundColor = Color_Gray;
    [self.view addSubview:view];
    
    inputInfo = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake( 0, 155, Screen_Width, Screen_Height - 175 )];
    inputInfo.font = [UIFont systemFontOfSize:Text_Size_Small];
    inputInfo.placeholder = @"请补充描述相关的背景、想法、要求等...";
    [self.view addSubview:inputInfo];
    
    if( self.isEdit )
    {
        [self setupTitle:@"编辑问题"];
        inputTitle.text = self.questionTitle;
        inputInfo.text = self.info;
    }
}

- ( void ) doBack
{
    if( inputTitle.text.length == 0 && inputInfo.text.length == 0 )
    {
        [super doBack];
    }
    else
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出编辑吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- ( void ) doNext
{
    self.questionTitle = inputTitle.text;
    if( self.questionTitle.length < 1 || self.questionTitle.length > 36 )
    {
        [SVProgressHUD showErrorWithStatus:@"标题最多36个字"];
        return;
    }
    self.info = inputInfo.text;
    if( self.info.length < 1 || self.info.length > 2000 )
    {
        [SVProgressHUD showErrorWithStatus:@"描述最多2000字"];
        return;
    }
    
    if( self.isEdit )
    {
        [self editQuestion];
    }
    else
    {
        [self addQuestion];
    }
}

- ( void ) editQuestion
{
    FORCE_CLOSE_KEYBOARD;
    [SVProgressHUD showWithStatus:@"正在发布" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    [request setValue:self.questionTitle forKey:@"title"];
    [request setValue:self.info forKey:@"content"];
    [request setValue:@[] forKey:@"images"];
    [request setValue:[userDefaults objectForKey:@"name"] forKey:@"name"];
    
    NSString * url = [NSString stringWithFormat:@"api/question/%@/edit", self.questionId];
    [[NetWork shareInstance] httpRequestWithPostPut:url params:request method:@"PUT" success:^(NSDictionary * result)
     {
         int code = [result[ @"result"] intValue];
         if( code == 3000 )
         {
             NSString * time = [NSString stringWithFormat:@"%@", result[ @"editTime" ]];
             [self editQuestionSuccess:time];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"发布失败"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [SVProgressHUD showErrorWithStatus:@"发布失败"];
     }];
}

- ( void ) addQuestion
{
    FORCE_CLOSE_KEYBOARD;
    [SVProgressHUD showWithStatus:@"正在发布" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    [request setValue:[NSNumber numberWithInt:0] forKey:@"questionType"];
    [request setValue:self.questionTitle forKey:@"title"];
    [request setValue:self.info forKey:@"info"];
    [request setValue:[NSNumber numberWithBool:NO] forKey:@"invisible"];
    [request setValue:@[] forKey:@"images"];
    
    [[NetWork shareInstance] httpRequestWithPostPut:@"api/question" params:request method:@"POST" success:^(NSDictionary * result)
     {
         int code = [result[ @"result"] intValue];
         if( code == 3000 )
         {
             NSString * questionId = [NSString stringWithFormat:@"%@", result[ @"id" ]];
             NSString * time = [NSString stringWithFormat:@"%@", result[ @"modifyTime" ]];
             [self addQuestionSuccess:questionId time:time];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"发布失败"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [SVProgressHUD showErrorWithStatus:@"发布失败"];
     }];
}

- ( void ) addQuestionSuccess : ( NSString * ) questionId time : ( NSString * ) time
{
    QuestionEntity * entity = [QuestionEntity new];
    entity.questionId = questionId;
    entity.questionTitle = self.questionTitle;
    entity.info = self.info;
    entity.createTime = time;
    entity.modifyTime = time;
    entity.updateTime = time;
    entity.changeTime = time;
    entity.type = 0;
    entity.answerCount = 0;
    entity.allCommentCount = 0;
    entity.questionCommentCount = 0;
    entity.praiseCount = 0;
    entity.hasImage = false;
    entity.myInviteArray = [NSMutableArray array];
    entity.inviteMeArray = [NSMutableArray array];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    entity.userHeadUrl = [userDefaults objectForKey:@"headUrl"];
    entity.userName = [userDefaults objectForKey:@"name"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AddNewQuestion object:nil userInfo:@{ @"question" : entity }];
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- ( void ) editQuestionSuccess : ( NSString * ) time
{
    NSDictionary * userInfo = @{ @"title" : self.questionTitle, @"info" : self.info, @"time" : time };
    [[NSNotificationCenter defaultCenter] postNotificationName:EditQuestionSuccess object:nil userInfo:userInfo];
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
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
