//
//  AddAnswerViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/30.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "AddAnswerViewController.h"
#import "GCPlaceholderTextView.h"
#import "NetWork.h"
#import "AnswerEntity.h"
#import "Tool.h"

@interface AddAnswerViewController ()<UIAlertViewDelegate>
{
    GCPlaceholderTextView * inputInfo;
}
@end

@implementation AddAnswerViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTitle:@"添加回答"];
    [self setupNextButtonTitle:@"发布"];
    
    UIView * tempView = [UIView new];
    tempView.backgroundColor = Color_Light_Gray;
    [self.view addSubview:tempView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake( 10, 10, Screen_Width - 20, 0 )];
    label.numberOfLines = 2;
    label.textColor = Color_Gray;
    label.font = [UIFont systemFontOfSize:Text_Size_Micro];
    label.text = self.questionTitle;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [label sizeToFit];
    [tempView addSubview:label];
    tempView.frame = CGRectMake( 0, 64, Screen_Width, label.frame.size.height + 20 );
    
    GCPlaceholderTextView * temp = [[GCPlaceholderTextView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:temp];
    
    inputInfo = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:tempView] + 10, Screen_Width, Screen_Height - [Tool getBottom:label] - 10 )];
    inputInfo.font = [UIFont systemFontOfSize:Text_Size_Big];
    inputInfo.placeholder = @"写下你的答案、建议、参考...";
    [self.view addSubview:inputInfo];
    
    if( self.isEdit )
    {
        [self setupTitle:@"编辑回答"];
        inputInfo.text = self.info;
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
    
    if( self.isEdit )
    {
        [self editAnswer];
    }
    else
    {
        [self addAnswer];
    }
}

- ( void ) editAnswer
{
    FORCE_CLOSE_KEYBOARD;
    [SVProgressHUD showWithStatus:@"正在发布" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    [request setValue:self.info forKey:@"content"];
    [request setValue:@[] forKey:@"images"];
    
    NSString * url = [NSString stringWithFormat:@"api/answer/%@", self.answerId];
    [[NetWork shareInstance] httpRequestWithPostPut:url params:request method:@"PUT" success:^(NSDictionary * result)
     {
         int code = [result[ @"result"] intValue];
         if( code == 4000 )
         {
             NSString * time = [NSString stringWithFormat:@"%@", result[ @"editTime" ]];
             [self editAnswerSuccess:time];
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

- ( void ) addAnswer
{
    FORCE_CLOSE_KEYBOARD;
    [SVProgressHUD showWithStatus:@"正在发布" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    [request setValue:[NSNumber numberWithInt:self.type] forKey:@"answerType"];
    [request setValue:self.questionId forKey:@"questionId"];
    [request setValue:self.info forKey:@"answer"];
    [request setValue:[NSNumber numberWithBool:NO] forKey:@"invisible"];
    [request setValue:@[] forKey:@"images"];
    
    [[NetWork shareInstance] httpRequestWithPostPut:@"api/answer" params:request method:@"POST" success:^(NSDictionary * result)
     {
         int code = [result[ @"result"] intValue];
         if( code == 4000 )
         {
             NSString * answerId = [NSString stringWithFormat:@"%@", result[ @"id" ]];
             NSString * time = [NSString stringWithFormat:@"%@", result[ @"modifyTime" ]];
             [self addAnswerSuccess:answerId time:time];
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

- ( void ) addAnswerSuccess : ( NSString * ) answerId time : ( NSString * ) time
{
    AnswerEntity * entity = [AnswerEntity new];
    entity.answerId = answerId;
    entity.questionId = self.questionId;
    entity.questionTitle = self.questionTitle;
    entity.info = self.info;
    entity.createTime = time;
    entity.modifyTime = time;
    entity.editTime = @"";
    entity.type = self.type;
    entity.commentArray = [NSMutableArray array];
    entity.commentCount = 0;
    entity.praiseCount = 0;
    entity.praiseArray = [NSMutableArray array];
    entity.hasImage = false;
    entity.imageArray = [NSMutableArray array];
    entity.inviteArray = [NSMutableArray array];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    entity.userHeadUrl = [userDefaults objectForKey:@"headUrl"];
    entity.name = [userDefaults objectForKey:@"name"];
    entity.userId = [userDefaults objectForKey:@"userId"];
    entity.company = [userDefaults objectForKey:@"company"];
    entity.part = [userDefaults objectForKey:@"department"];
    entity.job = [userDefaults objectForKey:@"job"];
    entity.pku = [userDefaults objectForKey:@"pku"];
    entity.sex = [[userDefaults objectForKey:@"sex"] intValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AddNewAnswer object:nil userInfo:@{ @"answer" : entity }];
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- ( void ) editAnswerSuccess : ( NSString * ) time
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EditAnswerSuccess" object:nil userInfo:@{ @"info" : self.info, @"time" : time }];
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- ( void ) doBack
{
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
