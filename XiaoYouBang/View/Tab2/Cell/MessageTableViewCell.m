//
//  MessageTableViewCell.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/6.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "MessageTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "Tool.h"

@implementation MessageTableViewCell

- ( id ) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        bgView = [[UIView alloc] initWithFrame:CGRectMake( 0, 10, Screen_Width, 100 )];
        [self.contentView addSubview:bgView];
        
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 10, 40, 20, 20 )];
        [bgView addSubview:headImageView];
        
        titleLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel1.textColor = Color_Gray;
        titleLabel1.font = [UIFont systemFontOfSize:Text_Size_Micro];
        [bgView addSubview:titleLabel1];
        
        titleLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel2.textColor = Color_Gray;
        titleLabel2.font = [UIFont systemFontOfSize:Text_Size_Small];
        titleLabel2.lineBreakMode = NSLineBreakByTruncatingTail;
        [bgView addSubview:titleLabel2];
        
        middleLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
        middleLabel1.textColor = [UIColor blackColor];
        middleLabel1.font = [UIFont systemFontOfSize:Text_Size_Small];
        [bgView addSubview:middleLabel1];
        
        middleLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
        middleLabel2.textColor = Text_Red;
        middleLabel2.font = [UIFont systemFontOfSize:Text_Size_Small];
        [bgView addSubview:middleLabel2];
        
        infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        infoLabel.textColor = Color_Heavy_Gray;
        infoLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        infoLabel.numberOfLines = 2;
        infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [bgView addSubview:infoLabel];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 70, 25, 60, 45 )];
        timeLabel.textColor = Color_Heavy_Gray;
        timeLabel.font = [UIFont systemFontOfSize:Text_Size_Micro];
        [bgView addSubview:timeLabel];
        
        line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = Color_Heavy_Gray;
        [bgView addSubview:line];
    }
    return self;
}

