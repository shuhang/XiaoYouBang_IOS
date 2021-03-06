//
//  FriendTableView.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/4.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "FriendTableView.h"
#import "MJRefresh.h"
#import "NetWork.h"
#import "Tool.h"
#import "FriendTableViewCell.h"
#import "SVProgressHUD.h"
#import <UIImageView+WebCache.h>

@interface FriendTableView()
{
    UITableView * tableView;
    UIView * headerView;
    UILabel * myPraiseCountLabel;
    UILabel * myJobLabel;
    UIImageView * myHeadImageView;
    UILabel * friendCountLabel;
}
@end

@implementation FriendTableView

- ( id ) initWithFrame:(CGRect)frame
{
    if( self = [super initWithFrame:frame] )
    {
        self.backgroundColor = [UIColor whiteColor];
        self.userArray = [NSMutableArray array];
        
        [self initHeaderView];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, frame.size.width, frame.size.height)];
        [tableView registerClass:[FriendTableViewCell class] forCellReuseIdentifier:@"FriendTableCell"];
        [tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
        [tableView headerBeginRefreshing];
        tableView.tableHeaderView = headerView;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:tableView];
    }
    return self;
}

- ( void ) initHeaderView
{
    headerView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, 181 )];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel * tempLabel = [[UILabel alloc] initWithFrame:CGRectMake( 15, 15, 80, 20 )];
    tempLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    tempLabel.textColor = Color_Gray;
    tempLabel.text = @"我的资料";
    [headerView addSubview:tempLabel];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    myHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 20, 45, 50, 50 )];
    [myHeadImageView sd_setImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:@"headUrl"]] placeholderImage:[UIImage imageNamed:@"head_default"]];
    [headerView addSubview:myHeadImageView];
    
    NSString * name = [userDefaults objectForKey:@"name"];
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 80, 45, name.length * 16, 25 )];
    nameLabel.font = [UIFont systemFontOfSize:Text_Size_Big];
    nameLabel.text = name;
    [headerView addSubview:nameLabel];
    
    myPraiseCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 85, 45, 70, 20 )];
    myPraiseCountLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    myPraiseCountLabel.textAlignment = NSTextAlignmentRight;
    myPraiseCountLabel.textColor = Text_Red;
    myPraiseCountLabel.text = [NSString stringWithFormat:@"赞 %d", [[userDefaults objectForKey:@"praisedCount"] intValue]];
    [headerView addSubview:myPraiseCountLabel];
    
    UIImageView * sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake( [Tool getRight:nameLabel] + 20, 52, 13, 13 )];
    if( [[userDefaults objectForKey:@"sex"] intValue] == 0 )
    {
        [sexImageView setImage:[UIImage imageNamed:@"female_color"]];
    }
    else
    {
        [sexImageView setImage:[UIImage imageNamed:@"male_color"]];
    }
    [headerView addSubview:sexImageView];
    
    UILabel * pkuLabel = [[UILabel alloc] initWithFrame:CGRectMake( 80, 85, Screen_Width - 80, 20 )];
    pkuLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    pkuLabel.textColor = Color_Gray;
    pkuLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    pkuLabel.text = [NSString stringWithFormat:@"北京大学 %@", [Tool getPkuLongByShort:[userDefaults objectForKey:@"pku"]]];
    [headerView addSubview:pkuLabel];
    
    myJobLabel = [[UILabel alloc] initWithFrame:CGRectMake( 80, 110, Screen_Width - 80, 20 )];
    myJobLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    myJobLabel.textColor = Color_Gray;
    myJobLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    myJobLabel.text = [NSString stringWithFormat:@"%@ %@ %@", [userDefaults objectForKey:@"company"], [userDefaults objectForKey:@"department"], [userDefaults objectForKey:@"job"]];
    [headerView addSubview:myJobLabel];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake( 0, 140, Screen_Width, 10 )];
    line.backgroundColor = Color_Light_Gray;
    [headerView addSubview:line];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake( 15, 160, 30, 20 )];
    label.font = [UIFont systemFontOfSize:Text_Size_Small];
    label.textColor = Color_Gray;
    label.text = @"校友";
    [headerView addSubview:label];
    
    friendCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( 50, 163, 100, 15 )];
    friendCountLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
    friendCountLabel.textColor = Color_Gray;
    friendCountLabel.text = [NSString stringWithFormat:@"共%d人", 0];
    [headerView addSubview:friendCountLabel];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake( 10, 190, Screen_Width - 20, 1 )];
    line1.backgroundColor = Color_Light_Gray;
    [headerView addSubview:line1];
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUser)];
    [headerView addGestureRecognizer:recognizer];
}

- ( void ) clickUser
{
    if( [self.delegate respondsToSelector:@selector(clickMe)] )
    {
        [self.delegate clickMe];
    }
}

- ( void ) headerRereshing
{
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    if( [userDefaults objectForKey:@"friend_update_time"] == nil )
    {
        [request setValue:@"" forKey:@"after"];
    }
    else
    {
        [request setValue:[userDefaults objectForKey:@"friend_update_time"] forKey:@"after"];
    }
    [[NetWork shareInstance] httpRequestWithPostPut:@"api/users" params:request method:@"POST" success:^(NSDictionary * result)
     {
         int code = [result[ @"result"] intValue];
         if( code == 8000 )
         {
             [self loadSuccess:result];
         }
         else
         {
             [self loadFailed];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [self loadFailed];
     }];
}

- ( void ) loadSuccess : ( NSDictionary * ) result
{
    NSArray * array = result[ @"data" ];
    for( NSDictionary * item in array )
    {
        UserEntity * entity = [UserEntity new];
        
        [Tool loadUserInfoEntity:entity item:item];
        
        [self.userArray addObject:entity];
    }
    
    [tableView reloadData];
    [tableView headerEndRefreshing];
    
    friendCountLabel.text = [NSString stringWithFormat:@"共%d人", self.userArray.count];
}

- ( void ) reloadTable
{
    [tableView reloadData];
}

- ( void ) startRefresh
{
    [tableView headerBeginRefreshing];
}

- ( void ) loadFailed
{
    [tableView headerEndRefreshing];
    [tableView footerEndRefreshing];
    [SVProgressHUD showErrorWithStatus:@"刷新失败"];
}

- ( void ) updateSelectCell
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendTableViewCell * cell = [tableView1 dequeueReusableCellWithIdentifier:@"FriendTableCell"];
    if( !cell )
    {
        cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendTableCell"];
    }
    UserEntity * entity = [self.userArray objectAtIndex:indexPath.row];
    cell.entity = entity;
    [cell updateCell];
    return cell;
}

- ( CGFloat ) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 113;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
    
    if( [self.delegate respondsToSelector:@selector(clickItemAt:)] )
    {
        [self.delegate clickItemAt:[self.userArray objectAtIndex:indexPath.row]];
    }
}

@end
