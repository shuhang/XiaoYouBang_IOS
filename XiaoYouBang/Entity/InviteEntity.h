//
//  InviteEntity.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/21.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InviteEntity : NSObject

@property( nonatomic, strong ) NSString * inviteUserId;
@property( nonatomic, strong ) NSString * name;
@property( nonatomic, strong ) NSString * headUrl;
@property( nonatomic, strong ) NSString * time;
@property( nonatomic, strong ) NSString * info;
@property( nonatomic, assign ) BOOL hasAnswered;
@property( nonatomic, assign ) BOOL isOtherInviteMe;

@end
