//
//  QuestionInfoView.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/28.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "QuestionInfoView.h"
#import "NetWork.h"
#import "MJRefresh.h"
#import "AnswerTableViewCell.h"
#import "Tool.h"
#import <UIImageView+WebCache.h>
#import "SVProgressHUD.h"

@interface QuestionInfoView()
{
    UITableView * tableView;
    
    UIView * headerView;
}
@end

@implementation QuestionInfoView

- ( id ) initWithFrame:(CGRect)frame
{
    if( self = [super initWithFrame:frame] )
    {
        self.backgroundColor = [UIColor whiteColor];

        [self initHeadView];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, frame.size.width, frame.size.height)];
        [tableView registerClass:[AnswerTableViewCell class] forCellReuseIdentifier:@"AnswerTableCell"];
        [tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
        [tableView addFooterWithTarget:self action:@selector(footerRereshing)];
        tableView.tableHeaderView = headerView;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:tableView];
        
        [self judgeFooter];
    }
    return self;
}

- ( void ) initHeadView
{
    headerView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, 0 )];
   
    userView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, 65 )];
    [headerView addSubview:userView];
    UITapGestureRecognizer * gestureHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUser:)];
    [userView addGestureRecognizer:gestureHead];
    
    commentView = [[UIView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:commentView];
    UITapGestureRecognizer * gestureComment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickComment:)];
    [commentView addGestureRecognizer:gestureComment];
    
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 10, 15, 50, 50 )];
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
    
    companyJobLabel = [[UILabel alloc] initWithFrame:CGRectMake( 75, 45, 240, 20 )];
    companyJobLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    companyJobLabel.textColor = Color_Heavy_Gray;
    [userView addSubview:companyJobLabel];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 65, 18, 60, 15 )];
    timeLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
    timeLabel.textColor = Color_Heavy_Gray;
    [userView addSubview:timeLabel];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = [UIFont systemFontOfSize:Text_Size_Big];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [headerView addSubview:titleLabel];
    
    infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    infoLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    infoLabel.numberOfLines = 0;
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [headerView addSubview:infoLabel];
    
    editImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edit_gray"]];
    editImageView.frame = CGRectZero;
    [headerView addSubview:editImageView];
    
    buttonEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonEdit.frame = CGRectZero;
    [buttonEdit setTitle:@"编辑问题" forState:UIControlStateNormal];
    buttonEdit.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    [buttonEdit setTitleColor:Color_Gray forState:UIControlStateNormal];
    [buttonEdit setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [buttonEdit addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:buttonEdit];
    
    myInviteLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    myInviteLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
    myInviteLabel.textColor = Text_Red;
    [headerView addSubview:myInviteLabel];
    
    inviteMeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    inviteMeLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
    inviteMeLabel.textColor = Text_Red;
    [headerView addSubview:inviteMeLabel];
    
    praiseCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    praiseCountLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    praiseCountLabel.textColor = Color_Gray;
    [headerView addSubview:praiseCountLabel];
    
    praiseUserLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    praiseUserLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    praiseUserLabel.textColor = Color_Gray;
    [headerView addSubview:praiseUserLabel];
    
    buttonPraise = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonPraise addTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:buttonPraise];
    
    commentCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    commentCountLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    commentCountLabel.textColor = Color_Heavy_Gray;
    [commentView addSubview:commentCountLabel];
    
    editLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    editLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
    editLabel.textColor = Color_Gray;
    [headerView addSubview:editLabel];
    
    buttonComment = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonComment.backgroundColor = Blue_Stone;
    [buttonComment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonComment setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [buttonComment setTitle:@"评论/灌水" forState:UIControlStateNormal];
    buttonComment.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
    [buttonComment addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
    [commentView addSubview:buttonComment];
    /////
    commentImageView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
    [commentView addSubview:commentImageView1];
    
    commentNameLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
    commentNameLabel1.font = [UIFont systemFontOfSize:Text_Size_Micro];
    commentNameLabel1.textColor = Color_Heavy_Gray;
    [commentView addSubview:commentNameLabel1];
    
    commentInfoLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
    commentInfoLabel1.font = [UIFont systemFontOfSize:Text_Size_Small];
    commentInfoLabel1.textColor = Color_Gray;
    commentInfoLabel1.numberOfLines = 2;
    commentInfoLabel1.lineBreakMode = NSLineBreakByTruncatingTail;
    [commentView addSubview:commentInfoLabel1];
    
    commentIndexLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
    commentIndexLabel1.font = [UIFont systemFontOfSize:Text_Size_Super_Micro];
    commentIndexLabel1.textColor = Color_Gray;
    [commentView addSubview:commentIndexLabel1];
    /////
    commentImageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
    [commentView addSubview:commentImageView2];
    
    commentNameLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
    commentNameLabel2.font = [UIFont systemFontOfSize:Text_Size_Micro];
    commentNameLabel2.textColor = Color_Heavy_Gray;
    [commentView addSubview:commentNameLabel2];
    
    commentInfoLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
    commentInfoLabel2.font = [UIFont systemFontOfSize:Text_Size_Small];
    commentInfoLabel2.textColor = Color_Gray;
    commentInfoLabel2.numberOfLines = 2;
    commentInfoLabel2.lineBreakMode = NSLineBreakByTruncatingTail;
    [commentView addSubview:commentInfoLabel2];
    
    commentIndexLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
    commentIndexLabel2.font = [UIFont systemFontOfSize:Text_Size_Super_Micro];
    commentIndexLabel2.textColor = Color_Gray;
    [commentView addSubview:commentIndexLabel2];
    //////
    commentImageView3 = [[UIImageView alloc] initWithFrame:CGRectZero];
    [commentView addSubview:commentImageView3];
    
    commentNameLabel3 = [[UILabel alloc] initWithFrame:CGRectZero];
    commentNameLabel3.font = [UIFont systemFontOfSize:Text_Size_Micro];
    commentNameLabel3.textColor = Color_Heavy_Gray;
    [commentView addSubview:commentNameLabel3];
    
    commentInfoLabel3 = [[UILabel alloc] initWithFrame:CGRectZero];
    commentInfoLabel3.font = [UIFont systemFontOfSize:Text_Size_Small];
    commentInfoLabel3.textColor = Color_Gray;
    commentInfoLabel3.numberOfLines = 2;
    commentInfoLabel3.lineBreakMode = NSLineBreakByTruncatingTail;
    [commentView addSubview:commentInfoLabel3];
    
    commentIndexLabel3 = [[UILabel alloc] initWithFrame:CGRectZero];
    commentIndexLabel3.font = [UIFont systemFontOfSize:Text_Size_Super_Micro];
    commentIndexLabel3.textColor = Color_Gray;
    [commentView addSubview:commentIndexLabel3];
    
    buttonAddAnswer = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonAddAnswer.backgroundColor = Bg_Red;
    buttonAddAnswer.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Big];
    [buttonAddAnswer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonAddAnswer setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [buttonAddAnswer setTitle:@"添加回答" forState:UIControlStateNormal];
    [buttonAddAnswer addTarget:self action:@selector(addEditAnswer) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:buttonAddAnswer];
    
    buttonInvite = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonInvite.backgroundColor = Bg_Red;
    [buttonInvite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonInvite setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [buttonInvite setTitle:@"邀请回答" forState:UIControlStateNormal];
    buttonInvite.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Big];
    [buttonInvite addTarget:self action:@selector(invite) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:buttonInvite];
    
    answerCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    answerCountLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    answerCountLabel.textColor = Color_Heavy_Gray;
    [headerView addSubview:answerCountLabel];
    
    line1 = [[UIView alloc] initWithFrame:CGRectZero];
    line1.backgroundColor = Color_Light_Gray;
    [headerView addSubview:line1];
    
    line2 = [[UIView alloc] initWithFrame:CGRectZero];
    line2.backgroundColor = Color_Light_Gray;
    [headerView addSubview:line2];
    
    line3 = [[UIView alloc] initWithFrame:CGRectZero];
    line3.backgroundColor = Color_Light_Gray;
    [commentView addSubview:line3];
    
    line4 = [[UIView alloc] initWithFrame:CGRectZero];
    line4.backgroundColor = Color_Light_Gray;
    [headerView addSubview:line4];
}

- ( void ) invite
{
    if( [self.delegate respondsToSelector:@selector(inviteOther)] )
    {
        [self.delegate inviteOther];
    }
}

- ( void ) addEditAnswer
{
    if( [self.delegate respondsToSelector:@selector(addOrEditAnswer)] )
    {
        [self.delegate addOrEditAnswer];
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
    if( [self.delegate respondsToSelector:@selector(praiseQuestion)] )
    {
        [self.delegate praiseQuestion];
    }
}

- ( void ) edit
{
    if( [self.delegate respondsToSelector:@selector(editQuestion)] )
    {
        [self.delegate editQuestion];
    }
}

- ( void ) clickComment : (UITapGestureRecognizer *)tap
{
    if( [self.delegate respondsToSelector:@selector(clickComment)] )
    {
        [self.delegate clickComment];
    }
}

- ( void ) clickUser : (UITapGestureRecognizer *)tap
{
    if( [self.delegate respondsToSelector:@selector(clickUser)] )
    {
        [self.delegate clickUser];
    }
}

- ( void ) updateHeader
{
    [headImageView sd_setImageWithURL:[NSURL URLWithString: self.entity.userHeadUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    nameLabel.frame = CGRectMake( 75, 15, self.entity.userName.length * 13, 20 );
    nameLabel.text = self.entity.userName;
    
    sexImageView.frame = CGRectMake( [Tool getRight:nameLabel] + 10, 20, 10, 10 );
    if( self.entity.sex == 0 )
    {
        [sexImageView setImage:[UIImage imageNamed:@"female_color"]];
    }
    else
    {
        [sexImageView setImage:[UIImage imageNamed:@"male_color"]];
    }
    
    pkuLabel.frame = CGRectMake( [Tool getRight:sexImageView] + 10, 15, 90, 20 );
    pkuLabel.text = self.entity.pku;
    
    timeLabel.text = [Tool getShowTime:self.entity.createTime];
    
    companyJobLabel.text = [NSString stringWithFormat:@"%@ %@", self.entity.company, self.entity.job];

    titleLabel.frame = CGRectMake( 10, [Tool getBottom:headImageView] + 10, Screen_Width - 20, 0);
    titleLabel.text = self.entity.questionTitle;
    [titleLabel sizeToFit];
    
    infoLabel.frame = CGRectMake( 15, [Tool getBottom:titleLabel] + 10, Screen_Width - 25, 0 );
    infoLabel.text = self.entity.info;
    [infoLabel sizeToFit];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    if( [self.entity.editTime isEqualToString:@""] )
    {
        if( [self.entity.userId isEqualToString:[userDefaults objectForKey:@"userId"]] )
        {
            editImageView.frame = CGRectMake( Screen_Width - 83, [Tool getBottom:infoLabel] + 18, 12, 12 );
            buttonEdit.frame = CGRectMake( Screen_Width - 90, [Tool getBottom:infoLabel] + 10, 100, 30 );
            line1.frame = CGRectMake( 0, [Tool getBottom:buttonEdit] + 10, Screen_Width, 10 );
        }
        else
        {
            buttonEdit.hidden = YES;
            editImageView.hidden = YES;
            line1.frame = CGRectMake( 0, [Tool getBottom:infoLabel] + 20, Screen_Width, 10 );
        }
    }
    else
    {
        editLabel.frame = CGRectMake( infoLabel.frame.origin.x, [Tool getBottom:infoLabel] + 20, 150, 15 );
        editLabel.text = [NSString stringWithFormat:@"此问题编辑于 %@", [Tool getShowTime:self.entity.editTime]];
        
        if( [self.entity.userId isEqualToString:[userDefaults objectForKey:@"userId"]] )
        {
            editImageView.frame = CGRectMake( Screen_Width - 83, [Tool getBottom:editLabel] + 18, 12, 12 );
            buttonEdit.frame = CGRectMake( Screen_Width - 90, [Tool getBottom:editLabel] + 10, 100, 30 );
            line1.frame = CGRectMake( 0, [Tool getBottom:buttonEdit] + 10, Screen_Width, 10 );
        }
        else
        {
            buttonEdit.hidden = YES;
            editImageView.hidden = YES;
            line1.frame = CGRectMake( 0, [Tool getBottom:infoLabel] + 20, Screen_Width, 10 );
        }
    }
    
    praiseCountLabel.frame = CGRectMake( 12, [Tool getBottom:line1] + 12, 45, 20 );
    praiseCountLabel.text = [NSString stringWithFormat:@"赞 %d", self.entity.praiseArray.count];
    
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
    praiseUserLabel.frame = CGRectMake( 60, praiseCountLabel.frame.origin.y + 3, Screen_Width - 110, [Tool getHeightByString:users width:Screen_Width - 110 height:999999 textSize:Text_Size_Small]);
    praiseUserLabel.text = users;
    
    if( ![self.entity.userId isEqualToString:[userDefaults objectForKey:@"userId"]] )
    {
        buttonPraise.frame = CGRectMake( Screen_Width - 40, praiseCountLabel.frame.origin.y + 3, 15, 15 );
        if( self.entity.hasPraised )
        {
            [buttonPraise setImage:[UIImage imageNamed:@"praise_red"] forState:UIControlStateNormal];
        }
        else
        {
            [buttonPraise setImage:[UIImage imageNamed:@"praise_gray"] forState:UIControlStateNormal];
        }
    }
    
    line2.frame = CGRectMake( 0, [Tool getBottom:praiseUserLabel] + 15, Screen_Width, 10 );
    if( [users isEqualToString:@""] )
    {
        line2.frame = CGRectMake( 0, [Tool getBottom:praiseCountLabel] + 15, Screen_Width, 10 );
    }
    
    commentCountLabel.frame = CGRectMake( praiseCountLabel.frame.origin.x, 10, 150, 20 );
    commentCountLabel.text = [NSString stringWithFormat:@"问题的评论 %d", self.entity.commentArray.count];
    
    buttonComment.frame = CGRectMake( Screen_Width - 70, 10, 60, 20 );
    
    line3.frame = CGRectMake( 10, [Tool getBottom:buttonComment] + 5, Screen_Width - 20, 1 );

    if( self.entity.commentArray.count > 0 )
    {
        CommentEntity * entity1 = [self.entity.commentArray objectAtIndex:0];
        
        commentImageView1.frame = CGRectMake( commentCountLabel.frame.origin.x, [Tool getBottom:line3] + 15, 20, 20 );
        [commentImageView1 sd_setImageWithURL:[NSURL URLWithString:entity1.userHeadUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
        
        commentNameLabel1.frame = CGRectMake( [Tool getRight:commentImageView1] + 10, commentImageView1.frame.origin.y, 70, 15 );
        commentNameLabel1.text = entity1.userName;
        
        commentIndexLabel1.frame = CGRectMake( commentImageView1.frame.origin.x, [Tool getBottom:commentImageView1] + 5, 20, 10 );
        commentIndexLabel1.text = [NSString stringWithFormat:@"%d评", self.entity.commentArray.count];
        
        commentInfoLabel1.frame = CGRectMake( commentNameLabel1.frame.origin.x, commentIndexLabel1.frame.origin.y, Screen_Width - 50, [Tool getHeightByString:entity1.info width:Screen_Width - 50 height:40 textSize:Text_Size_Small]);
        commentInfoLabel1.text = entity1.info;
        
        if( self.entity.commentArray.count > 1 )
        {
            CommentEntity * entity2 = [self.entity.commentArray objectAtIndex:1];
            
            commentImageView2.frame = CGRectMake( commentCountLabel.frame.origin.x, [Tool getBottom:commentInfoLabel1] + 15, 20, 20 );
            [commentImageView2 sd_setImageWithURL:[NSURL URLWithString:entity2.userHeadUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
            
            commentNameLabel2.frame = CGRectMake( [Tool getRight:commentImageView2] + 10, commentImageView2.frame.origin.y, 70, 15 );
            commentNameLabel2.text = entity2.userName;
            
            commentIndexLabel2.frame = CGRectMake( commentImageView2.frame.origin.x, [Tool getBottom:commentImageView2] + 5, 20, 10 );
            commentIndexLabel2.text = [NSString stringWithFormat:@"%d评", self.entity.commentArray.count - 1];
            
            commentInfoLabel2.frame = CGRectMake( commentNameLabel2.frame.origin.x, commentIndexLabel2.frame.origin.y, Screen_Width - 50, [Tool getHeightByString:entity2.info width:Screen_Width - 50 height:40 textSize:Text_Size_Small]);
            commentInfoLabel2.text = entity2.info;
            
            if( self.entity.commentArray.count > 2 )
            {
                CommentEntity * entity3 = [self.entity.commentArray objectAtIndex:2];
                
                commentImageView3.frame = CGRectMake( commentCountLabel.frame.origin.x, [Tool getBottom:commentInfoLabel2] + 15, 20, 20 );
                [commentImageView3 sd_setImageWithURL:[NSURL URLWithString:entity3.userHeadUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
                
                commentNameLabel3.frame = CGRectMake( [Tool getRight:commentImageView3] + 10, commentImageView3.frame.origin.y, 70, 15 );
                commentNameLabel3.text = entity3.userName;
                
                commentIndexLabel3.frame = CGRectMake( commentImageView3.frame.origin.x, [Tool getBottom:commentImageView3] + 5, 20, 10 );
                commentIndexLabel3.text = [NSString stringWithFormat:@"%d评", self.entity.commentArray.count - 2];
                
                commentInfoLabel3.frame = CGRectMake( commentNameLabel3.frame.origin.x, commentIndexLabel3.frame.origin.y, Screen_Width - 50, [Tool getHeightByString:entity3.info width:Screen_Width - 50 height:40 textSize:Text_Size_Small]);
                commentInfoLabel3.text = entity3.info;
                
                commentView.frame = CGRectMake( 0, [Tool getBottom:line2], Screen_Width, [Tool getBottom:commentInfoLabel3] + 15  );
            }
            else
            {
                commentView.frame = CGRectMake( 0, [Tool getBottom:line2], Screen_Width, [Tool getBottom:commentInfoLabel2] + 15  );
            }
        }
        else
        {
            commentView.frame = CGRectMake( 0, [Tool getBottom:line2], Screen_Width, [Tool getBottom:commentInfoLabel1] + 15  );
        }
    }
    else
    {
        commentView.frame = CGRectMake( 0, [Tool getBottom:line2], Screen_Width, 76 );
    }
    line4.frame = CGRectMake( 0, [Tool getBottom:commentView], Screen_Width, 10 );
    
    buttonAddAnswer.frame = CGRectMake( 20, [Tool getBottom:line4] + 10, 132, 30 );
    if( self.entity.hasAnswered == YES )
    {
        buttonAddAnswer.backgroundColor = Color_Heavy_Gray;
        [buttonAddAnswer setTitle:@"编辑回答" forState:UIControlStateNormal];
    }
    buttonInvite.frame = CGRectMake( Screen_Width - 152, buttonAddAnswer.frame.origin.y, 132, 30 );
    
    answerCountLabel.frame = CGRectMake( commentCountLabel.frame.origin.x, [Tool getBottom:buttonAddAnswer] + 10, 100, 20 );
    answerCountLabel.text = [NSString stringWithFormat:@"回答 %d", self.entity.answerCount];
    
    headerView.frame = CGRectMake( 0, 0, Screen_Width, [Tool getBottom:answerCountLabel] );
    tableView.tableHeaderView = headerView;
}

- ( void ) updateTable
{
    answerCountLabel.text = [NSString stringWithFormat:@"回答 %d", self.entity.answerCount];
    [tableView reloadData];
}

- ( void ) judgeFooter
{
    if( self.entity.answerArray.count == self.entity.answerCount )
    {
        [tableView removeFooter];
    }
    else
    {
        [tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    }
}

- ( void ) headerRereshing
{
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    [request setValue:@"" forKey:@"after"];
    
    NSString * url = [NSString stringWithFormat:@"api/question/%@/update", self.entity.questionId];
    [[NetWork shareInstance] httpRequestWithPostPut:url params:request method:@"POST" success:^(NSDictionary * result)
     {
         NSNumber * code = [result objectForKey:@"result"];
         if( [code intValue] == 3000 )
         {
             [Tool loadQuestionInfoEntity:self.entity item:result];
             [self updateHeader];
             [tableView headerEndRefreshing];
             [self judgeFooter];
         }
         else
         {
             [tableView headerEndRefreshing];
             [SVProgressHUD showErrorWithStatus:@"刷新失败"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [tableView headerEndRefreshing];
         [SVProgressHUD showErrorWithStatus:@"刷新失败"];
     }];
}

- ( void ) loadMoreSuccess : ( NSArray * ) data
{
    NSArray * temp = [Tool loadAnswerArray:data];
    NSMutableArray * old  = [NSMutableArray arrayWithArray:self.entity.answerArray];
    for( QuestionEntity * item in temp )
    {
        [old addObject:item];
    }
    self.entity.answerArray = old;
    [tableView reloadData];
    [tableView footerEndRefreshing];
    [self judgeFooter];
}

- ( void ) footerRereshing
{
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    [request setValue:[NSNumber numberWithInt:10] forKey:@"size"];
    if( self.entity.answerArray.count > 0 )
    {
        AnswerEntity * answer = [self.entity.answerArray objectAtIndex:self.entity.answerArray.count - 1];
        [request setValue:answer.createTime forKey:@"before"];
    }
    else
    {
        [request setValue:@"" forKey:@"before"];
    }
    
    NSString * url = [NSString stringWithFormat:@"api/question/%@/answers", self.entity.questionId];
    [[NetWork shareInstance] httpRequestWithPostPut:url params:request method:@"POST" success:^(NSDictionary * result)
     {
         NSNumber * code = [result objectForKey:@"result"];
         if( [code intValue] == 4000 )
         {
             [self loadMoreSuccess:result[ @"data" ]];
             [tableView footerEndRefreshing];
         }
         else
         {
             [tableView footerEndRefreshing];
             [SVProgressHUD showErrorWithStatus:@"加载失败"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [tableView footerEndRefreshing];
         [SVProgressHUD showErrorWithStatus:@"加载失败"];
     }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.entity.answerArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerTableViewCell * cell = [tableView1 dequeueReusableCellWithIdentifier:@"AnswerTableCell"];
    if( !cell )
    {
        cell = [[AnswerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AnswerTableCell"];
    }
    AnswerEntity * entity = [self.entity.answerArray objectAtIndex:indexPath.row];
    cell.entity = entity;
    cell.answerIndex = self.entity.answerCount - indexPath.row;
    [cell updateCell];
    return cell;
}

- ( CGFloat ) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerEntity * entity = [self.entity.answerArray objectAtIndex:indexPath.row];
    CGFloat height = [Tool getHeightByString:entity.info width:Screen_Width - 75 height:60 textSize:Text_Size_Small];

    return height + 60;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
    
    if( [self.delegate respondsToSelector:@selector(clickAnswerAtIndex:)] )
    {
        [self.delegate clickAnswerAtIndex:indexPath.row];
    }
}


@end
