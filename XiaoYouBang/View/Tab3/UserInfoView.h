//
//  UserInfoView.h
//  XiaoYouBang
//
//  Created by shuhang on 15/5/4.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEntity.h"

@interface UserInfoView : UIView

@property( nonatomic, strong ) UserEntity * entity;

- ( id ) initWithFrame:(CGRect)frame entity:( UserEntity * ) entity;

@end
