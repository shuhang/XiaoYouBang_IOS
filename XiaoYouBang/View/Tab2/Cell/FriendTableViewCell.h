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
// 0 : friend
// 1 : invite
@property( nonatomic, assign ) int type;
// 0 : question
// 1 : act
@property( nonatomic, assign ) int inviteType;

- ( void ) updateCell;

@end
