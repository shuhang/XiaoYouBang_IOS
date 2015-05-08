//
//  AnwerTableViewCell.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/28.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerEntity.h"

@interface AnswerTableViewCell : UITableViewCell
{
    UIImageView * headImageView;
    UILabel * nameLabel;
    UILabel * commentCountLabel;
    UILabel * praiseCountLabel;
    UILabel * indexLabel;
    UILabel * infoLabel;
    UIView * line;
}

@property( nonatomic, assign ) int answerIndex;
@property( nonatomic, strong ) AnswerEntity * entity;

- ( void ) updateCell;

@end
