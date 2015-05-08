//
//  MessageTableViewCell.h
//  XiaoYouBang
//
//  Created by shuhang on 15/5/6.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageEntity.h"

@interface MessageTableViewCell : UITableViewCell
{
    UIImageView * headImageView;
    UIView * bgView;
    UIView * line;
    UILabel * titleLabel1;
    UILabel * titleLabel2;
    UILabel * middleLabel1;
    UILabel * middleLabel2;
    UILabel * infoLabel;
    UILabel * timeLabel;
}

@property( nonatomic, strong ) MessageEntity * entity;

- ( void ) updateCell;

@end
