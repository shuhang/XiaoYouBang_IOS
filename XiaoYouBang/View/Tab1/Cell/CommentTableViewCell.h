//
//  CommentTableViewCell.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/30.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentEntity.h"

@interface CommentTableViewCell : UITableViewCell
{
    UIImageView * headImageView;
    UILabel * nameLabel;
    UILabel * timeLabel;
    UILabel * indexLabel;
    UILabel * infoLabel;
    UIView * line;
}

@property( nonatomic, strong ) CommentEntity * entity;
@property( nonatomic, assign ) int commentIndex;

- ( void ) updateCell;

@end
