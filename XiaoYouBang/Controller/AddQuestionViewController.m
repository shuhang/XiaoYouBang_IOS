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
#import "ChoosePictureViewController.h"
#import "Tool.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface AddQuestionViewController ()<UIAlertViewDelegate>
{
    GCPlaceholderTextView * inputTitle;
    GCPlaceholderTextView * inputInfo;
    UIButton * buttonPicture;
}
@end

@implementation AddQuestionViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = Color_With_Rgb( 255, 255, 255, 1 );
    [self setupNextButtonTitle:@"发布"];
    
    self.arrayPictures = [NSMutableArray array];
    self.imageArray = [NSMutableArray array];
    
    if( self.isEdit )
    {
        for( NSString * item in self.oldImageArray )
        {
            [self.arrayPictures addObject:item];
            [self.imageArray addObject:item];
        }
    }
    
    GCPlaceholderTextView * temp = [[GCPlaceholderTextView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:temp];
    
    inputTitle = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake( 0, 74, Screen_Width, 60 )];
    inputTitle.font = [UIFont systemFontOfSize:Text_Size_Big];
    [self.view addSubview:inputTitle];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake( 0, 144, 20, 1 )];
    view.backgroundColor = Color_Gray;
    [self.view addSubview:view];
    
    inputInfo = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake( 0, 155, Screen_Width, Screen_Height - 175 )];
    inputInfo.font = [UIFont systemFontOfSize:Text_Size_Small];
    [self.view addSubview:inputInfo];
    
    buttonPicture = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonPicture.frame = CGRectMake( Screen_Width - 60, Screen_Height - 60, 55, 55 );
    [buttonPicture setBackgroundImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
    [buttonPicture addTarget:self action:@selector(choosePicture) forControlEvents:UIControlEventTouchUpInside];
    buttonPicture.titleEdgeInsets = UIEdgeInsetsMake( 26, 0, 0, 0 );
    buttonPicture.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
    [buttonPicture setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:buttonPicture];
    
    if( self.type == 0 )
    {
        inputTitle.placeholder = @"请简要描述你的问题，至少包含一个问号";
        inputInfo.placeholder = @"请补充描述相关的背景、想法、要求等...";
        if( self.isEdit )
        {
            [self setupTitle:@"编辑问题"];
            inputTitle.text = self.questionTitle;
            inputInfo.text = self.info;
        }
        else
        {
            [self setupTitle:@"添加提问"];
        }
    }
    else if( self.type == 1 )
    {
        inputTitle.placeholder = @"请输入活动的标题，限30字...";
        inputInfo.placeholder = @"请描述活动的详细内容，包括发起初心、场地魅力、活动计划、交通提示、初步报名情况等...";
        [self setupTitle:@"编辑活动"];
        inputTitle.text = self.questionTitle;
        inputInfo.text = self.info;
    }
}

- ( void ) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [buttonPicture setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)self.arrayPictures.count] forState:UIControlStateNormal];
}

