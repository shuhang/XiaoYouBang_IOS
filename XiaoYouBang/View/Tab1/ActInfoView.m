//
//  ActInfoView.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/14.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "ActInfoView.h"
#import "NetWork.h"
#import "MJRefresh.h"
#import "AnswerTableViewCell.h"
#import "Tool.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "UIButton+WebCache.h"

@interface ActInfoView()
{
    UITableView * tableView;
    
    UIView * headerView;
}
@end

@implementation ActInfoView

- ( id ) initWithFrame:(CGRect)frame entity:(QuestionEntity *)entity
{
    if( self = [super initWithFrame:frame] )
    {
        self.backgroundColor = [UIColor whiteColor];
        self.entity = entity;
        
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
    
    photoView = [[UIView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:photoView];
    
    userView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, 65 )];
    [headerView addSubview:userView];
    UITapGestureRecognizer * gestureHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUser:)];
    [userView addGestureRecognizer:gestureHead];
    
    commentView = [[UIView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:commentView];
    UITapGestureRecognizer * gestureComment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickComment:)];
    [commentView addGestureRecognizer:gestureComment];
    
    joinView = [[UIView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:joinView];
    UITapGestureRecognizer * gestureJoin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickJoin:)];
    [joinView addGestureRecognizer:gestureJoin];
    
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
    
    infoLabel = [[MyCopyLabel alloc] initWithFrame:CGRectZero];
    infoLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    infoLabel.numberOfLines = 0;
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [headerView addSubview:infoLabel];
    
    editImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edit_gray"]];
    editImageView.frame = CGRectZero;
    [headerView addSubview:editImageView];
    
    buttonEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonEdit.frame = CGRectZero;
    [buttonEdit setTitle:@"编辑活动" forState:UIControlStateNormal];
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
    
    editLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    editLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
    editLabel.textColor = Color_Gray;
    [headerView addSubview:editLabel];
    
    ///////////////////////////////////////////////
    joinCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    joinCountLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    joinCountLabel.textColor = Color_Heavy_Gray;
    [joinView addSubview:joinCountLabel];
    
    buttonJoin = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonJoin.backgroundColor = Green;
    [buttonJoin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonJoin setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [buttonJoin setTitle:@"" forState:UIControlStateNormal];
    buttonJoin.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
    [buttonJoin addTarget:self action:@selector(join) forControlEvents:UIControlEventTouchUpInside];
    [joinView addSubview:buttonJoin];
    /////
    joinImageView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
    [joinView addSubview:joinImageView1];
    
    joinNameLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
    joinNameLabel1.font = [UIFont systemFontOfSize:Text_Size_Micro];
    joinNameLabel1.textColor = Text_Green;
    [joinView addSubview:joinNameLabel1];
    
    joinInfoLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
    joinInfoLabel1.font = [UIFont systemFontOfSize:Text_Size_Small];
    joinInfoLabel1.textColor = Color_Gray;
    joinInfoLabel1.numberOfLines = 2;
    joinInfoLabel1.lineBreakMode = NSLineBreakByTruncatingTail;
    [joinView addSubview:joinInfoLabel1];
    
    joinIndexLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
    joinIndexLabel1.font = [UIFont systemFontOfSize:Text_Size_Super_Micro];
    joinIndexLabel1.textColor = Color_Gray;
    [joinView addSubview:joinIndexLabel1];
    /////
    joinImageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
    [joinView addSubview:joinImageView2];
    
    joinNameLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
    joinNameLabel2.font = [UIFont systemFontOfSize:Text_Size_Micro];
    joinNameLabel2.textColor = Text_Green;
    [joinView addSubview:joinNameLabel2];
    
    joinInfoLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
    joinInfoLabel2.font = [UIFont systemFontOfSize:Text_Size_Small];
    joinInfoLabel2.textColor = Color_Gray;
    joinInfoLabel2.numberOfLines = 2;
    joinInfoLabel2.lineBreakMode = NSLineBreakByTruncatingTail;
    [joinView addSubview:joinInfoLabel2];
    
    joinIndexLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
    joinIndexLabel2.font = [UIFont systemFontOfSize:Text_Size_Super_Micro];
    joinIndexLabel2.textColor = Color_Gray;
    [joinView addSubview:joinIndexLabel2];
    //////
    joinImageView3 = [[UIImageView alloc] initWithFrame:CGRectZero];
    [joinView addSubview:joinImageView3];
    
    joinNameLabel3 = [[UILabel alloc] initWithFrame:CGRectZero];
    joinNameLabel3.font = [UIFont systemFontOfSize:Text_Size_Micro];
    joinNameLabel3.textColor = Text_Green;
    [joinView addSubview:joinNameLabel3];
    
    joinInfoLabel3 = [[UILabel alloc] initWithFrame:CGRectZero];
    joinInfoLabel3.font = [UIFont systemFontOfSize:Text_Size_Small];
    joinInfoLabel3.textColor = Color_Gray;
    joinInfoLabel3.numberOfLines = 2;
    joinInfoLabel3.lineBreakMode = NSLineBreakByTruncatingTail;
    [joinView addSubview:joinInfoLabel3];
    
    joinIndexLabel3 = [[UILabel alloc] initWithFrame:CGRectZero];
    joinIndexLabel3.font = [UIFont systemFontOfSize:Text_Size_Super_Micro];
    joinIndexLabel3.textColor = Color_Gray;
    [joinView addSubview:joinIndexLabel3];
    ///////////////////////////////////////////////
    commentCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    commentCountLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    commentCountLabel.textColor = Color_Heavy_Gray;
    [commentView addSubview:commentCountLabel];
    
    buttonComment = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonComment.backgroundColor = Blue_Stone;
    [buttonComment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonComment setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [buttonComment setTitle:@"灌水/邀请" forState:UIControlStateNormal];
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
    
    buttonAddSum = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonAddSum.backgroundColor = Bg_Red;
    [buttonAddSum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonAddSum setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [buttonAddSum setTitle:@"" forState:UIControlStateNormal];
    buttonAddSum.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
    [buttonAddSum addTarget:self action:@selector(addEditAnswer) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:buttonAddSum];
    
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
    
    line5 = [[UIView alloc] initWithFrame:CGRectZero];
    line5.backgroundColor = Color_Light_Gray;
    [joinView addSubview:line5];
    
    line6 = [[UIView alloc] initWithFrame:CGRectZero];
    line6.backgroundColor = Color_Light_Gray;
    [headerView addSubview:line6];
    
    line7 = [[UIView alloc] initWithFrame:CGRectZero];
    line7.backgroundColor = Color_Light_Gray;
    [headerView addSubview:line7];
}

- ( void ) addEditAnswer
{
    if( [self.delegate respondsToSelector:@selector(addOrEditSum)] )
    {
        [self.delegate addOrEditSum];
    }
}

- ( void ) comment
{
    if( [self.delegate respondsToSelector:@selector(addComment)] )
    {
        [self.delegate addComment];
    }
}

- ( void ) join
{
    if( [self.delegate respondsToSelector:@selector(addJoin)] )
    {
        [self.delegate addJoin];
    }
}

- ( void ) praise
{
    if( [self.delegate respondsToSelector:@selector(praiseAct)] )
    {
        [self.delegate praiseAct];
    }
}

- ( void ) edit
{
    if( [self.delegate respondsToSelector:@selector(editAct)] )
    {
        [self.delegate editAct];
    }
}

- ( void ) clickComment : (UITapGestureRecognizer *)tap
{
    if( [self.delegate respondsToSelector:@selector(clickComment)] )
    {
        [self.delegate clickComment];
    }
}

- ( void ) clickJoin : (UITapGestureRecognizer *)tap
{
    if( [self.delegate respondsToSelector:@selector(clickJoin)] )
    {
        [self.delegate clickJoin];
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
    [titleLabel setAttributedText:[Tool getModifyString:self.entity.questionTitle]];
    [titleLabel sizeToFit];
    
    infoLabel.frame = CGRectMake( 15, [Tool getBottom:titleLabel] + 10, Screen_Width - 25, 0 );
    [infoLabel setAttributedText:[Tool getModifyString:self.entity.info]];
    [infoLabel sizeToFit];
    
    if( self.entity.hasImage )
    {
        int count = ( int ) self.entity.imageArray.count;
        int width = ( Screen_Width - 40 ) / 3;
        for( int i = 0; i < count; i ++ )
        {
            int row = i / 3;
            int index = i % 3;
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake( 15 + index * ( 5 + width ), row * ( 5 + width ), width, width );
            button.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [button setTag:i];
            [photoView addSubview:button];
            
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            NSString * url = [NSString stringWithFormat:@"%@%@", Image_Server_Url, [self.entity.imageArray objectAtIndex:i]];
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"picture"]];
        }
        
        int rowCount = ( count + 3 ) / 3;
        if( count % 3 == 0 ) rowCount --;
        photoView.frame = CGRectMake( 0, [Tool getBottom:infoLabel] + 10, Screen_Width, rowCount * width + ( rowCount - 1 ) * 5 );
    }
    else
    {
        photoView.frame = CGRectMake( 0, [Tool getBottom:infoLabel], 0, 0 );
    }
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    if( [self.entity.editTime isEqualToString:@""] )
    {
        if( [self.entity.userId isEqualToString:[userDefaults objectForKey:@"userId"]] )
        {
            editImageView.frame = CGRectMake( Screen_Width - 83, [Tool getBottom:photoView] + 18, 12, 12 );
            buttonEdit.frame = CGRectMake( Screen_Width - 90, [Tool getBottom:photoView] + 10, 100, 30 );
            line1.frame = CGRectMake( 0, [Tool getBottom:buttonEdit] + 10, Screen_Width, 10 );
        }
        else
        {
            buttonEdit.hidden = YES;
            editImageView.hidden = YES;
            line1.frame = CGRectMake( 0, [Tool getBottom:photoView] + 20, Screen_Width, 10 );
        }
    }
    else
    {
        editLabel.frame = CGRectMake( infoLabel.frame.origin.x, [Tool getBottom:photoView] + 20, 150, 15 );
        editLabel.text = [NSString stringWithFormat:@"此活动编辑于 %@", [Tool getShowTime:self.entity.editTime]];
        
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
            line1.frame = CGRectMake( 0, [Tool getBottom:editLabel] + 10, Screen_Width, 10 );
        }
    }
    
    praiseCountLabel.frame = CGRectMake( 12, [Tool getBottom:line1] + 12, 45, 20 );
    praiseCountLabel.text = [NSString stringWithFormat:@"赞 %lu", (unsigned long)self.entity.praiseArray.count];
    
    NSMutableString * users = [NSMutableString string];
    int count = ( int )[self.entity.praiseArray count];
    for( int i = 0; i < count; i ++ )
    {
        if( i != 0 )
        {
            [users appendString:@"、"];
        }
        [users appendString:[self.entity.praiseArray objectAtIndex:i]];
    }
    praiseUserLabel.frame = CGRectMake( 60, praiseCountLabel.frame.origin.y + 3, Screen_Width - 110, 0 );
    [praiseUserLabel setAttributedText:[Tool getModifyString:users]];
    [praiseUserLabel sizeToFit];
    
    if( ![self.entity.userId isEqualToString:[userDefaults objectForKey:@"userId"]] )
    {
        buttonPraise.frame = CGRectMake( Screen_Width - 50, [Tool getBottom:line1], 45, 45 );
        buttonPraise.imageEdgeInsets = UIEdgeInsetsMake( 15, 15, 15, 15 );
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
    
    ///////////////////////////////////
    joinCountLabel.frame = CGRectMake( praiseCountLabel.frame.origin.x, 10, 150, 20 );
    joinCountLabel.text = [NSString stringWithFormat:@"活动报名 %lu", (unsigned long)self.entity.joinArray.count];
    
    buttonJoin.frame = CGRectMake( Screen_Width - 70, 10, 60, 20 );
    if( self.entity.hasSigned )
    {
        [buttonJoin setTitle:@"修改报名" forState:UIControlStateNormal];
    }
    else
    {
        [buttonJoin setTitle:@"我要报名" forState:UIControlStateNormal];
    }
    
    line5.frame = CGRectMake( 10, [Tool getBottom:buttonJoin] + 5, Screen_Width - 20, 1 );
    
    if( self.entity.joinArray.count > 0 )
    {
        CommentEntity * entity1 = [self.entity.joinArray objectAtIndex:0];
        
        joinImageView1.frame = CGRectMake( joinCountLabel.frame.origin.x, [Tool getBottom:line5] + 15, 20, 20 );
        [joinImageView1 sd_setImageWithURL:[NSURL URLWithString:entity1.userHeadUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
        
        joinNameLabel1.frame = CGRectMake( [Tool getRight:joinImageView1] + 10, joinImageView1.frame.origin.y, 70, 15 );
        joinNameLabel1.text = entity1.userName;
        
        joinIndexLabel1.frame = CGRectMake( joinImageView1.frame.origin.x, [Tool getBottom:joinImageView1] + 5, 20, 10 );
        joinIndexLabel1.text = [NSString stringWithFormat:@"%lu报", (unsigned long)self.entity.joinArray.count];
        
        joinInfoLabel1.frame = CGRectMake( joinNameLabel1.frame.origin.x, joinIndexLabel1.frame.origin.y, Screen_Width - 50, [Tool getHeightByString:entity1.info width:Screen_Width - 50 height:40 textSize:Text_Size_Small]);
        joinInfoLabel1.text = entity1.info;
        
        if( self.entity.joinArray.count > 1 )
        {
            CommentEntity * entity2 = [self.entity.joinArray objectAtIndex:1];
            
            joinImageView2.frame = CGRectMake( joinCountLabel.frame.origin.x, [Tool getBottom:joinInfoLabel1] + 15, 20, 20 );
            [joinImageView2 sd_setImageWithURL:[NSURL URLWithString:entity2.userHeadUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
            
            joinNameLabel2.frame = CGRectMake( [Tool getRight:joinImageView2] + 10, joinImageView2.frame.origin.y, 70, 15 );
            joinNameLabel2.text = entity2.userName;
            
            joinIndexLabel2.frame = CGRectMake( joinImageView2.frame.origin.x, [Tool getBottom:joinImageView2] + 5, 20, 10 );
            joinIndexLabel2.text = [NSString stringWithFormat:@"%d报", ( int )self.entity.joinArray.count - 1];
            
            joinInfoLabel2.frame = CGRectMake( joinNameLabel2.frame.origin.x, joinIndexLabel2.frame.origin.y, Screen_Width - 50, [Tool getHeightByString:entity2.info width:Screen_Width - 50 height:40 textSize:Text_Size_Small]);
            joinInfoLabel2.text = entity2.info;
            
            if( self.entity.joinArray.count > 2 )
            {
                CommentEntity * entity3 = [self.entity.joinArray objectAtIndex:2];
                
                joinImageView3.frame = CGRectMake( joinCountLabel.frame.origin.x, [Tool getBottom:joinInfoLabel2] + 15, 20, 20 );
                [joinImageView3 sd_setImageWithURL:[NSURL URLWithString:entity3.userHeadUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
                
                joinNameLabel3.frame = CGRectMake( [Tool getRight:joinImageView3] + 10, joinImageView3.frame.origin.y, 70, 15 );
                joinNameLabel3.text = entity3.userName;
                
                joinIndexLabel3.frame = CGRectMake( joinImageView3.frame.origin.x, [Tool getBottom:joinImageView3] + 5, 20, 10 );
                joinIndexLabel3.text = [NSString stringWithFormat:@"%d报", ( int )self.entity.joinArray.count - 2];
                
                joinInfoLabel3.frame = CGRectMake( joinNameLabel3.frame.origin.x, joinIndexLabel3.frame.origin.y, Screen_Width - 50, [Tool getHeightByString:entity3.info width:Screen_Width - 50 height:40 textSize:Text_Size_Small]);
                joinInfoLabel3.text = entity3.info;
                
                joinView.frame = CGRectMake( 0, [Tool getBottom:line2], Screen_Width, [Tool getBottom:joinInfoLabel3] + 15  );
            }
            else
            {
                joinView.frame = CGRectMake( 0, [Tool getBottom:line2], Screen_Width, [Tool getBottom:joinInfoLabel2] + 15  );
            }
        }
        else
        {
            joinView.frame = CGRectMake( 0, [Tool getBottom:line2], Screen_Width, [Tool getBottom:joinInfoLabel1] + 15  );
        }
    }
    else
    {
        joinView.frame = CGRectMake( 0, [Tool getBottom:line2], Screen_Width, 76 );
    }
    
    line6.frame = CGRectMake( 0, [Tool getBottom:joinView], Screen_Width, 10 );
    ///////////////////////////////////
    commentCountLabel.frame = CGRectMake( praiseCountLabel.frame.origin.x, 10, 150, 20 );
    commentCountLabel.text = [NSString stringWithFormat:@"灌水/邀请 %lu", (unsigned long)self.entity.commentArray.count];
    
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
        commentIndexLabel1.text = [NSString stringWithFormat:@"%lu评", (unsigned long)self.entity.commentArray.count];
        
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
            commentIndexLabel2.text = [NSString stringWithFormat:@"%d评", ( int )self.entity.commentArray.count - 1];
            
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
                commentIndexLabel3.text = [NSString stringWithFormat:@"%d评", ( int )self.entity.commentArray.count - 2];
                
                commentInfoLabel3.frame = CGRectMake( commentNameLabel3.frame.origin.x, commentIndexLabel3.frame.origin.y, Screen_Width - 50, [Tool getHeightByString:entity3.info width:Screen_Width - 50 height:40 textSize:Text_Size_Small]);
                commentInfoLabel3.text = entity3.info;
                
                commentView.frame = CGRectMake( 0, [Tool getBottom:line6], Screen_Width, [Tool getBottom:commentInfoLabel3] + 15  );
            }
            else
            {
                commentView.frame = CGRectMake( 0, [Tool getBottom:line6], Screen_Width, [Tool getBottom:commentInfoLabel2] + 15  );
            }
        }
        else
        {
            commentView.frame = CGRectMake( 0, [Tool getBottom:line6], Screen_Width, [Tool getBottom:commentInfoLabel1] + 15  );
        }
    }
    else
    {
        commentView.frame = CGRectMake( 0, [Tool getBottom:line6], Screen_Width, 76 );
    }
    
    if( self.entity.myInviteArray.count > 0 )
    {
        myInviteLabel.hidden = NO;
        
        NSMutableString * myInviteText = [NSMutableString stringWithString:@"你邀请 "];
        
        InviteEntity * invite1 = [ self.entity.myInviteArray objectAtIndex:0];
        [myInviteText appendString:invite1.name];
        
        if( self.entity.myInviteArray.count > 1 )
        {
            [myInviteText appendString:@"、"];
            InviteEntity * invite2 = [ self.entity.myInviteArray objectAtIndex:1];
            [myInviteText appendString:invite2.name];
        }
        if( self.entity.myInviteArray.count > 2 )
        {
            [myInviteText appendString:[NSString stringWithFormat:@"等%lu人", (unsigned long)self.entity.myInviteArray.count]];
        }
        
        if( self.entity.type == 0 )
        {
            [myInviteText appendString:@" 回答"];
        }
        else if( self.entity.type == 1 )
        {
            [myInviteText appendString:@" 参加"];
        }
        
        myInviteLabel.text = myInviteText;
    }
    else
    {
        myInviteLabel.hidden = YES;
    }
    
    if( self.entity.inviteMeArray.count > 0 )
    {
        inviteMeLabel.hidden = NO;
        
        NSMutableString * inviteMeText = [NSMutableString stringWithString:@""];
        
        InviteEntity * invite1 = [self.entity.inviteMeArray objectAtIndex:0];
        [inviteMeText appendString:invite1.name];
        
        if( self.entity.inviteMeArray.count > 1 )
        {
            [inviteMeText appendString:@"、"];
            InviteEntity * invite2 = [self.entity.inviteMeArray objectAtIndex:1];
            [inviteMeText appendString:invite2.name];
        }
        if( self.entity.inviteMeArray.count > 2 )
        {
            [inviteMeText appendString:[NSString stringWithFormat:@"等%lu人", (unsigned long)self.entity.inviteMeArray.count]];
        }
        
        if( self.entity.type == 0 )
        {
            [inviteMeText appendString:@" 邀请你回答"];
        }
        else if( self.entity.type == 1 )
        {
            [inviteMeText appendString:@" 邀请你参加"];
        }
        
        inviteMeLabel.text = inviteMeText;
    }
    else
    {
        inviteMeLabel.hidden = YES;
    }
    
    if( self.entity.myInviteArray.count > 0 )
    {
        myInviteLabel.frame = CGRectMake( 10, [Tool getBottom:commentView], 200, 15 );
        if( self.entity.inviteMeArray.count > 0 )
        {
            inviteMeLabel.frame = CGRectMake( 10, myInviteLabel.frame.origin.y + 25, 200, 15 );
            
            line4.frame = CGRectMake( 10, [Tool getBottom:inviteMeLabel] + 10, Screen_Width - 20, 0.5 );
        }
        else
        {
            inviteMeLabel.frame = CGRectZero;
            line4.frame = CGRectMake( 10, [Tool getBottom:myInviteLabel] + 10, Screen_Width - 20, 0.5 );
        }
    }
    else if( self.entity.inviteMeArray.count > 0 )
    {
        myInviteLabel.frame = CGRectZero;
        inviteMeLabel.frame = CGRectMake( 10, [Tool getBottom:commentView], 200, 15 );
        line4.frame = CGRectMake( 10, [Tool getBottom:inviteMeLabel] + 10, Screen_Width - 20, 0.5 );
    }
    else
    {
        myInviteLabel.frame = CGRectZero;
        inviteMeLabel.frame = CGRectZero;
        line4.frame = CGRectMake( 0, [Tool getBottom:commentView], Screen_Width, 10 );
    }
    
    answerCountLabel.frame = CGRectMake( praiseCountLabel.frame.origin.x, [Tool getBottom:line4] + 10, 150, 20 );
    answerCountLabel.text = [NSString stringWithFormat:@"活动总结 %lu", (unsigned long)self.entity.answerCount];
    
    buttonAddSum.frame = CGRectMake( Screen_Width - 70, [Tool getBottom:line4] + 10, 60, 20 );
    if( self.entity.hasAnswered == YES )
    {
        buttonAddSum.backgroundColor = Color_Heavy_Gray;
        [buttonAddSum setTitle:@"编辑总结" forState:UIControlStateNormal];
    }
    else
    {
        [buttonAddSum setTitle:@"添加总结" forState:UIControlStateNormal];
    }
    
    line7.frame = CGRectMake( 10, [Tool getBottom:buttonAddSum] + 5, Screen_Width - 20, 1 );

    headerView.frame = CGRectMake( 0, 0, Screen_Width, [Tool getBottom:line7] + 10 );
    tableView.tableHeaderView = headerView;
}

- ( void ) clickButton : ( id ) sender
{
    UIButton * button = ( UIButton * ) sender;
    if( [self.delegate respondsToSelector:@selector(clickPictureAtIndex:)] )
    {
        [self.delegate clickPictureAtIndex:( int )button.tag];
    }
}

- ( void ) updateTable
{
    answerCountLabel.text = [NSString stringWithFormat:@"活动总结 %ld", (long)self.entity.answerCount];
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
    cell.answerIndex = ( int )( self.entity.answerCount - indexPath.row );
    [cell updateCell];
    return cell;
}

- ( CGFloat ) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerEntity * entity = [self.entity.answerArray objectAtIndex:indexPath.row];
    UILabel * tempLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tempLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    tempLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    tempLabel.numberOfLines = 3;
    tempLabel.frame = CGRectMake( 60, 0, Screen_Width - 75, 0 );
    [tempLabel setAttributedText:[Tool getModifyString:entity.info]];
    [tempLabel sizeToFit];
    CGFloat height = tempLabel.frame.size.height;
    
    return height + 63;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
    
    if( [self.delegate respondsToSelector:@selector(clickSumAtIndex:)] )
    {
        [self.delegate clickSumAtIndex:( int )indexPath.row];
    }
}

@end
