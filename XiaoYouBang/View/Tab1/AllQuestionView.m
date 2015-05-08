//
//  AllQuestionView.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/20.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "AllQuestionView.h"
#import "MJRefresh.h"
#import "NetWork.h"
#import "Tool.h"
#import "QuestionEntity.h"
#import "QuestionTableViewCell.h"
#import "JSONKit.h"
#import "SVProgressHUD.h"

@interface AllQuestionView()
{
    UITableView * tableView;
}
@end

@implementation AllQuestionView

- ( id ) initWithFrame:(CGRect)frame
{
    if( self = [super initWithFrame:frame] )
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.questionArray = [NSMutableArray array];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, frame.size.width, frame.size.height)];
        [tableView registerClass:[QuestionTableViewCell class] forCellReuseIdentifier:@"QuestionTableCell"];
        [tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
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

- ( void ) startRefresh
{
    [tableView headerBeginRefreshing];
}

- ( void ) loadFailed
{
    [tableView headerEndRefreshing];
    [SVProgressHUD showErrorWithStatus:@"刷新失败"];
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
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    [request setValue:[NSNumber numberWithInt:10] forKey:@"size"];
    [request setValue:@"" forKey:@"before"];
    [request setValue:[NSNumber numberWithInt:0] forKey:@"questionType"];
    
    [[NetWork shareInstance] httpRequestWithPostPut:@"api/questions/public" params:request method:@"POST" success:^(NSDictionary * result)
    {
        int code = [result[ @"result"] intValue];
        if( code == 3000 )
        {
            self.questionArray = [self loadQuestionArray:result];
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
    [request setValue:[NSNumber numberWithInt:10] forKey:@"size"];
    [request setValue:[NSNumber numberWithInt:0] forKey:@"questionType"];
    if( self.questionArray.count == 0 )
    {
        [request setValue:@"" forKey:@"before"];
    }
    else
    {
        QuestionEntity * entity = [self.questionArray objectAtIndex:self.questionArray.count - 1];
        [request setValue:entity.modifyTime forKey:@"before"];
    }
    
    [[NetWork shareInstance] httpRequestWithPostPut:@"api/questions/public" params:request method:@"POST" success:^(NSDictionary * result)
     {
         NSNumber * code = [result objectForKey:@"result"];
         if( [code intValue] == 3000 )
         {
             NSMutableArray * temp = [self loadQuestionArray:result];
             NSMutableArray * old = [NSMutableArray arrayWithArray:self.questionArray];
             for( QuestionEntity * entity in temp )
             {
                 [old addObject:entity];
             }
             self.questionArray = old;
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
    return self.questionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionTableViewCell * cell = [tableView1 dequeueReusableCellWithIdentifier:@"QuestionTableCell"];
    if( !cell )
    {
        cell = [[QuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuestionTableCell"];
    }
    cell.type = 0;
    QuestionEntity * entity = [self.questionArray objectAtIndex:indexPath.row];
    [cell updateCell:entity];
    return cell;
}

- ( CGFloat ) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionEntity * entity = [self.questionArray objectAtIndex:indexPath.row];
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
