//
//  QuestionTableViewCell.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/21.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "QuestionTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "Tool.h"
#import "InviteEntity.h"

@implementation QuestionTableViewCell

- ( id ) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        self.backgroundColor = [UIColor whiteColor];
        
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 10, 15, 30, 30 )];
        [self.contentView addSubview:headImageView];
        
        pictureSymbolImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picture"]];
        pictureSymbolImageView.frame = CGRectMake( 140, 20, 15, 10 );
        [self.contentView addSubview:pictureSymbolImageView];
        
        pointImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"point"]];
        pointImageView.frame = CGRectMake( 300, 20, 5, 5 );
        [self.contentView addSubview:pointImageView];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 60, 15, 70, 20 )];
        nameLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        [self.contentView addSubview:nameLabel];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.font = [UIFont systemFontOfSize:Text_Size_Big];
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 2;
        [self.contentView addSubview:titleLabel];
        
        answerCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        answerCountLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        [self.contentView addSubview:answerCountLabel];
        
        praiseCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        praiseCountLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        [self.contentView addSubview:praiseCountLabel];
        
        commentCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        commentCountLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        [self.contentView addSubview:commentCountLabel];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:timeLabel];
        
        myInviteLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        myInviteLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
        myInviteLabel.textColor = Text_Red;
        [self.contentView addSubview:myInviteLabel];
        
        inviteMeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        inviteMeLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
        inviteMeLabel.textColor = Text_Red;
        [self.contentView addSubview:inviteMeLabel];
    }
    return self;
}

- ( void ) updateCell : ( QuestionEntity * ) entity_
{
    self.entity = entity_;
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString: self.entity.userHeadUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    if( self.entity.hasImage == NO )
    {
        pictureSymbolImageView.hidden = YES;
    }
    else
    {
        pictureSymbolImageView.hidden = NO;
    }
    
    if( self.entity.isNew )
    {
        pointImageView.hidden = YES;
    }
    else
    {
        pointImageView.hidden = NO;
    }
    
    nameLabel.text = self.entity.userName;
    titleLabel.text = self.entity.title;
    timeLabel.text = [Tool getShowByTime: self.entity.modifyTime];
    
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
            [myInviteText appendString:[NSString stringWithFormat:@"等%d人", self.entity.myInviteArray.count]];
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
            [inviteMeText appendString:[NSString stringWithFormat:@"等%d人邀请你", self.entity.inviteMeArray.count]];
        }
        
        if( self.entity.type == 0 )
        {
            [inviteMeText appendString:@"回答"];
        }
        else if( self.entity.type == 1 )
        {
            [inviteMeText appendString:@"参加"];
        }
        
        inviteMeLabel.text = inviteMeText;
    }
    else
    {
        inviteMeLabel.hidden = YES;
    }
    
    CGFloat titleHight = [Tool getHeightByString:self.entity.title width:Screen_Width - 30 height:45 textSize:Text_Size_Big];
    titleLabel.frame = CGRectMake( 10, 55, Screen_Width - 30, titleHight );
    
    answerCountLabel.frame = CGRectMake( 10, 55 + titleHight + 15, 70, 20 );
    praiseCountLabel.frame = CGRectMake( 90, answerCountLabel.frame.origin.y, 70, 20 );
    commentCountLabel.frame = CGRectMake( 170, answerCountLabel.frame.origin.y, 70, 20 );
    timeLabel.frame = CGRectMake( 260, answerCountLabel.frame.origin.y + 3, 50, 15 );
    
    if( self.entity.type == 0 )
    {
        if( self.type == 0 )
        {
            commentCountLabel.hidden = YES;
            
            answerCountLabel.text = [NSString stringWithFormat:@"回答 %d", self.entity.answerCount];
            praiseCountLabel.text = [NSString stringWithFormat:@"赞 %d", self.entity.praiseCount];
        }
        else
        {
            commentCountLabel.hidden = NO;
            
            answerCountLabel.text = [NSString stringWithFormat:@"回答 %d", self.entity.answerCount];
            praiseCountLabel.text = [NSString stringWithFormat:@"评论 %d", self.entity.commentCount];
            commentCountLabel.text = [NSString stringWithFormat:@"赞 %d", self.entity.praiseCount];
        }
    }
    else
    {
        commentCountLabel.hidden = NO;
        
        answerCountLabel.text = [NSString stringWithFormat:@"报名 %d", self.entity.joinCount];
        praiseCountLabel.text = [NSString stringWithFormat:@"赞 %d", self.entity.praiseCount];
        commentCountLabel.text = [NSString stringWithFormat:@"总结 %d", self.entity.answerCount];
    }
    
    if( self.entity.myInviteArray.count > 0 )
    {
        myInviteLabel.frame = CGRectMake( 10, answerCountLabel.frame.origin.y + 30, 200, 15 );
        if( self.entity.inviteMeArray.count > 0 )
        {
            inviteMeLabel.frame = CGRectMake( 10, myInviteLabel.frame.origin.y + 25, 200, 15 );
        }
    }
    else if( self.entity.inviteMeArray.count > 0 )
    {
        inviteMeLabel.frame = CGRectMake( 10, answerCountLabel.frame.origin.y + 30, 200, 15 );
    }
}

- ( void ) awakeFromNib {}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
