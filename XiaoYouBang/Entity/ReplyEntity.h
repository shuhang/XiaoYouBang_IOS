//
//  ReplyEntity.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/21.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyEntity : NSObject

@property( nonatomic, strong ) NSString * replyUserId;
@property( nonatomic, strong ) NSString * headUrl;
@property( nonatomic, strong ) NSString * replyUserName;
@property( nonatomic, strong ) NSString * titleUserName;
@property( nonatomic, strong ) NSString * commentUserName;
@property( nonatomic, strong ) NSString * commentUserHeadUrl;
@property( nonatomic, strong ) NSString * title;
@property( nonatomic, strong ) NSString * time;
@property( nonatomic, strong ) NSString * info;
@property( nonatomic, strong ) NSString * questionId;
@property( nonatomic, strong ) NSString * answerId;
@property( nonatomic, strong ) NSString * inviteUserId;
@property( nonatomic, assign ) NSInteger type;
@property( nonatomic, assign ) NSInteger questionType;
@property( nonatomic, assign ) BOOL isInvite;
@property( nonatomic, assign ) BOOL inInviteLogin;
@property( nonatomic, assign ) BOOL isActInvite;

@end
