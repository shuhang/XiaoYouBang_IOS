//
//  FriendTableViewCell.h
//  XiaoYouBang
//
//  Created by shuhang on 15/5/4.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEntity.h"

@interface FriendTableViewCell : UITableViewCell
{
    UIImageView * headImageView;
    UIImageView * sexImageView;
    UILabel * nameLabel;
    UILabel * praiseCountLabel;
    UILabel * pkuLabel;
    UILabel * jobLabel;
    UIView * line;
}

@property( nonatomic, strong ) UserEntity * entity;

- ( void ) updateCell;

@end