- ( void ) updateCell
{
    [headImageView sd_setImageWithURL:[NSURL URLWithString: self.entity.headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    switch( self.entity.type )
    {
        case 0 :
        {
            bgView.backgroundColor = Color_Light_Gray;
            
            titleLabel1.text = @"问";
            titleLabel1.frame = CGRectMake( 10, 13, 15, 15 );
            
            titleLabel2.text = [NSString stringWithFormat:@"%@：%@", self.entity.titleUserName, self.entity.question];
            titleLabel2.frame = CGRectMake( 30, 10, Screen_Width - 40, 20 );
            
            timeLabel.text = [Tool getShowTime:self.entity.time];
            
            middleLabel1.text = [NSString stringWithFormat:@"%@ 回复我", self.entity.middleUserName];
            middleLabel1.frame = CGRectMake( 45, 40, 150, 20 );
            middleLabel2.frame = CGRectZero;
            
            infoLabel.frame = CGRectMake( 45, [Tool getBottom:middleLabel1] + 10, Screen_Width - 55, 0 );
            infoLabel.text = self.entity.info;
            [infoLabel sizeToFit];
            
            break;
        }
        case 1 :
        {
            bgView.backgroundColor = Color_Light_Gray;
            
            titleLabel1.text = @"答";
            titleLabel1.frame = CGRectMake( 10, 13, 15, 15 );
            
            titleLabel2.text = [NSString stringWithFormat:@"%@：%@", self.entity.titleUserName, self.entity.answer];
            titleLabel2.frame = CGRectMake( 30, 10, Screen_Width - 40, 20 );
            
            timeLabel.text = [Tool getShowTime:self.entity.time];
            
            middleLabel1.text = [NSString stringWithFormat:@"%@ 回复我", self.entity.middleUserName];
            middleLabel1.frame = CGRectMake( 45, 40, 150, 20 );
            middleLabel2.frame = CGRectZero;
            
            infoLabel.frame = CGRectMake( 45, [Tool getBottom:middleLabel1] + 10, Screen_Width - 55, 0 );
            infoLabel.text = self.entity.info;
            [infoLabel sizeToFit];
            
            break;
        }
        case 2 :
        {
            bgView.backgroundColor = Color_Light_Gray;
            
            titleLabel1.text = @"问";
            titleLabel1.frame = CGRectMake( 10, 13, 15, 15 );
            
            titleLabel2.text = [NSString stringWithFormat:@"%@：%@", self.entity.titleUserName, self.entity.question];
            titleLabel2.frame = CGRectMake( 30, 10, Screen_Width - 40, 20 );
            
            timeLabel.text = [Tool getShowTime:self.entity.time];
            
            middleLabel1.text = self.entity.middleUserName;
            middleLabel1.frame = CGRectMake( 45, 40, self.entity.middleUserName.length * 13, 20 );
            middleLabel2.text = @" 邀请我回答";
            middleLabel2.frame = CGRectMake( 45 + self.entity.middleUserName.length * 13, 40, 100, 20 );
            
            infoLabel.frame = CGRectMake( 45, [Tool getBottom:middleLabel1] + 10, Screen_Width - 55, 0 );
            infoLabel.text = self.entity.info;
            [infoLabel sizeToFit];
            
            break;
        }
        case 3 :
        {
            bgView.backgroundColor = Super_Light_Red;
            
            titleLabel1.frame = CGRectZero;
            
            titleLabel2.text = @"校友录";
            titleLabel2.frame = CGRectMake( 10, 10, 80, 20 );
            
            timeLabel.text = [Tool getShowTime:self.entity.time];
            
            middleLabel1.text = self.entity.middleUserName;
            middleLabel1.frame = CGRectMake( 45, 40, self.entity.middleUserName.length * 13, 20 );
            middleLabel2.text = @" 新人报到";
            middleLabel2.frame = CGRectMake( 45 + self.entity.middleUserName.length * 13, 40, 120, 20 );
            
            infoLabel.frame = CGRectMake( 45, [Tool getBottom:middleLabel1] + 10, Screen_Width - 55, 0 );
            infoLabel.text = self.entity.info;
            [infoLabel sizeToFit];
            
            break;
        }
        case 4 :
        {
            bgView.backgroundColor = Color_Light_Gray;
            
            titleLabel1.frame = CGRectZero;
            
            titleLabel2.text = @"留言板";
            titleLabel2.frame = CGRectMake( 10, 10, 80, 20 );
            
            timeLabel.text = [Tool getShowTime:self.entity.time];
            
            if( self.entity.titleUserName.length == 0 )
            {
                middleLabel1.text = [NSString stringWithFormat:@"%@ 给我留言", self.entity.middleUserName];
            }
            else
            {
                middleLabel1.text = [NSString stringWithFormat:@"%@ 回复 %@", self.entity.middleUserName, self.entity.titleUserName];
            }
            middleLabel1.frame = CGRectMake( 45, 40, 150, 20 );
            middleLabel2.frame = CGRectZero;
            
            infoLabel.frame = CGRectMake( 45, [Tool getBottom:middleLabel1] + 10, Screen_Width - 55, 0 );
            infoLabel.text = self.entity.info;
            [infoLabel sizeToFit];
            
            break;
        }
        case 5 :
        {
            bgView.backgroundColor = Color_Light_Gray;
            
            titleLabel1.frame = CGRectZero;
            
            titleLabel2.text = [NSString stringWithFormat:@"%@的留言板", self.entity.titleUserName];
            titleLabel2.frame = CGRectMake( 10, 10, 80, 20 );
            
            timeLabel.text = [Tool getShowTime:self.entity.time];
            
            middleLabel1.text = [NSString stringWithFormat:@"%@ 回复我", self.entity.middleUserName];
            middleLabel1.frame = CGRectMake( 45, 40, 150, 20 );
            middleLabel2.frame = CGRectZero;
            
            infoLabel.frame = CGRectMake( 45, [Tool getBottom:middleLabel1] + 10, Screen_Width - 55, 0 );
            infoLabel.text = self.entity.info;
            [infoLabel sizeToFit];
            
            break;
        }
        case 6 :
        {
            bgView.backgroundColor = Color_Light_Gray;
            
            titleLabel1.text = @"活动";
            titleLabel1.frame = CGRectMake( 10, 13, 30, 15 );
            
            titleLabel2.text = [NSString stringWithFormat:@"%@：%@", self.entity.titleUserName, self.entity.question];
            titleLabel2.frame = CGRectMake( 45, 10, Screen_Width - 40, 20 );
            
            timeLabel.text = [Tool getShowTime:self.entity.time];
            
            middleLabel1.text = self.entity.middleUserName;
            middleLabel1.frame = CGRectMake( 45, 40, self.entity.middleUserName.length * 13, 20 );
            middleLabel2.text = @" 邀请我参加";
            middleLabel2.frame = CGRectMake( 45 + self.entity.middleUserName.length * 13, 40, 100, 20 );
            
            infoLabel.frame = CGRectMake( 45, [Tool getBottom:middleLabel1] + 10, Screen_Width - 55, 0 );
            infoLabel.text = self.entity.info;
            [infoLabel sizeToFit];
            
            break;
        }
    }
    
    bgView.frame = CGRectMake( 0, 10, Screen_Width, [Tool getBottom:infoLabel] + 10 );
    line.frame = CGRectMake( 0, [Tool getBottom:infoLabel] + 9.5, Screen_Width, 0.5 );
}

@end
