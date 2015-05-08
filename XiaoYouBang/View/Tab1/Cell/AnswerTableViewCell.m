//
//  AnwerTableViewCell.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/28.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "AnswerTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "Tool.h"

@implementation AnswerTableViewCell

- ( id ) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        self.backgroundColor = [UIColor whiteColor];
        
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 10, 15, 30, 30 )];
        [self.contentView addSubview:headImageView];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 60, 15, 70, 20 )];
        nameLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        [self.contentView addSubview:nameLabel];
        
        praiseCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 50, 15, 40, 15 )];
        praiseCountLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
        praiseCountLabel.textColor = Color_Gray;
        [self.contentView addSubview:praiseCountLabel];
        
        commentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( praiseCountLabel.frame.origin.x - 50, 15, 40, 15)];
        commentCountLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
        commentCountLabel.textColor = Color_Gray;
        [self.contentView addSubview:commentCountLabel];
        
        indexLabel = [[UILabel alloc] initWithFrame:CGRectMake( 10, headImageView.frame.origin.y + 35, 30, 15)];
        indexLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
        indexLabel.textColor = Color_Gray;
        [self.contentView addSubview:indexLabel];
        
        infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        infoLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        infoLabel.textColor = Color_Heavy_Gray;
        infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        infoLabel.numberOfLines = 3;
        [self.contentView addSubview:infoLabel];
        
        line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = Color_Light_Gray;
        [self.contentView addSubview:line];
    }
    return self;
}

- ( void ) updateCell
{
    [headImageView sd_setImageWithURL:[NSURL URLWithString:self.entity.userHeadUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    nameLabel.text = self.entity.name;
    commentCountLabel.text = [NSString stringWithFormat:@"评论 %d", self.entity.commentCount];
    praiseCountLabel.text = [NSString stringWithFormat:@"赞 %d", self.entity.praiseCount];
    indexLabel.text = [NSString stringWithFormat:@"%d答", self.answerIndex];
    
    CGFloat height = [Tool getHeightByString:self.entity.info width:Screen_Width - 75 height:60 textSize:Text_Size_Small];
    infoLabel.frame = CGRectMake( 60, indexLabel.frame.origin.y, Screen_Width - 75, height );
    infoLabel.text = self.entity.info;
    
    line.frame = CGRectMake( 10, [Tool getBottom:infoLabel] + 10, Screen_Width - 20, 0.5 );
}

@end
