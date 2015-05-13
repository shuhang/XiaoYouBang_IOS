//
//  QuestionTableViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/12.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "QuestionTableViewController.h"
#import "MJRefresh.h"
#import "NetWork.h"
#import "Tool.h"
#import "QuestionTableViewCell.h"
#import "JSONKit.h"
#import "SVProgressHUD.h"
#import "QuestionInfoViewController.h"

@interface QuestionTableViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView * tableView;
}
@end

@implementation QuestionTableViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    [self setupTitle:[NSString stringWithFormat:@"%@的提问 %d", self.userName, self.questionCount]];
    [self hideNextButton];
    
    self.questionArray = [NSMutableArray array];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height + 50 )];
    [tableView registerClass:[QuestionTableViewCell class] forCellReuseIdentifier:@"QuestionTableCell"];
    [tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    [tableView headerBeginRefreshing];
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
    [request setValue:[NSNumber numberWithInt:1] forKey:@"type"];
    
    NSString * url = [NSString stringWithFormat:@"api/user/%@/questions", self.userId];
    [[NetWork shareInstance] httpRequestWithPostPut:url params:request method:@"POST" success:^(NSDictionary * result)
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
    [request setValue:[NSNumber numberWithInt:1] forKey:@"type"];
    if( self.questionArray.count == 0 )
    {
        [request setValue:@"" forKey:@"before"];
    }
    else
    {
        QuestionEntity * entity = [self.questionArray objectAtIndex:self.questionArray.count - 1];
        [request setValue:entity.modifyTime forKey:@"before"];
    }
    NSString * url = [NSString stringWithFormat:@"api/user/%@/questions", self.userId];
    [[NetWork shareInstance] httpRequestWithPostPut:url params:request method:@"POST" success:^(NSDictionary * result)
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

- ( void ) doLoadQuestionInfo
{
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    NSString * url = [NSString stringWithFormat:@"api/question/%@", self.selectedEntity.questionId];
    [[NetWork shareInstance] httpRequestWithGet:url params:request success:^(NSDictionary * result)
     {
         if( [result[ @"result" ] intValue] == 3000 )
         {
             [Tool loadQuestionInfoEntity:self.selectedEntity item:result];
             [SVProgressHUD dismiss];
             QuestionInfoViewController * controller = [QuestionInfoViewController new];
             controller.entity = self.selectedEntity;
             [self.navigationController pushViewController:controller animated:YES];
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

- ( void ) updateSelectCell
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
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
    UILabel * titleLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel1.font = [UIFont systemFontOfSize:Text_Size_Big];
    titleLabel1.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel1.numberOfLines = 2;
    titleLabel1.frame = CGRectMake( 10, 0, Screen_Width - 20, 0 );
    [titleLabel1 setAttributedText:[Tool getModifyString:entity.questionTitle]];
    [titleLabel1 sizeToFit];
    CGFloat height = 101 + titleLabel1.frame.size.height;
    if( entity.myInviteArray.count > 0 ) height += 25;
    if( entity.inviteMeArray.count > 0 ) height += 25;
    return height;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndex = ( int )indexPath.row;
    self.selectedEntity = [self.questionArray objectAtIndex:indexPath.row];
    [self doLoadQuestionInfo];
}

@end
