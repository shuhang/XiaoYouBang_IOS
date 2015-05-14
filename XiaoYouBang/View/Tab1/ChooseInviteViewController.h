//
//  ChooseInviteViewController.h
//  XiaoYouBang
//
//  Created by shuhang on 15/5/12.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "BaseViewController.h"

@interface ChooseInviteViewController : BaseViewController

@property( nonatomic, strong ) NSMutableArray * arrayUsers;

/**
 *  0 : question
    1 : act
 **/
@property( nonatomic, assign ) int type;

@end
