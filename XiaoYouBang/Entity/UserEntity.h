//
//  UserEntity.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/21.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserEntity : NSObject

@property( nonatomic, strong ) NSString * userId;
@property( nonatomic, strong ) NSString * name;
@property( nonatomic, strong ) NSString * headUrl;
@property( nonatomic, strong ) NSString * birthday;
@property( nonatomic, strong ) NSString * pku;
@property( nonatomic, strong ) NSString * job1;
@property( nonatomic, strong ) NSString * job2;
@property( nonatomic, strong ) NSString * job3;
@property( nonatomic, strong ) NSString * oldHome;
@property( nonatomic, strong ) NSString * nowHome;
@property( nonatomic, strong ) NSString * qq;
@property( nonatomic, strong ) NSString * intro;
@property( nonatomic, strong ) NSString * inviteName;
@property( nonatomic, strong ) NSString * inviteHeadUrl;
@property( nonatomic, strong ) NSString * inviteUserId;
@property( nonatomic, assign ) int sex;
@property( nonatomic, assign ) int userVersion;
@property( nonatomic, assign ) int praiseCount;
@property( nonatomic, assign ) int questionCount;
@property( nonatomic, assign ) int answerCount;
@property( nonatomic, assign ) int answerMe;
@property( nonatomic, assign ) int myAnswer;
@property( nonatomic, assign ) int leaveWord;
@property( nonatomic, strong ) NSMutableArray * tagArray;
@property( nonatomic, strong ) NSMutableArray * commentArray;

@end
