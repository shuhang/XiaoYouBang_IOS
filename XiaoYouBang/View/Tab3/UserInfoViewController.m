//
//  UserInfoViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/4.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoView.h"
#import "NetWork.h"
#import "Tool.h"
#import "UserIntroViewController.h"
#import "MyDatabaseHelper.h"
#import "QuestionTableViewController.h"
#import "AnswerTableViewController.h"
#import "LeavewordViewController.h"
#import "UIImageView+WebCache.h"

@interface UserInfoViewController () <UserInfoViewDelegate>
{
    UserInfoView * infoView;
    UIView * mainView;
}
@end

@implementation UserInfoViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    if( [Tool judgeIsMe:self.entity.userId] )
    {
        [self setupTitle:@"我的资料"];
    }
    else
    {
        [self setupTitle:@"校友资料"];
    }
    [self hideNextButton];
    
    infoView = [[UserInfoView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height) entity:self.entity];
    infoView.delegate = self;
    [self.view addSubview:infoView];
    
    if( self.shouldRefresh )
    {
        [self startRefresh];
    }
    
    [infoView refreshUserComments];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editIntro:) name:EditIntroSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leavewordBack:) name:LeaveWordBack object:nil];
}

- ( void ) leavewordBack : ( NSNotification * ) noti
{
    NSDictionary * dic = [noti userInfo];
    [infoView updateLeaveword:dic[ @"value" ] count:[dic[ @"count" ] intValue]];
}

- ( void ) editIntro : ( NSNotification * ) noti
{
    NSDictionary * dic = [noti userInfo];
    self.entity.intro = [dic objectForKey:@"info"];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.entity.intro forKey:@"intro"];
    [userDefaults synchronize];
}

- ( void ) doBack
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EditIntroSuccess object:nil];
    [super doBack];
}

- ( void ) startRefresh
{
    dispatch_async
    (
        dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^
        {
            NSMutableDictionary * request = [NSMutableDictionary dictionary];
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
            NSString * url = [NSString stringWithFormat:@"api/user/%@", self.entity.userId];
            [[NetWork shareInstance] httpRequestWithGet:url params:request success:^(NSDictionary * result)
            {
                [Tool loadUserInfoEntity:self.entity item:result];
                if( ![Tool judgeIsMe:self.entity.userId] )
                {
                    self.entity.answerMe = [result[ @"answerMeCount" ] intValue];
                    self.entity.myAnswer = [result[ @"myAnswerCount" ] intValue];
                }
                dispatch_async
                (
                    dispatch_get_main_queue(), ^
                    {
                        [infoView updateInfo];
                    }
                );
                if( ![Tool judgeIsMe:self.entity.userId] )
                {
                    MyDatabaseHelper * helper = [MyDatabaseHelper new];
                    [helper insertOrUpdateUsers:[NSArray arrayWithObjects:self.entity, nil] updateTime:@"" symbol:NO];
                }
            }
            error:^(NSError * error)
            {
                NSLog( @"%@", error );
                [SVProgressHUD showErrorWithStatus:@"刷新资料失败"];
            }];
        }
    );
}

- ( void ) loadUserInfo
{
    [SVProgressHUD showWithStatus:@"正在加载邀请人资料" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    NSString * url = [NSString stringWithFormat:@"api/user/%@", self.entity.inviteUserId];
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

- ( void ) hidePicture : (UITapGestureRecognizer *)tap
{
    if( [mainView isDescendantOfView:[UIApplication sharedApplication].keyWindow] )
    {
        [mainView removeFromSuperview];
    }
}

#pragma mark UserInfoViewDelegate
- ( void ) clickHeadImage
{
    mainView = [[UIView alloc] init];
    mainView.backgroundColor = [UIColor blackColor];
    mainView.frame = [UIScreen mainScreen].bounds;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.frame = CGRectMake( 0, ( Screen_Height - Screen_Width ) / 2, Screen_Width, Screen_Width );
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.entity.headUrl] placeholderImage:[UIImage imageNamed:@"picture"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    [mainView addSubview:imageView];
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePicture:)];
    [imageView addGestureRecognizer:gesture];
    
    mainView.clipsToBounds = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:mainView];
}

- ( void ) clickIntro
{
    UserIntroViewController * controller = [UserIntroViewController new];
    controller.userId = self.entity.userId;
    controller.userName = self.entity.name;
    controller.intro = self.entity.intro;
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) clickLeaveWord
{
    LeavewordViewController * controller = [LeavewordViewController new];
    controller.userId = self.entity.userId;
    controller.userName = self.entity.name;
    controller.headUrl = self.entity.headUrl;
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) clickInvite
{
    if( self.entity.inviteUserId.length != 0 )
    {
        if( [Tool judgeIsMe:self.entity.inviteUserId] )
        {
            [self showMe];
        }
        else
        {
            MyDatabaseHelper * helper = [MyDatabaseHelper new];
            UserEntity * user = [helper getUserById:self.entity.inviteUserId];
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
}

- ( void ) clickQuestion
{
    QuestionTableViewController * controller = [QuestionTableViewController new];
    controller.userName = self.entity.name;
    controller.userId = self.entity.userId;
    controller.questionCount = self.entity.questionCount;
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) clickAnswer
{
    AnswerTableViewController * controller = [AnswerTableViewController new];
    controller.userName = self.entity.name;
    controller.userId = self.entity.userId;
    controller.answerCount = self.entity.answerCount;
    [self.navigationController pushViewController:controller animated:YES];
}
@end
