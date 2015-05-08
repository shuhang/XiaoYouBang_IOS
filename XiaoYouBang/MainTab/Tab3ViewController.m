//
//  Tab1ViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/14.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "Tab3ViewController.h"
#import "FriendTableView.h"
#import "UserInfoViewController.h"

@interface Tab3ViewController () <FriendTableViewDelegate>
{
    FriendTableView * friendView;
}
@end

@implementation Tab3ViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTitle:@"校友录"];
    [self hideBackButton];
    [self hideNextButton];
    
    friendView = [[FriendTableView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height)];
    friendView.delegate = self;
    [self.view addSubview:friendView];
}

- ( void ) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark FriendTableViewDelegate
- ( void ) clickItemAt:(UserEntity *)entity
{
    UserInfoViewController * controller = [UserInfoViewController new];
    controller.entity = entity;
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) clickMe
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    UserEntity * entity = [UserEntity new];
    entity.userId = [userDefaults objectForKey:@"userId"];
    entity.name = [userDefaults objectForKey:@"name"];
    entity.sex = [[userDefaults objectForKey:@"sex"] intValue];
    entity.headUrl = [userDefaults objectForKey:@"headUrl"];
    entity.birthday = [userDefaults objectForKey:@"birthyear"];
    entity.pku = [userDefaults objectForKey:@"pku"];
    entity.nowHome = [userDefaults objectForKey:@"base"];
    entity.oldHome = [userDefaults objectForKey:@"hometown"];
    entity.qq = [userDefaults objectForKey:@"qq"];
    entity.job1 = [userDefaults objectForKey:@"company"];
    entity.job2 = [userDefaults objectForKey:@"department"];
    entity.job3 = [userDefaults objectForKey:@"job"];
    entity.intro = [userDefaults objectForKey:@"intro"];
    entity.tagArray = [userDefaults objectForKey:@"tags"];
    entity.userVersion = [[userDefaults objectForKey:@"version"] intValue];
    entity.praiseCount = [[userDefaults objectForKey:@"praisedCount"] intValue];
    entity.answerCount = [[userDefaults objectForKey:@"questionCount"] intValue];
    entity.questionCount = [[userDefaults objectForKey:@"answerCount"] intValue];
    entity.inviteName = [userDefaults objectForKey:@"inviteUserName"];
    entity.inviteHeadUrl = [userDefaults objectForKey:@"inviteUserHeadUrl"];
    entity.inviteUserId = [userDefaults objectForKey:@"inviteUserId"];
    
    UserInfoViewController * controller = [UserInfoViewController new];
    controller.entity = entity;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
