//
//  MyMessageView.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/28.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "MyMessageView.h"
#import "MJRefresh.h"
#import "NetWork.h"
#import "Tool.h"
#import "MessageTableViewCell.h"
#import "SVProgressHUD.h"
#import "MessageEntity.h"

@interface MyMessageView()
{
    UITableView * tableView;
}
@end

@implementation MyMessageView

- ( id ) initWithFrame:(CGRect)frame
{
    if( self = [super initWithFrame:frame] )
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.messageArray = [NSMutableArray array];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, frame.size.width, frame.size.height)];
        [tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:@"MessageTableCell"];
        [tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
        [tableView addFooterWithTarget:self action:@selector(footerRereshing)];
        [tableView headerBeginRefreshing];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:tableView];
    }
    return self;
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

- ( void ) headerRereshing
{
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    [request setValue:@"" forKey:@"updateTime"];
    
    [[NetWork shareInstance] httpRequestWithPostPut:@"api/mq" params:request method:@"POST" success:^(NSDictionary * result)
     {
         int code = [result[ @"result"] intValue];
         if( code == 8000 )
         {
             self.messageArray = [Tool loadMessageArray:result[ @"data" ]];
             [tableView reloadData];
             [tableView headerEndRefreshing];
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

- ( void ) footerRereshing
{
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    if( self.messageArray.count == 0 )
    {
        [request setValue:@"" forKey:@"before"];
    }
    else
    {
        MessageEntity * entity = [self.messageArray objectAtIndex:self.messageArray.count - 1];
        [request setValue:entity.time forKey:@"before"];
    }
    
    [[NetWork shareInstance] httpRequestWithPostPut:@"api/mq" params:request method:@"POST" success:^(NSDictionary * result)
     {
         NSNumber * code = [result objectForKey:@"result"];
         if( [code intValue] == 8000 )
         {
             NSMutableArray * temp = [Tool loadMessageArray:result[ @"data" ]];
             NSMutableArray * old = [NSMutableArray arrayWithArray:self.messageArray];
             for( MessageEntity * entity in temp )
             {
                 [old addObject:entity];
             }
             self.messageArray = old;
             [tableView reloadData];
             [tableView footerEndRefreshing];
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
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell * cell = [tableView1 dequeueReusableCellWithIdentifier:@"MessageTableCell"];
    if( !cell )
    {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageTableCell"];
    }
    MessageEntity * entity = [self.messageArray objectAtIndex:indexPath.row];
    cell.entity = entity;
    [cell updateCell];
    return cell;
}

- ( CGFloat ) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageEntity * entity = [self.messageArray objectAtIndex:indexPath.row];
    CGFloat height = [Tool getHeightByString:entity.info width:Screen_Width - 55 height:300 textSize:Text_Size_Small];
    
    return height + 90;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
    
    if( [self.delegate respondsToSelector:@selector(clickMessage:)] )
    {
        [self.delegate clickMessage:[self.messageArray objectAtIndex:indexPath.row]];
    }
}

@end
