//
//  ActInfoView.h
//  XiaoYouBang
//
//  Created by shuhang on 15/5/14.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionEntity.h"

@protocol ActInfoViewDelegate <NSObject>

- ( void ) praiseAct;
- ( void ) addComment;
- ( void ) addJoin;
- ( void ) addOrEditSum;
- ( void ) clickUser;
- ( void ) clickComment;
- ( void ) clickJoin;
- ( void ) editAct;
- ( void ) clickSumAtIndex : ( int ) index;

@end

@interface ActInfoView : UIView<UITableViewDataSource, UITableViewDelegate>
{
    UIImageView * headImageView;
    UIImageView * sexImageView;
    UIImageView * editImageView;
    UIButton * buttonPraise;
    UIButton * buttonAddSum;
    UIButton * buttonJoin;
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
    
    UILabel * joinCountLabel;
    UIImageView * joinImageView1;
    UILabel * joinNameLabel1;
    UILabel * joinIndexLabel1;
    UILabel * joinInfoLabel1;
    
    UIImageView * joinImageView2;
    UILabel * joinNameLabel2;
    UILabel * joinIndexLabel2;
    UILabel * joinInfoLabel2;
    
    UIImageView * joinImageView3;
    UILabel * joinNameLabel3;
    UILabel * joinIndexLabel3;
    UILabel * joinInfoLabel3;
    
    UIView * line1;
    UIView * line2;
    UIView * line3;
    UIView * line4;
    UIView * line5;
    UIView * line6;
    UIView * line7;
    
    UIView * userView;
    UIView * commentView;
    UIView * joinView;
}

@property( nonatomic, strong ) QuestionEntity * entity;
@property( nonatomic, weak ) id< ActInfoViewDelegate > delegate;

- ( void ) updateHeader;
- ( void ) updateTable;
- ( id ) initWithFrame:(CGRect)frame entity:( QuestionEntity * ) entity;

@end
