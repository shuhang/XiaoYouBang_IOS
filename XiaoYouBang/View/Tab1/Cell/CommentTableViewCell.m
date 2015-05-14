//
//  CommentTableViewCell.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/30.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "CommentTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "Tool.h"

@implementation CommentTableViewCell

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
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 65, 17, 60, 15 )];
        timeLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
        timeLabel.textColor = Color_Gray;
        [self.contentView addSubview:timeLabel];
        
        indexLabel = [[UILabel alloc] initWithFrame:CGRectMake( 10, headImageView.frame.origin.y + 35, 30, 15)];
        indexLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
        indexLabel.textColor = Color_Gray;
        [self.contentView addSubview:indexLabel];
        
        infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        infoLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        infoLabel.textColor = Color_Heavy_Gray;
        infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        infoLabel.numberOfLines = 0;
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
    nameLabel.text = self.entity.userName;
    timeLabel.text = [Tool getShowTime:self.entity.time];
    indexLabel.text = [NSString stringWithFormat:@"%d评", self.commentIndex];
    
    CGFloat height = [Tool getHeightByString:self.entity.info width:Screen_Width - 75 height:99999999 textSize:Text_Size_Small];
    infoLabel.frame = CGRectMake( 60, indexLabel.frame.origin.y - 5, Screen_Width - 75, height );
    [infoLabel setAttributedText:[Tool getModifyString:self.entity.info]];
    [infoLabel sizeToFit];
    
    line.frame = CGRectMake( 10, [Tool getBottom:infoLabel] + 10, Screen_Width - 20, 0.5 );
}

@end
