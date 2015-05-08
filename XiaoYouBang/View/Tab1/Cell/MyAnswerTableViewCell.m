//
//  MyAnswerTableViewCell.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/2.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "MyAnswerTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "Tool.h"

@implementation MyAnswerTableViewCell

- ( id ) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        self.backgroundColor = [UIColor whiteColor];
        
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 10, 45, 30, 30)];
        [self.contentView addSubview:headImageView];
        
        titleView = [[UIView alloc] initWithFrame:CGRectMake( 10, 5, Screen_Width - 20, 30 )];
        titleView.backgroundColor = Color_Light_Gray;
        UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickQuestion)];
        [titleView addGestureRecognizer:recognizer];
        [self.contentView addSubview:titleView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 15, 10, Screen_Width - 30, 20 )];
        titleLabel.textColor = Color_Heavy_Gray;
        titleLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        titleLabel.numberOfLines = 1;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:titleLabel];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 55, 45, 100, 20 )];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        [self.contentView addSubview:nameLabel];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 70, 48, 60, 15)];
        timeLabel.textColor = Color_Heavy_Gray;
        timeLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
        timeLabel.numberOfLines = 1;
        timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:timeLabel];
        
        infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        infoLabel.textColor = Color_Heavy_Gray;
        infoLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        infoLabel.numberOfLines = 3;
        infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:infoLabel];
        
        praiseLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        praiseLabel.textColor = Color_Heavy_Gray;
        praiseLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        praiseLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:praiseLabel];
        
        commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        commentLabel.textColor = Color_Heavy_Gray;
        commentLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        commentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:commentLabel];
        
        line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = Color_Light_Gray;
        [self.contentView addSubview:line];
    }
    return self;
}

- ( void ) updateCell
{
    [headImageView sd_setImageWithURL:[NSURL URLWithString:self.entity.userHeadUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    titleLabel.text = [NSString stringWithFormat:@"%@：%@", self.entity.questionerName, self.entity.questionTitle];
    nameLabel.text = self.entity.name;
    timeLabel.text = [Tool getShowTime:self.entity.createTime];
    
    infoLabel.frame= CGRectMake( 55, 80, Screen_Width - 65, [Tool getHeightByString:self.entity.info width:Screen_Width - 65 height:60 textSize:Text_Size_Small] );
    infoLabel.text = self.entity.info;
    
    commentLabel.frame = CGRectMake( Screen_Width - 60, [Tool getBottom:infoLabel] + 15, 50, 20 );
    commentLabel.text = [NSString stringWithFormat:@"评论 %d", self.entity.commentCount];
    
    praiseLabel.frame = CGRectMake( Screen_Width - 110, commentLabel.frame.origin.y, 40, 20 );
    praiseLabel.text = [NSString stringWithFormat:@"赞 %d", self.entity.praiseCount];
    
    line.frame = CGRectMake( 10, [Tool getBottom:commentLabel] + 10, Screen_Width - 20, 0.5 );
}

- ( void ) clickQuestion
{
    if( [self.delegate respondsToSelector:@selector(clickQuestion:)] )
    {
        [self.delegate clickQuestion:self.entity.questionId];
    }
}

@end
