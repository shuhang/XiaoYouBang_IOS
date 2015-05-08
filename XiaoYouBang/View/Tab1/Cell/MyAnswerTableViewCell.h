//
//  MyAnswerTableViewCell.h
//  XiaoYouBang
//
//  Created by shuhang on 15/5/2.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerEntity.h"

@protocol MyAnswerTableViewCellDelegate <NSObject>

- ( void ) clickQuestion : ( NSString * ) questionId;

@end

@interface MyAnswerTableViewCell : UITableViewCell
{
    UIImageView * headImageView;
    UIView * titleView;
    UILabel * titleLabel;
    UILabel * nameLabel;
    UILabel * timeLabel;
    UILabel * infoLabel;
    UILabel * praiseLabel;
    UILabel * commentLabel;
    UIView * line;
}

@property( nonatomic, strong ) AnswerEntity * entity;
@property( nonatomic, weak ) id< MyAnswerTableViewCellDelegate > delegate;

- ( void ) updateCell;

@end
