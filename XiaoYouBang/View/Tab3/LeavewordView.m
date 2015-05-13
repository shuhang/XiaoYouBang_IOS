//
//  LeavewordView.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/13.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "LeavewordView.h"
#import "MJRefresh.h"
#import "NetWork.h"
#import "Tool.h"
#import "CommentTableViewCell.h"
#import "CommentEntity.h"
#import "SVProgressHUD.h"

@interface LeavewordView()
{
    UITableView * tableView;
}
@end

@implementation LeavewordView

- ( id ) initWithFrame:(CGRect)frame
{
    if( self = [super initWithFrame:frame] )
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.commentArray = [NSMutableArray array];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, frame.size.width, frame.size.height)];
        [tableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:@"CommentTableCell"];
        [tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
        //[tableView addFooterWithTarget:self action:@selector(footerRereshing)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:tableView];
    }
    return self;
}

- ( int ) getCommentCount
{
    return ( int )self.commentArray.count;
}

- ( void ) addComment:(CommentEntity *)comment
{
    [self.commentArray insertObject:comment atIndex:0];
    [tableView reloadData];
}

- ( void ) addSelfHeaderView:(UIView *)view
{
    tableView.tableHeaderView = view;
}

- ( void ) updateTable
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

- ( void ) headerRereshing
{
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    [request setValue:@"" forKey:@"after"];
    
    NSString * url = [NSString stringWithFormat:@"api/user/%@/comments", self.userId];
    [[NetWork shareInstance] httpRequestWithPostPut:url params:request method:@"POST" success:^(NSDictionary * result)
     {
         int code = [result[ @"result"] intValue];
         if( code == 4000 )
         {
             self.commentArray = [Tool loadCommentArray:result[ @"comments" ]];
             [tableView reloadData];
             [tableView headerEndRefreshing];
             
             if( [self.delegate respondsToSelector:@selector(refreshSuccess:)] )
             {
                 [self.delegate refreshSuccess:result[ @"leaveWord" ]];
             }
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell * cell = [tableView1 dequeueReusableCellWithIdentifier:@"CommentTableCell"];
    if( !cell )
    {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentTableCell"];
    }
    CommentEntity * entity = [self.commentArray objectAtIndex:indexPath.row];
    cell.entity = entity;
    cell.commentIndex = ( int )( self.commentArray.count - indexPath.row );
    [cell updateCell];
    return cell;
}

- ( CGFloat ) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentEntity * entity = [self.commentArray objectAtIndex:indexPath.row];
    UILabel * tempLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tempLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    tempLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    tempLabel.numberOfLines = 0;
    tempLabel.frame = CGRectMake( 60, 0, Screen_Width - 75, 0 );
    [tempLabel setAttributedText:[Tool getModifyString:entity.info]];
    [tempLabel sizeToFit];
    CGFloat height = tempLabel.frame.size.height;
    
    return height + 60;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
    
    if( [self.delegate respondsToSelector:@selector(clickCommentAtIndex:)] )
    {
        [self.delegate clickCommentAtIndex:( int )indexPath.row];
    }
}

@end
