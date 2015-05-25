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
#import "MyDatabaseHelper.h"
#import "Tool.h"
#import "EditInfoViewController.h"
#import "ChangePasswordViewController.h"

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
    
    MyDatabaseHelper * helper = [MyDatabaseHelper new];
    NSMutableArray * array = [helper getUserList];
    self.userArray = ( NSMutableArray * )[array sortedArrayUsingFunction:sortByName1 context:NULL];
    
    friendView = [[FriendTableView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height) userArray:self.userArray];
    friendView.delegate = self;
    [self.view addSubview:friendView];
}

NSInteger sortByName1( id u1, id u2, void *context )
{
    UserEntity * user1 = ( UserEntity * ) u1;
    UserEntity * user2 = ( UserEntity * ) u2;
    return [user1.name localizedCompare:user2.name];
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
    controller.shouldRefresh = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- ( void ) clickMe
{
    //UserInfoViewController * controller = [UserInfoViewController new];
    ChangePasswordViewController * controller = [ChangePasswordViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
