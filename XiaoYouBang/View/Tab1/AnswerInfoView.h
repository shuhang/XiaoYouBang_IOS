//
//  AnswerInfoView.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/30.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerEntity.h"

@protocol AnswerInfoViewDelegate <NSObject>

- ( void ) praiseAnswer;
- ( void ) addComment;
- ( void ) addSave;
- ( void ) editAnswer;
- ( void ) clickUser;
- ( void ) clickCommentAtIndex : ( int ) index;
- ( void ) clickQuestion;

@end

@interface AnswerInfoView : UIView<UITableViewDataSource, UITableViewDelegate>
{
    UIImageView * headImageView;
    UIImageView * sexImageView;
    UIView * userView;
    UILabel * nameLabel;
    UILabel * pkuLabel;
    UILabel * timeLabel;
    UILabel * companyJobLabel;
    UILabel * questionTitleLabel;
    UIView * questionTitleView;
    UILabel * infoLabel;
    UILabel * inviteLabel;
    UILabel * editLabel;
    UIView * praiseView;
    UILabel * praiseCountLabel;
    UILabel * praiseUserLabel;
    UILabel * commentCountLabel;
    
    UIView * bottomView1;
    UIView * bottomView2;
    //
    UIButton * buttonPraise;
    UIButton * buttonComment1;
    UIButton * buttonSave;
    //
    UIButton * buttonEdit;
    UIButton * buttonComment2;
}

@property( nonatomic, strong ) AnswerEntity * entity;
@property( nonatomic, weak ) id< AnswerInfoViewDelegate > delegate;

- ( void ) updateHeader;
- ( void ) updateTable;
- ( void ) updatePraiseButton;
- ( void ) updateSaveButton;
- ( void ) startRefresh;
- ( id ) initWithFrame:(CGRect)frame entity:( AnswerEntity * ) entity;

@end
