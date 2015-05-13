//
//  QuestionInfoView.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/28.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionEntity.h"

@protocol QuestionInfoViewDelegate <NSObject>

- ( void ) praiseQuestion;
- ( void ) addComment;
- ( void ) addOrEditAnswer;
- ( void ) inviteOther;
- ( void ) clickUser;
- ( void ) clickComment;
- ( void ) editQuestion;
- ( void ) clickAnswerAtIndex : ( int ) index;

@end

@interface QuestionInfoView : UIView<UITableViewDataSource, UITableViewDelegate>
{
    UIImageView * headImageView;
    UIImageView * sexImageView;
    UIImageView * editImageView;
    UIButton * buttonPraise;
    UIButton * buttonAddAnswer;
    UIButton * buttonInvite;
    UIButton * buttonEdit;
    UILabel * answerCountLabel;
    UILabel * nameLabel;
    UILabel * pkuLabel;
    UILabel * timeLabel;
    UILabel * companyJobLabel;
    UILabel * jobLabel;
    UILabel * titleLabel;
    UILabel * infoLabel;
    UILabel * myInviteLabel;
    UILabel * inviteMeLabel;
    UILabel * praiseCountLabel;
    UILabel * praiseUserLabel;
    UILabel * editLabel;
    
    UILabel * commentCountLabel;
    UIButton * buttonComment;
    UIImageView * commentImageView1;
    UILabel * commentNameLabel1;
    UILabel * commentIndexLabel1;
    UILabel * commentInfoLabel1;
    
    UIImageView * commentImageView2;
    UILabel * commentNameLabel2;
    UILabel * commentIndexLabel2;
    UILabel * commentInfoLabel2;
    
    UIImageView * commentImageView3;
    UILabel * commentNameLabel3;
    UILabel * commentIndexLabel3;
    UILabel * commentInfoLabel3;
    
    UIView * line1;
    UIView * line2;
    UIView * line3;
    UIView * line4;
    
    UIView * userView;
    UIView * commentView;
}

@property( nonatomic, strong ) QuestionEntity * entity;
@property( nonatomic, weak ) id< QuestionInfoViewDelegate > delegate;

- ( void ) updateHeader;
- ( void ) updateTable;
- ( id ) initWithFrame:(CGRect)frame entity:( QuestionEntity * ) entity;

@end
