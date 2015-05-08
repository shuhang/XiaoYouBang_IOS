//
//  AnswerInfoView.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/30.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "AnswerInfoView.h"
#import "NetWork.h"
#import "MJRefresh.h"
#import "Tool.h"
#import "CommentTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "SVProgressHUD.h"

@implementation AnswerInfoView
{
    UITableView * tableView;
    
    UIView * headerView;
}

- ( id ) initWithFrame:(CGRect)frame entity:( AnswerEntity * ) entity
{
    if( self = [super initWithFrame:frame] )
    {
        self.backgroundColor = [UIColor whiteColor];
        self.entity = entity;
        
        [self initHeadView];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, frame.size.width, frame.size.height - 40 )];
        [tableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:@"CommentTableCell"];
        [tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
        //[tableView addFooterWithTarget:self action:@selector(footerRereshing)];
        tableView.tableHeaderView = headerView;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:tableView];
        
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        if( [self.entity.userId isEqualToString:[userDefaults objectForKey:@"userId"]] )
        {
            bottomView2 = [[UIView alloc] initWithFrame:CGRectMake( 0, frame.size.height - 90, Screen_Width, 40 )];
            bottomView2.backgroundColor = Color_Heavy_Gray;
            [self addSubview:bottomView2];
            
            buttonComment2 = [UIButton buttonWithType:UIButtonTypeCustom];
            buttonComment2.backgroundColor = Color_Gray;
            [buttonComment2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [buttonComment2 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            [buttonComment2 setTitle:@"评论" forState:UIControlStateNormal];
            buttonComment2.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
            [buttonComment2 addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
            [bottomView2 addSubview:buttonComment2];
            
            buttonEdit = [UIButton buttonWithType:UIButtonTypeCustom];
            buttonEdit.backgroundColor = Color_Gray;
            [buttonEdit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [buttonEdit setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            [buttonEdit setTitle:@"编辑回答" forState:UIControlStateNormal];
            buttonEdit.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
            [buttonEdit addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
            [bottomView2 addSubview:buttonEdit];
            
            buttonEdit.frame = CGRectMake( 50, 7, 90, 26 );
            buttonComment2.frame = CGRectMake( 180, 7, 90, 26 );
        }
        else
        {
            bottomView1 = [[UIView alloc] initWithFrame:CGRectMake( 0, frame.size.height - 90, Screen_Width, 40 )];
            bottomView1.backgroundColor = Color_Heavy_Gray;
            [self addSubview:bottomView1];
            
            buttonPraise = [UIButton buttonWithType:UIButtonTypeCustom];
            buttonPraise.backgroundColor = Color_Gray;
            [buttonPraise setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [buttonPraise setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            [buttonPraise setTitle:@"赞" forState:UIControlStateNormal];
            buttonPraise.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
            [buttonPraise addTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
            [bottomView1 addSubview:buttonPraise];
            
            buttonComment1 = [UIButton buttonWithType:UIButtonTypeCustom];
            buttonComment1.backgroundColor = Color_Gray;
            [buttonComment1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [buttonComment1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            [buttonComment1 setTitle:@"评论" forState:UIControlStateNormal];
            buttonComment1.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
            [buttonComment1 addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
            [bottomView1 addSubview:buttonComment1];
            
            buttonSave = [UIButton buttonWithType:UIButtonTypeCustom];
            buttonSave.backgroundColor = Color_Gray;
            [buttonSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [buttonSave setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            [buttonSave setTitle:@"收藏" forState:UIControlStateNormal];
            buttonSave.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
            [buttonSave addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
            [bottomView1 addSubview:buttonSave];
            
            buttonPraise.frame = CGRectMake( 15, 7, 90, 26 );
            buttonComment1.frame = CGRectMake( 115, 7, 90, 26 );
            buttonSave.frame = CGRectMake( 215, 7, 90, 26 );
            if( self.entity.hasPraised )
            {
                buttonPraise.backgroundColor = Bg_Red;
            }
        }
    }
    return self;
}

- ( void ) initHeadView
{
    headerView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, 0 )];
    
    questionTitleView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, 0 )];
    questionTitleView.backgroundColor = Color_Light_Gray;
    UITapGestureRecognizer * gestureQuestion = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickQuestion:)];
    [questionTitleView addGestureRecognizer:gestureQuestion];
    [headerView addSubview:questionTitleView];
    
    questionTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    questionTitleLabel.font = [UIFont systemFontOfSize:Text_Size_Big];
    questionTitleLabel.textColor = Color_Heavy_Gray;
    questionTitleLabel.numberOfLines = 2;
    questionTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [headerView addSubview:questionTitleLabel];
    
    userView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, 65 )];
    [headerView addSubview:userView];
    UITapGestureRecognizer * gestureHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUser:)];
    [userView addGestureRecognizer:gestureHead];
    
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 10, 10, 50, 50 )];
    [userView addSubview:headImageView];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    [userView addSubview:nameLabel];
    
    sexImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [userView addSubview:sexImageView];
    
    pkuLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    pkuLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    pkuLabel.textColor = Color_Heavy_Gray;
    [userView addSubview:pkuLabel];
    
    companyJobLabel = [[UILabel alloc] initWithFrame:CGRectMake( 75, 40, 240, 20 )];
    companyJobLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    companyJobLabel.textColor = Color_Heavy_Gray;
    [userView addSubview:companyJobLabel];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 65, 13, 60, 15 )];
    timeLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
    timeLabel.textColor = Color_Heavy_Gray;
    [userView addSubview:timeLabel];
    
    infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    infoLabel.font = [UIFont systemFontOfSize:Text_Size_Big];
    infoLabel.numberOfLines = 0;
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [headerView addSubview:infoLabel];
    
    praiseView = [[UIView alloc] initWithFrame:CGRectZero];
    praiseView.backgroundColor = Light_Red;
    [headerView addSubview:praiseView];
    
    praiseCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    praiseCountLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    praiseCountLabel.textColor = Text_Red;
    [headerView addSubview:praiseCountLabel];
    
    praiseUserLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    praiseUserLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    praiseUserLabel.textColor = Color_Heavy_Gray;
    [headerView addSubview:praiseUserLabel];
    
    commentCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    commentCountLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    [headerView addSubview:commentCountLabel];
    
    editLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    editLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
    editLabel.textColor = Color_Gray;
    [headerView addSubview:editLabel];
}

