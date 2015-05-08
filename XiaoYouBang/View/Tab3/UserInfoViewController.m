//
//  UserInfoViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/4.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoView.h"

@interface UserInfoViewController ()
{
    UserInfoView * infoView;
}
@end

@implementation UserInfoViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    [self setupTitle:@"校友资料"];
    [self hideNextButton];
    
    infoView = [[UserInfoView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height) entity:self.entity];
    [self.view addSubview:infoView];
}

@end
