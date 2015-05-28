//
//  Tab4ViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/28.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "Tab4ViewController.h"
#import "UserInfoViewController.h"
#import "ChangePasswordViewController.h"
#import "Tool.h"
#import "LoginViewController.h"

@interface Tab4ViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    UITableView * tableSetting;
    NSArray * arrayData;
}
@end

@implementation Tab4ViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = Color_Super_Light_Gray;
    
    [self setupTitle:@"设置"];
    [self hideBackButton];
    [self hideNextButton];
    
    arrayData = @[ @[ @"个人资料", @"修改密码" ], @[ @"退出登录" ] ];
    
    tableSetting = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height ) style:UITableViewStyleGrouped];
    tableSetting.dataSource = self;
    tableSetting.delegate = self;
    [self.view addSubview:tableSetting];
}

- ( void ) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrayData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[arrayData objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * reuseIdentifier1 = @"SettingCell1";
    NSString * reuseIdentifier2 = @"SettingCell2";
    UITableViewCell * cell = nil;
    if( indexPath.section == 0 )
    {
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1];
        if( !cell )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier1];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier2];
        if( !cell )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier2];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    cell.textLabel.text = [[arrayData objectAtIndex:[indexPath section]] objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if( section == 0 )
    {
        return 20;
    }
    return 18;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch( indexPath.section )
    {
        case 0 :
        {
            switch( indexPath.row )
            {
                case 0 :
                {
                    UserInfoViewController * controller = [UserInfoViewController new];
                    controller.shouldRefresh = YES;
                    controller.entity = [Tool getMyEntity];
                    [self.navigationController pushViewController:controller animated:YES];
                    break;
                }
                case 1 :
                {
                    ChangePasswordViewController * controller = [ChangePasswordViewController new];
                    [self.navigationController pushViewController:controller animated:YES];
                    break;
                }
            }
            break;
        }
        case 1 :
        {
            switch( indexPath.row )
            {
                case 0 :
                {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出登录吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alertView show];
                    break;
                }
            }
            break;
        }
    }
}

#pragma mark - UIAlertViewDelegate
- ( void ) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 1 )
    {
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"" forKey:@"token"];
        [userDefaults synchronize];
        
        [Tool setChangeAccountSymbol:YES];
        
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
}

@end
