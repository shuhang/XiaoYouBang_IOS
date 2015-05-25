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
#import "ChoosePictureViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface AddAnswerViewController ()<UIAlertViewDelegate>
{
    GCPlaceholderTextView * inputInfo;
    UIButton * buttonPicture;
}
@end

@implementation AddAnswerViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
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
    [self.view addSubview:inputInfo];
    
    if( self.type == 0 )
    {
        [self setupTitle:@"添加回答"];
        inputInfo.placeholder = @"写下你的答案、建议、参考...";
        if( self.isEdit )
        {
            [self setupTitle:@"编辑回答"];
            inputInfo.text = self.info;
        }
    }
    else if( self.type == 1 )
    {
        [self setupTitle:@"添加活动总结"];
        inputInfo.placeholder = @"写下你的活动总结...";
        if( self.isEdit )
        {
            [self setupTitle:@"编辑活动总结"];
            inputInfo.text = self.info;
        }
    }
    
    buttonPicture = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonPicture.frame = CGRectMake( Screen_Width - 60, Screen_Height - 60, 55, 55 );
    [buttonPicture setBackgroundImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
    [buttonPicture addTarget:self action:@selector(choosePicture) forControlEvents:UIControlEventTouchUpInside];
    buttonPicture.titleEdgeInsets = UIEdgeInsetsMake( 26, 0, 0, 0 );
    buttonPicture.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
    [buttonPicture setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:buttonPicture];
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
        [self startEditAnswer];
    }
    else
    {
        [self startAddAnswer];
    }
}

- ( void ) startEditAnswer
{
    FORCE_CLOSE_KEYBOARD;
    if( self.arrayPictures.count > 0 )
    {
        [self addPictureAtIndex:0];
    }
    else
    {
        [self editAnswer];
    }
}

- ( void ) startAddAnswer
{
    FORCE_CLOSE_KEYBOARD;
    if( self.arrayPictures.count > 0 )
    {
        [self addPictureAtIndex:0];
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
    [request setValue:self.imageArray forKey:@"images"];
    
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

- ( void ) addPictureAtIndex : ( int ) index
{
    if( [[self.arrayPictures objectAtIndex:index] isKindOfClass:[NSString class]] )
    {
        if( index == ( int ) self.arrayPictures.count - 1 )
        {
            if( self.isEdit )
            {
                [self editAnswer];
            }
            else
            {
                [self addAnswer];
            }
        }
        else
        {
            [self addPictureAtIndex:index + 1];
        }
        return ;
    }
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在上传第%d张照片", ( index + 1 )] maskType:SVProgressHUDMaskTypeGradient];
    __block AddAnswerViewController * temp = self;
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
                                    if( self.isEdit )
                                    {
                                        [self editAnswer];
                                    }
                                    else
                                    {
                                        [self addAnswer];
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

- ( void ) addAnswer
{
    [SVProgressHUD showWithStatus:@"正在发布" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    [request setValue:[NSNumber numberWithInt:self.type] forKey:@"answerType"];
    [request setValue:self.questionId forKey:@"questionId"];
    [request setValue:self.info forKey:@"answer"];
    [request setValue:[NSNumber numberWithBool:NO] forKey:@"invisible"];
    [request setValue:self.imageArray forKey:@"images"];
    
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
    if( self.imageArray.count > 0 )
        entity.hasImage = YES;
    else
        entity.hasImage = NO;
    entity.imageArray = self.imageArray;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EditAnswerSuccess" object:nil userInfo:@{ @"info" : self.info, @"time" : time, @"imageArray" : self.imageArray}];
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- ( void ) doBack
{
    if( inputInfo.text.length == 0 )
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

#pragma mark - UIAlertViewDelegate
- ( void ) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 1 )
    {
        [super doBack];
    }
}

@end