- ( void ) clickUser : (UITapGestureRecognizer *)tap
{
    if( [self.delegate respondsToSelector:@selector(clickUser)] )
    {
        [self.delegate clickUser];
    }
}

- ( void ) clickQuestion : (UITapGestureRecognizer *)tap
{
    if( [self.delegate respondsToSelector:@selector(clickQuestion)] )
    {
        [self.delegate clickQuestion];
    }
}

- ( void ) comment
{
    if( [self.delegate respondsToSelector:@selector(addComment)] )
    {
        [self.delegate addComment];
    }
}

- ( void ) praise
{
    if( [self.delegate respondsToSelector:@selector(praiseAnswer)] )
    {
        [self.delegate praiseAnswer];
    }
}

- ( void ) edit
{
    if( [self.delegate respondsToSelector:@selector(editAnswer)] )
    {
        [self.delegate editAnswer];
    }
}

- ( void ) save
{
    if( [self.delegate respondsToSelector:@selector(addSave)] )
    {
        [self.delegate addSave];
    }
}

- ( void ) updateHeader
{
    NSString * title = [NSString stringWithFormat:@"问题：%@", self.entity.questionTitle];
    questionTitleLabel.frame = CGRectMake( 10, 10, Screen_Width - 20, 0 );
    questionTitleLabel.text = title;
    [questionTitleLabel sizeToFit];
    
    questionTitleView.frame = CGRectMake( 0, 0, Screen_Width, questionTitleLabel.frame.size.height + 20 );
    
    userView.frame = CGRectMake( 0, [Tool getBottom:questionTitleView], Screen_Width, 65 );
    [headImageView sd_setImageWithURL:[NSURL URLWithString: self.entity.userHeadUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    nameLabel.frame = CGRectMake( 75, 10, self.entity.name.length * 13, 20 );
    nameLabel.text = self.entity.name;
    
    sexImageView.frame = CGRectMake( [Tool getRight:nameLabel] + 10, headImageView.frame.origin.y + 5, 10, 10 );
    if( self.entity.sex == 0 )
    {
        [sexImageView setImage:[UIImage imageNamed:@"female_color"]];
    }
    else
    {
        [sexImageView setImage:[UIImage imageNamed:@"male_color"]];
    }
    
    pkuLabel.frame = CGRectMake( [Tool getRight:sexImageView] + 10, headImageView.frame.origin.y, 90, 20 );
    pkuLabel.text = self.entity.pku;
    
    timeLabel.frame = CGRectMake( Screen_Width - 65, headImageView.frame.origin.y + 3, 60, 15 );
    timeLabel.text = [Tool getShowTime:self.entity.createTime];
    
    companyJobLabel.frame = CGRectMake( 75, headImageView.frame.origin.y + 30, 240, 20 );
    companyJobLabel.text = [NSString stringWithFormat:@"%@ %@", self.entity.company, self.entity.job];

    infoLabel.frame = CGRectMake( 10, [Tool getBottom:userView] + 10, Screen_Width - 20, 0 );
    infoLabel.text = self.entity.info;
    [infoLabel sizeToFit];
    
    if( self.entity.editTime == nil || [self.entity.editTime isEqualToString:@""] )
    {
        editLabel.frame = CGRectMake( infoLabel.frame.origin.x, [Tool getBottom:infoLabel], 0, 0 );
    }
    else
    {
        editLabel.frame = CGRectMake( infoLabel.frame.origin.x, [Tool getBottom:infoLabel] + 20, 150, 15 );
        editLabel.text = [NSString stringWithFormat:@"此回答编辑于 %@", [Tool getShowTime:self.entity.editTime]];
    }
    
    NSMutableString * users = [NSMutableString string];
    int count = [self.entity.praiseArray count];
    for( int i = 0; i < count; i ++ )
    {
        if( i != 0 )
        {
            [users appendString:@"、"];
        }
        [users appendString:[self.entity.praiseArray objectAtIndex:i]];
    }
    
    praiseCountLabel.frame = CGRectMake( 12, [Tool getBottom:editLabel] + 25, 45, 20 );
    praiseCountLabel.text = [NSString stringWithFormat:@"赞 %d", self.entity.praiseArray.count];
    
    praiseUserLabel.frame = CGRectMake( 60, praiseCountLabel.frame.origin.y + 3, Screen_Width - 70, 0 );
    praiseUserLabel.text = users;
    [praiseUserLabel sizeToFit];
    
    if( users.length != 0 )
    {
        praiseView.frame = CGRectMake( 0, [Tool getBottom:editLabel] + 15, Screen_Width, praiseUserLabel.frame.size.height + 20 );
    }
    else
    {
        praiseView.frame = CGRectMake( 0, [Tool getBottom:editLabel] + 15, Screen_Width, praiseCountLabel.frame.size.height + 20 );
    }
    
    commentCountLabel.frame = CGRectMake( 10, [Tool getBottom:praiseView] + 10, 150, 20 );
    commentCountLabel.text = [NSString stringWithFormat:@"评论 %d", self.entity.commentArray.count];
    
    headerView.frame = CGRectMake( 0, 0, Screen_Width, [Tool getBottom:commentCountLabel] );
}

- ( void ) updatePraiseButton
{
    buttonPraise.backgroundColor = Bg_Red;
}

- ( void ) updateSaveButton
{
    if( self.entity.isHasSaved )
    {
        [buttonSave setTitle:@"已收藏" forState:UIControlStateNormal];
    }
    else
    {
        [buttonSave setTitle:@"收藏" forState:UIControlStateNormal];
    }
}

- ( void ) updateTable
{
    commentCountLabel.text = [NSString stringWithFormat:@"评论 %d", self.entity.commentArray.count];
    tableView.tableHeaderView = headerView;
    [tableView reloadData];
}

- ( void ) headerRereshing
{
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    NSString * url = [NSString stringWithFormat:@"api/answer/%@", self.entity.answerId];
    [[NetWork shareInstance] httpRequestWithGet:url params:request success:^(NSDictionary * result)
     {
         if( [result[ @"result" ] intValue] == 4000 )
         {
             [Tool loadAnswerInfoEntity:self.entity item:result];
             NSMutableArray * commentArray = [NSMutableArray array];
             for( NSDictionary * comment in result[ @"comments" ] )
             {
                 CommentEntity * commentEntity = [CommentEntity new];
                 [Tool loadCommentInfoEntity:commentEntity item:comment];
                 [commentArray addObject:commentEntity];
             }
             self.entity.commentArray = commentArray;
             
             [self updateHeader];
             [self updateTable];
             [tableView headerEndRefreshing];
         }
         else
         {
             [tableView headerEndRefreshing];
             [SVProgressHUD showErrorWithStatus:@"加载失败"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [tableView headerEndRefreshing];
         [SVProgressHUD showErrorWithStatus:@"加载失败"];
     }];
}

- ( void ) footerRereshing
{
    
}

- ( void ) startRefresh
{
    [tableView headerBeginRefreshing];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.entity.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell * cell = [tableView1 dequeueReusableCellWithIdentifier:@"CommentTableCell"];
    if( !cell )
    {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentTableCell"];
    }
    CommentEntity * entity = [self.entity.commentArray objectAtIndex:indexPath.row];
    cell.entity = entity;
    cell.commentIndex = self.entity.commentCount - indexPath.row;
    [cell updateCell];
    return cell;
}

- ( CGFloat ) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentEntity * entity = [self.entity.commentArray objectAtIndex:indexPath.row];
    CGFloat height = [Tool getHeightByString:entity.info width:Screen_Width - 75 height:99999999 textSize:Text_Size_Small];
    
    return height + 60;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
    
    if( [self.delegate respondsToSelector:@selector(clickCommentAtIndex:)] )
    {
        [self.delegate clickCommentAtIndex:indexPath.row];
    }
}

@end
