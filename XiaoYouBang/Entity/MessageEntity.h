//
//  MessageEntity.h
//  XiaoYouBang
//
//  Created by shuhang on 15/5/6.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageEntity : NSObject

/**
  0 : question
  1 : answer
  2 : invite question
  3 : new
  4 : leave to me
  5 : reply leave
  6 : invite act
 **/
@property( nonatomic, assign ) int type;
@property( nonatomic, strong ) NSString * headUrl;
@property( nonatomic, strong ) NSString * titleUserName;
@property( nonatomic, strong ) NSString * middleUserName;
@property( nonatomic, strong ) NSString * infoUserName;
@property( nonatomic, strong ) NSString * question;
@property( nonatomic, strong ) NSString * answer;
@property( nonatomic, strong ) NSString * time;
@property( nonatomic, strong ) NSString * info;
@property( nonatomic, strong ) NSString * userId;
@property( nonatomic, strong ) NSString * questionId;
@property( nonatomic, strong ) NSString * answerId;
@property( nonatomic, strong ) NSString * hostHeadUrl;
/**
  0 : question
  1 : act
 **/
@property( nonatomic, assign ) int inviteType;

@end
