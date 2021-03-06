//
//  MySaveView.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/28.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "MySaveView.h"
#import "MJRefresh.h"
#import "NetWork.h"
#import "Tool.h"
#import "MyAnswerTableViewCell.h"
#import "SVProgressHUD.h"

@interface MySaveView()<MyAnswerTableViewCellDelegate>
{
    UITableView * tableView;
}
@end

@implementation MySaveView

- ( id ) initWithFrame:(CGRect)frame
{
    if( self = [super initWithFrame:frame] )
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.answerArray = [NSMutableArray array];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, frame.size.width, frame.size.height)];
        [tableView registerClass:[MyAnswerTableViewCell class] forCellReuseIdentifier:@"MyAnswerTableCell"];
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

- ( NSMutableArray * ) loadAnswerArray : ( NSDictionary * ) result
{
    NSMutableArray * array = [NSMutableArray new];
    NSArray * data = result[ @"data"];
    for( NSDictionary * item in data )
    {
        AnswerEntity * entity = [AnswerEntity new];
        
        [Tool loadAnswerInfoEntity:entity item:item];
        
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
    [request setValue:[NSNumber numberWithInt:0] forKey:@"count"];
    
    [[NetWork shareInstance] httpRequestWithPostPut:@"api/user/saveanswers" params:request method:@"POST" success:^(NSDictionary * result)
     {
         int code = [result[ @"result"] intValue];
         if( code == 4000 )
         {
             self.answerArray = [self loadAnswerArray:result];
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
    if( self.answerArray.count == 0 )
    {
        [request setValue:[NSNumber numberWithInt:0] forKey:@"count"];
    }
    else
    {
        [request setValue:[NSNumber numberWithInt:self.answerArray.count] forKey:@"count"];
    }
    
    [[NetWork shareInstance] httpRequestWithPostPut:@"api/user/saveanswers" params:request method:@"POST" success:^(NSDictionary * result)
     {
         NSNumber * code = [result objectForKey:@"result"];
         if( [code intValue] == 4000 )
         {
             NSMutableArray * temp = [self loadAnswerArray:result];
             NSMutableArray * old = [NSMutableArray arrayWithArray:self.answerArray];
             for( QuestionEntity * entity in temp )
             {
                 [old addObject:entity];
             }
             self.answerArray = old;
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

- ( void ) doLoadQuestionInfo
{
    
}

- ( void ) updateSelectCell
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.answerArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAnswerTableViewCell * cell = [tableView1 dequeueReusableCellWithIdentifier:@"MyAnswerTableCell"];
    if( !cell )
    {
        cell = [[MyAnswerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyAnswerTableCell"];
    }
    AnswerEntity * entity = [self.answerArray objectAtIndex:indexPath.row];
    cell.entity = entity;
    cell.delegate = self;
    [cell updateCell];
    return cell;
}

- ( CGFloat ) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionEntity * entity = [self.answerArray objectAtIndex:indexPath.row];
    CGFloat height = [Tool getHeightByString:entity.info width:Screen_Width - 65 height:60 textSize:Text_Size_Small];
    
    return height + 125;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
    
    if( [self.delegate respondsToSelector:@selector(clickAnswer_save:)] )
    {
        [self.delegate clickAnswer_save:[self.answerArray objectAtIndex:indexPath.row]];
    }
}

#pragma mark MyAnswerTableViewCellDelegate
- ( void ) clickQuestion:(NSString *)questionId
{
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    NSString * url = [NSString stringWithFormat:@"api/question/%@", questionId];
    [[NetWork shareInstance] httpRequestWithGet:url params:request success:^(NSDictionary * result)
     {
         if( [result[ @"result" ] intValue] == 3000 )
         {
             QuestionEntity * entity = [QuestionEntity new];
             [Tool loadQuestionInfoEntity:entity item:result];
             [SVProgressHUD dismiss];
             if( [self.delegate respondsToSelector:@selector(loadQuestionSuccess_save:)] )
             {
                 [self.delegate loadQuestionSuccess_save:entity];
             }
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"加载失败"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [SVProgressHUD showErrorWithStatus:@"加载失败"];
     }];
}

@end
