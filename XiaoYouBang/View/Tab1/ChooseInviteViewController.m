//
//  ChooseInviteViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/12.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "ChooseInviteViewController.h"
#import "FriendTableViewCell.h"

@interface ChooseInviteViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView * tableView;
}
@end

@implementation ChooseInviteViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTitle:@"选择邀请人"];
    [self hideNextButton];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height + 50 )];
    [tableView registerClass:[FriendTableViewCell class] forCellReuseIdentifier:@"FriendTableCell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendTableViewCell * cell = [tableView1 dequeueReusableCellWithIdentifier:@"FriendTableCell"];
    if( !cell )
    {
        cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendTableCell"];
    }
    UserEntity * entity = [self.arrayUsers objectAtIndex:indexPath.row];
    cell.entity = entity;
    cell.type = 1;
    [cell updateCell];
    return cell;
}

- ( CGFloat ) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 111;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
    
    UserEntity * user = [self.arrayUsers objectAtIndex:indexPath.row];
    if( !user.hasAnswered && !user.hasInvited )
    {
        NSDictionary * info = @{ @"userId" : user.userId, @"userName" : user.name, @"headUrl" : user.headUrl };
        [[NSNotificationCenter defaultCenter] postNotificationName:ChooseInviter object:nil userInfo:info];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
