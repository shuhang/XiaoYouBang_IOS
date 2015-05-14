//
//  InviteViewController.h
//  XiaoYouBang
//
//  Created by shuhang on 15/5/12.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "BaseViewController.h"

@interface InviteViewController : BaseViewController

@property( nonatomic, strong ) NSArray * arrayInviters;
@property( nonatomic, strong ) NSMutableArray * arrayUsers;
@property( nonatomic, strong ) NSMutableArray * arrayJoin;
@property( nonatomic, strong ) NSString * questionId;

@property( nonatomic, strong ) NSString * name;
@property( nonatomic, strong ) NSString * userId;
@property( nonatomic, strong ) NSString * reason;
@property( nonatomic, assign ) BOOL canInvite;

/**
 *  0 : question
    1 : act
 **/
@property( nonatomic, assign ) int type;

@end