- ( void ) choosePicture
{
    ChoosePictureViewController * controller = [ChoosePictureViewController new];
    controller.arrayPictures = self.arrayPictures;
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) doBack
{
    if( inputTitle.text.length == 0 && inputInfo.text.length == 0 )
    {
        [self.arrayPictures removeAllObjects];
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
    if( self.type == 0 )
    {
        if( self.questionTitle.length < 1 || self.questionTitle.length > 36 )
        {
            [SVProgressHUD showErrorWithStatus:@"标题最多36个字"];
            return;
        }
        if( [self.questionTitle rangeOfString:@"?"].length == 0 && [self.questionTitle rangeOfString:@"？"].length == 0 )
        {
            [SVProgressHUD showErrorWithStatus:@"标题至少包含一个问号"];
            return;
        }
    }
    else
    {
        if( self.questionTitle.length < 1 || self.questionTitle.length > 30 )
        {
            [SVProgressHUD showErrorWithStatus:@"标题最多30个字"];
            return;
        }
    }
    self.info = inputInfo.text;
    if( self.info.length < 1 || self.info.length > 2000 )
    {
        [SVProgressHUD showErrorWithStatus:@"描述最多2000字"];
        return;
    }
    
    if( self.isEdit )
    {
        [self startEditQuestion];
    }
    else
    {
        [self startAddQuestion];
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

- ( void ) startEditQuestion
{
    FORCE_CLOSE_KEYBOARD;
    if( self.arrayPictures.count > 0 )
    {
        [self addPictureAtIndex:0];
    }
    else
    {
        [self editQuestion];
    }
}

- ( void ) startAddQuestion
{
    FORCE_CLOSE_KEYBOARD;
    if( self.arrayPictures.count > 0 )
    {
        [self addPictureAtIndex:0];
    }
    else
    {
        [self addQuestion];
    }
}

- ( void ) addQuestion
{
    [SVProgressHUD showWithStatus:@"正在发布" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    [request setValue:[NSNumber numberWithInt:0] forKey:@"questionType"];
    [request setValue:self.questionTitle forKey:@"title"];
    [request setValue:self.info forKey:@"info"];
    [request setValue:[NSNumber numberWithBool:NO] forKey:@"invisible"];
    [request setValue:self.imageArray forKey:@"images"];
    
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

- ( void ) addPictureAtIndex : ( int ) index
{
    if( [[self.arrayPictures objectAtIndex:index] isKindOfClass:[NSString class]] )
    {
        if( index == ( int ) self.arrayPictures.count - 1 )
        {
            if( self.isEdit )
            {
                [self editQuestion];
            }
            else
            {
                [self addQuestion];
            }
        }
        else
        {
             [self addPictureAtIndex:index + 1];
        }
        return ;
    }
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在上传第%d张照片", ( index + 1 )] maskType:SVProgressHUDMaskTypeGradient];
    __block AddQuestionViewController * temp = self;
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^
    {
        NSData * data = nil;
        if( [[temp.arrayPictures objectAtIndex:index] isKindOfClass:[ALAsset class]] )
        {
            data = [Tool getThumbImageData:[UIImage imageWithCGImage:[[[self.arrayPictures objectAtIndex:index] defaultRepresentation] fullScreenImage]]];
        }
        else
        {
            data = [Tool getThumbImageData:[temp.arrayPictures objectAtIndex:index]];
        }
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary * result = [[NetWork shareInstance] uploadHeadImage:[NSString stringWithFormat:@"api/image?token=%@", [userDefaults objectForKey:@"token"]] fileName:@"head.jpg" fileData:data mimeType:@"image/jpeg"];
        if( result == nil || [result[ @"result" ] intValue] != 9000 )
        {
            dispatch_async
            (
                dispatch_get_main_queue(), ^
                {
                    [SVProgressHUD showErrorWithStatus:@"上传照片失败"];
                }
            );
        }
        else
        {
            dispatch_async
            (
                dispatch_get_main_queue(), ^
                {
                    [temp.imageArray addObject:result[ @"url" ]];
                    if( index == ( int ) temp.arrayPictures.count - 1 )
                    {
                        if( temp.isEdit )
                        {
                            [temp editQuestion];
                        }
                        else
                        {
                            [temp addQuestion];
                        }
                    }
                    else
                    {
                        [temp addPictureAtIndex:index + 1];
                    }
                }
            );
        }
     });
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
    if( self.imageArray.count > 0 )
        entity.hasImage = YES;
    else
        entity.hasImage = NO;
    entity.myInviteArray = [NSMutableArray array];
    entity.inviteMeArray = [NSMutableArray array];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    entity.userHeadUrl = [userDefaults objectForKey:@"headUrl"];
    entity.userName = [userDefaults objectForKey:@"name"];
    
    [self.arrayPictures removeAllObjects];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AddNewQuestion object:nil userInfo:@{ @"question" : entity }];
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- ( void ) editQuestionSuccess : ( NSString * ) time
{
    NSDictionary * userInfo = @{ @"title" : self.questionTitle, @"info" : self.info, @"time" : time, @"imageArray" : self.imageArray };
    if( self.type == 0 )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:EditQuestionSuccess object:nil userInfo:userInfo];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:EditActSuccess object:nil userInfo:userInfo];
    }
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
