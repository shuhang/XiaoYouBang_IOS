//
//  FriendTableViewCell.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/4.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "FriendTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Tool.h"

@implementation FriendTableViewCell

- ( id ) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        self.backgroundColor = [UIColor whiteColor];
        
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 20, 15, 50, 50 )];
        [self.contentView addSubview:headImageView];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.font = [UIFont systemFontOfSize:Text_Size_Big];
        [self.contentView addSubview:nameLabel];
        
        praiseCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 115, 17, 100, 20 )];
        praiseCountLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        praiseCountLabel.textAlignment = NSTextAlignmentRight;
        praiseCountLabel.textColor = Text_Red;
        [self.contentView addSubview:praiseCountLabel];
        
        sexImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:sexImageView];
        
        pkuLabel = [[UILabel alloc] initWithFrame:CGRectMake( 80, 55, Screen_Width - 80, 20 )];
        pkuLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        pkuLabel.textColor = Color_Gray;
        pkuLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:pkuLabel];
        
        jobLabel = [[UILabel alloc] initWithFrame:CGRectMake( 80, 80, Screen_Width - 80, 20 )];
        jobLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        jobLabel.textColor = Color_Gray;
        jobLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:jobLabel];
        
        line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = Color_Light_Gray;
        [self.contentView addSubview:line];
    }
    return self;
}

- ( void ) updateCell
{
    [headImageView sd_setImageWithURL:[NSURL URLWithString:self.entity.headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    nameLabel.text = self.entity.name;
    nameLabel.frame = CGRectMake( 80, 15, self.entity.name.length * 16, 25 );
    
    sexImageView.frame = CGRectMake( [Tool getRight:nameLabel] + 20, 22, 13, 13 );
    if( self.entity.sex == 0 )
    {
        [sexImageView setImage:[UIImage imageNamed:@"female_color"]];
    }
    else
    {
        [sexImageView setImage:[UIImage imageNamed:@"male_color"]];
    }
    if( self.type == 0 )
    {
        praiseCountLabel.text = [NSString stringWithFormat:@"赞 %d", self.entity.praiseCount];
    }
    else if( self.type == 1 )
    {
        if( self.entity.hasInvited )
        {
            praiseCountLabel.text = @"该用户已邀请";
        }
        else if( self.entity.hasAnswered )
        {
            if( self.inviteType == 0 )
            {
                praiseCountLabel.text = @"该用户已作答";
            }
            else
            {
                praiseCountLabel.text = @"该用户已报名";
            }
        }
        else
        {
            praiseCountLabel.text = @"";
        }
    }
    pkuLabel.text = [NSString stringWithFormat:@"北京大学 %@", [Tool getPkuLongByShort:self.entity.pku]];
    jobLabel.text = [NSString stringWithFormat:@"%@ %@ %@", self.entity.job1, self.entity.job2, self.entity.job3];
    line.frame = CGRectMake( 10, [Tool getBottom:jobLabel] + 10, Screen_Width - 20, 0.5 );
}

@end
