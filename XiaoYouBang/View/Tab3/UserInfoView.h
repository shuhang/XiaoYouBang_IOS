//
//  UserInfoView.h
//  XiaoYouBang
//
//  Created by shuhang on 15/5/4.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEntity.h"

@protocol UserInfoViewDelegate <NSObject>

- ( void ) clickHeadImage;
- ( void ) clickIntro;
- ( void ) clickLeaveWord;
- ( void ) clickInvite;
- ( void ) clickQuestion;
- ( void ) clickAnswer;

@end

@interface UserInfoView : UIView

@property( nonatomic, strong ) UserEntity * entity;
@property( nonatomic, weak ) id< UserInfoViewDelegate > delegate;

- ( id ) initWithFrame:(CGRect)frame entity:( UserEntity * ) entity;
- ( void ) updateInfo;
- ( void ) refreshUserComments;
- ( void ) updateLeaveword : ( NSString * ) value count : ( int ) count;

@end
