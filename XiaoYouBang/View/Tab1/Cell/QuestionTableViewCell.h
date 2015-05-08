//
//  QuestionTableViewCell.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/21.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionEntity.h"

@interface QuestionTableViewCell : UITableViewCell
{
    UIImageView * headImageView;
    UIImageView * pictureSymbolImageView;
    UIImageView * pointImageView;
    UILabel * nameLabel;
    UILabel * titleLabel;
    UILabel * answerCountLabel;
    UILabel * praiseCountLabel;
    UILabel * commentCountLabel;
    UILabel * timeLabel;
    UILabel * myInviteLabel;
    UILabel * inviteMeLabel;
}

@property( nonatomic, strong ) QuestionEntity * entity;
/**
 *  for question
    type : 0 --> for all
    type : 1 --> for mine
 */
@property( nonatomic, assign ) int type;

- ( void ) updateCell : ( QuestionEntity * ) entity;

@end
