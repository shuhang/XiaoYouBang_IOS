//
//  AddActViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/14.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "AddActViewController.h"
#import "GCPlaceholderTextView.h"
#import "NetWork.h"
#import "QuestionEntity.h"
#import "ChoosePictureViewController.h"
#import "Tool.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface AddActViewController ()<UITextViewDelegate>
{
    GCPlaceholderTextView * inputTitle;
    GCPlaceholderTextView * inputInfo;
    UITextField * fieldTime;
    UITextField * fieldPlace;
    UITextField * fieldMoney;
    
    UIButton * buttonPicture;
}
@end

@implementation AddActViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTitle:@"发起活动"];
    [self setupNextButtonTitle:@"发布"];
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = Color_With_Rgb( 255, 255, 255, 1 );
    
    self.arrayPictures = [NSMutableArray array];
    self.imageArray = [NSMutableArray array];
    
    GCPlaceholderTextView * temp = [[GCPlaceholderTextView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:temp];
    
    inputTitle = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake( 0, 74, Screen_Width, 50 )];
    inputTitle.font = [UIFont systemFontOfSize:Text_Size_Big];
    inputTitle.placeholder = @"请输入活动的标题，限30字...";
    [self.view addSubview:inputTitle];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake( 0, 134, 20, 0.5 )];
    line1.backgroundColor = Color_Gray;
    [self.view addSubview:line1];
    
    fieldTime = [[UITextField alloc] initWithFrame:CGRectMake( 20, 140, Screen_Width - 40, 35 )];
    fieldTime.placeholder = @"活动时间";
    fieldTime.backgroundColor = [UIColor whiteColor];
    fieldTime.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldTime setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldTime];
    [self.view addSubview:fieldTime];
    
    fieldTime.layer.cornerRadius = 5.0f;
    fieldTime.layer.masksToBounds = YES;
    fieldTime.layer.borderColor = Green.CGColor;
    fieldTime.layer.borderWidth= 0.5f;
    
    fieldPlace = [[UITextField alloc] initWithFrame:CGRectMake( 20, 180, Screen_Width - 40, 35 )];
    fieldPlace.placeholder = @"活动地点";
    fieldPlace.backgroundColor = [UIColor whiteColor];
    fieldPlace.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldPlace setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldPlace];
    [self.view addSubview:fieldPlace];
    
    fieldPlace.layer.cornerRadius = 5.0f;
    fieldPlace.layer.masksToBounds = YES;
    fieldPlace.layer.borderColor = Green.CGColor;
    fieldPlace.layer.borderWidth= 0.5f;
    
    fieldMoney = [[UITextField alloc] initWithFrame:CGRectMake( 20, 220, Screen_Width - 40, 35 )];
    fieldMoney.placeholder = @"活动费用";
    fieldMoney.backgroundColor = [UIColor whiteColor];
    fieldMoney.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldMoney setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldMoney];
    [self.view addSubview:fieldMoney];
    
    fieldMoney.layer.cornerRadius = 5.0f;
    fieldMoney.layer.masksToBounds = YES;
    fieldMoney.layer.borderColor = Green.CGColor;
    fieldMoney.layer.borderWidth= 0.5f;
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake( 0, 264, 20, 0.5 )];
    line2.backgroundColor = Color_Gray;
    [self.view addSubview:line2];
    
    inputInfo = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake( 0, 270, Screen_Width, Screen_Height - 270 )];
    inputInfo.font = [UIFont systemFontOfSize:Text_Size_Big];
    inputInfo.placeholder = @"请描述活动的详细内容，包括发起初心、场地魅力、活动计划、交通提示、初步报名情况等...";
    inputInfo.delegate = self;
    [self.view addSubview:inputInfo];
    
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
    self.actTitle = inputTitle.text;
    if( self.actTitle.length == 0 || self.actTitle.length > 30 )
    {
        [SVProgressHUD showErrorWithStatus:@"标题1~30字"];
        return;
    }
    NSString * time = fieldTime.text;
    if( time.length == 0 )
    {
        [SVProgressHUD showErrorWithStatus:@"请输入活动时间"];
        return;
    }
    NSString * place = fieldPlace.text;
    if( place.length == 0 )
    {
        [SVProgressHUD showErrorWithStatus:@"请输入活动地点"];
        return;
    }
    NSString * money = fieldMoney.text;
    if( money.length == 0 )
    {
        [SVProgressHUD showErrorWithStatus:@"请输入活动费用"];
        return;
    }
    NSString * info = inputInfo.text;
    if( info.length == 0 || info.length > 2000 )
    {
        [SVProgressHUD showErrorWithStatus:@"详情1~2000字"];
        return;
    }
    self.info = [NSString stringWithFormat:@"时间：%@\n地点：%@\n费用：%@\n\n【活动详情】\n%@", time, place, money, info];
    
    [self startAddAct];
}

- ( void ) startAddAct
{
    FORCE_CLOSE_KEYBOARD;
    if( self.arrayPictures.count > 0 )
    {
        [self addPictureAtIndex:0];
    }
    else
    {
        [self addAct];
    }
}

- ( void ) addPictureAtIndex : ( int ) index
{
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在上传第%d张照片", ( index + 1 )] maskType:SVProgressHUDMaskTypeGradient];
    __block AddActViewController * temp = self;
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
                                    [temp addAct];
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

- ( void ) addAct
{
    [SVProgressHUD showWithStatus:@"正在发布" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    [request setValue:[NSNumber numberWithInt:1] forKey:@"questionType"];
    [request setValue:self.actTitle forKey:@"title"];
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
             [self addActSuccess:questionId time:time];
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

- ( void ) addActSuccess : ( NSString * ) questionId time : ( NSString * ) time
{
    QuestionEntity * entity = [QuestionEntity new];
    entity.questionId = questionId;
    entity.questionTitle = self.actTitle;
    entity.info = self.info;
    entity.createTime = time;
    entity.modifyTime = time;
    entity.updateTime = time;
    entity.changeTime = time;
    entity.type = 1;
    entity.answerCount = 0;
    entity.allCommentCount = 0;
    entity.joinCount = 0;
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AddNewAct object:nil userInfo:@{ @"act" : entity }];
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITextViewDelegate


@end
