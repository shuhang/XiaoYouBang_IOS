//
//  AllQuestionView.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/20.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "AllActView.h"
#import "MJRefresh.h"
#import "NetWork.h"
#import "Tool.h"
#import "QuestionEntity.h"
#import "QuestionTableViewCell.h"
#import "JSONKit.h"

@interface AllActView()
{
    UITableView * tableView;
}
@end

@implementation AllActView

- ( id ) initWithFrame:(CGRect)frame
{
    if( self = [super initWithFrame:frame] )
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.actArray = [NSMutableArray array];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, frame.size.width, frame.size.height)];
        [tableView registerClass:[QuestionTableViewCell class] forCellReuseIdentifier:@"ActTableCell"];
        [tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
        [tableView headerBeginRefreshing];
        [tableView addFooterWithTarget:self action:@selector(footerRereshing)];
        tableView.headerPullToRefreshText = @"下拉刷新";
        tableView.headerReleaseToRefreshText = @"松开马上刷新";
        tableView.headerRefreshingText = @"正在刷新";
        tableView.footerPullToRefreshText = @"上拉加载更多";
        tableView.footerReleaseToRefreshText = @"松开加载更多";
        tableView.footerRefreshingText = @"正在加载";
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
    }
    return self;
}

- ( void ) loadFailed
{
    
}

- ( NSMutableArray * ) loadQuestionArray : ( NSDictionary * ) result
{
    NSMutableArray * array = [NSMutableArray new];
    NSArray * data = result[ @"data"];
    for( NSDictionary * item in data )
    {
        QuestionEntity * entity = [QuestionEntity new];
        
        [Tool loadQuestionTableEntity:entity item:item];
        
        [array addObject:entity];
    }
    
    return array;
}

- ( void ) headerRereshing
{
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    [request setValue:@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiI1NGMxMDBhZDQ5NzcwM2YwNGMxMTI5OGMiLCJleHAiOiIyMDE2LTA0LTE2IDEwOjUzOjAyICswODowMCJ9.wgW7lCEPg9LGFThzTIXJzpyHR1yuTckKOjviuCIkDv0" forKey:@"token"];
    [request setValue:[NSNumber numberWithInt:10] forKey:@"size"];
    [request setValue:@"" forKey:@"before"];
    [request setValue:[NSNumber numberWithInt:1] forKey:@"questionType"];
    
    [[NetWork shareInstance] httpRequestWithPostPut:@"api/questions/public" params:request success:^(NSDictionary * result)
     {
         int code = [result[ @"result"] intValue];
         if( code == 3000 )
         {
             self.actArray = [self loadQuestionArray:result];
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
    [request setValue:@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiI1NGMxMDBhZDQ5NzcwM2YwNGMxMTI5OGMiLCJleHAiOiIyMDE2LTA0LTE2IDEwOjUzOjAyICswODowMCJ9.wgW7lCEPg9LGFThzTIXJzpyHR1yuTckKOjviuCIkDv0" forKey:@"token"];
    [request setValue:[NSNumber numberWithInt:10] forKey:@"size"];
    [request setValue:[NSNumber numberWithInt:1] forKey:@"questionType"];
    if( self.actArray.count == 0 )
    {
        [request setValue:@"" forKey:@"before"];
    }
    else
    {
        QuestionEntity * entity = [self.actArray objectAtIndex:self.actArray.count - 1];
        [request setValue:entity.modifyTime forKey:@"before"];
    }
    
    [[NetWork shareInstance] httpRequestWithPostPut:@"api/questions/public" params:request success:^(NSDictionary * result)
     {
         NSNumber * code = [result objectForKey:@"result"];
         if( [code intValue] == 3000 )
         {
             NSMutableArray * temp = [self loadQuestionArray:result];
             NSMutableArray * old = [NSMutableArray arrayWithArray:self.actArray];
             for( QuestionEntity * entity in temp )
             {
                 [old addObject:entity];
             }
             self.actArray = old;
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
    return self.actArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionTableViewCell * cell = [tableView1 dequeueReusableCellWithIdentifier:@"ActTableCell"];
    if( !cell )
    {
        cell = [[QuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActTableCell"];
    }
    cell.type = 0;
    QuestionEntity * entity = [self.actArray objectAtIndex:indexPath.row];
    [cell updateCell:entity];
    return cell;
}

- ( CGFloat ) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionEntity * entity = [self.actArray objectAtIndex:indexPath.row];
    CGFloat height = 100 + [Tool getHeightByString:entity.title width:Screen_Width - 30 height:45 textSize:Text_Size_Big];
    if( entity.myInviteArray.count > 0 ) height += 25;
    if( entity.inviteMeArray.count > 0 ) height += 25;
    
    return height;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
}

@end