//
//  CommentTableView.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/30.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "CommentTableView.h"
#import "MJRefresh.h"
#import "NetWork.h"
#import "Tool.h"
#import "CommentTableViewCell.h"
#import "CommentEntity.h"
#import "SVProgressHUD.h"

@interface CommentTableView()
{
    UITableView * tableView;
}
@end

@implementation CommentTableView

- ( id ) initWithFrame:(CGRect)frame
{
    if( self = [super initWithFrame:frame] )
    {
        self.backgroundColor = [UIColor whiteColor];
        
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
    if( self.type == 0 )
    {
        NSMutableDictionary * request = [NSMutableDictionary dictionary];
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
        [request setValue:@"" forKey:@"after"];
        
        NSString * url = [NSString stringWithFormat:@"api/question/%@/comments/update", self.questionId];
        [[NetWork shareInstance] httpRequestWithPostPut:url params:request method:@"POST" success:^(NSDictionary * result)
         {
             int code = [result[ @"result"] intValue];
             if( code == 3000 )
             {
                 self.commentArray = [Tool loadCommentArray:result[ @"data" ]];
                 self.commentCount = ( int )self.commentArray.count;
                 [tableView reloadData];
                 [tableView headerEndRefreshing];
                 
                 if( [self.delegate respondsToSelector:@selector(refreshSuccess)] )
                 {
                     [self.delegate refreshSuccess];
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
