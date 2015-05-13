//
//  UserInfoViewController.h
//  XiaoYouBang
//
//  Created by shuhang on 15/5/4.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "BaseViewController.h"
#import "UserEntity.h"

@interface UserInfoViewController : BaseViewController

@property( nonatomic, strong ) UserEntity * entity;
@property( nonatomic, assign ) BOOL shouldRefresh;

@end
